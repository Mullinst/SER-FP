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
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (406, null, '33.6412264,-112.0368447');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (407, null, '33.6113304,-112.1212947');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (408, null, '33.4079095,-111.9243777');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (409, null, '33.4367002,-112.206431');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (410, null, '33.6493594,-112.3670237');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (411, null, '33.6397631,-112.0986029');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (412, null, '33.5536406,-112.119699');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (413, null, '33.6541944,-112.1534577');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (414, null, '33.3648559,-111.843495');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (416, null, '33.5669515,-112.2577578');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (417, null, '33.4150751,-111.7566013');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (418, null, '33.5382845,-112.1039227');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (419, null, '33.4080579,-111.8772685');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (420, null, '33.6554134,-112.0316529');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (421, null, '33.6676724,-112.1025327');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (422, null, '33.4376625,-112.2410317');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (423, null, '33.1675595,-96.8920278');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (425, null, '33.4947585,-112.0201127');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (426, null, '33.6662014,-112.0673767');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (427, null, '33.3345125,-111.8433547');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (428, null, '33.6551644,-112.2393297');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (429, null, '33.4471525,-111.9281787');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (430, null, '33.6098059,-112.2053555');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (431, null, '33.3806415,-111.8263017');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (432, null, '33.409364,-112.0135074');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (433, null, '33.4074145,-111.8079967');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (434, null, '33.3916535,-112.1020737');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (435, null, '33.5061735,-112.0493757');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (436, null, '33.7118205,-112.2060812');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (437, null, '33.4119299,-111.5476465');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (438, null, '33.3829174,-111.7396899');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (439, null, '33.6820964,-112.2231297');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (440, null, '33.4944695,-112.0814467');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (441, null, '33.378615,-111.9293337');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (442, null, '33.276166,-111.8446517');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (443, null, '33.4942457,-112.1532231');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (444, null, '33.460884,-112.1707277');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (445, null, '33.422865,-112.1710237');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (446, null, '33.452482,-112.3438207');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (447, null, '33.465832,-111.7043437');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (448, null, '33.508713,-112.2755717');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (449, null, '33.4713933,-112.2395927');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (451, null, '33.466338,-112.2060837');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (452, null, '33.422705,-111.8508947');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (453, null, '33.5657848,-112.3120173');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (454, null, '33.581282,-112.1217952');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (456, null, '33.523125,-112.1692217');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (457, null, '33.4220906,-111.6861617');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (458, null, '33.480019,-112.1200867');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (459, null, '33.39457,-111.6170997');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (460, null, '33.3924858,-111.8949009');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (461, null, '33.509081,-112.1164747');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (462, null, '33.334031,-111.9571557');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (463, null, '33.377792,-111.9813959');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (467, null, '33.3891829,-111.9625422');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (468, null, '33.605781,-112.3046417');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (469, null, '33.378562,-111.7743167');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (470, null, '33.5391261,-112.2058367');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (471, null, '33.449616,-112.2742277');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (474, null, '33.2470259,-111.6394614');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (475, null, '33.3632502,-111.9476715');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (476, null, '33.625985,-111.9967897');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (477, null, '33.6255165,-112.1430807');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (478, null, '33.314929,-111.6885097');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (479, null, '33.5587935,-112.0670698');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (481, null, '33.4924047,-112.2222962');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (482, null, '32.8946445,-111.7599114');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (483, null, '32.8946445,-111.7599114');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (485, null, '33.596112,-112.0375795');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (486, null, '33.3368098,-111.7927105');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (487, null, '33.4954596,-112.2585103');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (489, null, '34.945014,-81.9450527');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (490, null, '33.6102247,-112.2519065');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (491, null, '33.909654,-84.8262904');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (492, null, '33.429732,-112.5934477');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (493, null, '33.377209,-112.1352687');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (494, null, '33.63931,-112.3081537');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (495, null, '33.2137395,-111.6462423');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (496, null, '33.366805,-111.6891137');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (497, null, '33.6772011,-112.0338993');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (498, null, '33.2954776,-111.8440836');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (499, null, '33.065649,-112.0505347');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1400, null, '33.422762,-111.8961665');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1401, null, '33.4531087,-112.3940841');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1404, null, '33.2827077,-111.7580307');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1408, null, '33.480637,-112.0354487');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1411, null, '33.5381563,-112.1389007');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1420, null, '33.349517,-111.9599387');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1428, null, '33.5970448,-112.1216725');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1450, null, '32.296813,-110.9741057');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1452, null, '32.2365879,-110.8844579');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1453, null, '32.200075,-110.8777927');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1454, null, '32.258025,-110.9628227');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1456, null, '32.3588043,-111.0859622');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1460, null, '32.206046,-110.8297947');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1461, null, '32.2048323,-110.9112123');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1463, null, '33.4531087,-112.3940841');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1464, null, '32.265074,-110.9797997');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1470, null, '32.1775323,-110.9962612');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1475, null, '32.4067378,-110.9497407');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1476, null, '32.2204577,-110.8123667');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1479, null, '32.2727574,-110.8767324');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1482, null, '32.133259,-111.0400894');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1483, null, '32.337822,-111.0406847');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1487, null, '32.191166,-110.7755157');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1490, null, '32.163607,-110.9395747');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1492, null, '32.250166,-111.0004167');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1493, null, '32.2448475,-110.8487473');
INSERT INTO Stores(storeid, storemanagerid, location) VALUES (1496, null, '32.1924237,-110.8586664');


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
