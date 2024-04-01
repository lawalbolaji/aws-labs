#!/bin/sh -ex

# freeze all writes on volume before creating snapshot to ensure data consistency -> fsfreeze -f /mnt/volume/
aws ec2 create-snapshot --volume-id vol-0d34bc22ce7515599
# unfreeze writes once snapshot is created fsfreeze -u /mnt/volume/