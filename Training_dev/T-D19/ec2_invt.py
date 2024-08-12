#!/usr/bin/env python3

import os
import json
import boto3

def get_inventory():
    # Set up AWS credentials and region
    aws_access_key_id = os.getenv('AWS_ACCESS_KEY_ID')
    aws_secret_access_key = os.getenv('AWS_SECRET_ACCESS_KEY')
    region_name = 'us-east-2'  # Your AWS region

    if not aws_access_key_id or not aws_secret_access_key:
        raise ValueError("AWS credentials are not set in environment variables")

    # Initialize the EC2 client
    ec2 = boto3.client(
        'ec2',
        aws_access_key_id=aws_access_key_id,
        aws_secret_access_key=aws_secret_access_key,
        region_name=region_name
    )
    
    # Describe instances with a specific tag
    response = ec2.describe_instances(Filters=[{'Name': 'tag:Role', 'Values': ['webserver']}])
    
    inventory = {
        'all': {
            'hosts': [],
            'vars': {}
        },
        '_meta': {
            'hostvars': {}
        }
    }

    # Path to your SSH private key file and SSH username
    ssh_key_file = '/home/einfochips/Downloads/ansible-worker.pem'  # Update this path if necessary
    ssh_user = 'ubuntu'  # SSH username
    
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            public_dns = instance.get('PublicDnsName', instance['InstanceId'])
            inventory['all']['hosts'].append(public_dns)
            inventory['_meta']['hostvars'][public_dns] = {
                'ansible_host': instance.get('PublicIpAddress', instance['InstanceId']),
                'ansible_ssh_private_key_file': ssh_key_file,
                'ansible_user': ssh_user
            }
    
    return inventory

if __name__ == '__main__':
    print(json.dumps(get_inventory(), indent=2))

