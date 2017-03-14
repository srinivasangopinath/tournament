-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.
DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament;

CREATE TABLE players(
PLAYER_ID serial PRIMARY KEY NOT NULL,
name TEXT NOT NULL
);

CREATE SEQUENCE serial START 1;

CREATE TABLE matches(
ROUND_ID INT NOT NULL,
MATCH_NUM INT NOT NULL,
WINNER INT REFERENCES players(player_id) NOT NULL,
LOSER INT REFERENCES players(player_id) NOT NULL
);

/*
INSERT INTO players (name) values ('aaa AAA') returning player_id;
INSERT INTO players (name) values ('bbb BBB') returning player_id;
INSERT INTO players (name) values ('ccc CCC') returning player_id;
INSERT INTO players (name) values ('ddd DDD') returning player_id;
INSERT INTO players (name) values ('eee EEE') returning player_id;
INSERT INTO players (name) values ('fff FFF') returning player_id;
INSERT INTO players (name) values ('ggg GGG') returning player_id;
INSERT INTO players (name) values ('hhh HHH') returning player_id;

INSERT INTO matches (ROUND_ID,MATCH_NUM,WINNER,LOSER) values (1,nextval('serial'),1,2);
INSERT INTO matches (ROUND_ID,MATCH_NUM,WINNER,LOSER) values (1,nextval('serial'),3,4);
INSERT INTO matches (ROUND_ID,MATCH_NUM,WINNER,LOSER) values (1,nextval('serial'),5,6);
INSERT INTO matches (ROUND_ID,MATCH_NUM,WINNER,LOSER) values (1,nextval('serial'),7,8);


create view standings as 
select st.player_id, st.name, sum(st.wins) wins, sum(st.loses) loss from (
select p.player_id,p.name,count(m.winner) wins, 0 loses 
from players p left join matches m on (p.player_id=m.winner)
group by p.player_id,p.name 
union
select p.player_id,p.name,0 wins, count(m.loser) loses 
from players p left join matches m on (p.player_id=m.loser)
group by p.player_id,p.name ) as st
group by st.player_id,st.name
order by 1
*/

create view standings as 
select st.player_id, st.name, st.wins wins, sum(st.wins+st.loser) matches from (
select p.player_id,p.name,coalesce(count(m.winner),0) wins, coalesce(count(m.loser),0) loses 
from players p left join matches m on (p.player_id=m.winner)
group by p.player_id,p.name) as st
order by 3 desc;
