/*
Copyright 2016 Robert King, Jacky Liang, Troy Mullins, and Thomas Norby
Licensed under MIT 
(https://github.com/Mullinst/SER-FP/blob/master/LICENSE)

Table definitions for the tournament project.
*/

-- Create and connect to tournament database 
CREATE DATABASE tournament; 
\c tournament;

-- Drop all previous tables
DROP TABLE IF EXISTS Players CASCADE;
DROP TABLE IF EXISTS Tournaments CASCADE;
DROP TABLE IF EXISTS Matches CASCADE;
DROP TABLE IF EXISTS Results CASCADE;

-- Define tables
CREATE TABLE Players (
	player_id serial PRIMARY KEY,
	name text NOT NULL
);

CREATE TABLE Tournaments (
	tournament_id serial PRIMARY KEY,
	participants integer[],
	max_rounds integer,
	current_round integer
);

CREATE TABLE Matches (
	match_id serial PRIMARY KEY,
	tournament_id integer REFERENCES Tournaments,
	round_number integer,
	player1 integer REFERENCES Players,
	player2 integer REFERENCES Players
);

CREATE TABLE Results (
	player_id integer REFERENCES Players,
	match_id integer REFERENCES Matches,
	result char(1) CHECK (
		result LIKE 'w' OR result LIKE 'l' OR result LIKE 't'),
	PRIMARY KEY (player_id, match_id)
);

-- Define views
CREATE VIEW player_count AS (
	-- Count of players currently registerd
	SELECT count(*) 
	FROM Players 
	WHERE name != 'Bye');

CREATE VIEW current_tournament AS (
	-- Id of current tournament
	SELECT tournament_id AS id 
	FROM Tournaments 
	ORDER BY tournament_id DESC 
	LIMIT 1);

CREATE VIEW max_rounds AS (
	-- Maximum number of rounds for current tournament
	SELECT max_rounds
	FROM Tournaments, current_tournament
	WHERE tournament_id = current_tournament.id);

CREATE VIEW current_round AS (
	-- Current round of current tournament
	SELECT current_round AS num
	FROM Tournaments, current_tournament
	WHERE tournament_id = current_tournament.id);

CREATE VIEW current_matches AS (
	-- All matches from the current tournament
	SELECT Matches.match_id, Matches.tournament_id, 
		   Matches.round_number, Matches.player1, Matches.player2
	FROM Matches, current_tournament
	WHERE tournament_id = current_tournament.id);

CREATE VIEW current_round_matches AS (
	-- All matches of the current round
	SELECT match_id, tournament_id,
		   round_number, player1, player2
	FROM current_matches, current_round
	WHERE round_number = current_round.num);

CREATE VIEW current_results AS (
	-- Results from matches played during the current tournament
	SELECT Results.player_id, Results.match_id, Results.result
	FROM Results, current_matches
	WHERE Results.match_id = current_matches.match_id);

CREATE VIEW current_player_ids AS (
	-- Ids of current tournaments participants
	SELECT UNNEST(participants) AS id 
	FROM Tournaments, current_tournament 
	WHERE tournament_id = current_tournament.id);

CREATE VIEW current_players AS (
	-- Id and name of players in current tournament
	SELECT id AS player_id, name
	FROM current_player_ids, Players
	WHERE current_player_ids.id = Players.player_id);

CREATE VIEW participant_count AS (
	-- Count of players in current tournament
	SELECT count(*) 
	FROM current_players 
	WHERE name != 'Bye');

CREATE VIEW current_wins_by_id AS (
	-- Id and win count of all players with 1 or more win
	SELECT player_id, count(result) AS wins
	FROM current_results
	WHERE result LIKE 'w' 
	GROUP BY player_id);

CREATE VIEW current_player_wins AS (
	-- Id and win count of all players
	SELECT current_players.player_id, 
		COALESCE(current_wins_by_id.wins, 0) AS wins
	FROM current_players
	LEFT JOIN current_wins_by_id
	ON current_players.player_id = current_wins_by_id.player_id);

CREATE VIEW current_draws_by_id AS (
	-- Id and draw count of all players with 1 or more draw
	SELECT player_id, count(result) AS draws
	FROM current_results
	WHERE result LIKE 't' 
	GROUP BY player_id);

CREATE VIEW current_player_draws AS (
	-- Id and draw count of all players
	SELECT current_players.player_id, 
		COALESCE(current_draws_by_id.draws, 0) AS draws
	FROM current_players
	LEFT JOIN current_draws_by_id
	ON current_players.player_id = current_draws_by_id.player_id);

CREATE VIEW player1_opponents AS (
	-- List of opponents registered as player 2
	SELECT current_player_ids.id AS player_id, player2 AS opponent
	FROM current_player_ids JOIN current_matches
	ON current_player_ids.id = current_matches.player1
		OR current_player_ids.id = current_matches.player2
	WHERE id != 0 AND id = player1 AND player2 != 0);

CREATE VIEW player2_opponents AS (
	-- List of opponents registered as player 1
	SELECT current_player_ids.id AS player_id, player1 AS opponent
	FROM current_player_ids JOIN current_matches 
	ON current_player_ids.id = current_matches.player1 
		OR current_player_ids.id = current_matches.player2
	WHERE id != 0 AND id = player2 AND player1 != 0);

CREATE VIEW previous_opponents_by_id AS (
	-- Pairings of players ids to their individual opponents
	SELECT * FROM player1_opponents 
	UNION ALL 
	SELECT * FROM player2_opponents);

CREATE VIEW opponents_wins AS (
	-- Count of wins by opponents for players with 1 or more OMW
	SELECT previous_opponents_by_id.player_id, sum(wins) AS opponent_wins
	FROM previous_opponents_by_id, current_player_wins
	WHERE previous_opponents_by_id.opponent = current_player_wins.player_id
	GROUP BY previous_opponents_by_id.player_id
	ORDER BY opponent_wins DESC);

CREATE VIEW opponent_match_wins AS (
	-- Count of wins by opponents
	SELECT current_players.player_id,
		COALESCE(opponents_wins.opponent_wins, 0) AS OMW
	FROM current_players 
	LEFT JOIN opponents_wins
	ON current_players.player_id = opponents_wins.player_id);

CREATE VIEW non_bye_matches AS (
	-- Match ids of all byes
	SELECT *
	FROM current_matches
	WHERE match_id NOT IN (
		SELECT match_id 
		FROM current_matches 
		WHERE player2 = 0));

CREATE VIEW current_match_counts_by_id AS (
	-- Count of current matches played by id for 1 or more matches played
	SELECT current_players.player_id, count(non_bye_matches.match_id) AS matches
	FROM current_players, non_bye_matches
	WHERE current_players.player_id = non_bye_matches.player2
		OR current_players.player_id = non_bye_matches.player1
	GROUP BY current_players.player_id
	ORDER BY current_players.player_id ASC);

CREATE VIEW current_player_match_counts AS (
	-- Count of current matches played
	SELECT current_players.player_id,
		COALESCE(current_match_counts_by_id.matches, 0) AS matches
	FROM current_players
	LEFT JOIN current_match_counts_by_id
	ON current_players.player_id = current_match_counts_by_id.player_id);

CREATE VIEW current_standings AS (
	-- Standings for the current tournament
	SELECT current_players.player_id, current_players.name,
		   current_player_wins.wins, current_player_draws.draws,
		   current_player_match_counts.matches, opponent_match_wins.OMW 
	FROM current_players, current_player_wins,
		 current_player_match_counts, current_player_draws,
		 opponent_match_wins
	WHERE 
		current_players.player_id = current_player_wins.player_id 
		AND 
		current_player_wins.player_id = current_player_draws.player_id 
		AND 
		current_player_draws.player_id = current_player_match_counts.player_id
		AND
		current_player_match_counts.player_id = opponent_match_wins.player_id
		AND current_players.player_id != 0
	ORDER BY wins DESC, draws DESC, OMW DESC);

/*
-------------------------- 
	Pair Sorting Views
--------------------------
*/

CREATE VIEW current_round_paired_ids AS (
	-- Ids of player already paired for the current round
	SELECT player1 AS player_id 
	FROM current_round_matches 
	UNION ALL 
	SELECT player2 AS player_id 
	FROM current_round_matches 
	ORDER BY player_id ASC);

CREATE VIEW current_round_unpaired_ids AS (
	-- Ids for players unpaired for the current round
	SELECT id AS player_id
	FROM current_player_ids 
	WHERE id NOT IN (SELECT * FROM current_round_paired_ids));

CREATE VIEW current_byes_by_id AS (
	-- Ids of player who have recieved byes in the current tournament
	SELECT id 
	FROM current_player_ids, current_matches 
	WHERE current_player_ids.id = current_matches.player1 
		AND current_matches.player2 = 0);

CREATE VIEW current_round_unpaired_without_bye AS (
	-- Ids of player without byes in the current tournament
	SELECT player_id
	FROM current_round_unpaired_ids
	WHERE player_id NOT IN (SELECT * FROM current_byes_by_id));

CREATE VIEW hru_player_without_bye AS (
	-- Player id of highest ranked unpaired player
	-- That hasn't recieved a bye in the current tournament
	SELECT current_standings.player_id 
	FROM current_round_unpaired_without_bye, current_standings 
	WHERE current_round_unpaired_without_bye.player_id = current_standings.player_id
	LIMIT 1);

CREATE VIEW hru_player AS (
	-- Player id of highest ranked unpaired player
	SELECT current_standings.player_id 
	FROM current_round_unpaired_ids, current_standings 
	WHERE current_round_unpaired_ids.player_id = current_standings.player_id
	LIMIT 1);

CREATE VIEW hru_player_previous_opponents AS (
	-- List of previous opponents of highest ranked unpaired player
	SELECT opponent
	FROM previous_opponents_by_id, hru_player
	WHERE previous_opponents_by_id.player_id = hru_player.player_id);

CREATE VIEW unplayed_unpaired_players AS (
	-- List of remaining unpaired players hru player has not played
	SELECT current_round_unpaired_ids.player_id 
	FROM current_round_unpaired_ids, hru_player 
	WHERE current_round_unpaired_ids.player_id 
	NOT IN (SELECT * FROM hru_player_previous_opponents)
	AND current_round_unpaired_ids.player_id != 
	hru_player.player_id);

CREATE VIEW hru_players_next_opponent AS (
	-- Highest unpaired player that hru player has not played
	SELECT current_standings.player_id 
	FROM unplayed_unpaired_players, current_standings 
	WHERE unplayed_unpaired_players.player_id = current_standings.player_id
	LIMIT 1);

CREATE VIEW round_pairs_player1 AS (
	-- Retrieves player1 from current round
	SELECT match_id, player1 AS id1, name AS name1
	FROM current_round_matches, current_players
	WHERE current_round_matches.player1 = current_players.player_id);

CREATE VIEW round_pairs_player2 AS (
	-- Retrieves player2 from current round
	SELECT match_id, player2 AS id2, name AS name2
	FROM current_round_matches, current_players
	WHERE current_round_matches.player2 = current_players.player_id);

CREATE VIEW round_pairings AS (
	-- Retrieves pairings from current round
	SELECT id1, name1, id2, name2
	FROM round_pairs_player1, round_pairs_player2
	WHERE round_pairs_player1.match_id = round_pairs_player2.match_id);

-- Insert Player to act as bye
INSERT INTO Players VALUES (0, 'Bye');
