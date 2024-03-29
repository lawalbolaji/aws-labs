#!/bin/sh -ex

yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

INTERFACE=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs)
SUBNETID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${INTERFACE}/subnet-id)

echo '<center><h1>This instance is in the subnet with ID: SUBNETID </h1></center>' | tee /var/www/html/index.html
sed "s/SUBNETID/$SUBNETID/" /var/www/html/index.html | tee /var/www/html/index.html

# I noticed the sed command was emptying out the file in some instances
# it's not clear why this happens or when it happens - it looks random for now
