#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

ServerLocation := 0
; All GUI elements
Gui, Add, Button, x5 y5, Reset
Gui, Add, Button, x50 y5, Load New challenges
Gui, Add, Text, x175 y9 vChallenges, Challenges
Gui, Add, Edit, x5 y30 w200 h100 vPlayers, TotalPlayers=1`r`nPlayer1=
Gui, Add, GroupBox, x5 y135 w210 h70, Filezilla Server Location (Blank for none)
Gui, Add, Edit, x10 y150 w200 h50 vServerLocation, %A_WorkingDir%
Gui, Show, w250, Server, Control
WinSet, AlwaysOnTop, On, Server

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
    Gui, Submit, NoHide
    IniRead, number_of_players, Players.ini, Players, TotalPlayers
    IniRead, first_name, %A_WorkingDir%\Challenges\Challenges.ini, Challenges, challenge1

    FileRemoveDir, %A_WorkingDir%\Clients, 1
    FileCreateDir, %A_WorkingDir%\Clients
    xmloutput := "<FileZillaServer>`r`n    <Settings>`r`n        <Item name=""Admin port"" type=""numeric"">14147</Item>`r`n    </Settings>`r    <Groups />`r`n    <Users>`r`n"
    Loop, %number_of_players% {
        IniRead, player, Players.ini, Players, Player%A_Index%

        FileCreateDir, %A_WorkingDir%\Clients\%player%
        FileAppend, [Challenge]`r`nName=%first_name%`r`nItemNumber=1, %A_WorkingDir%\Clients\%player%\Challenge.ini
        FileCopy, %A_WorkingDir%\Challenges\%first_name%.orig, %A_WorkingDir%\Clients\%player%\%first_name%.orig
		xmloutput = %xmloutput%        <User Name="%player%">`r`n            <Option Name="Pass"></Option>`r`n            <Option Name="Salt"></Option>`r`n            <Option Name="Group"></Option>`r`n            <Option Name="Bypass server userlimit">0</Option>`r`n            <Option Name="User Limit">0</Option>`r`n            <Option Name="IP Limit">0</Option>`r`n            <Option Name="Enabled">1</Option>`r`n            <Option Name="Comments"></Option>`r`n            <Option Name="ForceSsl">0</Option>`r`n            <IpFilter>`r`n                <Disallowed />`r`n                <Allowed />`r`n            </IpFilter>`r`n            <Permissions>`r`n               <Permission Dir="%A_WorkingDir%\Clients\%player%">`r`n                <Option Name="FileRead">1</Option>`r`n                <Option Name="FileWrite">1</Option>`r`n                <Option Name="FileDelete">1</Option>`r`n                <Option Name="FileAppend">1</Option>`r`n                <Option Name="DirCreate">1</Option>`r`n                <Option Name="DirDelete">1</Option>`r`n                <Option Name="DirList">1</Option>`r`n                <Option Name="DirSubdirs">1</Option>`r`n                <Option Name="IsHome">1</Option>`r`n                <Option Name="AutoCreate">0</Option>`r`n            </Permission>`r`n            </Permissions>`r`n            <SpeedLimits DlType="0" DlLimit="10" ServerDlLimitBypass="0" UlType="0" UlLimit="10" ServerUlLimitBypass="0">`r`n                <Download />`r`n                <Upload />`r`n            </SpeedLimits>`r`n        </User>`r`n
    }
	changefile := 0
	IfExist, %ServerLocation%\FileZilla Server.xml
		changefile := 1
	if (changefile) {
		if (ServerLocation != "") {
			xmloutput = %xmloutput%    </Users>`r`n</FileZillaServer>
			FileDelete, %ServerLocation%\FileZilla Server.xml
			FileAppend, %xmloutput%, %ServerLocation%\FileZilla Server.xml
			Sleep, 500
			runWait, %comspec% /c refresh.bat "%ServerLocation%",, Hide
			MsgBox,,, Reset complete`, users updated, 2
		} else {
			MsgBox,,, Reset complete, 1
		}
	} else {
		MsgBox,,, Reset complete, 1
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
