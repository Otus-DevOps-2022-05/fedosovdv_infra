terraform {
  backend "s3" {
    # bucket                      = ""
    # access_key                  = ""
    # secret_key                  = ""
    endpoint                    = "storage.yandexcloud.net"
    region                      = "ru-central1-a"
    key                         = "prod.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
# terraform init \
# -backend-config="access_key=$TERR_KEY"\
# -backend-config="secret_key=$TERR_SEC"\
# -backend-config="bucket=$BUCKET_NAME"
