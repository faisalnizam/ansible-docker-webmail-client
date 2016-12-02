#!/bin/bash

__start_mariadbmysql() {
echo "Starting Mysql Mariadb-Server."
systemctl start mariadb.service
}


__start_httpd() {
echo "Starting Httpd Server."
systemctl start httpd.service
}


__start_mariadbmysql
__start_httpd

