#!/bin/bash

# ssl data:
#Country Name (2 letter code) [AU]:
#State or Province Name (full name) [Some-State]:
#Locality Name (eg, city) []:
#Organization Name (eg, company) [Internet Widgits Pty Ltd]:
#Organizational Unit Name (eg, section) []:
#Common Name (e.g. server FQDN or YOUR name) []:
#Email Address []:
cat << EOF | openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout priv.key \
    -out chain.crt
US
North Carolina
Raleigh
Liquid Rocketry

database
admin@liquidrocketry.com
EOF


# read crt
#openssl x509 -in chain.crt -noout -text

# check priv
#openssl rsa -in priv.key -noout -check
