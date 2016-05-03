#!/usr/bin/env python
#
# Copyright 2016 Robert King, Jacky Liang, Troy Mullins, and Thomas Norby
# Licensed under MIT
# (https://github.com/Mullinst/SER-FP/blob/master/LICENSE)
#
# project.py -- Routing for shift trade app
# @author - Troy Mullins

from flask import Flask, render_template, request, redirect, jsonify, url_for, flash, make_response
from flask import session as login_session
from oauth2client.client import flow_from_clientsecrets, FlowExchangeError
from database_functions import *
import httplib2, requests
import random, string, json, os

app = Flask(__name__)

# Loads client ID for use in logging in with google.
CLIENT_ID = json.loads(
    open(os.path.dirname(os.path.abspath(__file__)) + '/client_secrets.json', 'r').read())['web']['client_id']


# Create anti-forgery state token
@app.route('/login')
def showLogin():
    state = ''.join(random.choice(string.ascii_uppercase + string.digits)
                    for x in xrange(32))
    login_session['state'] = state
    return render_template('login.html', STATE=state)


@app.route('/gconnect', methods=['POST'])
def gconnect():
    # Validate state token
    if request.args.get('state') != login_session['state']:
        response = make_response(json.dumps('Invalid state parameter.'), 401)
        response.headers['Content-Type'] = 'application/json'
        return response
    # Obtain authorization code
    code = request.data

    try:
        # Upgrade the authorization code into a credentials object
        oauth_flow = flow_from_clientsecrets('client_secrets.json', scope='')
        oauth_flow.redirect_uri = 'postmessage'
        credentials = oauth_flow.step2_exchange(code)
    except FlowExchangeError:
        response = make_response(
            json.dumps('Failed to upgrade the authorization code.'), 401)
        response.headers['Content-Type'] = 'application/json'
        return response

    # Check that the access token is valid.
    access_token = credentials.access_token
    url = ('https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=%s'
           % access_token)
    h = httplib2.Http()
    result = json.loads(h.request(url, 'GET')[1])
    # If there was an error in the access token info, abort.
    if result.get('error') is not None:
        response = make_response(json.dumps(result.get('error')), 500)
        response.headers['Content-Type'] = 'application/json'

    # Verify that the access token is used for the intended user.
    gplus_id = credentials.id_token['sub']
    if result['user_id'] != gplus_id:
        response = make_response(
            json.dumps("Token's user ID doesn't match given user ID."), 401)
        response.headers['Content-Type'] = 'application/json'
        return response

    # Verify that the access token is valid for this app.
    if result['issued_to'] != CLIENT_ID:
        response = make_response(
            json.dumps("Token's client ID does not match app's."), 401)
        print "Token's client ID does not match app's."
        response.headers['Content-Type'] = 'application/json'
        return response

    stored_credentials = login_session.get('credentials')
    stored_gplus_id = login_session.get('gplus_id')
    if stored_credentials is not None and gplus_id == stored_gplus_id:
        response = make_response(json.dumps('Current user is already connected.'),
                                 200)
        response.headers['Content-Type'] = 'application/json'
        return response

    # Store the access token in the session for later use.
    login_session['access_token'] = credentials.access_token
    login_session['gplus_id'] = gplus_id

    # Get user info
    userinfo_url = "https://www.googleapis.com/oauth2/v1/userinfo"
    params = {'access_token': credentials.access_token, 'alt': 'json'}
    answer = requests.get(userinfo_url, params=params)

    data = answer.json()

    # Store google data in session
    login_session['username'] = data['name']
    login_session['picture'] = data['picture']
    login_session['email'] = data['email']

    # Add user to database if first login
    if getUserID(login_session.get('email')) is None:
        createUser(login_session)

    # Retrieve userType and add to session
    login_session['userType'] = getUserType(getUserID(login_session.get('email')))

    output = ''
    output += '<h1>Welcome, '
    output += login_session['username']
    output += '!</h1>'
    output += '<img src="'
    output += login_session['picture']
    output += ' " style = "width: 300px; height: 300px;border-radius: 150px;-webkit-border-radius: 150px;-moz-border-radius: 150px;"> '
    flash("you are now logged in as %s" % login_session['username'])
    print "done!"
    return output


# DISCONNECT - Revoke a current user's token and reset their login_session
@app.route('/gdisconnect')
def gdisconnect():
    access_token = login_session['access_token']
    print 'In gdisconnect access token is %s', access_token
    print 'User name is: '
    print login_session['username']
    if access_token is None:
        print 'Access Token is None'
        response = make_response(json.dumps('Current user not connected.'), 401)
        response.headers['Content-Type'] = 'application/json'
        return response
    url = 'https://accounts.google.com/o/oauth2/revoke?token=%s' % login_session['access_token']
    h = httplib2.Http()
    result = h.request(url, 'GET')[0]
    print 'result is '
    print result
    if result['status'] == '200':
        del login_session['access_token']
        del login_session['gplus_id']
        del login_session['username']
        del login_session['email']
        del login_session['picture']
        del login_session['userType']
        response = make_response(json.dumps('Successfully disconnected.'), 200)
        response.headers['Content-Type'] = 'application/json'
        flash('Successfully disconnected.', 'success')
        return redirect(url_for('showHome'))
    else:
        response = make_response(json.dumps('Failed to revoke token for given user.', 400))
        response.headers['Content-Type'] = 'application/json'
        flash('Failed to revoke token for given user.', 'error')
        return redirect(url_for('showHome'))


# Show homepage
@app.route('/')
def showHome():
    # If user is not logged in render public homepage
    if 'username' not in login_session:
        return render_template('publicHome.html')
    else:
        # If user is logged in check userType and route accordingly
        if login_session['userType']:
            return render_template('home.html', userType=login_session['userType'])
        else:
            # Add appropriate error handling
            return render_template('publicHome.html')


# View open shifts
# See all shifts that have been requested off by others.
@app.route('/openShifts', methods=['GET', 'POST'])
def showOpenShifts():
    if 'username' not in login_session:
        return render_template('publicHome.html')
    else:
        # Get pertinent information
        user_id = getUserID(login_session.get('email'))
        user_info = getUserInfo(user_id)
        store_id = user_info[-1]
        manager = getStoreManager(store_id)
        nonUrgentShifts = getCurrentStoreNonUrgentShifts(user_id, store_id)
        urgentShifts = getCurrentStoreUrgentShifts(user_id, store_id)
        user_perms = getUserPermissions(user_id)
        # If the method is post check if it was a delete or accept request.
        if request.method == 'POST':
            if 'delete' in request.form:
                result = deleteShift(user_id, request.form['shiftID'])
                if result == True:
                    flash('Successfully deleted shift!','success')
                else:
                    flash('Error: Failed to delete shift.','error')
                return redirect(url_for('showOpenShifts', userType=login_session['userType']))
            elif 'accept' in request.form:
                result = acceptShift(user_id, request.form['shiftID'])
                if result == True:
                    flash('Successfully accepted shift!','success')
                else:
                    flash('Error: Failed to accept shift.','error')
                return redirect(url_for('showOpenShifts', userType=login_session['userType']))
        return render_template('openShifts.html', userType=login_session['userType'],manager=manager, nonUrgentShifts=nonUrgentShifts, urgentShifts=urgentShifts, user_perms=user_perms)


# See the shifts that are currently assigned to the user logged in.
@app.route('/myShifts', methods=['GET', 'POST'])
def showMyShifts():
    if 'username' not in login_session:
        return render_template('publicHome.html')
    else:
        user_id = getUserID(login_session.get('email'))
        created_shifts = getRequestedShiftChanges(user_id)
        pending_shifts = getPendingShiftChangesByUser(user_id)
        approved_requests = getApprovedShiftChangesByRequestorID(user_id)
        approved_accepts = getApprovedShiftChangesByAcceptorID(user_id)
        user_perms = getUserPermissions(user_id)
        if request.method == 'POST':
            if 'submitEdits' in request.form:
                if 'urgent' not in request.form:
                    result = editShift(request.form['shift'], request.form['time'], request.form['date'], False)
                else:
                    result = editShift(request.form['shift'], request.form['time'], request.form['date'], True)
                if result == True:
                    flash('Successfully editted shift!','success')
                else:
                    flash('Error: Failed to edit shift.','error')
                return redirect(url_for('showMyShifts', userType=login_session['userType']))
            user_id = getUserID(login_session.get('email'))
            if 'delete' in request.form:
                result = deleteShift(user_id, request.form['shiftID'])
                if result == True:
                    flash('Successfully deleted shift!','success')
                else:
                    flash('Error: Failed to delete shift.','error')
                return redirect(url_for('showMyShifts', userType=login_session['userType']))

            if 'urgent' not in request.form:
                createShift(user_id, request.form['time'], request.form['date'], False)
            else:
                createShift(user_id, request.form['time'], request.form['date'], True)
            flash('Successfully Added Shift', 'success')
            return redirect(url_for('showMyShifts', userType=login_session['userType']))
        return render_template('myShifts.html', userType=login_session['userType'],
                                created_shifts=created_shifts,pending_shifts=pending_shifts,
                                approved_requests=approved_requests,
                                user_perms=user_perms, approved_accepts=approved_accepts)


@app.route('/schedule', methods=['GET', 'POST'])
def showSchedule():
    if login_session['userType'] == 'Store Manager':
        user_id = getUserID(login_session.get('email'))
        print user_id
        user_info = getUserInfo(user_id)
        store_id = user_info[-1]
        print store_id
        manager = getStoreManagerID(store_id)
        print manager
        if manager != user_id:
            flash('Database error: Store id mismatch, contact an admin for help.', 'error')
            return redirect(url_for('showHome', userType=login_session['userType']))
        pending_shifts = getPendingShiftChangesByStore(store_id)
        if request.method == 'POST':
            if 'approve' in request.form:
                result = approveShift(user_id, request.form['shiftID'])
                if result == True:
                    flash('Successfully approving shift!','success')
                else:
                    flash('Error: Failed to approve shift.','error')
                return redirect(url_for('showSchedule', userType=login_session['userType']))
        return render_template('manager.html', userType=login_session['userType'], pending_shifts=pending_shifts)
    elif 'user' in login_session:
        flash('You do not have permission to access that.', 'error')
        return render_template('Home.html')
    else:
        return render_template('publicHome.html')


@app.route('/admin', methods=['GET', 'POST'])
def showAdminPanel():
    if login_session['userType'] == 'Admin':
        applicants = getApplicants()
        users = getUsers()
        current_user_id = getUserID(login_session.get('email'))
        print current_user_id
        if request.method == 'POST':
            changeUserType(request.form['name'], request.form['type'])
            editUserPermissions(current_user_id, request.form['name'], request.form['post'], request.form['accept'], request.form['approve'], request.form['delete'])
            flash('Changes Successfully Made', 'success')
            return redirect(url_for('showAdminPanel', userType=login_session['userType'], applicants=applicants, users=users,user_id=current_user_id))
        return render_template('admin_panel.html', userType=login_session['userType'], applicants=applicants, users=users,user_id=current_user_id)
    else:
        return render_template('publicHome.html')


if __name__ == '__main__':
    app.secret_key = 'super_secret_key'  # Not for live use.
    app.debug = True
    app.run(host='0.0.0.0', port=8000)
