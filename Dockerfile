FROM zabbix/zabbix-server-mysql:alpine-7.0.28

LABEL maintainer="mr.lioncub" \
      link1="https://github.com/zabbix/zabbix-docker/tree/7.0" \
      link2="https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server" \
      link3="https://github.com/pjsip/pjproject"

USER root

RUN set -x \
  && tempDir="$(mktemp -d)" \
  && chown nobody:nobody $tempDir \
  && cd $tempDir \
  && wget https://download.microsoft.com/download/0b3d5518-b4a7-4a2b-afc7-7ee9e967f93c/msodbcsql18_18.6.2.1-1_amd64.apk \
  && wget https://download.microsoft.com/download/cad0d30f-b9b1-4765-a011-81d8a66c8b8d/mssql-tools18_18.6.2.1-1_amd64.apk \
  && apk add --allow-untrusted msodbcsql18_18.6.2.1-1_amd64.apk \
  && apk add --allow-untrusted mssql-tools18_18.6.2.1-1_amd64.apk \
  && apk add coreutils \
  && rm -rf $tempDir \
  && rm -rf /var/cache/apk/*

RUN set -x \
  && apk add --no-cache pjsua

USER 1997
