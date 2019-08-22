#NoEnv
#SingleInstance, Force
SetWorkingDir %A_ScriptDir%

; Defining a function to be used later
Get(url) {
	oHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	oHTTP.Open("GET", "http://" . url , False)
	oHTTP.Send()
	
	return oHTTP.ResponseText
}
Post(url, data) {
	oHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	oHTTP.Open("POST", "http://" . url , False)
	oHTTP.Send(A_IPAddress2 . "|" . data)
	
	return oHTTP.ResponseText
}

; All GUI elements
Gui, Add, Text, x5 y5, IP:
Gui, Add, Edit, vIp x20 y2 w140, localhost
Gui, Add, Text, x165 y28, Refresh:
Gui, Add, Edit, vRefresh x210 y25 w35, 1000
Gui, Add, Button, x165 y2 w75 vStartOrStop gStartStop, Start
Gui, Add, Button, x5 y25 w75 gSubmit, Submit
; Gui, Add, Button, x85 y25 w75, Restart
Gui, Show, w250, Coding Royale, Control
WinSet, AlwaysOnTop, On, Coding Royale

again := ""
loop {
	Gui, Submit, NoHide
	If %Start% {
		get := Get(Ip)
		IfNotEqual, get, GET
			IfNotEqual, get, %again%
				MsgBox % get
		again := get
	}
	Sleep, %Refresh%
}



; Changes the button between start/stop when pressed
StartStop:
	If Start {
		GuiControl,,StartOrStop,Start
		Start := 0
	} else {
		GuiControl,,StartOrStop,Stop
		Start := 1
		PostInfo := StrSplit(Post(Ip, "GetFile"),"*name*")
		FileData := PostInfo[2]
		FileName := PostInfo[1]
		FileDelete, %FileName%.java
		FileAppend, %FileData%, %FileName%.java
	}
return

Submit:
	if Start {
		FileRead, file, %FileName%.java
		PostData := Post(Ip, "Submit|" . StrReplace(StrReplace(file, "`r`n", "*newline*"), "`t", "*tab*"))
		if (PostData == "Fail" || PostData == "") {
			MsgBox, Try again
		} else if (PostData == "Win") {
			MsgBox, You win!
			Goto, GuiClose
		} else {
			PostInfo := StrSplit(Post(Ip, "GetFile"),"*name*")
			FileData := PostInfo[2]
			FileName := PostInfo[1]
			FileDelete, %FileName%.java
			FileAppend, %FileData%, %FileName%.java
			MsgBox, Success! The new file is %FileName%.java
		}
	}
return

GuiClose:
Start := 0
Gui, Hide
Sleep, 500
ExitApp
