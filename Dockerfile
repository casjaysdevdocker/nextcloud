FROM casjaysdevdocker/alpine:latest AS build

ARG LICENSE=WTFPL \
  IMAGE_NAME=nextcloud \
  TIMEZONE=America/New_York \
  PORT=8000 \
  NEXTCLOUD_VERSION=24.0.5 \
  ALPINE_VERSION=edge \
  SMBCLIENT_VERSION=1.0.6 \
  NEXTCLOUD_UPDATE=1 \
  PGID=1000 \
  PUID=1000

ENV SHELL=/bin/bash \
  TERM=xterm-256color \
  HOSTNAME=${HOSTNAME:-casjaysdev-$IMAGE_NAME} \
  TZ=$TIMEZONE

RUN mkdir -p /bin/ /config/ /data/ /dist/nextcloud/ && \
  rm -Rf /bin/.gitkeep /config/.gitkeep /data/.gitkeep && \
  echo "http://dl-cdn.alpinelinux.org/alpine/$ALPINE_VERSION/main" >> /etc/apk/repositories && \
  echo "http://dl-cdn.alpinelinux.org/alpine/$ALPINE_VERSION/community" >> /etc/apk/repositories && \
  echo "http://dl-cdn.alpinelinux.org/alpine/$ALPINE_VERSION/testing" >> /etc/apk/repositories && \
  apk update -U --no-cache \
  apk add --no-cache \
  openrc \
  icu-data-full \
  curl \
  gnupg \
  tar \
  unzip \
  xz \
  s6-overlay \
  bash \
  ca-certificates \
  curl \
  ffmpeg \
  imagemagick \
  ghostscript \
  libsmbclient \
  libxml2 \
  nginx \
  openssl \
  php8 \
  php8-bcmath \
  php8-bz2 \
  php8-cli \
  php8-ctype \
  php8-curl \
  php8-dom \
  php8-exif \
  php8-fileinfo \
  php8-fpm \
  php8-ftp \
  php8-gd \
  php8-gmp \
  php8-iconv \
  php8-intl \
  php8-json \
  php8-ldap \
  php8-mbstring \
  php8-opcache \
  php8-openssl \
  php8-pcntl \
  php8-pecl-apcu \
  php8-pecl-imagick \
  php8-pecl-mcrypt \
  php8-pecl-memcached \
  php8-pdo \
  php8-pdo_mysql \
  php8-pdo_pgsql \
  php8-pdo_sqlite \
  php8-posix \
  php8-redis \
  php8-session \
  php8-simplexml \
  php8-sqlite3 \
  php8-xml \
  php8-xmlreader \
  php8-xmlwriter \
  php8-zip \
  php8-zlib \
  tzdata; \
  \
  apk --update --no-cache add -t build-dependencies \
  autoconf \
  automake \
  build-base \
  libtool \
  pcre-dev \
  php8-dev \
  php8-pear \
  samba-dev; \
  \
  apk add --no-cache \
  python3 \
  py3-pip; \
  python3 -m pip install --upgrade pip && \
  python3 -m pip install nextcloud_news_updater; \
  \
  mv /etc/php8 /etc/php && \
  ln -s /etc/php /etc/php8 && \
  mv /etc/init.d/php-fpm8 /etc/init.d/php-fpm && \
  ln -s /etc/init.d/php-fpm /etc/init.d/php-fpm8 && \
  mv /etc/logrotate.d/php-fpm8 /etc/logrotate.d/php-fpm && \
  ln -s /etc/logrotate.d/php-fpm /etc/logrotate.d/php-fpm8 && \
  mv /var/log/php8 /var/log/php && ln -s /var/log/php /var/log/php8 && \
  ln -s /usr/sbin/php-fpm8 /usr/sbin/php-fpm; \
  \
  cd /tmp && \
  wget -q https://pecl.php.net/get/smbclient-${SMBCLIENT_VERSION}.tgz && \
  pecl8 install smbclient-${SMBCLIENT_VERSION}.tgz; \
  \
  apk del build-dependencies && \
  rm -rf /tmp/* /var/www/*; \
  \
  RUN cd /tmp && \
  curl -SsOL "https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2" && \
  curl -SsOL "https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2.asc" && \
  curl -SsOL "https://nextcloud.com/nextcloud.asc" && \
  gpg --import "nextcloud.asc" && \
  gpg --verify --batch --no-tty "nextcloud-${NEXTCLOUD_VERSION}.tar.bz2.asc" "nextcloud-${NEXTCLOUD_VERSION}.tar.bz2"; \
  \
  cd /dist/nextcloud && \
  tar -xjf "/tmp/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2" --strip 1 -C . && \
  addgroup -g ${PGID} nextcloud && adduser -D -h /home/nextcloud -u ${PUID} -G nextcloud -s /bin/sh nextcloud; \
  \
  rm -rf /tmp/*

COPY ./bin/. /usr/local/bin/
COPY ./config/. /etc/
COPY ./data/. /data/

FROM scratch
ARG BUILD_DATE="$(date +'%Y-%m-%d %H:%M')"

LABEL org.label-schema.name="nextcloud" \
  org.label-schema.description="Containerized version of nextcloud" \
  org.label-schema.url="https://hub.docker.com/r/casjaysdevdocker/nextcloud" \
  org.label-schema.vcs-url="https://github.com/casjaysdevdocker/nextcloud" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.version=$BUILD_DATE \
  org.label-schema.vcs-ref=$BUILD_DATE \
  org.label-schema.license="$LICENSE" \
  org.label-schema.vcs-type="Git" \
  org.label-schema.schema-version="latest" \
  org.label-schema.vendor="CasjaysDev" \
  maintainer="CasjaysDev <docker-admin@casjaysdev.com>"

ENV SHELL="/bin/bash" \
  TERM="xterm-256color" \
  HOSTNAME="casjaysdev-nextcloud" \
  TZ="${TZ:-America/New_York}"

WORKDIR /root

VOLUME ["/root","/config","/data"]

EXPOSE $PORT

COPY --from=build /. /

ENTRYPOINT [ "tini", "--" ]
HEALTHCHECK CMD [ "/usr/local/bin/entrypoint-nextcloud.sh", "healthcheck" ]
CMD [ "/usr/local/bin/entrypoint-nextcloud.sh" ]
