import boto3
from datetime import datetime

def lambda_handler(event, context):
    # S3クライアントの作成
    s3_client = boto3.client('s3')

    bucket_name = 's3-test-8365737289'

    # 現在の日付を取得
    current_date = datetime.now().strftime('%Y%m%d')
    
    # タグ
    tags = {
        'TagSet': [
            {
                'Key': 'Date',
                'Value': current_date
            }
        ]
    }
    
    # タグをS3バケットに設定
    s3_client.put_bucket_tagging(
        Bucket=bucket_name,
        Tagging=tags
    )
    
    return {
        'statusCode': 200,
        'body': f'Success {bucket_name}'
    }
