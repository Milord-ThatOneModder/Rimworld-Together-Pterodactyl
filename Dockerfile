FROM        --platform=linux/amd64 ubuntu:22.04

LABEL       author="Lighthouse Servers, Noble Milord" maintainer="https://github.com/Milord-ThatOneModder"

LABEL       org.opencontainers.image.source="https://github.com/Milord-ThatOneModder/Rimworld-Together-Pterodactyl"
LABEL       org.opencontainers.image.licenses=LGPL

ENV         DEBIAN_FRONTEND=noninteractive

RUN         dpkg --add-architecture i386 \
			&& apt update \
			&& apt upgrade -y \
			&& apt -y install tar curl wget unzip python3 python3-pip gcc g++ lib32gcc-s1 libgcc1 libcurl4-gnutls-dev:i386 libssl-dev:i386 libssl-dev libcurl4:i386 lib32tinfo6 libtinfo6:i386 lib32z1 lib32stdc++6 libncurses5:i386 libcurl3-gnutls:i386 libsdl2-2.0-0:i386 iproute2 gdb libsdl1.2debian libfontconfig1 telnet net-tools netcat tzdata  libtinfo6:i386 libtbb2:i386 libtinfo5:i386 libcurl4-gnutls-dev:i386 libcurl4:i386 libncurses5:i386 libcurl3-gnutls:i386 faketime:i386 libtbb2:i386 \
			&& apt -y install lib32tinfo6 lib32stdc++6 lib32z1 libtbb2 libtinfo5 libstdc++6 readline-common libncursesw5 libfontconfig1 libnss-wrapper gettext-base libc++-dev libc6-i386 libcurl4 libc6 libc6:i386 libssl3 libssl3:i386 libc6 libc6:i386 xvfb libgssapi-krb5-2 libicu66 zlib1g

RUN 		useradd -d /home/container -m container

# Install .NET
ENV DOTNET_VERSION=6.0.0

RUN curl -fSL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-x64.tar.gz \
    && dotnet_sha512='6a1ae878efdc9f654e1914b0753b710c3780b646ac160fb5a68850b2fd1101675dc71e015dbbea6b4fcf1edac0822d3f7d470e9ed533dd81d0cfbcbbb1745c6c' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

## install rcon
RUN 		cd /tmp/ \
			&& curl -sSL https://github.com/gorcon/rcon-cli/releases/download/v0.10.2/rcon-0.10.2-amd64_linux.tar.gz > rcon.tar.gz \
			&& tar xvf rcon.tar.gz \
			&& mv rcon-0.10.2-amd64_linux/rcon /usr/local/bin/

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]