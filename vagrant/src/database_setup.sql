/*
Copyright 2016 Robert King, Jacky Liang, Troy Mullins, and Thomas Norby
Licensed under MIT 
(https://github.com/Mullinst/SER-FP/blob/master/LICENSE)

Table definitions for the tournament project.
*/

-- Create and connect to tournament database 
CREATE DATABASE database; 
\c database;

-- Drop all previous tables
DROP TABLE IF EXISTS Users CASCADE;


-- Define tables
CREATE TABLE Users (
	id serial PRIMARY KEY,
	name text NOT NULL,
	email text NOT NULL,
	picture text NOT NULL
);

CREATE TABLE Stores (
	storeID serial PRIMARY KEY,
	storeManagerID integer REFERENCES Users,
	location text
);

CREATE TABLE Shifts (
	shiftID serial PRIMARY KEY,
	startTime date,
	endTime date,
	storeID integer REFERENCES Stores
);

-- Define views
CREATE VIEW user_count AS (
	-- Count of players currently registerd
	SELECT count(*) 
	FROM Users);

-- Define example data
