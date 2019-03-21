@echo off
if not "%~4"=="" @echo on

REM 1st: IP of host
REM 2nd: Username
REM 3rd: Password
REM 4th: Optional, anything enables debugging (@echo on)

set starting=%cd%
if not "%~4"=="" cd %~4


echo open %~1> deletemessage.ftp
echo %~2>> deletemessage.ftp
echo %~3>> deletemessage.ftp

echo mdelete message.txt>> deletemessage.ftp

echo disconnect>> deletemessage.ftp
echo quit>> deletemessage.ftp

ftp -i -s:deletemessage.ftp
del deletemessage.ftp

cd "%starting%"
