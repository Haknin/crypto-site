#!/usr/bin/bash

pgrep flask

if [[ "$?" == "0" ]]; then
  pkill flask
  sleep 7
  cd /home/ec2-user/crypto-site
  flask run --host=0.0.0.0
fi

cd /home/ec2-user/crypto-site
flask run --host=0.0.0.0
