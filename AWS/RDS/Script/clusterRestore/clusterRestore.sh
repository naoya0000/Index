#!/bin/bash
awsopts="--output text --no-cli-pager"
. clusterRestore.conf
[[ ${#cluster} == 0 ]] && echo "clusterRestore.conf has empty list." && exit 255
 
echo -e "\n◆情報取得日時 : $(TZ=Asia/Tokyo date "+%Y-%m-%d (%A) %H:%M")" > clusterRestore.txt
 
echo -e "\n\n【0】クラスター\n${cluster[0]}\n${cluster[0]}-old" >> clusterRestore.txt
 
count=0
for wi in $(aws rds describe-db-clusters ${awsopts} --db-cluster-identifier ${cluster[0]} --query "DBClusters[].DBClusterMembers[?IsClusterWriter==\`true\`].[DBInstanceIdentifier]"); do
  ((count++))
  wi_info=$(aws rds describe-db-instances --no-cli-pager --db-instance-identifier "${wi}" --query "DBInstances[].{\
  Engine: Engine,\
  EngineVersion: EngineVersion,\
  DBClusterIdentifier: DBClusterIdentifier,\
  DBInstanceIdentifier: DBInstanceIdentifier,\
  DBInstanceClass: DBInstanceClass,\
  DBSubnetGroupName: DBSubnetGroup.DBSubnetGroupName,\
  VpcSecurityGroupId: VpcSecurityGroups[*].VpcSecurityGroupId,\
  AvailabilityZone: AvailabilityZone,\
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
  echo -e "\n【$count】ライターインスタンス\n$wi\n$wi-old\n$wi_info"
done >> clusterRestore.txt
 
for ri in $(aws rds describe-db-clusters ${awsopts} --db-cluster-identifier ${cluster[0]} --query "DBClusters[].DBClusterMembers[?IsClusterWriter==\`false\`].[DBInstanceIdentifier]"); do
  ((count++))
  ri_info=$(aws rds describe-db-instances --no-cli-pager --db-instance-identifier "${ri}" --query "DBInstances[].{\
  Engine: Engine,\
  EngineVersion: EngineVersion,\
  DBClusterIdentifier: DBClusterIdentifier,\
  DBInstanceClass: DBInstanceClass,\
  AvailabilityZone: AvailabilityZone,\
  DBInstanceIdentifier: DBInstanceIdentifier,\
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
  echo -e "\n【$count】リーダーインスタンス\n$ri\n$ri-old\n$ri_info"
done >> clusterRestore.txt
