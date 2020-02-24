#!/bin/bash
app=database.py
mode=development
host=0.0.0.0
port=6969

FLASK_APP=$app FLASK_ENV=$mode python -m flask run -h $host -p $port
