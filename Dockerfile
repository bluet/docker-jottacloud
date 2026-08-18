# Name: jottacloud
# Description: This dockerfile is used to build the docker image for a containerized jotta backup client, with the latest version of official jotta-cli preloaded at the time of build.
# Author: BlueT - Matthew Lien - 練喆明

FROM ubuntu:26.04
LABEL org.opencontainers.image.authors="bluet@bluet.org"

VOLUME [ "/data" ]

ENV JOTTA_TOKEN="**None**" \
	JOTTA_DEVICE="**docker-jottacloud**" \
	JOTTA_SCANINTERVAL="12h"\
	LOCALTIME="Asia/Taipei" \
	STARTUP_TIMEOUT=15 \
	JOTTAD_SYSTEMD=0

RUN apt-get update -y &&\
	apt-get install -y curl apt-transport-https ca-certificates &&\
	curl -fsSL https://repo.jotta.cloud/jotta.gpg -o /usr/share/keyrings/jotta.gpg &&\
	echo "deb [signed-by=/usr/share/keyrings/jotta.gpg] https://repo.jotta.cloud/debian debian main" | tee /etc/apt/sources.list.d/jotta-cli.list &&\
	apt-get update -y &&\
	apt-get install -y expect jotta-cli psmisc unminimize &&\
	apt-get dist-upgrade -y &&\
	apt-get autoremove -y --purge &&\
	apt-get clean &&\
	rm -rf /var/lib/lists/*

COPY entrypoint.sh /src/
WORKDIR /src
RUN chmod +x entrypoint.sh

EXPOSE 14443

ENTRYPOINT [ "/src/entrypoint.sh" ]
