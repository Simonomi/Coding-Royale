@echo off

REM 1st: Person to send message to
REM 2nd: Message to send

echo %~2>message.txt
move message.txt "%cd%\Clients\%~1\"
