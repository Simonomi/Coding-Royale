#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; Imports/copies all .bat files into a "Files folder"
FileCreateDir %A_WorkingDir%\Files\
FileInstall get.bat, %A_WorkingDir%\Files\get.bat
; FileInstall getbomb.bat, %A_WorkingDir%\Files\getbomb.bat
; FileInstall getmessage.bat, %A_WorkingDir%\Files\getmessage.bat
; FileInstall getchallenge.bat, %A_WorkingDir%\Files\getchallenge.bat
FileInstall deletemessage.bat, %A_WorkingDir%\Files\deletemessage.bat
FileInstall deletebomb.bat, %A_WorkingDir%\Files\deletebomb.bat
FileInstall submit.bat, %A_WorkingDir%\Files\submit.bat


; All GUI elements
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

; Sets focous to the "IP" field and declares %item% as ERROR
GuiControl, Focus, Ip
item := "ERROR"

Loop {
	Gui, Submit, NoHide
	If %Run% {
		; IfNotExist, %A_WorkingDir%\Challenge.ini
			; RunWait, %comspec% /c ""%A_WorkingDir%\Files\getchallenge.bat" %Ip% %User% %Pass% Files",, Hide
		; Runs get.bat to get the challenge, challenge.ini, bombs, or messages
		RunWait, %comspec% /c ""%A_WorkingDir%\Files\get.bat" %Ip% %User% %Pass% Files",, Hide
		
		; Gets the name of the current challenge and saves it to %item%
		IniRead, item, %A_WorkingDir%\Files\Challenge.ini, Challenge, Name
		
		; If %item%.java doesn't exist, deletes all .java files in same directory as file, then copies %item%.java from Files if it exists
		IfNotExist, %A_WorkingDir%\%item%.java
			FileDelete, *.java
		IfNotExist, %A_WorkingDir%\%item%.java
			IfExist, %A_WorkingDir%\Files\%item%.java
				FileMove, %A_WorkingDir%\Files\%item%.java, %A_WorkingDir%\%item%.java, 0
		
		; IfNotExist, %A_WorkingDir%\Files\bomb.bomb
			; RunWait, %comspec% /c ""%A_WorkingDir%\Files\getbomb.bat" %Ip% %User% %Pass% Files",, Hide
		; IfNotExist, %A_WorkingDir%\Files\message.txt
			; RunWait, %comspec% /c ""%A_WorkingDir%\Files\getmessage.bat" %Ip% %User% %Pass% Files",, Hide
		
		; Handles any messages by MsgBox-ing the contents of message.txt
		exists := 0
		IfExist, %A_WorkingDir%\Files\message.txt
			exists := 1
		If (exists) {
			FileRead, words, %A_WorkingDir%\Files\message.txt
			MsgBox,,Message, %words%, 10
			FileDelete, %A_WorkingDir%\Files\message.txt
			RunWait, %comspec% /c ""%A_WorkingDir%\Files\deletemessage.bat" %Ip% %User% %Pass%",, Hide
		}
		
		; Handles any bombs by Send-ing the contents of bomb.bomb
		exists := 0
		IfExist, %A_WorkingDir%\Files\bomb.bomb
			exists := 1
		If (exists) {
			FileRead, words, %A_WorkingDir%\Files\bomb.bomb
			Send, %words%
			FileDelete, %A_WorkingDir%\Files\bomb.bomb
			RunWait, %comspec% /c ""%A_WorkingDir%\Files\deletebomb.bat" %Ip% %User% %Pass%",, Hide
		}
	} else {
		; Delets all .java files if the script isn't in "run" mode
		FileDelete, *.java
	}
	; Disables "run" mode if any box is empty
	GuiControl, Enable, Run
	If (Ip = "" or User = "" or Pass = "") {
		GuiControl, Disable, Run
	}
	; Waits for the time in the refresh box (default 1 second)
	Sleep, %Refresh%
}
return


; When the submit button is pressed, run submit.bat
ButtonSubmit:
	RunWait, %comspec% /c ""%A_WorkingDir%\Files\submit.bat" %Ip% %User% %Pass% %A_WorkingDir%\*.java",, Hide
return

; When the restart button is pressed, delete the current .java file (then get gets the original)
ButtonRestart:
	FileDelete, %item%.java
return


; When alt-s is pressed, submits
*!s::
	Goto, ButtonSubmit
return


; When the GUI is closed, hides GUI, waits 5 seconds, then deletes all files and exits (delay is to let any .bat's finish running)
GuiClose:
RunWait = 0
Gui, Hide
Sleep, 5000
FileDelete, *.java
FileRemoveDir, Files, 1
ExitApp
