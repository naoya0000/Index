import boto3
from datetime import datetime

def lambda_handler(event, context):
    s3_client = boto3.client('s3')
    bucket_name = 's3-test-8365737289'
    current_date = datetime.now().strftime('%Y%m%d')
    
    try:
        # 現在のタグを取得
        response = s3_client.get_bucket_tagging(Bucket=bucket_name)
        existing_tags = response['TagSet']
        
        # 新しいタグを追加
        new_tags = existing_tags + [
            {
                'Key': 'Date',
                'Value': current_date
            }
        ]
        
        # タグを更新
        s3_client.put_bucket_tagging(
            Bucket=bucket_name,
            Tagging={
                'TagSet': new_tags
            }
        )
        
        return {
            'statusCode': 200,
            'body': 'Success'
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Error: {str(e)}'
        }
