@echo off
if not "%~5"=="" @echo on

REM 1st: IP of host
REM 2nd: Username
REM 3rd: Password
REM 4th: Directory to be sent to
REM 5th: Optional, anything enables debugging (@echo on)

set starting=%cd%
if not "%~4"=="" cd %~4


echo open %~1> getbomb.ftp
echo %~2>> getbomb.ftp
echo %~3>> getbomb.ftp

echo mget *.bomb>> getbomb.ftp

echo disconnect>> getbomb.ftp
echo quit>> getbomb.ftp

ftp -i -s:getbomb.ftp
del getbomb.ftp

if not "%~4"=="" copy *.bomb %starting%
cd "%starting%"
