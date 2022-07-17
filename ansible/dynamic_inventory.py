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
            self.inventory = self.get_ter_inventary()
        # Called with `--host [hostname]`.
        elif self.args.host:
            # Not implemented, since we return _meta info `--list`.
            self.inventory = self.empty_inventory()
        # If no groups or vars are present, return an empty inventory.
        else:
            self.inventory = self.empty_inventory()

        print (json.dumps(self.inventory))

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
