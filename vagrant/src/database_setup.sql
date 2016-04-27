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
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (400, 400, '33.4215295,-111.9723862');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (401, 401, '33.4509285,-111.8448717');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (402, 402, '33.3906167,-111.8417746');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (404, 404, '33.4220205,-111.6342207');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (405, 405, '33.5680485,-112.1022196');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (406, 406, '33.6412264,-112.0368447');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (407, 407, '33.6113304,-112.1212947');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (408, 408, '33.4079095,-111.9243777');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (409, 409, '33.4367002,-112.206431');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (410, 410, '33.6493594,-112.3670237');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (411, 411, '33.6397631,-112.0986029');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (412, 412, '33.5536406,-112.119699');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (413, 413, '33.6541944,-112.1534577');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (414, 414, '33.3648559,-111.843495');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (416, 416, '33.5669515,-112.2577578');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (417, 417, '33.4150751,-111.7566013');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (418, 418, '33.5382845,-112.1039227');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (419, 419, '33.4080579,-111.8772685');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (420, 420, '33.6554134,-112.0316529');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (421, 421, '33.6676724,-112.1025327');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (422, 422, '33.4376625,-112.2410317');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (423, 423, '33.1675595,-96.8920278');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (425, 425, '33.4947585,-112.0201127');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (426, 426, '33.6662014,-112.0673767');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (427, 427, '33.3345125,-111.8433547');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (428, 428, '33.6551644,-112.2393297');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (429, 429, '33.4471525,-111.9281787');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (430, 430, '33.6098059,-112.2053555');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (431, 431, '33.3806415,-111.8263017');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (432, 432, '33.409364,-112.0135074');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (433, 433, '33.4074145,-111.8079967');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (434, 434, '33.3916535,-112.1020737');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (435, 435, '33.5061735,-112.0493757');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (436, 436, '33.7118205,-112.2060812');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (437, 437, '33.4119299,-111.5476465');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (438, 438, '33.3829174,-111.7396899');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (439, 439, '33.6820964,-112.2231297');

-- Define example data
INSERT INTO Users (name, email, picture) VALUES ('Bob','none','none');
INSERT INTO Users (name, email, picture) VALUES ('Sally','none','none');
INSERT INTO Users (name, email, picture) VALUES ('Jon','none','none');
INSERT INTO Permissions (user_id) VALUES (1);
INSERT INTO Permissions (user_id) VALUES (2);
INSERT INTO Permissions (user_id) VALUES (3);