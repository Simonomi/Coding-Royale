# Coding-Royale
## Game explanation
A battle royale game in which the objective is to finish a series of short chalanges. Each challenge is to debug a small program, when a challenge is completed, all other players recieve a pentalty (a series of forced keystrokes). The goal is to finish all challenges before any other players. The more players the more fun!

## Instructions to use:
### Client
Just download and run the .exe file in the root directory, Useless without a server.
### Server
The server contains all necesary files except an FTP server, just manually write the players.ini file (examples in files) and run server.ahk. You must also have an FTP server running with all users who are playing, their home directories being the _/Server/Clients/**username**/_ folder corresponding to each user (I use filezilla). In the _/Server/Challenges/_ folder, there are example challenges, but the format is just **name**.orig as the challenge, **name**goal.txt containing the correct output, and Challenges.ini containing an index of all challenges (again, examples in files).

### Note: Built for Windows 10
