#!/bin/bash

#Setup the enviorment variables for the composer REST Server

#1) Set up the card to be used
export COMPOSER_CARD=admin@fraudblocker

#2) Set up the namespace usage    always | never
export COMPOSER_NAMESPACES=never

#3) Set up the REST Server Authentication    true | false
export COMPOSER_AUTHENTICATION=true

#4) Set up the Passport stratergy provider
export COMPOSER_PROVIDERS='{
  "jwt": {
    "provider": "passport-jwt",
    "module": "/Work/Testing/Composer-Multiuser/fraudBlocker/fraudblocker/custom-jwt.js",
    "secretOrKey":"Secret Hash",
    "authScheme": "saml",
    "successRedirect": "/",
    "failureRedirect": "/"
  }
}'

#5) Execure the REST Server
composer-rest-server