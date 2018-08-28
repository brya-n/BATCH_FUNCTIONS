ECHO OFF
COLOR 1F
REM   *****************************************************
REM   This 1 of 2 batch files has been designed for
REM   CUSTOMER for use to create a list of files
REM   from a specified location for use within a FOR /F
REM   loop in a command line
REM   
REM   @brya-n    
REM   *****************************************************


:FUNCTION_COMMAND_WINDOW
REM   Set up of prompt to include date and time
PROMPT $_$d$s$t$h$h$h$_$p$_$g$s

REM   Default location to save directory listings and 
REM   temporary files created by this batch program
REM   The only temporary file is temp.bpa
REM   =%HOMEDRIVE%%HOMEPATH%\Desktop
REM   change if required
SET _FILE_LIST_LOCATION=%HOMEDRIVE%%HOMEPATH%\Desktop

REM ========================================================

REM --------------------------------------------------------
REM Altering content beyond this point may cause the batch
REM file to fail.
REM --------------------------------------------------------


:FUNCTION_DIR_TEXT_FILE_SAVE
REM   Obtain date and time for the text filename to give
REM   unique filename for imported file(s)
REM   Delimiters used are   \._:
REM   In the timestamp %%k = YEAR, %%j= MONTH, %%i= DAY
REM   In the timestamp %%l = HOUR, %%m= MINUTE, %%n= SECOND
REM   In the timestamp %%m = MILLISECONDS (Not Used)
ECHO %DATE%_%TIME% > %_FILE_LIST_LOCATION%\temp.bpa
FOR /F "delims=/._: tokens=1,2,3,4,5,6" %%i IN (%_FILE_LIST_LOCATION%\temp.bpa) DO (
	SET _TIME_STAMP=%%k-%%j-%%i_%%l%%m%%n
	)
	DEL %_FILE_LIST_LOCATION%\temp.bpa


:FUNCTION_MENU_SELECTION
REM   Check if a folder has been dragged and dropped
REM   If not, prompt user to copy/paste folder into a menu
REM   Checks if the directory location exists
REM   If not returns to this menu.
REM   Press 0 then ENTER to leave the batch file
ECHO OFF
CLS
IF [%1]==[] SET _SOURCE_DIR=DIRECTORY NOT SET	
IF NOT [%1]==[] SET _SOURCE_DIR=%~f1


ECHO %_SOURCE_DIR%...
PAUSE

CD /D %_SOURCE_DIR% || GOTO FUNCTION_INPUT_DIR
GOTO FUNCTION_SELECT_FILTER

:FUNCTION_INPUT_DIR
COLOR 02
CLS
ECHO ......................................................
ECHO Production of file listing for use in FILE_CMD
ECHO Part 1 of 2.       @brya-n    
ECHO ......................................................
ECHO You have not specified the location of a valid folder
ECHO Drag and drop or copy and paste the required folder
ECHO then press ENTER
ECHO.
ECHO Your current selection is:
ECHO %_SOURCE_DIR%
ECHO.
ECHO Typing a full stop . will select the source location 
ECHO of your current Command Line Prompt.
ECHO.
SET /p _SOURCE_DIR=     Directory of Source File(s) : 
CD /D %_SOURCE_DIR% || GOTO FUNCTION_CHECK_INPUT_DIR
GOTO FUNCTION_SELECT_FILTER

:FUNCTION_CHECK_INPUT_DIR
COLOR 02
CLS
ECHO ......................................................
ECHO Production of file listing for use in FILE_CMD
ECHO Part 1 of 2.       @brya-n    
ECHO ......................................................
ECHO You have not specified the location of a valid folder
ECHO Drag and drop or copy and paste the required folder
ECHO then press ENTER
ECHO.
ECHO Your current selection is:
ECHO %_SOURCE_DIR%
ECHO.
ECHO Typing a full stop . will select the source location 
ECHO of your current Command Line Prompt.
ECHO.
SET /p _SOURCE_DIR=     Directory of Source File(s) : 
CD /D %_SOURCE_DIR% || GOTO FUNCTION_INPUT_DIR
GOTO FUNCTION_SELECT_FILTER

:FUNCTION_SELECT_FILTER
REM   For the user to select file type as a filter
COLOR 1F
CLS
ECHO ......................................................
ECHO Production of file listing for use in FILE_CMD
ECHO Part 1 of 2.       @brya-n    
ECHO ......................................................
ECHO.
ECHO Your Source location for files is:
IF %_SOURCE_DIR%==. ECHO %~d0%~p0
IF NOT %_SOURCE_DIR%==. ECHO %_SOURCE_DIR%
ECHO.
ECHO Select a filter to use for files at this location,
ECHO placing a space between each filter.
ECHO For example *.264 *.lvf will only select files ending 
ECHO in a file extension of .264 and/or .lvf
ECHO Then press ENTER
ECHO.
ECHO To select all files just press ENTER without any 
ECHO filter.
ECHO.
SET /p _FILTER_FILE= Filter(s) to be used : 
CLS
COLOR 1F
ECHO ......................................................
ECHO Production of file listing for use in FILE_CMD
ECHO Part 1 of 2.       @brya-n    
ECHO ......................................................
ECHO The filename of %_TIME_STAMP%_FileList.txt 
ECHO Contains all files in the chosen directory
ECHO matching the filter requirements. 
ECHO.
ECHO The file(s) are:
ECHO.
PAUSE
DIR %_SOURCE_DIR%\%_FILTER_FILE% /A-D /B /P

:FUNCTION_EXPORT_FILE_LIST
REM  Each file has been sent to a text file as file reference parameters
REM  These are separated with a ?
REM  Duplicated File Extension for easy viewing purposes
REM  This will be loaded into the FILE_ALL.BAT
DIR %_SOURCE_DIR%\%_FILTER_FILE% /A-D /B > %_FILE_LIST_LOCATION%\temp.bpa
FOR /F "tokens=*" %%i IN (%_FILE_LIST_LOCATION%\temp.bpa) DO (

    ECHO %%~xi?%%~di%%~pi%%~ni%%~xi?%%~di%%~pi?%%~ni%%~xi?%%~ni?>> %_FILE_LIST_LOCATION%\%_TIME_STAMP%_FileList.txt
    )
	COPY %_FILE_LIST_LOCATION%\%_TIME_STAMP%_FileList.txt %_FILE_LIST_LOCATION%\temp.bpa
	DEL %_FILE_LIST_LOCATION%\%_TIME_STAMP%_FileList.txt
	
:FUNCTION_REMOVE_FIRST_
REM Trims the filename to remove the first full stop
REM For easy use of file in Part 2 of 2
FOR /F "tokens=1,* delims=." %%i IN (%_FILE_LIST_LOCATION%\temp.bpa) DO (
    ECHO %%j >> %_FILE_LIST_LOCATION%\%_TIME_STAMP%_FileList.txt
    )
	DEL %_FILE_LIST_LOCATION%\temp.bpa

:END
COLOR 1F
CLS
ECHO ......................................................
ECHO Production of file listing for use in FILE_CMD
ECHO Part 1 of 2.       @brya-n    
ECHO ......................................................
ECHO.
ECHO Your file listing can be found at:
ECHO %_FILE_LIST_LOCATION%\
ECHO.
ECHO The filename is:
ECHO %_TIME_STAMP%_FileList.txt
ECHO.
ECHO Drag and drop this into FILE_ALL.BAT
ECHO.
PAUSE
EXIT /B



	
	

