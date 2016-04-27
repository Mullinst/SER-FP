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
);

CREATE TABLE Permissions (
	user_id integer REFERENCES Users,
	post boolean DEFAULT true,
	accept boolean DEFAULT true,
	approve_requests boolean DEFAULT false,
	delete_requests boolean DEFAULT false,
	edit_permissions boolean DEFAULT false
); 

CREATE TABLE Stores (
	storeID serial PRIMARY KEY,
	storeManagerID integer REFERENCES Users,
	location text
);

CREATE TABLE Shifts (
	shiftID serial PRIMARY KEY,
	assigneeID integer REFERENCES Users (id),
	-- startTime date,
	-- endTime date,
	storeID integer REFERENCES Stores
);

-- Alter Users table to add storeID column
ALTER TABLE IF EXISTS Users ADD storeID integer REFERENCES Stores DEFAULT 1;

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
INSERT INTO Stores (location) VALUES ('Unassigned');

-- Define example data
INSERT INTO Users (name, email, picture) VALUES ('Bob','none','none');
INSERT INTO Users (name, email, picture) VALUES ('Sally','none','none');
INSERT INTO Users (name, email, picture) VALUES ('Jon','none','none');