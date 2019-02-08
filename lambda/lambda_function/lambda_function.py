# -*- coding: utf-8 -*-
"""Main module."""

import json


def handler(event: dict, context: object) -> dict:
    """
    Handler of AWS Lambda function.

    :param event: event data
    :type event: dict
    :param context: runtime information of the AWS Lambda function
    :type context: LambdaContext object
    """
    response = {
        'isBase64Encoded': False,
        'statusCode': 200,
        'headers': {},
        'multiValueHeaders': {},
        'body': 'Hello, World!'
    }

    return response
