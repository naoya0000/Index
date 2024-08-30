#!/bin/bash
awsopts="--output text --no-cli-pager"
. globalRestore.conf
[[ ${#globalcluster} == 0 ]] && echo "globalRestore.conf has empty list." && exit 255
 
echo -e "\n◆情報取得日時 : $(TZ=Asia/Tokyo date "+%Y-%m-%d (%A) %H:%M")" > globalRestore.txt
 
echo -e "\n\n■グローバルクラスター\n${globalcluster[0]}\n$(aws rds describe-global-clusters ${awsopts} --global-cluster-identifier "${globalcluster[0]}" --query "GlobalClusters[].[GlobalClusterArn]")" >> globalRestore.txt
for p in $(aws rds describe-global-clusters ${awsopts} --global-cluster-identifier "${globalcluster[0]}" --query "GlobalClusters[].GlobalClusterMembers[?IsWriter==\`true\`].[DBClusterArn]"); do
  for pc in $(aws rds describe-db-clusters ${awsopts} --query "DBClusters[?DBClusterArn==\`${p}\`].[DBClusterIdentifier]"); do
    pc_info=$(aws rds describe-db-clusters --no-cli-pager --db-cluster-identifier "${pc}" --query "DBClusters[].{\
    DBClusterIdentifier: DBClusterIdentifier,\
    DBClusterArn: DBClusterArn,\
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
    }")
    echo -e "\n■東京側プライマリクラスター\n$pc_info"
  done
  count=0
  for pi in $(aws rds describe-db-clusters ${awsopts} --query "DBClusters[?DBClusterArn==\`${p}\`].DBClusterMembers[].[DBInstanceIdentifier]"); do
    ((count++))
    wr_p=$(aws rds describe-db-clusters ${awsopts} --query "DBClusters[].DBClusterMembers[?DBInstanceIdentifier==\`${pi}\`].[IsClusterWriter]")
    pi_info=$(aws rds describe-db-instances --no-cli-pager --db-instance-identifier "${pi}" --query "DBInstances[].{\
    AvailabilityZone: AvailabilityZone,\
    DBInstanceIdentifier: DBInstanceIdentifier,\
    DBInstanceClass: DBInstanceClass,\
    Engine: Engine,\
    EngineVersion: EngineVersion,\
    DBClusterIdentifier: DBClusterIdentifier,\
    DBParameterGroups: DBParameterGroups[].DBParameterGroupName,\
    AutoMinorVersionUpgrade: AutoMinorVersionUpgrade,\
    PerformanceInsightsEnabled: PerformanceInsightsEnabled,\
    PerformanceInsightsKMSKeyId: PerformanceInsightsKMSKeyId,\
    PreferredMaintenanceWindow: PreferredMaintenanceWindow,\
    MonitoringInterval: MonitoringInterval,\
    MonitoringRoleArn: MonitoringRoleArn,\
    PerformanceInsightsRetentionPeriod: PerformanceInsightsRetentionPeriod,\
    TagList: TagList[*]\
    }")
    echo -e "\n【$count】東京側インスタンス（ライター: ${wr_p}）\n$pi_info"
  done
done >> globalRestore.txt
 
for s in $(aws rds describe-global-clusters ${awsopts} --global-cluster-identifier "${globalcluster[0]}" --query "GlobalClusters[].GlobalClusterMembers[?IsWriter==\`false\`].[DBClusterArn]"); do
  for sc in $(aws rds describe-db-clusters ${awsopts} --region=ap-northeast-3 --query "DBClusters[?DBClusterArn==\`${s}\`].[DBClusterIdentifier]"); do
    sc_info=$(aws rds describe-db-clusters --no-cli-pager --region=ap-northeast-3 --db-cluster-identifier "${sc}" --query "DBClusters[].{\
    DBClusterIdentifier: DBClusterIdentifier,\
    DBClusterArn: DBClusterArn,\
    Engine: Engine,\
    EngineVersion: EngineVersion,\
    AvailabilityZones: AvailabilityZones[*],\
    DBSubnetGroup: DBSubnetGroup,\
    VpcSecurityGroupId: VpcSecurityGroups[*].VpcSecurityGroupId,\
    EnabledCloudwatchLogsExports: EnabledCloudwatchLogsExports[*],\
    KmsKeyId: KmsKeyId,\
    DBClusterParameterGroup: DBClusterParameterGroup,\
    BackupRetentionPeriod: BackupRetentionPeriod,\
    PreferredBackupWindow: PreferredBackupWindow,\
    PreferredMaintenanceWindow: PreferredMaintenanceWindow,\
    CopyTagsToSnapshot: CopyTagsToSnapshot,\
    DeletionProtection: DeletionProtection,\
    TagList: TagList[*]\
    }")
    echo -e "\n■大阪側セカンダリクラスター\n$sc_info"
  done
  count=0
  for si in $(aws rds describe-db-clusters ${awsopts} --region=ap-northeast-3 --query "DBClusters[?DBClusterArn==\`${s}\`].DBClusterMembers[].[DBInstanceIdentifier]"); do
    ((count++))
    wr_s=$(aws rds describe-db-clusters ${awsopts} --region=ap-northeast-3 --query "DBClusters[].DBClusterMembers[?DBInstanceIdentifier==\`${si}\`].[IsClusterWriter]")
    si_info=$(aws rds describe-db-instances --no-cli-pager --region=ap-northeast-3 --db-instance-identifier "${si}" --query "DBInstances[].{\
    AvailabilityZone: AvailabilityZone,\
    DBInstanceIdentifier: DBInstanceIdentifier,\
    DBInstanceClass: DBInstanceClass,\
    Engine: Engine,\
    EngineVersion: EngineVersion,\
    DBClusterIdentifier: DBClusterIdentifier,\
    DBParameterGroups: DBParameterGroups[].DBParameterGroupName,\
    AutoMinorVersionUpgrade: AutoMinorVersionUpgrade,\
    PerformanceInsightsEnabled: PerformanceInsightsEnabled,\
    PerformanceInsightsKMSKeyId: PerformanceInsightsKMSKeyId,\
    PreferredMaintenanceWindow: PreferredMaintenanceWindow,\
    MonitoringInterval: MonitoringInterval,\
    MonitoringRoleArn: MonitoringRoleArn,\
    PerformanceInsightsRetentionPeriod: PerformanceInsightsRetentionPeriod,\
    TagList: TagList[*]\
    }")
    echo -e "\n【$count】大阪側インスタンス（ライター: ${wr_s}）\n$si_info"
  done
done >> globalRestore.txt