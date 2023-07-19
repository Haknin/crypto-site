#!/usr/bin/bash -xe
curl -s $EC2_IP_TEST:5000
curl -s $EC2_IP_TEST:5000 | grep crypto
