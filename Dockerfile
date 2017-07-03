FROM alpine:3.5
MAINTAINER Michal <nemrod@reaper.pl>

# Add Testing Repository
RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Install apk packages
RUN apk --update upgrade \
 && apk add \
  ca-certificates \
  ffmpeg \
  imagemagick \
  mono@testing \
  sqlite-libs \
  unzip \
  wget \
 && update-ca-certificates --fresh \
 && rm /var/cache/apk/*

# Set Emby Package Information
ENV PKG_NAME Emby.Mono
ARG VER
ENV PKG_VER ${VER:-3.0}
ARG BUILD
ENV PKG_BUILD ${BUILD:-8400}
ENV APP_BASEURL https://github.com/MediaBrowser/Emby/releases/download/
ENV APP_PKGNAME ${PKG_VER}.${PKG_BUILD}/${PKG_NAME}.zip
ENV APP_URL ${APP_BASEURL}/${APP_PKGNAME}
ENV APP_PATH /opt/emby

# Download & Install Emby
RUN mkdir -p ${APP_PATH} \
 && wget -O "${APP_PATH}/emby.zip" ${APP_URL} \ 
 && unzip "${APP_PATH}/emby.zip" -d ${APP_PATH} \
 && rm "${APP_PATH}/emby.zip" 

# Link libsqlite3.so library
#RUN ln -s /usr/lib/libsqlite3.so.0 /usr/lib/libsqlite3.so 
# Correct sqlite and imagemagick config
ADD config/* ${APP_PATH}/

# Create user and change ownership
RUN mkdir /config \
 && addgroup -g 3001 -S tor \
 && adduser -u 3001 -SHG tor tor \
 && chown -R tor:tor \
    ${APP_PATH} \
 && chown -R tor:tor /config

VOLUME ["/config"]

# Default MB3 HTTP/tcp server port
EXPOSE 8096/tcp
# Default MB3 HTTPS/tcp server port
#EXPOSE 8920/tcp
# UDP server port
EXPOSE 7359/udp
# ssdp port for UPnP / DLNA discovery
EXPOSE 1900/udp

# Add run script
ADD emby.sh /emby.sh
RUN chmod +x /emby.sh

USER tor
WORKDIR ${APP_PATH}

CMD ["/emby.sh"]
