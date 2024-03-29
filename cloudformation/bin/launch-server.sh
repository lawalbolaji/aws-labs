#!/bin/sh -e

AMIID=$(
    aws ec2 describe-images \
        --filters "Name=description,Values=Amazon Linux 2023 AMI 2023.2.20231016.0 x86_64 HVM kernel-6.1" \
        --query "Images[0].ImageId" \
        --output text
)

VPCID=$(
    aws ec2 describe-vpcs \
        --filter "Name=isDefault,Values=true" \
        --query "Vpcs[0].VpcId" \
        --output text
)

SUBNETID=$(
    aws ec2 describe-subnets \
        --filter "Name=vpc-id,Values=$VPCID" \
        --query "Subnets[0].SubnetId" \
        --output text
)

SGID=$(
    aws ec2 create-security-group \
        --group-name mysecuritygroup \
        --description "My Security Group" \
        --vpc-id $VPCID \
        --output=text
)

# add inbound rules for ssh
aws ec2 authorize-security-group-ingress \
    --group-id $SGID \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# create instance
INSTANCEID=$(
    aws ec2 run-instances \
        --image-id $AMIID \
        --key-name mykey \
        --instance-type t2.micro \
        --security-group-ids $SGID \
        --subnet-id $SUBNETID \
        --query "Instances[0].InstanceId" \
        --output text
)

echo "waiting for $INSTANCEID ..."

aws ec2 wait instance-running --instance-ids $INSTANCEID

PUBLICNAME=$(
    aws ec2 describe-instances \
        --instance-ids $INSTANCEID \
        --query "Reservations[0].Instances[0].PublicDnsName" \
        --output text
)

echo "$INSTANCEID is accepting SSH connections under $PUBLICNAME"
echo "ssh -i mykey.pem ec2-user@$PUBLICNAME"
read -p "Press [Enter] key to terminate $INSTANCEID ..."
aws ec2 terminate-instances --instance-ids $INSTANCEID
echo "terminating $INSTANCEID ..."
aws ec2 wait instance-terminated --instance-ids $INSTANCEID
aws ec2 delete-security-group --group-id $SGID

echo "instance $INSTANCEID termiate"
echo "all resources cleaned up"
