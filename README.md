# tournament

open Git Bash
change the directory to the vagrant file folder
Start the vagrant shell using the command "vagrant ssh"
Then use the command "vagrant up" to start the virtual machine
Run Python tournament/tournament_test.py to get the results as follows:

hello world!
1. countPlayers() returns 0 after initial deletePlayers() execution.
2. countPlayers() returns 1 after one player is registered.
3. countPlayers() returns 2 after two players are registered.
4. countPlayers() returns zero after registered players are deleted.
5. Player records successfully deleted.
6. Newly registered players appear in the standings with no matches.
7. After a match, players have updated standings.
8. After match deletion, player standings are properly reset.
9. Matches are properly deleted.
[(25, 'Twilight Sparkle', 0L, 0L), (26, 'Fluttershy', 0L, 0L), (27, 'Applejack', 0L, 0L), (28, 'Pinkie Pie', 0L, 0L), (29, 'Rarity', 0L, 0L), (30, 'Rainbow Dash', 0L, 0L), (31, 'Princess Celestia', 0L, 0L), (32, 'Princess Luna', 0L, 0L)]
10. After one match, players with one win are properly paired.
Success!  All tests pass!
