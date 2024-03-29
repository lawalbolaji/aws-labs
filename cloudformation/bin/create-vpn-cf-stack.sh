#!/bin/sh

VpcId=$(aws ec2 describe-vpcs --query Vpcs[0].VpcId --output text)
SubnetId=$(aws ec2 describe-subnets --filter Name=vpc-id,Values=$VpcId --query Subnets[0].SubnetId --output text)
SharedSecret=$(openssl rand -base64 30)
Password=$(openssl rand -base64 30)

aws cloudformation create-stack --stack-name vpn \
    --template-body file:///Users/abdulrasheedlawal/software-engineering/playground/cloud/aws/playground/cloudformation/vpn-stack.json \
    --parameters \
    ParameterKey=KeyName,ParameterValue=mykey \
    ParameterKey=VPC,ParameterValue=$VpcId \
    ParameterKey=Subnet,ParameterValue=$SubnetId \
    ParameterKey=IPSecSharedSecret,ParameterValue=$SharedSecret \
    ParameterKey=VPNUser,ParameterValue=vpn \
    ParameterKey=VPNPassword,ParameterValue=$Password

aws cloudformation describe-stacks --stack-name vpn --query Stacks[0].Outputs
