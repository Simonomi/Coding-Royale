#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; All GUI elements
Gui, Add, Button, x5 y5, Reset
Gui, Add, Button, x50 y5, Load New challenges
Gui, Add, Text, x175 y9 vChallenges, Challenges
Gui, Add, Edit, x5 y30 w200 h100 vPlayers, TotalPlayers=1`r`nPlayer1=
Gui, Show, w250, Server, Control

IniRead, allplayers, Players.ini, Players
IniRead, challengeName, %A_WorkingDir%\Challenges\Challenges.ini, Challenges, Name
GuiControl, Text, Players, %allplayers%
GuiControl, Text, Challenges, %challengeName%

Loop {
	Gui, Submit, NoHide
	IniRead, number_of_players, Players.ini, Players, TotalPlayers
	IniRead, number_of_challenges, %A_WorkingDir%\Challenges\Challenges.ini, Challenges, TotalNumber
	IniRead, newName, %A_WorkingDir%\Challenges\Challenges.ini, Challenges, Name
	GuiControl, Text, Challenges, %newName%
	
	IniRead, playersini, Players.ini, Players
	if (playersini != Players) {
		FileDelete, Players.ini
		FileAppend, [Players]`r`n%Players%, Players.ini
	}
	
	Loop, %number_of_players% {
		IniRead, player, Players.ini, Players, Player%A_Index%
		reset := ""
		IfExist, %A_WorkingDir%\Clients\%player%\submit.txt
			submitted := player
		
		; FileDelete, %A_WorkingDir%\result.txt
		If (not submitted = "") {
			; Submit for %player%
			IniRead, progress, %A_WorkingDir%\Clients\%player%\Challenge.ini, Challenge, Name
			
			runWait, %comspec% /c ""%A_WorkingDir%\check.bat" "%A_WorkingDir%\Clients\%player%\" %progress% "%A_WorkingDir%\Challenges\%progress%goal.txt"",, Hide
			
			FileRead, result, result.txt
			FileDelete, result.txt
			FileDelete, %A_WorkingDir%\Clients\%player%\submit.txt
			FileDelete, %A_WorkingDir%\Clients\%player%\*.java
			result := StrReplace(result, "`r`n")
			
			If (result = "yes") {
				FileDelete, %A_WorkingDir%\result.txt
				submitted := ""
				
				bomb = %A_Index%
				Loop, %number_of_players% {
					If (not (A_Index = bomb)) {
						IniRead, tempplayer, Players.ini, Players, Player%A_Index%
						FileAppend %player%, %A_WorkingDir%\Clients\%tempplayer%\bomb.bomb
					}
				}
				
				IniRead, old_num, %A_WorkingDir%\Clients\%player%\Challenge.ini, Challenge, ItemNumber
				IniRead, total, %A_WorkingDir%\Challenges\Challenges.ini, Challenges, TotalNumber
				new_num := old_num + 1
				If (new_num > total) {
					; Win here
					runWait, %comspec% /c message.bat %player% "You have completed all challenges.",, Hide
					FileAppend, `r`n%player% wins!, winlog.txt
					runWait, %comspec% /c message.bat %player% "%player% has finished all challenges!",, Hide
					FileDelete, %A_WorkingDir%\Clients\%player%\*.orig
				} else {
					runWait, %comspec% /c message.bat %player% "Submission accepted`, you have been sent the next challenge.",, Hide
					IniRead, new_item, %A_WorkingDir%\Challenges\Challenges.ini, Challenges, challenge%new_num%
					IniWrite, %new_num%, %A_WorkingDir%\Clients\%player%\Challenge.ini, Challenge, ItemNumber
					IniWrite, %new_item%, %A_WorkingDir%\Clients\%player%\Challenge.ini, Challenge, Name
					FileDelete, %A_WorkingDir%\Clients\%player%\*.orig
					FileCopy, %A_WorkingDir%\Challenges\%new_item%.orig, %A_WorkingDir%\Clients\%player%\%new_item%.orig
				}
				; Send new challenge
				; Delete old challenge
			}
			If (result = "no") {
				runWait, %comspec% /c message.bat %player% "Submission failed: challenge incomplete. If you aren't getting errors`, you may need to restart.",, Hide
				FileDelete, %A_WorkingDir%\result.txt
				submitted := ""
			}

		}
	}
	Sleep, 5000
}


*!r::
	Reload
return

ButtonReset:
	IniRead, number_of_players, Players.ini, Players, TotalPlayers
	IniRead, first_name, %A_WorkingDir%\Challenges\Challenges.ini, Challenges, challenge1
	
	FileRemoveDir, %A_WorkingDir%\Clients, 1
	FileCreateDir, %A_WorkingDir%\Clients
	Loop, %number_of_players% {
		IniRead, player, Players.ini, Players, Player%A_Index%
		
		FileCreateDir, %A_WorkingDir%\Clients\%player%
		FileAppend, [Challenge]`r`nName=%first_name%`r`nItemNumber=1, %A_WorkingDir%\Clients\%player%\Challenge.ini
		FileCopy, %A_WorkingDir%\Challenges\%first_name%.orig, %A_WorkingDir%\Clients\%player%\%first_name%.orig
	}
return

ButtonLoadNewChallenges:
	newFolder := 0
	FileSelectFolder, newFolder, *%A_WorkingDir%\Challenges,, Choose new folder
	if (newFolder) {
		IniRead, oldName, %A_WorkingDir%\Challenges\Challenges.ini, Challenges, Name
		FileCopyDir, Challenges, %A_WorkingDir%\%oldName%
		FileRemoveDir, %A_WorkingDir%\Challenges, 1
		FileCopyDir, %newFolder%, %A_WorkingDir%\Challenges
	}
return

GuiClose:
RunWait = 0
Gui, Hide
FileRemoveDir, Clients, 1
ExitApp
