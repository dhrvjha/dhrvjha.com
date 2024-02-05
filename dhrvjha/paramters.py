import boto3


def ssm_get_value(key: str):
    ssm = boto3.client('ssm')
    response = ssm.get_parameter(Name=key, WithDecryption=True)
    secret_value = response['Parameter']['Value']
    return secret_value
