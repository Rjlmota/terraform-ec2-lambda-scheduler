import botocore
import boto3
import logging
import json
import sys
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)
rds = boto3.client('rds')

""" 
    EventBridge sample event: 
    { 
        "action": "start",
        "rdsid": "rds-identifier",
        "is_cluster: "true"
    }
"""

def startRDS(rdsid, is_cluster):
    if is_cluster == 'true':
        try:
            rds.start_db_cluster(DBClusterIdentifier=rdsid)
            logger.info('Success :: start_db_cluster ' + rdsid) 
        except ClientError as e:
            logger.error(e)   
        return "started:OK"
    else:
        try:
            rds.start_db_instance(DBInstanceIdentifier=rdsid)
            logger.info('Success :: start_db_instance ' + rdsid) 
        except ClientError as e:
            logger.error(e)   
        return "started:OK"


def stopRDS(rdsid, is_cluster):
    if is_cluster == 'true':
        try:
            rds.stop_db_cluster(DBClusterIdentifier=rdsid)
            logger.info('Success :: stop_db_cluster ' + rdsid) 
        except ClientError as e:
            logger.error(e)   
        return "stopped:OK"
    else:
        try:
            rds.stop_db_instance(DBInstanceIdentifier=rdsid)
            logger.info('Success :: stop_db_instance ' + rdsid) 
        except ClientError as e:
            logger.error(e)   
        return "stopped:OK"


def lambda_handler(event, context):
    logger.info("Event: " + str(event))
    rdsid = event.get('rdsid')
    action = event.get('action')
    is_cluster = event.get('is_cluster')
    
    if action == 'start':
        startRDS(rdsid, is_cluster)
    elif action == 'stop':
        stopRDS(rdsid)
        
    return {
    	'statusCode': 200,
    	'body': json.dumps("Script execution completed. See Cloudwatch logs for complete output")
	}
