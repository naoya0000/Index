#!/bin/bash
awsopts="--output text --no-cli-pager"
. downloadLog.conf
[[ ${#clusters} == 0 ]] && echo "downloadLog.conf has empty list." && exit 255
for c in ${clusters[@]}; do
  for i in $(aws rds describe-db-clusters ${awsopts} --filters Name=db-cluster-id,Values=$c --query "DBClusters[].[DBClusterMembers[].[DBInstanceIdentifier]]"); do
    mkdir -p "${i}/error"
    for f in $(aws rds describe-db-log-files ${awsopts} --db-instance-identifier "${i}" --query "DescribeDBLogFiles[].[LogFileName]"); do
      echo "${i}/${f}" 1>&2
      aws rds download-db-log-file-portion ${awsopts} --db-instance-identifier "${i}" --log-file-name "${f}" > "${i}/${f}"
    done
  done
done