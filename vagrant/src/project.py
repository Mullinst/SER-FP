#!/usr/bin/env python
#
# Copyright 2016 Robert King, Jacky Liang, Troy Mullins, and Thomas Norby
# Licensed under MIT
# (https://github.com/Mullinst/SER-FP/blob/master/LICENSE)
#
# project.py -- 

from flask import Flask, render_template, request, redirect, jsonify, url_for, flash
from flask import session as login_session
import random
import string
from oauth2client.client import flow_from_clientsecrets
from oauth2client.client import FlowExchangeError
import httplib2
from flask import make_response
import requests

app = Flask(__name__)


# Show homepage
@app.route('/')
def showHome():
    return render_template('home.html')


if __name__ == '__main__':
    app.secret_key = 'super_secret_key'
    app.debug = True
    app.run(host='0.0.0.0', port=8000)
