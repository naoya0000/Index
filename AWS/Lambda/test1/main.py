import json
import boto3

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    bucket_name = 's3-test-8365737289'
    input_key = 'a.json'
    output_key = 'b.json'

    try:
        # S3からa.jsonを取得
        response = s3_client.get_object(Bucket=bucket_name, Key=input_key)
        content = response['Body'].read().decode('utf-8')
        data = json.loads(content)

        # データを編集
        data['file_name'] = 'b.json'
        data['number'] = 21

        # b.jsonとしてS3にアップロード
        updated_content = json.dumps(data)
        s3_client.put_object(Bucket=bucket_name, Key=output_key, Body=updated_content)

        return {
            'statusCode': 200,
            'body': json.dumps('Success')
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error: {str(e)}')
        }