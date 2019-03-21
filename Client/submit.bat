@echo off
if not "%~5"=="" @echo on

REM 1st: IP of host
REM 2nd: Username
REM 3rd: Password
REM 4th: Full path for file to submit
REM 5th: Optional, anything enables debugging (@echo on)


echo submit> file.txt


echo open %~1> submit.ftp
echo %~2>> submit.ftp
echo %~3>> submit.ftp

echo send file.txt submit.txt>> submit.ftp
if not "%~4"=="" echo mdelete *.java>> submit.ftp
if not "%~4"=="" echo send *.java>> submit.ftp

echo disconnect>> submit.ftp
echo quit>> submit.ftp

ftp -i -s:submit.ftp
del submit.ftp
del file.txt
