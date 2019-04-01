#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

FileInstall makegoal.bat, makegoal.bat

FileSelectFile, Files, M3, %A_WorkingDir%, Select java files to be made into a challenge pack, (*.java; *.orig)
if(not Files = "") {
	InputBox, Name, Challenge pack creator, Name of pack:,,,125
	location := "ERROR"
	FileCreateDir, %Name%
	FileAppend, [Challenges], %A_WorkingDir%\%Name%\Challenges.ini
	IniWrite, %Name%, %A_WorkingDir%\%Name%\Challenges.ini, Challenges, Name
	Loop, parse, Files, `n, `r 
	{
		if (A_Index = 1) {
			location := A_LoopField
		} else {
			FileCopy, %location%\%A_LoopField%, %A_WorkingDir%\%Name%
		}
	}
	TotalNumber := 0
	Loop, Files, %A_WorkingDir%\%Name%\*.java 
	{
		SplitPath, A_LoopFileName,,,, fileName
		RunWait, %comspec% /c "makegoal.bat %Name% %fileName%",, hide
		FileDelete, %A_WorkingDir%\%Name%\%A_LoopFileName%
		TotalNumber := %TotalNumber% + 1
		IniWrite, %fileName%, %A_WorkingDir%\%Name%\Challenges.ini, Challenges, challenge%TotalNumber%
	}
	IniWrite, %TotalNumber%, %A_WorkingDir%\%Name%\Challenges.ini, Challenges, TotalNumber
}
