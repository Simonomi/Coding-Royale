#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir% 

IniRead, number_of_players, Players.ini, Players, TotalPlayers
IniRead, first_name, %A_WorkingDir%\Challenges\Challenges.ini, Challenges, challenge1

Loop, %number_of_players% {
	IniRead, player, Players.ini, Players, Player%A_Index%
	
	FileCreateDir, %A_WorkingDir%\Clients\%player%
	FileDelete,  %A_WorkingDir%\Clients\%player%\Challenge.ini
	FileAppend, [Challenge]`r`nName=Front11`r`nItemNumber=1, %A_WorkingDir%\Clients\%player%\Challenge.ini
	FileCopy, %A_WorkingDir%\Challenges\%first_name%.orig, %A_WorkingDir%\Clients\%player%\%first_name%.orig
}
