import boto3

def run_fargate_task(s3filepath: str, cluster: str, taskDefinition: str, subnets: list, securityGroups: list, publicIP: bool = True,):
    client = boto3.client('ecs')
    response = client.run_task(
        cluster=cluster,
        launchType='FARGATE',
        taskDefinition=taskDefinition,
        count=1,
        platformVersion='LATEST',
        networkConfiguration={
            'awsvpcConfiguration': {
                'subnets': subnets,
                'assignPublicIp': 'ENABLED' if publicIP else 'DISABLED',
                'securityGroups': securityGroups,
            },
        },
        overrides={
            'containerOverrides':[
                {
                    'environment':[
                        {
                            'name':'S3_PATH',
                            'value':s3filepath
                        }
                    ]
                }
            ]
        }
    )
    return str(response)