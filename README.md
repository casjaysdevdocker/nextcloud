## 👋 Welcome to nextcloud 🚀  

nextcloud README  
  
  
## Run container

```shell
dockermgr update nextcloud
```

### via command line

```shell
docker pull casjaysdevdocker/nextcloud:latest && \
docker run -d \
--restart always \
--name casjaysdevdocker-nextcloud \
--hostname casjaysdev-nextcloud \
-e TZ=${TIMEZONE:-America/New_York} \
-v $HOME/.local/share/srv/docker/nextcloud/files/data:/data:z \
-v $HOME/.local/share/srv/docker/nextcloud/files/config:/config:z \
-p 80:80 \
casjaysdevdocker/nextcloud:latest
```

### via docker-compose

```yaml
version: "2"
services:
  nextcloud:
    image: casjaysdevdocker/nextcloud
    container_name: nextcloud
    environment:
      - TZ=America/New_York
      - HOSTNAME=casjaysdev-nextcloud
    volumes:
      - $HOME/.local/share/srv/docker/nextcloud/files/data:/data:z
      - $HOME/.local/share/srv/docker/nextcloud/files/config:/config:z
    ports:
      - 80:80
    restart: always
```

## Authors  

🤖 casjay: [Github](https://github.com/casjay) [Docker](https://hub.docker.com/r/casjay) 🤖  
⛵ CasjaysDevDocker: [Github](https://github.com/casjaysdevdocker) [Docker](https://hub.docker.com/r/casjaysdevdocker) ⛵  
