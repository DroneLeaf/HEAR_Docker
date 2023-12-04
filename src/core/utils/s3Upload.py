import sys
import boto3

import os
import sys
import threading


from botocore.exceptions import NoCredentialsError, ClientError
import os
import progressbar
import time
from progressbar import ProgressBar, Percentage, \
    Timer, ETA, Counter,Bar

AWS_S3_BUCKET_NAME = 'hear-bucket'
AWS_REGION = 'me-south-1'
***HA-REMOVED-BY-HASHIM***
***HA-REMOVED-BY-HASHIM***

LOCAL_FILE = "hear_fc_devel.zip"
NAME_FOR_S3 = 'hear_arch/'+sys.argv[1]
print(NAME_FOR_S3)


            
def main():
    print('uploading... 🤌 🤌 🤌:) ☁️')
    
    # init s3_client
    s3_client = boto3.client(
        service_name='s3',
        region_name=AWS_REGION,
        aws_access_key_id=AWS_ACCESS_KEY,
        aws_secret_access_key=AWS_SECRET_KEY
    )
    
    # define proggress bar
    statinfo = os.stat(LOCAL_FILE)
    widgets = [Percentage()," | ",Timer(), " ",Bar('*'),ETA()]
    up_progress = progressbar.progressbar.ProgressBar(maxval=statinfo.st_size,widgets=widgets)
    up_progress.start()
    def upload_progress(chunk):
       up_progress.update(up_progress.currval + chunk)

    # start upload
    response = s3_client.upload_file(LOCAL_FILE, AWS_S3_BUCKET_NAME, NAME_FOR_S3,
    Callback=upload_progress)
    up_progress.finish()

    print('Congrates, The file will be there 👍:)')
    print('https://hear-bucket.s3.me-south-1.amazonaws.com/'+NAME_FOR_S3)

if __name__ == '__main__':
    main()


