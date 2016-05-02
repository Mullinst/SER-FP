/*
Copyright 2016 Robert King, Jacky Liang, Troy Mullins, and Thomas Norby
Licensed under MIT 
(https://github.com/Mullinst/SER-FP/blob/master/LICENSE)
*/

-- Create and connect to database 
CREATE DATABASE database; 
\c database;

-- Drop all previous tables
DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS Permissions CASCADE;
DROP TABLE IF EXISTS Stores CASCADE;
DROP TABLE IF EXISTS Shifts CASCADE;


-- Define tables
CREATE TABLE Users (
	id serial PRIMARY KEY,
	name text NOT NULL,
	email text NOT NULL,
	picture text NOT NULL,
	userType text NOT NULL DEFAULT 'Applicant'
	-- storeID column added after tables created
);

CREATE TABLE Permissions (
	user_id integer PRIMARY KEY REFERENCES Users (id),
	post boolean DEFAULT true,
	accept boolean DEFAULT true,
	approve_requests boolean DEFAULT false,
	delete_requests boolean DEFAULT false,
	edit_permissions boolean DEFAULT false
); 

CREATE TABLE Stores (
	storeID serial PRIMARY KEY,
	storeManagerID integer REFERENCES Users (id) DEFAULT 1,
	location text
);

CREATE TABLE Shifts (
	shiftID serial PRIMARY KEY,
	requestor_ID integer REFERENCES Users (id),
	acceptor_ID integer REFERENCES Users (id),
	shift_number integer,
	shift_day date,
	isUrgent boolean,
	status text DEFAULT 'Active',
	storeID integer REFERENCES Stores
);

-- Alter Users table to add storeID column
ALTER TABLE IF EXISTS Users ADD storeID integer REFERENCES Stores DEFAULT 400;

-- Define views
CREATE VIEW user_count AS (
	-- Count of players currently registerd
	SELECT count(*) 
	FROM Users);

CREATE VIEW names AS (
	-- List of all usernames
	SELECT name
	FROM Users);

CREATE VIEW applicants As (
	-- List the names of all applicants
	SELECT id, name
	FROM Users
	WHERE userType = 'Applicant');


-- Define default store entry
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (400, null, '33.4215295,-111.9723862');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (401, null, '33.4509285,-111.8448717');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (402, null, '33.3906167,-111.8417746');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (404, null, '33.4220205,-111.6342207');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (405, null, '33.5680485,-112.1022196');

-- Define example data
INSERT INTO Users (name, email, picture) VALUES ('Bob','none','none');
INSERT INTO Users (name, email, picture) VALUES ('Sally','none','none');
INSERT INTO Users (name, email, picture) VALUES ('Jon','none','none');
INSERT INTO Permissions (user_id) VALUES (1);
INSERT INTO Permissions (user_id) VALUES (2);
INSERT INTO Permissions (user_id) VALUES (3);
INSERT INTO Shifts (requestor_ID, shift_number, shift_day, isUrgent, storeID) VALUES (1, 2, '05/4/2016', true, 400);
INSERT INTO Shifts (requestor_ID, shift_number, shift_day, isUrgent, storeID) VALUES (1, 1, '05/14/2016', false, 400);
INSERT INTO Shifts (requestor_ID, shift_number, shift_day, isUrgent, storeID) VALUES (2, 3, '05/6/2016', true, 400);
INSERT INTO Shifts (requestor_ID, shift_number, shift_day, isUrgent, storeID) VALUES (2, 2, '05/9/2016', false, 400);
INSERT INTO Shifts (requestor_ID, shift_number, shift_day, isUrgent, storeID) VALUES (3, 1, '05/11/2016', false, 400);
INSERT INTO Shifts (requestor_ID, shift_number, shift_day, isUrgent, storeID) VALUES (3, 2, '05/22/2016', true, 400);
INSERT INTO Shifts (requestor_ID, shift_number, shift_day, isUrgent, storeID) VALUES (3, 3, '05/30/2016', false, 400);
