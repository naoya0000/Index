 
◆EC2用CLI
 
 
■一覧化資料用describeコマンド
aws ec2 describe-instances \
    --query "Reservations[].Instances[].[\
    AmiLaunchIndex,\
    ImageId,\
    InstanceId,\
    InstanceType,\
    LaunchTime,\
    Monitoring.State,\
    Placement.AvailabilityZone,\
    Placement.GroupName,\
    Placement.Tenancy,\
    PrivateDnsName,\
    PrivateIpAddress,\
    PublicDnsName,\
    State.Code,\
    State.Name,\
    StateTransitionReason,\
    SubnetId,\
    VpcId,\
    Architecture,\
    BlockDeviceMappings[]|[0].DeviceName,\
    BlockDeviceMappings[]|[0].Ebs.AttachTime,\
    BlockDeviceMappings[]|[0].Ebs.DeleteOnTermination,\
    BlockDeviceMappings[]|[0].Ebs.VolumeId,\
    ClientToken,\
    EbsOptimized,\
    EnaSupport,\
    Hypervisor,\
    IamInstanceProfile.Arn,\
    IamInstanceProfile.Id,\
    NetworkInterfaces[]|[0].Attachment.AttachTime,\
    NetworkInterfaces[]|[0].Attachment.AttachmentId,\
    NetworkInterfaces[]|[0].Attachment.DeleteOnTermination,\
    NetworkInterfaces[]|[0].Attachment.DeviceIndex,\
    NetworkInterfaces[]|[0].Attachment.Status,\
    NetworkInterfaces[]|[0].Attachment.NetworkCardIndex,\
    NetworkInterfaces[]|[0].Description,\
    NetworkInterfaces[]|[0].Groups[]|[0].GroupName,\
    NetworkInterfaces[]|[0].Groups[]|[0].GroupId,\
    NetworkInterfaces[]|[0].MacAddress,\
    NetworkInterfaces[]|[0].NetworkInterfaceId,\
    NetworkInterfaces[]|[0].OwnerId,\
    NetworkInterfaces[]|[0].PrivateDnsName,\
    NetworkInterfaces[]|[0].PrivateIpAddress,\
    NetworkInterfaces[]|[0].PrivateIpAddresses[]|[0].Primary,\
    NetworkInterfaces[]|[0].PrivateIpAddresses[]|[0].PrivateDnsName,\
    NetworkInterfaces[]|[0].PrivateIpAddresses[]|[0].PrivateIpAddress,\
    NetworkInterfaces[]|[0].SourceDestCheck,\
    NetworkInterfaces[]|[0].Status,\
    NetworkInterfaces[]|[0].SubnetId,\
    NetworkInterfaces[]|[0].VpcId,\
    NetworkInterfaces[]|[0].InterfaceType,\
    RootDeviceName,\
    RootDeviceType,\
    SecurityGroups[]|[0].GroupName,\
    SecurityGroups[]|[0].GroupId,\
    SourceDestCheck,\
    Tags[?Key==\`aws:cloudformation:stack-name\`]|[0].Value,\
    Tags[?Key==\`aws:cloudformation:stack-id\`]|[0].Value,\
    Tags[?Key==\`aws:cloudformation:logical-id\`]|[0].Value,\
    Tags[?Key==\`xxxx\`]|[0].Value,\
    VirtualizationType,\
    CpuOptions.CoreCount,\
    CpuOptions.ThreadsPerCore,\
    CapacityReservationSpecification.CapacityReservationPreference,\
    HibernationOptions.Configured,\
    MetadataOptions.State,\
    MetadataOptions.HttpTokens,\
    MetadataOptions.HttpPutResponseHopLimit,\
    MetadataOptions.HttpEndpoint,\
    MetadataOptions.HttpProtocolIpv6,\
    MetadataOptions.InstanceMetadataTags,\
    EnclaveOptions.Enabled,\
    PlatformDetails,\
    UsageOperation,\
    UsageOperationUpdateTime,\
    MaintenanceOptions.AutoRecovery\
    ]" --output text > describeInstances.txt
 
/home/cloudshell-user/describeInstances.txt
 
 
■特定情報のテーブル化
aws ec2 describe-instances \
--query "Reservations[].Instances[?Tags[?Key==\`aaa\` && Value==\`AAA\`] && Tags[?Key==\`bbb\` && Value==\`BBB\`]].[\
    Tags[?Key==\`ccc\`]|[0].Value,\
    PrivateIpAddress\
        ]" \
--output table
 
 
■対象EC2describe
aws ec2 describe-instances \
--instance-ids i-xxxx \
--query "Reservations[].Instances[].PrivateDnsNameOptions"
 
 
■EBS.DeleteOnTerminationの有効化・無効化
aws ec2 modify-instance-attribute \
  --instance-id <インスタンスID> \
  --block-device-mappings "[{\"DeviceName\": \"/dev/sda1\",\"Ebs\":{\"DeleteOnTermination\":false}}]"
 
 
■終了保護確認
aws ec2 describe-instance-attribute \
    --instance-id i-xxx \
    --attribute disableApiTermination \
    --query "DisableApiTermination.Value"