# fedosovdv_infra
fedosovdv Infra repository

## ДЗ-4 (cloud-testapp)

```
testapp_IP = 51.250.91.35

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
