#!/usr/bin/env python

import os
import argparse
import subprocess
try:
    import json
except ImportError:
    import simplejson as json

class ExampleInventory(object):

    def __init__(self):
        self.inventory = {}
        self.read_cli_args()

        # Called with `--list`.
        if self.args.list:
            self.inventory = self.get_yc_inventary()
        # Called with `--host [hostname]`.
        elif self.args.host:
            # Not implemented, since we return _meta info `--list`.
            self.inventory = self.empty_inventory()
        # If no groups or vars are present, return an empty inventory.
        else:
            self.inventory = self.empty_inventory()

        print (json.dumps(self.inventory))

    def get_yc_inventary(self):
        cmd = [
            "yc",
            "compute",
            "instance",
            "list",
            "--format",
            "json",
        ]
        folder_id = os.environ["FOLDER_ID"]
        if folder_id:
            cmd.append("--folder-id")
            cmd.append(folder_id)
        result = subprocess.run(cmd, stdout=subprocess.PIPE)
        result_txt = result.stdout.decode("utf-8")
        adr_dict = {}
        inv_dict = {}
        for elem in json.loads(result_txt):
            name = elem.get("name")
            net_int = elem.get("network_interfaces", [{}])[0]
            # если интерфейс не 1, то  [0] не работает!!
            inner_ip = net_int.get("primary_v4_address", {}).get("address", "")
            ip_addr = (
                net_int.get("primary_v4_address", {})
                .get("one_to_one_nat", {})
                .get("address", "")
            )
            g_name = name.split("-")[-1].strip()  # получение имени группы и имени хоста =/
            # при нескольких хостах в группе не переопределять, а добавлять
            inv_dict[g_name] = {"hosts": [ip_addr.strip()], "vars": {}}

            adr_dict[g_name] = {"inner": inner_ip, "ip": ip_addr}  # для  vars -ов

        if "app" in inv_dict and "db" in inv_dict:
            pass  # установка переменных
            inv_dict["app"]["vars"] = {
                "db_host": adr_dict.get("db", {}).get("inner", "")
            }
            inv_dict["db"]["vars"] = {
                "mongo_bind_ip": adr_dict.get("db", {}).get("inner", "")
            }

        inv_dict["_meta"] = {"hostvars": {}}
        return inv_dict

    def get_ter_inventary(self):
        cmd = ["terraform", "output"]
        os.chdir("../terraform/stage/")
        result = subprocess.run(cmd, stdout=subprocess.PIPE)
        ter_out = result.stdout.decode("utf-8")
        terr_dict = {}
        for row in ter_out.split("\n"):
            if row.find("=") < 2:
                continue
            name, ip_addr = row.split("=")
            terr_dict[name] = ip_addr
        # т.к. у нас по 1 машине в группе
        inv_dict = {
            k.split("_")[-1].strip(): {"hosts": [ip.strip()]}
            for k, ip in terr_dict.items()
        }
        inv_dict["_meta"]: {"hostvars": {}}
        return inv_dict


    # Empty inventory for testing.
    def empty_inventory(self):
        return {'_meta': {'hostvars': {}}}

    # Read the command line args passed to the script.
    def read_cli_args(self):
        parser = argparse.ArgumentParser()
        parser.add_argument('--list', action = 'store_true')
        parser.add_argument('--host', action = 'store')
        self.args = parser.parse_args()

# Get the inventory.
ExampleInventory()
