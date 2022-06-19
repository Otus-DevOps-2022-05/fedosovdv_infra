# fedosovdv_infra
fedosovdv Infra repository

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
