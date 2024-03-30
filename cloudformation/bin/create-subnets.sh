# for some reason, systemctl cannot start httpd - need to investigate this
# solution:

# checked the logs, it turns out:
# my instance didn't have the right permissions
# the index.txt file had the wrong extension, apache expects a index.html at /var/www/html/index.html

# public 1a
aws ec2 run-instances \
    --image-id ami-0df435f331839b2d6 \
    --key-name mykey \
    --instance-type t2.micro \
    --security-group-ids sg-01a9f495fe630315f \
    --subnet-id subnet-0163464213442409a \
    --metadata-options "HttpTokens=optional" \
    --user-data file://get-user-data.txt \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=public-1a}]'

# public 1b
aws ec2 run-instances \
    --image-id ami-0df435f331839b2d6 \
    --key-name mykey \
    --instance-type t2.micro \
    --security-group-ids sg-01a9f495fe630315f \
    --subnet-id subnet-02d8c75187b6dd5fb \
    --metadata-options "HttpTokens=optional" \
    --user-data file://get-user-data.txt \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=public-1b}]'

# private 1a
aws ec2 run-instances \
    --image-id ami-0df435f331839b2d6 \
    --key-name mykey \
    --instance-type t2.micro \
    --subnet-id subnet-0d3d1c419b616d677 \
    --metadata-options "HttpTokens=optional" \
    --user-data file://get-user-data.txt \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=private-1a}]'

# private 1b
aws ec2 run-instances \
    --image-id ami-0df435f331839b2d6 \
    --key-name mykey \
    --instance-type t2.micro \
    --subnet-id subnet-023a55f9ec2fb4d18 \
    --metadata-options "HttpTokens=optional" \
    --user-data file://get-user-data.txt \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=private-1b}]'
