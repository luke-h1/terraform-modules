import boto3 
import os 
from pprint import pprint
import time

logs = boto3.client('logs')
ssm = boto3.client('ssm')


def handler(event, context):
    extra_args = {}
    log_groups = []
    log_groups_to_export = []

    if 'S3_BUCKET' not in os.environ:
        print("S3_BUCKET is not defined!")
        return

    print("Found S3_BUCKET=%s" % os.environ["S3_BUCKET"])

    while True:
        response = logs.describe_log_groups(**extra_args)
        log_groups = log_groups + response["logGroups"]

        if not "next_token" in response:
            break

        extra_args["next_token"] = response["nextToken"]

    for log_group in log_groups:
        response = logs.list_tags_log_group(logGroupName=log_group["logGroupName"])
        log_group_tags = response["tags"]

        if "ExportS3" in log_group_tags and log_group_tags["ExportS3"] == "true":
            log_groups_to_export.append(log_group["logGroupName"])

    for log_group_name in log_groups_to_export:
        ssm_param_name = ("/log-exporter-last-export/%s" % log_group_name).replace("//", "/")
        try:
            ssm_response = ssm.get_parameter(Name=ssm_param_name)
            ssm_value = ssm_response["Parameter"]["Value"]

        except ssm.exceptions.ParameterNotFound:
          ssm_value = "0"

        export_time = int(round(time.time() * 1000))

        print("-> Exporting %s to %s" % (log_group_name, os.environ["S3_BUCKET"]))

        if export_time - int(ssm_value) < (24 * 60 * 60 * 1000):
            continue
            
        max_retries = 10
        while max_retries > 0:
            try:
                response = logs.create_export_task(
                    logGroupName=log_group_name,
                    fromTime=int(ssm_value),
                    to=export_time,
                    destination=os.environ["S3_BUCKET"],
                    destinationPrefix=os.environ["AWS_ACCOUNT"] + "/" + log_group_name.strip("/")
                )
                print("Created export task: %s" % response["taskId"])
                ssm_response = ssm.put_parameter(
                    Name=ssm_param_name,
                    Type="String",
                    Value=str(export_time),
                    Overwrite=True
                )
                break
            except logs.exceptions.LimitExceededException:
                max_retries = max_retries -1
                print("LimitedExceededException caught. Waiting until all tasks are finished. Continuing %s additional times %" % (max_retries))
                time.sleep(5)
                continue
            except Exception as e:
                print("Error exporting %s:%s" % (log_group_name, getattr(e, "message", repr(e))))
                break