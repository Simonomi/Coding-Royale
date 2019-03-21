#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%



Loop {
	IniRead, number_of_players, Players.ini, Players, TotalPlayers
	IniRead, number_of_challenges, %A_WorkingDir%\Challenges\Challenges.ini, Challenges, TotalNumber
	Loop, %number_of_players% {
		IniRead, player, Players.ini, Players, Player%A_Index%
		reset := ""
		IfExist, %A_WorkingDir%\Clients\%player%\submit.txt
			submitted := player
		
		; FileDelete, %A_WorkingDir%\result.txt
		If (not submitted = "") {
			; Submit for %player%
			IniRead, progress, %A_WorkingDir%\Clients\%player%\Challenge.ini, Challenge, Name
			
			runWait, %comspec% /c ""%A_WorkingDir%\Challenges\check.bat" "%A_WorkingDir%\Clients\%player%\" %progress% "%A_WorkingDir%\Challenges\%progress%goal.txt"",, Hide
			
			FileRead, result, result.txt
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
					MsgBox, %player% wins!
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
