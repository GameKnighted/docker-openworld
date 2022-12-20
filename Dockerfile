FROM debian:latest

MAINTAINER Pterodactyl Software, <support@pterodactyl.io>

RUN apk add --no-cache --update curl ca-certificates openssl git tar bash sqlite fontconfig \
    && adduser --disabled-password --home /home/container container

ARG OPENWORLD_RELEASE_VERSION='1.4.2'

RUN apt-get update && \ 
    apt-get -y upgrade && \
    apt-get install wget curl unzip libicu67 -y
RUN wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install apt-transport-https dotnet-runtime-3.1 -y && \
    useradd -m container && \
    cd /home/container && \
    wget https://github.com/TastyLollipop/OpenWorld/releases/download/${OPENWORLD_RELEASE_VERSION}/LinuxX64.zip && \
    unzip LinuxX64.zip && \
    rm LinuxX64.zip && \
    chmod +x Open\ World\ Server && \
    mv Open\ World\ Server OpenWorldServer && \
    chown -R container:container /home/container

USER container
ENV  USER=container HOME=/home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
