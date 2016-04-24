#!/usr/bin/env python
#
# Copyright 2016 Robert King, Jacky Liang, Troy Mullins, and Thomas Norby
# Licensed under MIT
# (https://github.com/Mullinst/SER-FP/blob/master/LICENSE)
#
# database_functions.py -- 

import psycopg2


def connect(database_name="database"):
    """Connect to the PostgreSQL database.  Returns a database connection."""
    try:
        db = psycopg2.connect("dbname={}".format(database_name))
        cursor = db.cursor()
        return db, cursor
    except:
        print("Error connecting to the database: {}".format(database_name))

# User Helper Functions
def createUser(login_session):
    """creates a user"""
    db, cursor = connect()
    name = login_session.get('username')
    email = login_session.get('email')
    picture = login_session.get('picture')
    query = "INSERT INTO Users (name, email, picture) VALUES (%s,%s,%s);"
    param = (name, email, picture,)
    cursor.execute(query, param)
    db.commit()
    query = "SELECT id FROM Users WHERE email = %s"
    param = (email,)
    cursor.execute(query, param)
    user_id = cursor.fetchone()[0]
    db.close()
    return user_id


def getUserID(email):
    try:
        db, cursor = connect()
        query = "SELECT id FROM Users WHERE email = %s"
        param = (email,)
        cursor.execute(query, param)
        user_id = cursor.fetchone()[0]
        db.close()
        return user_id
    except:
        return None
