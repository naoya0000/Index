#!/bin/bash
awsopts="--output text --no-cli-pager"
. ebsRestore.conf
[[ ${#instances} == 0 ]] && echo "instances list is empty." && exit 255
[[ ${#List} == 0 ]] && echo "List is empty." && exit 255
 
echo -e "\n◆情報取得日時 : $(TZ=Asia/Tokyo date "+%Y-%m-%d (%A) %H:%M")" > ebsRestore.txt
 
 
echo -e "\n\n◆EC2主要タグ確認用(AAA/CCC/BBB/DDD/Name)" >> ebsRestore.txt
aws ec2 describe-instances \
--query "Reservations[].Instances[?Tags[?Key==\`AAA\` && Value==\`${List[0]}\`]].[\
    InstanceId,\
    Tags[?Key==\`AAA\`]|[0].Value,\
    Tags[?Key==\`CCC\`]|[0].Value,\
    Tags[?Key==\`BBB\`]|[0].Value,\
    Tags[?Key==\`DDD\`]|[0].Value,\
    Tags[?Key==\`Name\`]|[0].Value\
        ]" \
--output text >> ebsRestore.txt
 
 
echo -e "\n\n◆EBS主要タグ確認用(使用可能:available)" >> ebsRestore.txt
aws ec2 describe-volumes \
    --query "Volumes[?Tags[?Key==\`AAA\` && Value==\`${List[0]}\`] && State=='available'].[\
    VolumeId,\
    Tags[?Key==\`AAA\`]|[0].Value,\
    Tags[?Key==\`CCC\`]|[0].Value,\
    Tags[?Key==\`BBB\`]|[0].Value,\
    Tags[?Key==\`DDD\`]|[0].Value,\
    Tags[?Key==\`Name\`]|[0].Value\
    ]" \
    --output text >> ebsRestore.txt
 
 
echo -e "\n\n◆EBS主要タグ確認用(使用中:in-use)" >> ebsRestore.txt
aws ec2 describe-volumes \
    --query "Volumes[?Tags[?Key==\`AAA\` && Value==\`${List[0]}\`] && State=='in-use'].[\
    VolumeId,\
    Tags[?Key==\`AAA\`]|[0].Value,\
    Tags[?Key==\`CCC\`]|[0].Value,\
    Tags[?Key==\`BBB\`]|[0].Value,\
    Tags[?Key==\`DDD\`]|[0].Value,\
    Tags[?Key==\`Name\`]|[0].Value\
    ]" \
    --output text >> ebsRestore.txt
 
 
echo -e "\n\n\n◆作業用\n\n■旧ボリュームのリネーム\n-old-2024mmdd\n\n■リストア対象" >> ebsRestore.txt
 
for i in ${instances[@]}; do
  echo -e "\n\n\n■"$i
  for id in $(aws ec2 describe-instances ${awsopts} --query "Reservations[].Instances[?Tags[?Key=='Name' && Value=='$i']].[InstanceId]"); do
    AAA=$(aws ec2 describe-instances ${awsopts} --query "Reservations[].Instances[?Tags[?Key=='Name' && Value=='$i']].[Tags[?Key==\`AAA\`]|[0].Value]")
    BBB=$(aws ec2 describe-instances ${awsopts} --query "Reservations[].Instances[?Tags[?Key=='Name' && Value=='$i']].[Tags[?Key==\`BBB\`]|[0].Value]")
    CCC=$(aws ec2 describe-instances ${awsopts} --query "Reservations[].Instances[?Tags[?Key=='Name' && Value=='$i']].[Tags[?Key==\`CCC\`]|[0].Value]")
    count=0
    for vid in $(aws ec2 describe-instances ${awsopts} --instance-id $id --query "Reservations[].Instances[].BlockDeviceMappings[].Ebs.VolumeId"); do
      ((count++))
      echo -e "\n\n□$count"
      Name=$(aws ec2 describe-volumes ${awsopts} --volume-ids $vid --query "Volumes[].[Tags[?Key==\`Name\`]|[0].Value]")
      Create=$(aws ec2 describe-volumes ${awsopts} --volume-ids $vid --query "Volumes[].[VolumeType, Size, AvailabilityZone, KmsKeyId]")
      Device=$(aws ec2 describe-volumes ${awsopts} --volume-ids $vid --query "Volumes[].[Attachments[0].Device]")
      echo -e "【 スナップショットからボリュームを作成 】\n$Create\nName\n$Name"
      echo -e "【 ボリュームのアタッチ 】\n$id\n$Device"
      echo -e "【 CLI 】\naws ec2 create-tags --resources [vol-id] --tags Key=AAA,Value=$AAA Key=BBB,Value=$BBB Key=CCC,Value=$CCC Key=DDD,Value=ddd"
    done
  done
done >> ebsRestore.txt
