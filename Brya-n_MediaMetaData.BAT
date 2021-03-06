@ECHO OFF
@CLS
REM ---------------------------------------------------------------------
REM Author: brya-n (https://github.com/bray-n)         
REM Version 1.0.0
REM Work in progress
REM Currently on hold, will implement:
REM A: Registry lookup for required programs
REM B: Better User interface
REM C: Batch files using these exports
REM ---------------------------------------------------------------------

REM ---------------------------------------------------------------------
REM Use the user interface
REM ---------------------------------------------------------------------
CALL :UI_GENERIC

REM ---------------------------------------------------------------------
REM Requires correct programs
REM ---------------------------------------------------------------------
IF NOT %_NULL_CONFIG%==0 GOTO :EXCEPTION_REQUIRED_PROGRAMS

REM ---------------------------------------------------------------------
REM Requires an argument of a source file
REM ---------------------------------------------------------------------
IF [%1]==[] GOTO :EXCEPTION_NO_ARG
IF NOT EXIST "%1" GOTO :EXCEPTION_FILE_NOT_DETECTED


REM ---------------------------------------------------------------------
REM Exports information to a sub-folder
REM Named accoding to file name and appended with current time
REM ---------------------------------------------------------------------
:DEFINE_EXPORT_PATH
FOR /F "tokens=1-4 delims=:." %%B IN ("%~x1_%TIME:~0,8%") DO SET _TXT=%%B-%%C-%%D
MD "%~dp0%~n1-%_TXT%"
CD /D "%~dp0%~n1-%_TXT%"
SET _PATH=%CD%

REM ---------------------------------------------------------------------
REM Variables already defined from user interface
REM MediaInfo export
REM *** COMMAND LINE VERSION ***
REM ---------------------------------------------------------------------
%_mediaInfo% --Version > GetVersion.txt
:CONCATANATE MEDIA INFO
SETLOCAL
(SET _MIVER=)
FOR /F "delims=," %%B IN (GetVersion.txt) DO (
	CALL SET _MIVER=%%_MIVER%%, %%B
)
SET _MIVER=MediaInfo Version used                   :%_MIVER:~1%
ECHO %_MIVER% > "%~n1-%~x1_mi.txt"
ECHO.
%_mediaInfo% %1 >> "%~n1-%~x1_mi.txt"
ENDLOCAL

REM ---------------------------------------------------------------------
REM Variables already defined from user interface
REM ExifTool already command line binary
REM ---------------------------------------------------------------------
ECHO.
:EXIF DATA
TYPE NUL > "%~n1-%~x1_EXIF.txt"
%_exifTool% -k -a -u -P -ee -g:3:1 %1 >> "%~n1-%~x1_EXIF.txt"

REM ---------------------------------------------------------------------
REM Variables already defined from user interface
REM FFprobe already command line binary
REM ---------------------------------------------------------------------
:FFPROBE
%_ffProbe% -show_frames -show_entries frame=media_type,stream_index,key_frame,pkt_pts,pkt_pts_time,pkt_dts,pkt_dts_time,best_effort_timestamp,best_effort_timestamp_time,pkt_duration,pkt_duration_time,pkt_pos,pkt_size,width,height,pix_fmt,sample_aspect_ratio,pict_type,coded_picture_number,display_picture_number,interlaced_frame,top_field_first,repeat_pict -i %1 -of xml > %~n1-%~x1_ffprobe.xml"

REM ---------------------------------------------------------------------
REM Exit of user interface
REM Opens up the folder for the export text files
REM ---------------------------------------------------------------------
@ECHO ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
@ECHO Ί PROCESS COMPLETED:                                                          Ί
@ECHO Ί Metadata programs run.                                                      Ί
@ECHO Ί Press RETURN to continue, the output location will be opened.               Ί
@ECHO ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ  
PAUSE>NUL
DEL /Q GetVersion.txt
start .

REM ---------------------------------------------------------------------
REM End of the file is here, this way user interface and exceptions
REM Can be referenced beyond the END, therefore cannot interfere with
REM the normal running of the script
REM ---------------------------------------------------------------------
:END
EXIT /B

REM ---------------------------------------------------------------------
REM Exception raised
REM No file supplied
REM ---------------------------------------------------------------------
:EXCEPTION_NO_ARG
COLOR 4F
@ECHO.
@ECHO ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
@ECHO Ί EXCEPTION:                                                                  Ί
@ECHO Ί You need to supply a FILE                                                   Ί
@ECHO Ί Press any key to exit                                                       Ί
@ECHO ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ  
PAUSE>NUL
GOTO END

REM ---------------------------------------------------------------------
REM Exception raised
REM No file supplied
REM ---------------------------------------------------------------------
:EXCEPTION_FILE_NOT_DETECTED
COLOR 4F
@ECHO.
@ECHO ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
@ECHO Ί EXCEPTION:                                                                  Ί
@ECHO Ί Your selection does not EXIST                                               Ί
@ECHO Ί Press any key to exit                                                       Ί
@ECHO ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ  
PAUSE>NUL
GOTO END

REM ---------------------------------------------------------------------
REM Exception raised
REM Programs are required 
REM ---------------------------------------------------------------------
:EXCEPTION_REQUIRED_PROGRAMS
COLOR 4F
@ECHO.
@ECHO ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
@ECHO Ί EXCEPTION:                                                                  Ί
@ECHO Ί Some of the required programs are not in the required directories.          Ί
@ECHO Ί Please review the text file displayed on exit.                              Ί
@ECHO Ί Press any key to exit.                                                      Ί
@ECHO ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ  
PAUSE>NUL
%~dp0\Required_Programs.Txt
GOTO END



REM ---------------------------------------------------------------------
REM Generic user environment
REM This batch file was programmed using Notepad++ to set character encodings
REM for use with command line output.  The encoding must be set for a new 
REM document.  Selection as:
REM       SETTING > PREFERENCES > NEW DOCUMENT > ENCODING  = OEM-US
REM
REM Within the batch file the codepage of 437 needs to be used
REM
REM Further information:  https://en.wikipedia.org/Code_page_437
REM Ruler for standard 80 width, max width 79:
REM   '''''''''''''''''''20'''''''''''''''''40''''''''''''''''''60''''''''''''''''''80
REM Characters:
REM Θ Ι Κ Λ Μ Ν Ξ  Θ Ό » Ί Ή  
REM 
REM ---------------------------------------------------------------------
:UI_GENERIC
chcp 437>NUL
COLOR 1F
REM   '''''''''''''''''''20'''''''''''''''''40''''''''''''''''''60''''''''''''''''''80
@ECHO ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
@ECHO Ί Media Metadata Script                    https://github.com/brya-n          Ί
@ECHO ΜΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΛΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΉ
@ECHO Ί Author:  brya-n       Ί This script obtains metadata using specified        Ί

REM -------------------------------------------------------------------------------
REM Check for config file, if not present will create it.
REM -------------------------------------------------------------------------------
IF EXIST "%~dp0\Brya-n_MediaMetaData.cfg" GOTO CONFIG_FOUND
@ECHO Ί Date:    04^/09^/2018   Ί 3rd party programs and output as text file at the   Ί
@ECHO Ί Version: 1.0.0        Ί specified location.  Config file needs to be made.  Ί
@ECHO ΜΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΚΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΉ
@ECHO Ί Configuration file not found, creating configuration file.                  Ί 
TYPE NUL > "%~dp0\Brya-n_MediaMetaData.cfg"
@ECHO ffProbe^=NUL >> "%~dp0\Brya-n_MediaMetaData.cfg"
@ECHO exifTool^=NUL >> "%~dp0\Brya-n_MediaMetaData.cfg"
@ECHO mediaInfo^=NUL >> "%~dp0\Brya-n_MediaMetaData.cfg"


REM -------------------------------------------------------------------------------
REM Ask for the location of 3rd party programs if not in config file
REM Version 1:
REM This is hard coded to a specified location
REM -------------------------------------------------------------------------------
:CONFIG_FOUND
SET _NULL_CONFIG=0
@ECHO Ί Date:    04^/09^/2018   Ί programs: FFprobe, ExifTool and MediaInfo.  These   Ί
@ECHO Ί Version: 1.0.0        Ί currently must exist in named directories here.     Ί
@ECHO ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΚΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ
@ECHO.
FOR /F "tokens=*" %%B IN (%~dp0Brya-n_MediaMetaData.cfg) DO (
	SET _%%B
)
SET _RESET_CONFIG=0
TYPE NUL > "%~dp0\Required_Programs.TXT"


IF %_ffProbe% EQU NUL (
SET /A _NULL_CONFIG=_NULL_CONFIG+2
COLOR 02
@ECHO ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
@ECHO Ί FFmpeg framework not in configuration:                                      Ί
@ECHO Ί This demostration batch script assumes ffprobe is is at:                    Ί
@ECHO Ί     %~dp0FFMPEGBin\ffprobe.exe
@ECHO Ί FFprobe can be found at:  https://www.ffmpeg.org                            Ί
   IF EXIST %~dp0FFMPEG\Bin\ffprobe.exe (
      SET _ffProbe="%~dp0FFMPEG\Bin\ffprobe.exe"
	  SET _RESET_CONFIG=1
   ) ELSE (
	  @ECHO "%DATE% %TIME:~0,8%  FFprobe Required" >> "%~dp0\Required_Programs.Txt"
	  @ECHO "%DATE% %TIME:~0,8%  Installed to subfolder here named: FFMPEG\BIN" >> "%~dp0\Required_Programs.Txt"	  
	  @ECHO "%DATE% %TIME:~0,8%  Obtained from:  https://www.ffmpeg.org" >> "%~dp0\Required_Programs.Txt"
	  @ECHO "%DATE% %TIME:~0,8%  Last Accessed 04/09/2018" >> "%~dp0\Required_Programs.Txt"
	  @ECHO. >> "%~dp0\Required_Programs.Txt"
   )  
@ECHO Ί Press any key to continue.                                                  Ί
@ECHO ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ  
PAUSE>NUL 
)
IF %_exifTool% EQU NUL (
SET /A _NULL_CONFIG=_NULL_CONFIG+4
COLOR 02
@ECHO ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
@ECHO Ί ExifTool program not in configuration:                                      Ί
@ECHO Ί This demostration batch script assumes ExifTool is is at:                   Ί
@ECHO Ί     %~dp0EXIFTOOL\ExifTool.exe
@ECHO Ί ExifTool can be found at:  https://www.sno.phy.queensu.ca/~phil/exiftool    Ί
   IF EXIST %~dp0EXIFTOOL\ExifTool.exe (
      SET _exifTool="%~dp0EXIFTOOL\ExifTool.exe"
	  SET _RESET_CONFIG=1	  
   ) ELSE (
	  @ECHO "%DATE% %TIME:~0,8%  ExifTool Required" >> "%~dp0\Required_Programs.Txt"
	  @ECHO "%DATE% %TIME:~0,8%  Installed to subfolder here named: EXIFTOOL" >> "%~dp0\Required_Programs.Txt"	  
	  @ECHO "%DATE% %TIME:~0,8%  Obtained from:  https://www.sno.phy.queensu.ca/~phil/exiftool" >> "%~dp0\Required_Programs.Txt"
	  @ECHO "%DATE% %TIME:~0,8%  Last Accessed 04/09/2018" >> "%~dp0\Required_Programs.Txt"
	  @ECHO. >> "%~dp0\Required_Programs.Txt"
   )
@ECHO Ί Press any key to continue.                                                  Ί
@ECHO ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ  
PAUSE>NUL 
)
IF %_mediaInfo% EQU NUL (
SET /A _NULL_CONFIG=_NULL_CONFIG+8
COLOR 02
@ECHO ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
@ECHO Ί MediaInfo program not in configuration:                                     Ί
@ECHO Ί This demostration batch script assumes MediaInfo ^(CLI^) is is at:            Ί
@ECHO Ί     %~dp0MEDIAINFO\MediaInfo.exe
@ECHO Ί MediaInfo can be found at:  https://mediaarea.net/en/MediaInfo              Ί
   IF EXIST %~dp0MEDIAINFO\MediaInfo.exe (
      SET _mediaInfo="%~dp0MEDIAINFO\MediaInfo.exe"
	  SET _RESET_CONFIG=1	  
   ) ELSE (
	  @ECHO "%DATE% %TIME:~0,8%  MediaInfo (Command Line Interface version) Required" >> "%~dp0\Required_Programs.Txt"
	  @ECHO "%DATE% %TIME:~0,8%  Installed to subfolder here named: MEDIAINFO" >> "%~dp0\Required_Programs.Txt"	  
	  @ECHO "%DATE% %TIME:~0,8%  Obtained from:  https://mediaarea.net/en/MediaInfo" >> "%~dp0\Required_Programs.Txt"
	  @ECHO "%DATE% %TIME:~0,8%  Last Accessed 04/09/2018" >> "%~dp0\Required_Programs.Txt"
	  @ECHO. >> "%~dp0\Required_Programs.Txt"
   )
@ECHO Ί Press any key to continue.                                                  Ί
@ECHO ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ 
PAUSE>NUL 
)
IF %_RESET_CONFIG% EQU 1 (
COLOR 1F
@ECHO ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
@ECHO ffProbe^=%_ffProbe% > "%~dp0\Brya-n_MediaMetaData.cfg"
@ECHO exifTool^=%_exifTool% >> "%~dp0\Brya-n_MediaMetaData.cfg"
@ECHO mediaInfo^=%_mediaInfo% >> "%~dp0\Brya-n_MediaMetaData.cfg"
@CLS
GOTO UI_GENERIC
)
@ECHO ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
@ECHO Ί Config set up.                                                              Ί
@ECHO Ί Press any key to continue.                                                  Ί
@ECHO ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ  
PAUSE>NUL
@ECHO %_NULL_CONFIG%
REM   '''''''''''''''''''20'''''''''''''''''40''''''''''''''''''60''''''''''''''''''80
EXIT /B


