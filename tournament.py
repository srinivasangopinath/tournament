#!/usr/bin/env python
#
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2
print("hello world!")

def connect():
    """Connect to the PostgreSQL database.  Returns a database connection."""
    return psycopg2.connect("dbname=tournament")


def deleteMatches():
    """Remove all the match records from the database."""
    DB=connect()
    c=DB.cursor()
    c.execute("delete from matches")
    DB.commit()
    DB.close()

def deletePlayers():
    """Remove all the player records from the database."""
    DB=connect()
    c=DB.cursor()
    c.execute("delete from players")
    DB.commit()
    DB.close()


def countPlayers():
    """Returns the number of players currently registered."""
    DB=connect()
    c=DB.cursor()
    c.execute("select count(*) from players")
    reg_players=c.fetchone()[0]
    DB.close()
    return reg_players


def registerPlayer(name):
    """Adds a player to the tournament database.

    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)

    Args:
      name: the player's full name (need not be unique).
    """
    DB=connect()
    c=DB.cursor()
    player=("INSERT INTO players (name) VALUES (%s) RETURNING player_id")
    c.execute(player,(name,))
    player_id=c.fetchone()[0]
    DB.commit()
    DB.close()

def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place, or a player
    tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """
    DB=connect()
    c=DB.cursor()
##    player_record=("select player_id, name,wins,(wins+loss) as matches from standings order by wins desc, name")
    player_record=("select * from standings")
    c.execute(player_record)
    playerStandings=c.fetchall()
    DB.commit()
    DB.close()
    return playerStandings

def reportMatch(winner, loser):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """
    DB=connect()
    c=DB.cursor()
##    match_result=("INSERT INTO matches VALUES (winner,loser) VALUES (%s, %s)")
##    c.execute(match_result, (winner,loser,))
    c.execute( "INSERT INTO matches(winner, loser) VALUES ('%s', '%s');" % (winner, loser))
    DB.commit()
    DB.close()

def swissPairings():
    """Returns a list of pairs of players for the next round of a match.

    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.

    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """
    DB=connect()
    c=DB.cursor()
    player_standings=("select player_id, name, wins  from standings order by wins")
    c.execute(player_standings)
    players=c.fetchall()
    swissPairings=[(players[i-1] + players[i]) for i in range(1, len(player), 2)]
    DB.commit()
    DB.close()
    return swissPairings
