FROM lsiobase/xenial.arm64

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

# environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV MYSQL_DIR="/config"
ENV DATADIR=$MYSQL_DIR/databases

COPY files/trusted.gpg /etc/apt/trusted.gpg

RUN \
 echo "**** install packages ****" && \
 cd /opt && \
 curl -sO https://downloads.mariadb.com/MariaDB/mariadb-10.2.12/repo/ubuntu/mariadb-10.2.12-ubuntu-xenial-arm64-debs.tar && \
 chown root:root mariadb-10.2.12-ubuntu-xenial-arm64-debs.tar && \
 tar -xf mariadb-10.2.12-ubuntu-xenial-arm64-debs.tar && \
 chown root:root mariadb-10.2.11-ubuntu-xenial-arm64-debs && \
 cd mariadb-10.2.11-ubuntu-xenial-arm64-debs &&\ 
 ./setup_repository && \
 apt-get update && \
 apt-get install -y \
	mariadb-server && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/lib/mysql \
	/var/tmp/* \
        /opt/mariadb-10.2.12-ubuntu-xenial-arm64-debs.tar \
        /opt/mariadb-10.2.11-ubuntu-xenial-amd64-debs && \
 mkdir -p \
	/var/lib/mysql

# add local files
COPY root/ /

# ports and volumes
EXPOSE 3306
VOLUME /config
