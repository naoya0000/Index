aws rds describe-db-clusters \
--query "DBClusters[].[\
    DBClusterIdentifier,\
    DeletionProtection,\
    EngineVersion,\
    DatabaseName,\
    MasterUsername,\
    PreferredBackupWindow,\
    PreferredMaintenanceWindow,\
    DBClusterParameterGroup,\
    DBSubnetGroup,\
    TagList[?Key==\`aaa\`]|[0].Value,\
    DBClusterMembers[]|[0].DBInstanceIdentifier,\
    DBClusterMembers[]|[1].DBInstanceIdentifier,\
    DBClusterMembers[]|[2].DBInstanceIdentifier\
    ]" --output text > rdscluster.txt
 
■条件指定のDescribe
aws rds describe-db-clusters \
--query "DBClusters[?TagList[?Key==\`aaa\` && Value==\`xxx\`]].[\
    DBClusterIdentifier,\
    EngineVersion,\
    TagList[?Key==\`aaa\`]|[0].Value\
        ]" \
--output table
 
■ラベル付与
aws rds describe-db-clusters \
--no-cli-pager \
--db-cluster-identifier xxxx \
--query "DBClusters[].{\
    DBClusterIdentifier: DBClusterIdentifier,\
    Engine: Engine,\
    EngineVersion: EngineVersion,\
    AvailabilityZones: AvailabilityZones[*],\
    DBSubnetGroup: DBSubnetGroup,\
    VpcSecurityGroupId: VpcSecurityGroups[*].VpcSecurityGroupId,\
    EnabledCloudwatchLogsExports: EnabledCloudwatchLogsExports[*],\
    KmsKeyId: KmsKeyId,\
    DBClusterParameterGroup: DBClusterParameterGroup,\
    CopyTagsToSnapshot: CopyTagsToSnapshot,\
    DeletionProtection: DeletionProtection,\
    TagList: TagList[*]\
    }"
 
 
■JST表示
aws rds describe-db-clusters \
--output text \
--filters Name=db-cluster-id,Values=xxxx \
--query "DBClusters[].PreferredMaintenanceWindow" | \
awk -F '[:-]' \
'{\
  days="sunmontuewedthufrisatsun";\
  day1=index(days,$1);\
  day2=index(days,$4);\
  jst_hour1=sprintf("%02d", (($2)+9)%24);\
  jst_hour2=sprintf("%02d", (($5)+9)%24);\
  if ($5 < 15) \
  {\
  print substr(days, day1, 3)":"jst_hour1":"$3"-"substr(days, day2, 3)":"jst_hour2":"$6\
  }\
  else if ($2 < 15 && $5 >= 15) \
  {\
  print substr(days, day1, 3)":"jst_hour1":"$3"-"substr(days, (day2+3), 3)":"jst_hour2":"$6\
  }\
  else \
  {\
  print substr(days, (day1+3), 3)":"jst_hour1":"$3"-"substr(days, (day2+3), 3)":"jst_hour2":"$6\
  }\
}'
