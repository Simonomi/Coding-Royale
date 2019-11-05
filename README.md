# Coding-Royale
## Game explanation
A battle royale game in which the objective is to finish a series of short challenges. Each challenge is to debug a small program, when a challenge is completed, the player moves on to the next challenge. The goal is to finish all challenges before any other players. The more players the more fun!

## Client
Just download and run the .exe file in the Releases page and fill out the blanks (IP is that of the server). To reset the current file, stop/start again. Stopping (Including finishing the game) will now automatically delete all previous challenges. **Note: Useless without a server**

## Server
For the server, just run the .exe file in Releases and it should set itself up. You must have at least one working challenge pack (_.chp_ file) in the same directory. **Note: You must have JDK installed and be able to successfully use *javac* and *java* via command prompt.**

## Challenge packs
The challenge pack creator can be used by running the executable in the latest release and following the on-screen instructions. The original files are the working *.java* files that produce the desired output when run and the changed files are the files that will be sent to the clients during gameplay. Both types of files should have the same filename with a *.java* extension. It is recommended to put both types of files in their own directories. **Note: The use of \*name\* or \*newline\* in challenges may cause issues.**

### Built for Windows 10

## To do (possibly):
* Add player icons
