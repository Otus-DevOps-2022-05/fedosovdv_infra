 #!/bin/sh
NAME="reddit-app-bake"
FAMILY="reddit-full"
SUB_NET="default-ru-central1-a"
ZONE="ru-central1-a"
SSH_PUB=~/.ssh/appuser.pub

IMG_ID=$(yc compute image list | awk  -v fam=$FAMILY 'BEGIN { FS = "|" }; $6 ~  /READY/ && $4 ~ fam {print $2} '|head | tr -d '[:space:]')

yc compute instance create \
 --name $NAME \
 --hostname $NAME \
 --cores=2 \
 --memory=4 \
 --create-boot-disk image-id=$IMG_ID,size=10GB \
 --network-interface subnet-name=$SUB_NET,nat-ip-version=ipv4 \
 --metadata serial-port-enable=1 \
 --ssh-key $SSH_PUB \
 --zone $ZONE
