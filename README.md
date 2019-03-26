# Coding-Royale
## Game explanation
A battle royale game in which the objective is to finish a series of short chalanges. Each challenge is to debug a small program, when a challenge is completed, all other players recieve a pentalty (a series of forced keystrokes). The goal is to finish all challenges before any other players. The more players the more fun!

## Instructions to use:
### Client
Just download and run the .exe file in the root directory and fill out the blanks (IP is that of server). **Note: Useless without a server, deletes all java files in directory.**
### Server
The server contains all necesary files except an FTP server, just run server.ahk (you need autohotkey) and an FTP server (I use filezilla). The FTP server should be set up to where each user has their "home" directory in _/Clients/**name**/_.
#### File formats:
Players.ini (editable through server.ahk) should look similar to the following:<br/>

_[Players]<br/>
TotalPlayers=2<br/>
Player1=FirstPlayer<br/>
Player2=SecondPlayer_<br/><br/>

A _challenge pack_ should contain a Challenges.ini that looks like this:<br/>

[Challenges]<br/>
Name=Default<br/>
TotalNumber=3<br/>
challenge1=SimpleMod<br/>
challenge2=Front11<br/>
challenge3=CombineStrings<br/>

And contain a **name**.orig with the flawed java file, as well as a **name**goal.txt with the desired output (check it because whitespace is weird)
### Note: Built for Windows 10
