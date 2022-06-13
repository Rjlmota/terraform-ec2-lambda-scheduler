import sys
import boto3
import json
from botocore.exceptions import ClientError

regiao = 'us-east-1'

def lambda_handler(event, context):
    instancias = event.get('ec2id')
    operacao = event.get('action')

    instancias = instancias.split(",")

    # '' ou None ?
    if instancias is None or operacao is None:
        print("Campos incompletos.")
        return("Campos incompletos.")
    
    if operacao == "start":
                try:
                    ec2 = boto3.client('ec2', region_name=regiao)
                    response = ec2.start_instances(InstanceIds=instancias, DryRun=False)
                    print(response)
                except ClientError as e:
                    print(e)
                    return(e.response['Error']['Message'])
    elif operacao == "stop":
                try:
                    ec2 = boto3.client('ec2', region_name=regiao)
                    response = ec2.stop_instances(InstanceIds=instancias, DryRun=False)
                    print(response)
                except ClientError as e:
                    print(e)
                    return(e.response['Error']['Message'])

    else:
        print("Not a valid option")