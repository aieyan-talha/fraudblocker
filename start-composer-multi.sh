#!/bin/bash

#mongo ds145370.mlab.com:45370/fraudblocker-auth -u <dbuser> -p <dbpassword>

#1) Setup multi user mode of the Composer REST Server   true | false
export COMPOSER_MULTIUSER=true

#2) Set the data source
export COMPOSER_DATASOURCES='{
    "db":{
      "name": "db",
      "host": "ds145370.mlab.com",
      "port": "45370",
      "database": "fraudblocker-auth",
      "user": "test",
      "password": "test123",
      "connector": "mongodb"
    }
  }'

  #3) Run shell script for running composer REST Server
  ./start-composer-rest-server.sh
