#!/usr/bin/env python

import functools

import boto3
import c7n.cli
from c7n import mu


@functools.wraps(boto3.session.Session.client)
def client_wrapper(f):
    def wrapper(self, *args, **kwargs):
        kwargs['endpoint_url'] = 'http://localhost:4566'
        return f(self, *args, **kwargs)
    return wrapper

mu.PolicyHandlerTemplate = """\
import functools
import os
import boto3
from c7n import handler
@functools.wraps(boto3.session.Session.client)
def client_wrapper(f):
    def wrapper(self, *args, **kwargs):
        kwargs['endpoint_url'] = f'http://{os.environ.get("LOCALSTACK_HOSTNAME")}:4566'
        return f(self, *args, **kwargs)
    return wrapper
def run(event, context):
    boto3.session.Session.client = client_wrapper(boto3.session.Session.client)
    return handler.dispatch_event(event, context)
"""

if __name__ == '__main__':
    boto3.session.Session.client = client_wrapper(boto3.session.Session.client)
    c7n.cli.main()
