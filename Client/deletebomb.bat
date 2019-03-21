@echo off
if not "%~4"=="" @echo on

REM 1st: IP of host
REM 2nd: Username
REM 3rd: Password
REM 4th: Optional, anything enables debugging (@echo on)

set starting=%cd%
if not "%~4"=="" cd %~4


echo open %~1> deletebomb.ftp
echo %~2>> deletebomb.ftp
echo %~3>> deletebomb.ftp

echo mdelete *.bomb>> deletebomb.ftp

echo disconnect>> deletebomb.ftp
echo quit>> deletebomb.ftp

ftp -i -s:deletebomb.ftp
del deletebomb.ftp

cd "%starting%"
