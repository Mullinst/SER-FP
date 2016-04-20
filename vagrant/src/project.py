#!/usr/bin/env python
#
# Copyright 2016 Troy Mullins
# Licensed under MIT
# (https://github.com/Mullinst/SER-FP/blob/master/LICENSE)
#
# project.py -- 

from flask import Flask, render_template, request, redirect, jsonify, url_for, flash
import psycopg2
import string
import httplib2
from flask import make_response
import requests

app = Flask(__name__)

# Database functions
def connect(database_name="tournament"):
    """Connect to the PostgreSQL database.  Returns a database connection."""
    try:
        db = psycopg2.connect("dbname={}".format(database_name))
        cursor = db.cursor()
        return db, cursor
    except:
        print("Error connecting to the database: {}".format(database_name))


# Show catalog
@app.route('/')
def showHome():
    return render_template('home.html')


if __name__ == '__main__':
    app.secret_key = 'super_secret_key'
    app.debug = True
    app.run(host='0.0.0.0', port=8000)
