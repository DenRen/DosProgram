@ECHO OFF

IF "%1"=="__class"    goto END
IF "%1"=="__typeinfo" goto USAGE
IF "%1"=="/?" goto HELP

SETLOCAL
SET PATCH=C:\WATCOM10;C:\WATCOM10\BINNT;%PATH%
SET WATCOM=C:\WATCOM10

C:\WATCOM10\BINNT\wcl386 -I=C:\WATCOM10\H  %1 %2 %3 %4 %5
IF ERRORLEVEL==1 goto ERR
ENDLOCAL

GOTO END

:HELP
C:\WATCOM10\BINNT\wcl386
GOTO END


:USAGE
ECHO WATCOM C 10             [wpp.bat $args]     (C:\WATCOM\BINNT\)

:END
set errorlevel=666
:ERR