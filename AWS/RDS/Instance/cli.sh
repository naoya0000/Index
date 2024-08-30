aws rds describe-db-instances \
--query "DBInstances[].[\
    DBClusterIdentifier,\
    DBInstanceIdentifier,\
    DBInstanceArn,\
    InstanceCreateTime,\
    Endpoint.Address,\
    DBParameterGroups[]|[0].DBParameterGroupName,\
    DBParameterGroups[]|[0].ParameterApplyStatus,\
    DeletionProtection,\
    DBSubnetGroup.DBSubnetGroupName,\
    AvailabilityZone,\
    MultiAZ,\
    EngineVersion,\
    DBInstanceClass,\
    Engine,\
    DBInstanceStatus,\
    MasterUsername,\
    DBName,\
    PreferredBackupWindow,\
    BackupRetentionPeriod,\
    PreferredMaintenanceWindow,\
    KmsKeyId,\
    MonitoringInterval,\
    CopyTagsToSnapshot,\
    PerformanceInsightsEnabled,\
    TagList[?Key==\`aaa\`]|[0].Value\
    ]" --output text > rdsinstance.txt
    