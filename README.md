# fedosovdv_infra
fedosovdv Infra repository


## ДЗ-7 (terraform-2)
- Созданы модули app, db
- *Для *.tfstate используется yandex_storage_bucket
- *В модули app и db добавлены provisioner для деплоя и работы приложения

### Для сборки необходимо:
1.
- Создать bucket в terraform
- Создать файл **terraform.tfvars** на основе **terraform.tfvars.examples**
- Запустить terraform apply
2.
- Перейти в terraform/stage или terraform/prod
- Создать файл **terraform.tfvars** на основе **terraform.tfvars.examples**
- Добавить переменные среды для инициализации:
```
export TERR_KEY="<service-account key>"
export TERR_SEC="<service-account secret>"
export BUCKET_NAME="<bucket name>"
```
- Выполнить init
```
 terraform init \
 -backend-config="access_key=$TERR_KEY"\
 -backend-config="secret_key=$TERR_SEC"\
 -backend-config="bucket=$BUCKET_NAME"
 ```
- Применить конфигурацию

 ```
 terraform apply
 ```


## ДЗ-6 (terraform-1)
- В .gitignore добавлены *.tfstate, *.tfstate.backup, *.tfvars
- Ресурсы описаны в terraform/main.tf
- Переменные описаны в variables.tf

### Для сборки необходимо:
- Создать файл **terraform.tfvars** на основе **terraform.tfvars.examples**
- Применение конфигурации
 ```
 terraform apply
 ```

## ДЗ-5 (packer-base)

-  Скрипты для сборки образов в **packer/scripts/**
-  Параметры сборки используются из **packer/variables.json**
-  Шаблон для reddit-base **packer/ubuntu16.json**
-  \*шаблон bake-образа  **packer/immutable.json**
-  \*скрипт для создания ВМ с помощью Yandex.Cloud CLI **config-scripts/create-reddit-vm.sh**

### Для сборки образа необходимо:
- Перейти в /packer  ```cd /packer```
- Создать файл **variables.json** на основе **variables.json.examples**
- Выполнить синтаксическую проверку шаблона :
```
packer validate -var-file=variables.json ubuntu16.json
```

- Запустить процесс сборки образа:
```
packer build -var-file=variables.json ubuntu16.json
```


### *Bake-образ
для создания используется скрипт **packer/scripts/reddit_app_install.sh**,
он же создает reddit-app.service для автозапуска приложения

Запуск сборки образа:
```
packer build -var-file=variables.json immutable.json
```

### *Автоматизация создания ВМ
для работы скрипта должна быть пройдена инициализация профиля YC CLI

в скрипте используется образ из хранилища яндекс с условием image_family==reddit-full

*параметры (family,name,sub_net,...) указаны в начале скрипта*

Запуск скрипта:
```
cd  config-scripts
./create-reddit-vm.sh
```


## ДЗ-4 (cloud-testapp)

```
testapp_IP = 51.250.0.81

testapp_port = 9292
```

*команда CLI для получения инстанса с уже запущенным приложением
```
yc compute instance create \
  --name reddit-app \
  --cores=2 \
  --zone ru-central1-a \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata-from-file user-data=metadata.yml
```

## ДЗ-3 (cloud-bastion)

Данные для подключения:
```
bastion_IP = 51.250.14.220
someinternalhost_IP = 10.128.0.34
```

Подключение в одну строку:

```
ssh -i ~/.ssh/appuser -J appuser@51.250.14.220 appuser@10.128.0.34
```


Подключение по алиасу```ssh someinternalhost```:

для подключения в ~/.ssh/config прописать:

```
Host someinternalhost
  ProxyJump appuser@51.250.14.220
  HostName 10.128.0.34
  User appuser
  IdentityFile ~/.ssh/appuser
```

Валидный сертификат для панели управления VPN-сервера настроен через sslip.io:
https://51-250-14-220.sslip.io
