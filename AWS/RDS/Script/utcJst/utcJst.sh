#!/bin/bash
awsopts="--output text --no-cli-pager"
. utcJst.conf
[[ ${#clusters} == 0 ]] && echo "utcJst.conf has empty list." && exit 255
for c in ${clusters[@]}; do
  for utc_window in $(aws rds describe-db-clusters ${awsopts} --db-cluster-identifier $c --query "DBClusters[].[PreferredMaintenanceWindow]"); do
   for jst_window in $(echo $utc_window | \
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
      }'); do
      echo $c"  "$utc_window"  "$jst_window
    done
  done
done > utcJst.txt
 