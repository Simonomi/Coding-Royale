@echo off
if not "%~5"=="" @echo on

REM 1st: IP of host
REM 2nd: Username
REM 3rd: Password
REM 4th: Directory to be sent to
REM 5th: Optional, anything enables debugging (@echo on)

set starting=%cd%
if not "%~4"=="" cd %~4


echo open %~1> getchallenge.ftp
echo %~2>> getchallenge.ftp
echo %~3>> getchallenge.ftp

echo mget challenge.ini>> getchallenge.ftp

echo disconnect>> getchallenge.ftp
echo quit>> getchallenge.ftp

ftp -i -s:getchallenge.ftp
del getchallenge.ftp

if not "%~4"=="" copy challenge.ini %starting%
cd "%starting%"
