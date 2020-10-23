#!/usr/bin/env python3
"""
 @file src/database.py
 @author Pavan Dayal
"""

import argparse
from flask import Flask
app = Flask(__name__)

# TODO create interface to manage adding/removing/renaming sensors to sql db
sensors = [
    {
        "name" : "Altitude",
        "key" : "sensor-altitude",
        "identifier": {
            "namespace" : "liquidrocketry.sensors",
            "key": "sensor-altitude"
        }
    },
    {
        "name" : "Fuel",
        "key" : "sensor-fuel",
        "identifier": {
            "namespace" : "liquidrocketry.sensors",
            "key": "sensor-fuel"
        }
    }
]

@app.route("/")
def server_status():
    return {"status": "ok"}

@app.route("/sensors")
def get_sensors():
    return {
        "status": "ok",
        "data": {
            "sensors": sensors
        }
    }

@app.route("/get")
def get_data():
    data = [{"time":1, "num":3.14}, {"time":2, "num":2.718}]
    return {"status": "success", "data": data}

@app.route("/append")
def add_data():
    return {"status": "success"}

def foo(a):
    return a + 1

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="run sensor database")
    parser.add_argument("--host", default="0.0.0.0", help="host to bind to")
    parser.add_argument("--port", default=8080, type=int, help="port to bind to")
    parser.add_argument("--cert", default=None, help="https cert")
    parser.add_argument("--priv", default=None, help="https priv")
    args = parser.parse_args()
    #host = "0.0.0.0"
    #port = 8080
    #cert = "../ui/res/chain.crt"
    #priv = "../ui/res/priv.key"
    if args.cert and args.priv:
        app.run(
            host=args.host,
            port=args.port,
            ssl_context=(args.cert, args.priv)
        )
    else:
        app.run(
            host=args.host,
            port=args.port
        )

