ECHO OFF
COLOR 1F
REM   *****************************************************
REM   This 2 of 2 batch files has been designed for
REM   CUSTOMER for use to create a list of files
REM   from a specified location for use within a FOR /F
REM   loop in a command line
REM
REM   brya-n
REM   
REM   *****************************************************


:VARIABLES_DIRECTORY
REM  Target directory will be the location your converted files are saved.
SET _TARGET_DIRECTORY=%HOMEDRIVE%%HOMEPATH%\Desktop\FFMPEG_CONVERSION

REM  Location of ffmpeg (Modify for your location)
SET _FFMPEG_BIN_DIR=%HOMEDRIVE%%HOMEPATH%\FFmpeg\Bin


:VARIABLES_COMMAND
REM To hold the ffmpeg command before the input file
SET _COMMAND_IN=ffmpeg -f h264 -i

REM To hold the conversion command after the input file
SET _CONVERSION=-c:v libx264 -f avi

REM To hold additional output filename info
SET _FILE-APPEND=libx264

REM Output file extension
SET _FILE-EXTENSION=AVI

REM After Output, defaults to a space but can select SET _GLOBAL_OUTPUT=-report for example
SET _GLOBAL_OUTPUT= 


:SETUP_WORSPACE
REM Checks there is an input
IF [%1]==[] GOTO ERROR_NO_INPUT

REM makes the working directory
MD %_TARGET_DIRECTORY%


:FUNCTION_COMMAND_WINDOW
REM   Set up of prompt to include date and time
PROMPT $_$d$s$t$h$h$h$_$p$_$g$s

:RUN_FFMPEG_COMMAND
COLOR 07
CLS
ECHO ......................................................
ECHO Production of file listing for use in FILE_CMD
ECHO Part 2 of 2.       @brya-n    
ECHO ......................................................
ECHO Your selected command as specified in
ECHO VARIABLES_COMMAND will now be run on all the files
ECHO in the list created from Part 1 of 2
ECHO.
PAUSE


FOR /F "tokens=1,2,3,4 delims=?" %%i IN (%1) DO (
	PAUSE
        %_COMMAND_IN% "%%j%%k" %_CONVERSION% "%_TARGET_DIRECTORY%\%%l-%%i%_FILE-APPEND%.%_FILE-EXTENSION%" %_GLOBAL_OUTPUT%
	)
PAUSE
EXIT /B

:ERROR_NO_INPUT
REM This is for drag and drop purposes, using the previously formatted
REM file created using the Part 1 of 2
COLOR 02
CLS
ECHO ......................................................
ECHO Production of file listing for use in FILE_CMD
ECHO Part 2 of 2.       @brya-n    
ECHO ......................................................
ECHO You need to drag and drop a file formatted using
ECHO Part 1 of 2.  This batch file will now terminate
ECHO.
PAUSE
EXIT /B



