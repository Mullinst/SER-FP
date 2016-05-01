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
        param = (user_id,)
        cursor.execute(query, param)
        # Delete user from Users table
        query = "DELETE FROM Users WHERE id = %s RETURNING *;"
        cursor.execute(query, param)
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


def getUserType(user_id):
    """ Returns userType for given user. """
    try:
        db, cursor = connect()
        query = "SELECT userType FROM Users WHERE id = %s;"
        param = (user_id,)
        cursor.execute(query, param)
        userType = cursor.fetchone()[0]
        db.close()
        return userType
    except:
        return None


def changeUserType(user_id, userType):
    """ Change userType of given user. """
    try:
        if userType == 'Employee' or userType == 'Store Manager' or userType == 'Admin':
            db, cursor = connect()
            query = "UPDATE Users SET userType = %s WHERE id = %s"
            param = (userType, user_id,)
            cursor.execute(query, param)
            db.commit()
            db.close()
            return userType
        else:
            return None
    except:
        return None

def editUserPermissions(current_user_id, user_id, post=True,
        accept=True, approve_requests=False,
        delete_requests=False, edit_permissions=False):
    """ Edit given users permissions.
    Args:
        current_user_id: User id of the user attempting
            to edit permissions.
        user_id: An integer referencing the user whose
            permissions will be editted. 

    Optional Args:
        post: Boolean value referencing posting permission.
        accept: Boolean value referencing permission to accept shifts. 
        approve_requests: Boolean value referencing permission
            to approve shift changes.
        delete_requests: Boolean value referencing permission
            to delete users posts.
        edit_permissions: Boolean value referencing Permissions
            to edit users permissions.
    """
    try:
        db, cursor = connect()
        # Check that current user has permission to edit permissions.
        query = ("SELECT edit_permissions FROM Permissions "
                 "WHERE user_id = %s;")
        param = (current_user_id,)
        cursor.execute(query, param)
        user_edit_permissions = cursor.fetchone()[0]
        if user_edit_permissions == True:
            # If the current user has permission to edit permissions
            # edit the permissions of the defined user.
            if current_user_id == user_id:
                # If the current user has permission to edit override defualt.
                edit_permissions = True
            query = ("UPDATE Permissions SET post = %s, accept = %s,"
                     "approve_requests = %s, delete_requests = %s,"
                     "edit_permissions = %s WHERE user_id = %s;")
            param = (post, accept, approve_requests, delete_requests,
                     edit_permissions, int(user_id),)
            print param
            cursor.execute(query, param)
            db.commit()
            db.close()
            return True
    except:
        return None


def createShift(user_id, shift_number, date, is_urgent=False):
    """ Creates shift cover request """
    try:
        db, cursor = connect()
        query = "SELECT storeID FROM Users WHERE id = %s;"
        param = (user_id,)
        print param
        cursor.execute(query, param)
        storeID = cursor.fetchone()[0]
        query = "INSERT INTO Shifts (requestor_user_ID, shift_number, shift_day, isUrgent, storeID) VALUES (%s,%s,%s,%s,%s);"
        param = (user_id, int(shift_number), str(date), is_urgent, storeID,)
        print param
        cursor.execute(query, param)
        db.commit()
        db.close()
        return True
    except:
        return None

def deleteShift(user_id, shift_id):
    """ Deletes given shift """
    return None

def getApplicants():
    """ Returns the id and name pairs of all applicants. """
    try:
        db, cursor = connect()
        query = "SELECT * FROM applicants;"
        cursor.execute(query)
        applicants = cursor.fetchall()
        db.close()
        return applicants
    except:
        return None


def getUsers():
    """ Returns id and name pairs for all users. """
    try:
        db, cursor = connect()
        query = "SELECT id, name FROM Users;"
        cursor.execute(query)
        users = cursor.fetchall()
        db.close()
        return users
    except:
        return None


def getShifts(email):
    try:
        db, cursor = connect()
        query = ("SELECT * FROM Users, Shifts"
                "WHERE Users.email = %s"
                "AND Users.id = Shifts.assigneeID;")
        params = (email)
        cursor.execute(query, params)
        shifts = cursor.fetchall()
        db.close()
        return shifts
    except:
        return None
