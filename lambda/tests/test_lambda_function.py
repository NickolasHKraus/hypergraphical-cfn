#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import unittest

import mock

from lambda_function import lambda_function

"""Tests for `lambda_function` package."""


class TestAWSLambda(unittest.TestCase):
    """Tests for `lambda_function` package."""

    def setUp(self):
        """Set up test fixtures, if any."""

    def tearDown(self):
        """Tear down test fixtures, if any."""

    def test_handler(self):
        """Test for handler function."""
        expected = {
            'isBase64Encoded': False,
            'statusCode': 200,
            'headers': {},
            'multiValueHeaders': {},
            'body': 'Hello, World!'
        }
        self.assertEqual(expected, lambda_function.handler({}, None))
