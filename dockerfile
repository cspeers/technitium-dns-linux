ARG BASE_IMAGE=mcr.microsoft.com/dotnet/sdk:5.0
FROM ${BASE_IMAGE}

LABEL maintainer="cspeers"
ARG INSTALL_URL="https://download.technitium.com/dns/DnsServerPortable.tar.gz"

ARG HEALTHCHECK_DNS="google.com"
ENV CHECK_ADDRESS=${HEALTHCHECK_DNS}

RUN apt-get update && apt-get -qy install \
  curl \
  dnsutils \
  net-tools

RUN mkdir /tmp/install
RUN mkdir /app
RUN mkdir /certs

WORKDIR /tmp/install
ADD ${INSTALL_URL} install.tar.gz
RUN tar -zxvf install.tar.gz -C /app

WORKDIR /app
RUN rm -rf /tmp/install

EXPOSE 5380/tcp
EXPOSE 53/tcp
EXPOSE 53/udp
EXPOSE 853/tcp
EXPOSE 443/tcp
EXPOSE 53443/tcp

VOLUME ["/app/config"]
VOLUME ["/certs"]

ENTRYPOINT ["dotnet", "DnsServerApp.dll"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD dig +time=3 +tries=1 @localhost $CHECK_ADDRESS || exit 1