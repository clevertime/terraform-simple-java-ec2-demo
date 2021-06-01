#!/bin/bash

# ssm install
dnf install -y https://s3.${region}.amazonaws.com/amazon-ssm-${region}/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# java install
yum install -y java-1.8.0-openjdk-devel

# awscli install
dnf install python3-pip
pip3 install awscli
export PATH="/usr/local/bin:$PATH"

# unzip install
dnf install -y unzip

# download code
aws s3 cp s3://${bucket}/${key} /opt
