aws ec2 describe-volumes \
    --query "Volumes[].[\
    VolumeId,\
    Attachments[0].InstanceId,\
    Attachments[0].Device,\
    Attachments[0].State,\
    Attachments[0].DeleteOnTermination,\
    AvailabilityZone,\
    Size,\
    State,\
    Encrypted.\
    KmsKeyId,\
    VolumeType,\
    Tags[?Key==\`Tag\`]|[0].Value\
    ]" --output text > ebs.txt


    