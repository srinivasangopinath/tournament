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

CREATE SEQUENCE serial START 1;

CREATE TABLE players(
PLAYER_ID serial PRIMARY KEY NOT NULL,
name TEXT NOT NULL
);


CREATE TABLE matches(
MATCH_NUM serial PRIMARY KEY,
WINNER INT REFERENCES players(player_id),
LOSER INT REFERENCES players(player_id)
);

create view standings as 
select st.player_id, st.name, st.wins, st.matches from (
select p.player_id,p.name,coalesce(count(m.winner),0) wins, coalesce(count(m.winner),0)+coalesce(count(m.loser),0) matches 
from players p left join matches m on (p.player_id=m.winner)
group by p.player_id,p.name) as st
order by 3 desc;

/*
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

create view match_view as 
select p.player_id,
p.name,
m.match_num,
m.winner,
m.loser,
1 as points
from players p left join matches m on (p.player_id=m.winner)
--where m.match_num is not null
union
select p.player_id,
p.name,
m.match_num,
m.winner,
m.loser,
0 as points
from players p left join matches m on (p.player_id=m.loser)
--where m.match_num is not null
order by 1,6;


create view standings as 
select player_id,name,sum(points) wins, count(*) matches from match_view 
group by player_id,name
order by player_id,4;
*/