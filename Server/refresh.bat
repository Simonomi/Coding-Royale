@echo off

REM 1st: folder location of filezilla server executable

cd %~1
"Filezilla Server.exe" /reload-config
