@echo off
if not "%~5"=="" @echo on

REM 1st: IP of host
REM 2nd: Username
REM 3rd: Password
REM 4th: Directory to be sent to
REM 5th: Optional, anything enables debugging (@echo on)

set starting=%cd%
if not "%~4"=="" cd %~4
delete *.java

echo open %~1> get.ftp
echo %~2>> get.ftp
echo %~3>> get.ftp

echo mget *.orig>> get.ftp
echo get message.txt>> get.ftp
echo get challenge.ini>> get.ftp
echo get bomb.bomb>> get.ftp

echo disconnect>> get.ftp
echo quit>> get.ftp

ftp -i -s:get.ftp
del get.ftp

rename *.orig *.java

if not "%~4"=="" move *.java "%starting%\"
delete *.orig
cd "%starting%"
