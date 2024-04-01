#!/bin/sh -ex

# grabbed the default vpc and a random subnet in the default vpc for dev
aws cloudformation create-stack --stack-name ec2-with-block \
    --capabilities CAPABILITY_NAMED_IAM \
    --template-body file:///Users/abdulrasheedlawal/software-engineering/playground/sre/cloud/aws/playground/cloudformation/ec2-with-block-storage/stack.json \
    --parameters ParameterKey=KeyName,ParameterValue=plg-us-east-1 \
    ParameterKey=VPC,ParameterValue=vpc-094246dbf6f82e3d5 \
    ParameterKey=Subnet,ParameterValue=subnet-09e1ee16d2f218d62 \
    --client-request-token $(uuidgen)
