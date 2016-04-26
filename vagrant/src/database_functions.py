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
    """ creates a user using login session information """
    db, cursor = connect()
    name = login_session.get('username')
    email = login_session.get('email')
    picture = login_session.get('picture')
    query = "INSERT INTO Users (name, email, picture) VALUES (%s,%s,%s);"
    param = (name, email, picture,)
    cursor.execute(query, param)
    query = "SELECT id FROM Users WHERE email = %s;"
    param = (email,)
    cursor.execute(query, param)
    user_id = cursor.fetchone()[0]
    query = "INSERT INTO Permissions (user_id) VALUES (%s);"
    param = (user_id,)
    cursor.execute(query, param)
    db.commit()
    db.close()
    return user_id


def deleteUser(user_id):
    """ Deletes user from users table and returns the users information """
    try:
        db, cursor = connect()
        # Delete user permissions
        query = "DELETE FROM Permissions WHERE user_id = %s;"
        cursor.execute(query, user_id)
        # Delete user from Users table
        query = "DELETE FROM Users WHERE id = %s RETURNING *;"
        cursor.execute(query, user_id)
        user = cursor.fetchall()
        db.commit()
        db.close()
        return user
    except:
        return None


def getUserInfo(user_id):
    """ Returns user iformation for specified user """
    try:
        db, cursor = connect()
        query = "SELECT * FROM Users WHERE id = %s;"
        param = (user_id,)
        cursor.execute(query, param)
        user = cursor.fetchall()
        db.close()
        return user
    except:
        return None


def getUserID(email):
    """ Returns user id associated with given email """
    try:
        db, cursor = connect()
        query = "SELECT id FROM Users WHERE email = %s;"
        param = (email,)
        cursor.execute(query, param)
        user_id = cursor.fetchone()[0]
        db.close()
        return user_id
    except:
        return None


