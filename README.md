# zabbix-server-mysql
[![Docker Version](https://img.shields.io/docker/v/idscan/zabbix-proxy-sqlite3)](https://hub.docker.com/r/idscan/zabbix-server-mysql)
[![Docker Image Size](https://img.shields.io/docker/image-size/idscan/zabbix-server-mysql)](https://hub.docker.com/r/idscan/zabbix-server-mysql)

Zabbix server uses MySQL database with Microsoft ODBC driver for SQL Server on Alpine and Ubuntu docker images

## Uses

  * Official docker image Zabbix server (MySQL) LTS
  * Microsoft ODBC driver for SQL Server 18
  * Alpine-based: `Dockerfile`
  * Ubuntu-based: `Dockerfile.ubuntu`

## Test

 1. Run Zabbix Server with this image idscan/zabbix-server-mysql
 2. Check ODBC Driver:
```bash
docker exec _container_name_ odbcinst -q -d -n "ODBC Driver 18 for SQL Server"
```
Result:
```
[ODBC Driver 18 for SQL Server]
Description=Microsoft ODBC Driver 18 for SQL Server
Driver=/opt/microsoft/msodbcsql18/lib64/libmsodbcsql-18.3.so.1.1
UsageCount=1
```
 3. Create odbc.ini:
```
[mssql-test]
Description = MS SQL test
Driver = ODBC Driver 18 for SQL Server
Server = tcp:192.168.100.100,1433
TrustServerCertificate = Yes
```
 4. [Mount](https://docs.docker.com/storage/bind-mounts/) our odbc.ini in docker _container_name_ (recreate container with -v|--mount or with volume in compose):
```
-v /path/our/odbc.ini:/etc/odbc.ini:ro
```
 5. Check DSN:
```bash
docker exec _container_name_ odbcinst -q -s -n
```
Result our DSN name:
```
[mssql-test]
```
and show our DSN mssql-test:
```bash
docker exec _container_name_ odbcinst -q -s -n mssql-test
```
Result will show the contents of our odbc.ini:
```
[mssql-test]
Description = MS SQL test
Driver = ODBC Driver 18 for SQL Server
Server = tcp:192.168.100.100,1433

```
 6. Check connect:
```bash
docker exec _container_name_ isql mssql sqluser sqlpassword
```
Result:
```
+---------------------------------------+
| Connected!                            |
|                                       |
| sql-statement                         |
| help [tablename]                      |
| quit                                  |
|                                       |
+---------------------------------------+
SQL>
```

## SQL query
Create login & grant permission for zabbix:
```sql
CREATE LOGIN zabbixlogin WITH PASSWORD='*Password*';
GRANT VIEW SERVER STATE TO zabbixlogin;
GRANT VIEW ANY DEFINITION TO zabbixlogin;
```
permission for the "Get job status" item :
```sql
USE [msdb]
CREATE USER zabbixlogin FOR LOGIN zabbixlogin
GRANT EXECUTE ON [dbo].agent_datetime TO [zabbixlogin]
ALTER ROLE db_datareader ADD MEMBER [zabbixlogin];
```
