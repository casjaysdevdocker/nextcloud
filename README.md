## 👋 Welcome to nextcloud 🚀  

nextcloud README  
  
  
## Install my system scripts  

```shell
 sudo bash -c "$(curl -q -LSsf "https://github.com/systemmgr/installer/raw/main/install.sh")"
 sudo systemmgr --config && sudo systemmgr install scripts  
```
  
## Automatic install/update  
  
```shell
dockermgr update nextcloud
```
  
## Install and run container
  
```shell
dockerHome="/var/lib/srv/$USER/docker/casjaysdevdocker/nextcloud/nextcloud/latest/rootfs"
mkdir -p "/var/lib/srv/$USER/docker/nextcloud/rootfs"
git clone "https://github.com/dockermgr/nextcloud" "$HOME/.local/share/CasjaysDev/dockermgr/nextcloud"
cp -Rfva "$HOME/.local/share/CasjaysDev/dockermgr/nextcloud/rootfs/." "$dockerHome/"
docker run -d \
--restart always \
--privileged \
--name casjaysdevdocker-nextcloud-latest \
--hostname nextcloud \
-e TZ=${TIMEZONE:-America/New_York} \
-v "$dockerHome/data:/data:z" \
-v "$dockerHome/config:/config:z" \
-p 80:80 \
casjaysdevdocker/nextcloud:latest
```
  
## via docker-compose  
  
```yaml
version: "2"
services:
  ProjectName:
    image: casjaysdevdocker/nextcloud
    container_name: casjaysdevdocker-nextcloud
    environment:
      - TZ=America/New_York
      - HOSTNAME=nextcloud
    volumes:
      - "/var/lib/srv/$USER/docker/casjaysdevdocker/nextcloud/nextcloud/latest/rootfs/data:/data:z"
      - "/var/lib/srv/$USER/docker/casjaysdevdocker/nextcloud/nextcloud/latest/rootfs/config:/config:z"
    ports:
      - 80:80
    restart: always
```
  
## Get source files  
  
```shell
dockermgr download src casjaysdevdocker/nextcloud
```
  
OR
  
```shell
git clone "https://github.com/casjaysdevdocker/nextcloud" "$HOME/Projects/github/casjaysdevdocker/nextcloud"
```
  
## Build container  
  
```shell
cd "$HOME/Projects/github/casjaysdevdocker/nextcloud"
buildx 
```
  
## Authors  
  
🤖 casjay: [Github](https://github.com/casjay) 🤖  
⛵ casjaysdevdocker: [Github](https://github.com/casjaysdevdocker) [Docker](https://hub.docker.com/u/casjaysdevdocker) ⛵  
