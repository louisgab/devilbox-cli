#!/bin/bash

VERSION="0.1.0"
DATE="2019-03-10"
NAME="devilbox-cli"
DESCRIPTION="A simple and conveniant cli to manage devilbox from anywhere"
LINK="https://github.com/louisgab/devilbox-cli"

ENV_FILE=".env"

PHP_CONFIG="PHP_SERVER="
APACHE_CONFIG="HTTPD_SERVER=apache-"
MYSQL_CONFIG="MYSQL_SERVER=mysql-"
DOCROOT_CONFIG="HTTPD_DOCROOT_DIR="
WWWPATH_CONFIG="HOST_PATH_HTTPD_DATADIR="
DBPATH_CONFIG="HOST_PATH_MYSQL_DATADIR="

COLOR_DEFAULT=$(tput sgr0)
COLOR_RED=$(tput setaf 1)
COLOR_GREEN=$(tput setaf 2)
COLOR_YELLOW=$(tput setaf 3)
COLOR_BLUE=$(tput setaf 4)
# COLOR_PURPLE=$(tput setaf 5)
# COLOR_CYAN=$(tput setaf 6)
COLOR_LIGHT_GRAY=$(tput setaf 7)
COLOR_DARK_GRAY=$(tput setaf 0)
