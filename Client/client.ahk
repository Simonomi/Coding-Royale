#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

FileCreateDir %A_WorkingDir%\Files\
FileInstall get.bat, %A_WorkingDir%\Files\get.bat
FileInstall getbomb.bat, %A_WorkingDir%\Files\getbomb.bat
FileInstall deletebomb.bat, %A_WorkingDir%\Files\deletebomb.bat
FileInstall getmessage.bat, %A_WorkingDir%\Files\getmessage.bat
FileInstall deletemessage.bat, %A_WorkingDir%\Files\deletemessage.bat
FileInstall getchallenge.bat, %A_WorkingDir%\Files\getchallenge.bat
FileInstall submit.bat, %A_WorkingDir%\Files\submit.bat


Gui, Add, Edit, vRefresh x5 y2 w35, 1000
Gui, Add, Text, x45 y5, IP:
Gui, Add, Edit, vIp x60 y2 w100,
Gui, Add, Text, x5 y27, Username:
Gui, Add, Edit, vUser x60 y25 w100,
Gui, Add, Text, x5 y50 , Password:
Gui, Add, Edit, vPass x60 y47 w100 Password*,
Gui, Add, CheckBox, vRun x185 y6, Run
Gui, Add, Button, x167 y25 w75, Submit
Gui, Add, Button, x167 y47 w75, Restart
Gui, Show, w250, Title, Control

GuiControl, Focus, Ip
item := "ERROR"

Loop {
	Gui, Submit, NoHide
	If %Run% {
		IfNotExist, %A_WorkingDir%\Challenge.ini
			RunWait, %comspec% /c ""%A_WorkingDir%\Files\getchallenge.bat" %Ip% %User% %Pass% Files",, Hide
		IniRead, item, %A_WorkingDir%\Files\Challenge.ini, Challenge, Name
		
		IfNotExist, %A_WorkingDir%\%item%.java
			FileDelete, *.java
		IfNotExist, %A_WorkingDir%\%item%.java
			RunWait, %comspec% /c ""%A_WorkingDir%\Files\get.bat" %Ip% %User% %Pass% Files",, Hide
		IfNotExist, %A_WorkingDir%\%item%.java
			FileMove, %A_WorkingDir%\Files\*.java, %A_WorkingDir%\*.*, 0
		
		IfNotExist, %A_WorkingDir%\bomb.bomb
			RunWait, %comspec% /c ""%A_WorkingDir%\Files\getbomb.bat" %Ip% %User% %Pass% Files",, Hide
		IfNotExist, %A_WorkingDir%\Files\message.txt
			RunWait, %comspec% /c ""%A_WorkingDir%\Files\getmessage.bat" %Ip% %User% %Pass% Files",, Hide
		exists := 0
		IfExist, %A_WorkingDir%\Files\message.txt
			exists := 1
		If (exists) {
			FileRead, words, %A_WorkingDir%\Files\message.txt
			MsgBox,,Message, %words%, 10
			FileDelete, %A_WorkingDir%\Files\message.txt
			RunWait, %comspec% /c ""%A_WorkingDir%\Files\deletemessage.bat" %Ip% %User% %Pass%",, Hide
		}
		
		exists := 0
		IfExist, bomb.bomb
			exists := 1
		If (exists) {
			FileRead, words, bomb.bomb
			Send, %words%
			FileDelete, bomb.bomb
			RunWait, %comspec% /c ""%A_WorkingDir%\Files\deletebomb.bat" %Ip% %User% %Pass%",, Hide
		}
	} else {
		FileDelete, *.java
	}
		GuiControl, Enable, Run
	If (Ip = "" or User = "" or Pass = "") {
		GuiControl, Disable, Run
	}
	Sleep, %Refresh%
}
return


ButtonSubmit:
	RunWait, %comspec% /c ""%A_WorkingDir%\Files\submit.bat" %Ip% %User% %Pass% %A_WorkingDir%\*.java",, Hide
return

ButtonRestart:
	FileDelete, %item%.java
return



*!s::
	Goto, ButtonSubmit
return


GuiClose:
RunWait = 0
Gui, Hide
Sleep, 5000
FileDelete, *.ftp
FileDelete, *.bomb
FileDelete, *.java
FileRemoveDir, Files, 1
ExitApp
