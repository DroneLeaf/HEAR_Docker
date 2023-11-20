import boto3

AWS_S3_BUCKET_NAME = 'hear-bucket'
AWS_REGION = 'me-south-1'
AWS_ACCESS_KEY = 'AKIAUJ6SOV74EPNOMEGF'
AWS_SECRET_KEY = '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'

LOCAL_FILE = 'hear_fc_devel.zip'
NAME_FOR_S3 = 'hear_arch/hear_fc_devel.zip'

def main():
    print('uploading... :)')

    s3_client = boto3.client(
        service_name='s3',
        region_name=AWS_REGION,
        aws_access_key_id=AWS_ACCESS_KEY,
        aws_secret_access_key=AWS_SECRET_KEY
    )

    response = s3_client.upload_file(LOCAL_FILE, AWS_S3_BUCKET_NAME, NAME_FOR_S3)

    print('Congrates, The file will be there :)')
    print(f'upload_log_to_aws response: {response}')

if __name__ == '__main__':
    main()