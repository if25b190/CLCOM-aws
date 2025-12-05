#!/bin/bash

ln -sf /etc/resolv.custom.conf /etc/resolv.conf
tee /etc/resolv.custom.conf <<EOF
nameserver 10.0.0.254
nameserver 10.0.0.253
EOF
