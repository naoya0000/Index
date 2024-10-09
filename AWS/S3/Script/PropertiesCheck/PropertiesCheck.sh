#!/bin/bash

# 引数チェック
if [ $# -ne 1 ]; then
    echo "ERROR: 引数≠1"
    exit 1
fi

# 引数
BUCKET=$1

# 現在の日付
echo -e "\n◆情報取得日時 : $(TZ=Asia/Tokyo date "+%Y-%m-%d (%A) %H:%M")" > s3.txt

# S3情報取得

echo -e "\n◆get-bucket-versioning" >> s3.txt
aws s3api get-bucket-versioning --bucket "$BUCKET" >> s3.txt

echo -e "\n◆get-bucket-taggingg" >> s3.txt
aws s3api get-bucket-tagging --bucket "$BUCKET" >> s3.txt

echo -e "\n◆get-bucket-encryption" >> s3.txt
aws s3api get-bucket-encryption --bucket "$BUCKET" >> s3.txt

# echo -e "\n◆get-bucket-intelligent-tiering-configuration" >> s3.txt
# aws s3api get-bucket-intelligent-tiering-configuration --bucket "$BUCKET" >> s3.txt

echo -e "\n◆get-bucket-logging-tiering-configuration" >> s3.txt
aws s3api get-bucket-logging --bucket "$BUCKET" >> s3.txt

echo -e "\n◆get-bucket-accelerate-configuration" >> s3.txt
aws s3api get-bucket-accelerate-configuration --bucket "$BUCKET" >> s3.txt

echo -e "\n◆get-bucket-acl" >> s3.txt
aws s3api get-bucket-acl --bucket "$BUCKET" >> s3.txt

echo -e "\n◆get-bucket-request-payment" >> s3.txt
aws s3api get-bucket-request-payment --bucket "$BUCKET" >> s3.txt

# echo -e "\n◆get-bucket-website" >> s3.txt
# aws s3api get-bucket-website --bucket "$BUCKET" >> s3.txt

echo -e "\n◆get-bucket-policy" >> s3.txt
aws s3api get-bucket-policy --bucket "$BUCKET" --query Policy --output text | jq . --indent 4 >> s3.txt

# echo -e "\n◆get-bucket-metrics-configuration" >> s3.txt
# aws s3api get-bucket-metrics-configuration --bucket "$BUCKET" >> s3.txt

# echo -e "\n◆get-bucket-lifecycle-configurationl" >> s3.txt
# aws s3api get-bucket-lifecycle-configuration --bucket "$BUCKET" >> s3.txt

# echo -e "\n◆get-bucket-replication" >> s3.txt
# aws s3api get-bucket-replication --bucket "$BUCKET" >> s3.txt

# echo -e "\n◆get-bucket-inventory-configuration" >> s3.txt
# aws s3api get-bucket-inventory-configuration --bucket "$BUCKET" >> s3.txt





