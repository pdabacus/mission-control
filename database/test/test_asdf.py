#!/usr/bin/env python3

"""
 @file test/test_asdf.py
 @author Pavan Dayal
"""

import unittest
from src import database

class TestAsdf(unittest.TestCase):
    def test_main_foo(self):
        self.assertEqual(database.foo(1), 2, msg="not equal")
