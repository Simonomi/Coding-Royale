@echo off

REM 1st: location of file
REM 2nd: file name (no extension)

set starting=%cd%

cd "%~1"
javac %~2.java > nul 2> nul

java %~2 | more > %~2goal.txt
if errorlevel 1 goto error
del *.class


:end
cd %starting%
