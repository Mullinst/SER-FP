#!/usr/bin/env python
#
# Copyright 2016 Robert King, Jacky Liang, Troy Mullins, and Thomas Norby
# Licensed under MIT
# (https://github.com/Mullinst/SER-FP/blob/master/LICENSE)
#
# database_functions.py -- All functions for interacting with the database.
# @author - Troy Mullins

import psycopg2

def connect(database_name="database"):
    """Connect to the PostgreSQL database.  Returns a database connection."""
    try:
        db = psycopg2.connect("dbname={}".format(database_name))
        cursor = db.cursor()
        return db, cursor
    except:
        print("Error connecting to the database: {}".format(database_name))


# ---------------- #
#  User Functions  #
# ---------------- #
def createUser(login_session):
    """ creates a user using login session information """
    try:
        db, cursor = connect()
        # Localize login session information 
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
            query = "SELECT userType FROM Users WHERE id = %s"
            param = (user_id,)
            cursor.execute(query, param)
            selected_type = cursor.fetchone()[0]
            if selected_type == 'Admin':
                # By default, all admins have permission to edit permissions.
                query = "UPDATE Permissions SET edit_permissions = true WHERE id = %s"
                param = (user_id,)
                cursor.execute(query, param)
            db.commit()
            db.close()
            return selected_type
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
        user = cursor.fetchall()[0]
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


def getUserPermissions(user_id):
    """ Returns permissions for a given user. """
    try:
        db, cursor = connect()
        query = ("SELECT post, accept, approve_requests, "
                 "delete_requests, edit_permissions "
                 "FROM Permissions WHERE user_id = %s;")
        param = (user_id,)
        cursor.execute(query, param)
        perms = cursor.fetchall()[0]
        db.close()
        return perms
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


def getStoreManager(storeID):
    """ Returns the name of the store manager for a given store. """
    try:
        db, cursor = connect()
        query = "SELECT storeManagerID FROM Stores WHERE storeID = %s;"
        params = (storeID,)
        cursor.execute(query, params)
        storeManagerID = cursor.fetchone()[0]
        query = "SELECT name FROM Users WHERE id = %s;"
        params = (storeManagerID,)
        cursor.execute(query, params)
        name = cursor.fetchone()[0]
        db.close()
        return name
    except:
        return None


def getStoreManagerID(storeID):
    """ Returns the ID of the store manager for a given store. """
    try:
        db, cursor = connect()
        query = "SELECT storeManagerID FROM Stores WHERE storeID = %s;"
        params = (storeID,)
        cursor.execute(query, params)
        storeManagerID = cursor.fetchone()[0]
        db.close()
        return storeManagerID
    except:
        return None




# ----------------- #
#  Shift Functions  #
# ----------------- #
def createShift(user_id, shift_number, date, is_urgent=False):
    """ Creates shift cover request """
    try:
        db, cursor = connect()
        # Get users post permission
        query = "SELECT post FROM Permissions WHERE user_id = %s"
        param = (user_id,)
        cursor.execute(query, param)
        postPerm = cursor.fetchone()[0]
        if postPerm == True:
            query = "SELECT storeID FROM Users WHERE id = %s;"
            param = (user_id,)
            cursor.execute(query, param)
            storeID = cursor.fetchone()[0]
            query = "INSERT INTO Shifts (requestor_ID, shift_number, shift_day, isUrgent, storeID) VALUES (%s,%s,%s,%s,%s);"
            param = (user_id, int(shift_number), str(date), is_urgent, storeID,)
            cursor.execute(query, param)
            db.commit()
            db.close()
            return True
    except:
        return None


def relistShift(user_id, shift_id):
    """ Edits shift to reflect relisting """
    try:
        db, cursor = connect()
        # Get users post permission
        query = "SELECT post FROM Permissions WHERE user_id = %s"
        param = (user_id,)
        cursor.execute(query, param)
        postPerm = cursor.fetchone()[0]
        if postPerm == True:
            query = "UPDATE Shifts SET requestor_ID = %s, acceptor_ID = null, isUrgent = true, status = 'Active' WHERE shiftID = %s;"
            param = (user_id, shift_id,)
            cursor.execute(query, param)
            db.commit()
            db.close()
            return True
    except:
        return None    


def editShift(shift_id, shift_number, date, is_urgent=False):
    """ Edit given shift """
    try:
        db, cursor = connect()
        query = "UPDATE Shifts SET shift_number = %s, shift_day = %s, isUrgent = %s WHERE shiftID = %s;"
        param = (int(shift_number), str(date), is_urgent, shift_id,)
        cursor.execute(query, param)
        db.commit()
        db.close()
        return True
    except:
        return None


def deleteShift(user_id, shift_id):
    """ Deletes given shift """
    try:
        db, cursor = connect()
        # Get requestor ID
        query = "SELECT requestor_ID FROM Shifts WHERE shiftID = %s"
        param = (shift_id,)
        cursor.execute(query, param)
        ownerID = cursor.fetchone()[0]
        # Get users delete permission
        query = "SELECT delete_requests FROM Permissions WHERE user_id = %s"
        param = (user_id,)
        cursor.execute(query, param)
        userDeletePerm = cursor.fetchone()[0]
        if user_id == ownerID or userDeletePerm == True:
            query = "DELETE FROM Shifts WHERE shiftID = %s;"
            param = (shift_id,)
            cursor.execute(query, param)
            db.commit()
            db.close()
            return True
    except:
        return None


def acceptShift(user_id, shift_id):
    """ Updates shift to reflect acceptors information. """
    try:
        db, cursor = connect()
        # Get users accept permission
        query = "SELECT accept FROM Permissions WHERE user_id = %s"
        param = (user_id,)
        cursor.execute(query, param)
        acceptPerm = cursor.fetchone()[0]
        if acceptPerm == True:
            query = "UPDATE Shifts SET acceptor_ID = %s, status = 'Pending' WHERE shiftID = %s;"
            param = (user_id,shift_id,)
            cursor.execute(query, param)
            db.commit()
            db.close()
            return True
    except:
        return None


def approveShift(user_id, shift_id):
    """ Updates status of shift change request if the user
    calling the function has permission to approve requests. """
    try:
        db, cursor = connect()
        query = "SELECT approve_requests FROM Permissions WHERE user_id = %s"
        param = (user_id,)
        cursor.execute(query, param)
        result = cursor.fetchone()[0]
        if result == True:
            query = "UPDATE Shifts SET status = 'Approved' WHERE shiftID = %s;"
            param = (shift_id,)
            cursor.execute(query, param)
            db.commit()
            db.close()
            return True
    except:
        return None

def getRequestedShiftChanges(user_id):
    """ Returns all shift change requests created by the user. """
    try:
        db, cursor = connect()
        query = "SELECT * FROM Shifts WHERE requestor_id = %s ORDER BY shift_day;"
        params = (user_id,)
        cursor.execute(query, params)
        shifts = cursor.fetchall()
        db.close()
        return shifts
    except:
        return None


def getPendingShiftChangesByStore(store_id):
    """ Returns all pending shift changes for a given store. """
    try:
        db, cursor = connect()
        query = "SELECT * FROM Shifts WHERE storeID = %s AND status = 'Pending' ORDER BY shift_day;"
        params = (store_id,)
        cursor.execute(query, params)
        shifts = cursor.fetchall()
        db.close()
        return shifts
    except:
        return None

def getPendingShiftChangesByUser(user_id):
    """ Returns all pending shift changes a given user is involved in. """
    try:
        db, cursor = connect()
        query = "SELECT * FROM Shifts WHERE (requestor_id = %s or acceptor_ID = %s) AND status = 'Pending' ORDER BY shift_day;"
        params = (user_id, user_id,)
        cursor.execute(query, params)
        shifts = cursor.fetchall()
        db.close()
        return shifts
    except:
        return None


def getApprovedShiftChangesByStore(store_id):
    """ Returns all approved shift changes for a given store. """
    try:
        db, cursor = connect()
        query = "SELECT * FROM Shifts WHERE storeID = %s AND status = 'Approved' ORDER BY shift_day;"
        params = (store_id,)
        cursor.execute(query, params)
        shifts = cursor.fetchall()
        db.close()
        return shifts
    except:
        return None


def getApprovedShiftChangesByRequestorID(user_id):
    """ Returns all approved shift changes a given user is involved in. """
    try:
        db, cursor = connect()
        query = "SELECT * FROM Shifts WHERE requestor_id = %s AND status = 'Approved' ORDER BY shift_day;"
        params = (user_id,)
        cursor.execute(query, params)
        shifts = cursor.fetchall()
        db.close()
        return shifts
    except:
        return None


def getApprovedShiftChangesByAcceptorID(user_id):
    """ Returns all approved shift changes a given user is involved in. """
    try:
        db, cursor = connect()
        query = "SELECT * FROM Shifts WHERE acceptor_ID = %s AND status = 'Approved' ORDER BY shift_day;"
        params = (user_id,)
        cursor.execute(query, params)
        shifts = cursor.fetchall()
        db.close()
        return shifts
    except:
        return None


def getCurrentStoreNonUrgentShifts(user_id, store_id):
    """ Returns all the shifts for a given store. """
    try:
        db, cursor = connect()
        query = "SELECT * FROM Shifts WHERE requestor_ID != %s AND storeID = %s AND status = 'Active' AND isUrgent = false ORDER BY shift_day;"
        params = (user_id, store_id,)
        cursor.execute(query, params)
        shifts = cursor.fetchall()
        db.close()
        return shifts
    except:
        return None


def getCurrentStoreUrgentShifts(user_id, store_id):
    """ Returns all the shifts for a given store. """
    try:
        db, cursor = connect()
        query = "SELECT * FROM Shifts WHERE requestor_ID != %s AND  storeID = %s AND status = 'Active' AND isUrgent = true ORDER BY shift_day;"
        params = (user_id, store_id,)
        cursor.execute(query, params)
        shifts = cursor.fetchall()
        db.close()
        return shifts
    except:
        return None
