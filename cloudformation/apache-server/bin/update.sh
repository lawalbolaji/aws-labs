# !/bin/sh -ex

aws cloudformation update-stack --stack-name apache-server \
    --template-body file:///Users/abdulrasheedlawal/software-engineering/playground/sre/cloud/aws/playground/cloudformation/apache-server/stack.json \
    --parameters ParameterKey=KeyName,UsePreviousValue=true \
    --client-request-token '6FF4057B-2FDE-4F71-92D4-7FAE768E8E18'
