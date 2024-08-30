#!/bin/bash
awsopts="--output text --no-cli-pager"
. bpCheck.conf
[[ ${#buckets} == 0 ]] && echo "buckets list is empty." && exit 255
 
 
# 判定リスト
Required_elements=(
    "s3:GetObject"
    "StringNotLike"
)
 
# バケットポリシー判定
for b in ${buckets[@]}; do
    for POLICY in "$(aws s3api get-bucket-policy --bucket $b --query Policy --output text)"; do
        for element in "${Required_elements[@]}"; do
            if echo "$POLICY" | grep -q "$element"; then
                echo "$b    any"
            else
                echo "$b    none"
            fi
        done
    done
done > bpCheck.txt