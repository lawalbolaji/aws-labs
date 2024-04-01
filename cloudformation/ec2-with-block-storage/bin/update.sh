#!/bin/sh -ex

# grabbed the default vpc and a random subnet in the default vpc for dev
aws cloudformation update-stack --stack-name ec2-with-block \
    --capabilities CAPABILITY_NAMED_IAM \
    --template-body file:///Users/abdulrasheedlawal/software-engineering/playground/sre/cloud/aws/playground/cloudformation/ec2-with-block-storage/stack.json \
    --parameters ParameterKey=KeyName,UsePreviousValue=true \
    ParameterKey=VPC,UsePreviousValue=true \
    ParameterKey=Subnet,UsePreviousValue=true
