#!/usr/bin/env python3

"""
 @file src/database.py
 @author Pavan Dayal
"""

from flask import Flask
app = Flask(__name__)

@app.route("/")
def server_status():
    return {"status": "ok"}

@app.route("/get")
def get_data():
    data = [{"time":1, "num":3.14}, {"time":2, "num":2.718}]
    return {"status": "success", "data": data}

@app.route("/append")
def add_data():
    return {"status": "success"}

def foo(a):
    return a + 1
