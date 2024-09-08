import boto3

def lambda_handler(event, context):
    # S3クライアントを作成
    s3_client = boto3.client('s3')
    
    bucket_name = 's3-test-8365737289'
    object_key = 'b.json'
    
    try:
        # S3からオブジェクトを削除
        s3_client.delete_object(Bucket=bucket_name, Key=object_key)
        
        return {
            'statusCode': 200,
            'body': 'Success'
        }
    except s3_client.exceptions.ClientError as e:
        return {
            'statusCode': 500,
            'body': f'Error: {str(e)}'
        }
