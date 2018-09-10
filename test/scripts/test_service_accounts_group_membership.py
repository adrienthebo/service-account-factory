#!/usr/bin/env python3
import os
import sys
sys.path.append(os.path.dirname(__file__) + '/../../scripts')

import unittest
from unittest.mock import patch
from service_accounts_group_membership import create_parser, GsuiteAPI


class GsuiteAPITest(unittest.TestCase):
    service_accounts = '[{ \
        "account_id":"service-account-one", \
        "description":"Service account description", \
        "groups":["test-group@example.com","test_sa_group@example.com"], \
        "network_access":"true", \
        "roles":["roles/editor","roles/browser"] \
    }]'

    def setUp(self):
        parser = create_parser()
        self.parser = parser

    def mock_create_service(credentials_path, email):
        return

    def test_initialize_without_credentials_file(self):
        with self.assertRaises(Exception) as cm:
            GsuiteAPI(credentials_path=None, email='fake@fake.com')

        self.assertEqual(
            str(cm.exception),
            'Missing service account credentials file'
        )

    def test_initialize_without_email(self):
        with self.assertRaises(Exception) as cm:
            GsuiteAPI(credentials_path='/valid/credentials.json', email=None)

        self.assertEqual(
            str(cm.exception),
            'Missing directory admin email address'
        )

    @patch('service_accounts_group_membership.GsuiteAPI.create_service',
           side_effect=mock_create_service)
    def test_add_members_with_groups(self, mock_create_service):
        service_accounts = '[{ \
            "description":"Service account description", \
            "groups":["test-group@example.com","test_sa_group@example.com"], \
            "network_access":"true", \
            "roles":["roles/editor","roles/browser"] \
        }]'

        gsuite = GsuiteAPI(credentials_path='/credentials/path', email='fake@fake.com')
        response = gsuite.add_members('project-id-123', service_accounts)

        self.assertEqual(response, True)

    @patch('service_accounts_group_membership.GsuiteAPI.create_service',
           side_effect=mock_create_service)
    def test_add_members_without_groups(self, mock_create_service):
        service_accounts = '''[{ \
            "account_id":"service-account-one", \
            "description":"Service account description", \
            "network_access":"true", \
            "roles":["roles/editor","roles/browser"] \
        }]'''

        gsuite = GsuiteAPI(credentials_path='/credentials/path', email='fake@fake.com')
        response = gsuite.add_members('project-id-123', service_accounts)

        self.assertEqual(response, True)


if __name__ == "__main__":
    unittest.main()
