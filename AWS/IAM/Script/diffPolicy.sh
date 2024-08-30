#!/bin/bash
 
# 引数チェック
if [ $# -ne 1 ]; then
    echo "ERROR: 引数≠1"
    exit 1
fi
 
# 引数１
POLICY_ARN=$1
 
# 現在の日付
DATE=$(TZ=Asia/Tokyo date "+%Y%m%d_%H%M%S")
 
# スクリプト実行ディレクトリの確認
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
 
# 同形式のファイルのリストを取得
FILES=$(find "$SCRIPT_DIR" -type f -name "*.json")
 
# 既存JSONファイル削除
if [ $(echo "$FILES" | wc -w) -ge 2 ]; then
    rm -i *.json
fi
 
# ポリシーバージョン取得
VERSION=$(aws iam get-policy --policy-arn "$POLICY_ARN" --query "Policy.DefaultVersionId" --output text)
 
# ポリシー記述取得
POLICY_INFO=$(aws iam get-policy-version --policy-arn "$POLICY_ARN" --version-id "$VERSION" --output json)
 
# ファイル名１
OUTPUT="dfp$DATE.json"
 
# ファイル出力
echo "$POLICY_INFO" > "$OUTPUT"
 
# 出力ファイル確認
echo "$OUTPUT"
 
# 同形式のファイルのリストを取得
FILES=$(find "$SCRIPT_DIR" -type f -name "*.json")
 
# ファイル数チェック
if [ $(echo "$FILES" | wc -w) -ne 2 ]; then
    echo "MESSAGE: 同形式ファイル≠2"
    exit 1
fi
 
# ファイル名２
EVIDENCE="dfip$DATE.txt"
 
# ファイル比較
count=0
for file1 in $FILES; do
    ((count++))
    for file2 in $FILES; do
        if [ "$file1" != "$file2" ] && [ $count -eq 1 ]; then
            echo "vimdiff $file1 $file2"
            vimdiff "$file1" "$file2"
            diff "$file1" "$file2" > "ed/${EVIDENCE}"
        fi
    done
done