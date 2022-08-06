FROM ghcr.io/linuxserver/baseimage-alpine:3.16

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="nomandera,nemchik"

# environment settings
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache --upgrade \
    curl \
    fail2ban \
    jq \
    nftables && \
  echo "**** copy fail2ban confs to /defaults ****" && \
  mkdir -p \
    /tmp/fail2ban-confs \
    /defaults/fail2ban/{action.d,filter.d,jail.d} && \
  curl -o \
    /tmp/fail2ban-confs.tar.gz -L \
    "https://github.com/linuxserver/fail2ban-confs/tarball/master" && \
  tar xf \
    /tmp/fail2ban-confs.tar.gz -C \
    /tmp/fail2ban-confs --strip-components=1 && \
  cp \
    /tmp/fail2ban-confs/README.md \
    /defaults/fail2ban/ && \
  cp \
    /tmp/fail2ban-confs/*.conf \
    /defaults/fail2ban/ && \
  cp \
    /tmp/fail2ban-confs/action.d/*.conf \
    /defaults/fail2ban/action.d/ && \
  cp \
    /tmp/fail2ban-confs/filter.d/*.conf \
    /defaults/fail2ban/filter.d/ && \
  cp \
    /tmp/fail2ban-confs/jail.d/*.conf \
    /defaults/fail2ban/jail.d/ && \
  echo "**** cleanup ****" && \
  rm -rf \
      /root/.cache \
      /tmp/*

# add local files
COPY root/ /

# ports and volumes
VOLUME /config
