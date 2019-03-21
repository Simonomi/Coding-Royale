@echo off
if not "%~5"=="" @echo on

REM 1st: IP of host
REM 2nd: Username
REM 3rd: Password
REM 4th: Directory to be sent to
REM 5th: Optional, anything enables debugging (@echo on)

set starting=%cd%
if not "%~4"=="" cd %~4


echo open %~1> getmessage.ftp
echo %~2>> getmessage.ftp
echo %~3>> getmessage.ftp

echo mget message.txt>> getmessage.ftp

echo disconnect>> getmessage.ftp
echo quit>> getmessage.ftp

ftp -i -s:getmessage.ftp
del getmessage.ftp

if not "%~4"=="" copy message.txt %starting%
cd "%starting%"
