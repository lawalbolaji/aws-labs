# !/bin/sh -ex

aws cloudformation create-stack --stack-name apache-server \
    --template-body file:///Users/abdulrasheedlawal/software-engineering/playground/sre/cloud/aws/playground/cloudformation/apache-server/stack.json \
    --parameters ParameterKey=KeyName,ParameterValue=plg-us-east-1 \
    --client-request-token $(uuidgen)
