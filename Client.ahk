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
	; MsgBox, oHTTP.Send(%PlayerName% . "|" . data)
	oHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	oHTTP.Open("POST", "http://" . url , False)
	GuiControlGet, PlayerName
	oHTTP.Send(PlayerName . "|" . data)
	
	return oHTTP.ResponseText
}

; All GUI elements
Gui, Add, Text, x5 y5, IP:
Gui, Add, Edit, vIp x20 y2 w125, %A_IPAddress2%
Gui, Add, Text, x5 y29, Name:
Gui, Add, Edit, vPlayerName x40 y25 w105, Simonomi
Gui, Add, Button, x150 y2 w75 vStartOrStop gStartStop, Start
Gui, Add, Button, x150 y25 w75 vSubmitButton gSubmit, Submit
Gui, Show, w230, Coding Royale, Control
WinSet, AlwaysOnTop, On, Coding Royale

again := ""
loop {
	Gui, Submit, NoHide
	If %Start% {
		GuiControl, Enable, SubmitButton
		get := Get(Ip)
		IfNotEqual, get, GET
			IfNotEqual, get, %again%
				MsgBox % get
		again := get
	} else {
		GuiControl, Disable, SubmitButton
	}
	GuiControl, Enable, StartOrStop
	If (Ip = "" or PlayerName = "") {
		GuiControl, Disable, StartOrStop
	}
	Sleep, 1000
}



; Changes the button between start/stop when pressed
StartStop:
	If Start {
		for x in Files
			FileDelete % Files[x]
		GuiControl,,StartOrStop,Start
		Start := 0
	} else {
		Files := []
		GuiControl,,StartOrStop,Stop
		Start := 1
		PostInfo := StrSplit(Post(Ip, "GetFile"),"*name*")
		FileData := PostInfo[2]
		FileName := PostInfo[1]
		FullName := FileName . ".java"
		Files.Push(FullName)
		FileDelete, %FileName%.java
		FileAppend, %FileData%, %FileName%.java
	}
return

Submit:
	if Start {
		GuiControl,,SubmitButton,Submitting
		FileRead, file, %FileName%.java
		PostData := Post(Ip, "Submit|" . StrReplace(StrReplace(file, "`r`n", "*newline*"), "`t", "*tab*"))
		if (PostData == "Fail" || PostData == "") {
			GuiControl,,SubmitButton,Submit
			MsgBox, Try again
		} else if (PostData == "Win") {
			GuiControl,,SubmitButton,Submit
			PostInfo := StrSplit(Post(Ip, "GetFile"),"*name*")
			FileName := PostInfo[1]
			FullName := FileName . ".java"
			Files.Push(FullName)
			FileDelete, %FileName%.java
			MsgBox, You win!
			Goto, GuiClose
		} else {
			PostInfo := StrSplit(Post(Ip, "GetFile"),"*name*")
			FileData := PostInfo[2]
			FileName := PostInfo[1]
			FullName := FileName . ".java"
			Files.Push(FullName)
			FileDelete, %FileName%.java
			FileAppend, %FileData%, %FileName%.java
			GuiControl,,SubmitButton,Submit
			MsgBox, Success! The new file is %FileName%.java
		}
	}
return

PlayerName:
	Gui, Submit, NoHide
return

GuiClose:
Start := 0
Gui, Hide
Sleep, 500
ExitApp
