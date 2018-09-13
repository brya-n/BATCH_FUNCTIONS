# BATCH_FUNCTIONS
Microsoft Windows 7, 10
Intended to return formatted string of:
CODE#VALUE#NUL
As ECHO
So this can be delimited by the calling batch program

Version 1.0.0
Refactoring what codes are returned, delimited by #

Token 1:  
   0#  Exception codes
   1#  Values
 
Standard Exception Codes
   0#0#"No supplied argument."#NUL
   0#1#"More than X argument(s)."#NUL   
   0#2# ... here onwards more function specific ... #NUL

Value example   ... where **VALUE** represents the variable of the value

   1#**VALUE**#"A human readable message."#NUL

NUL:   Because I'm fed up of sometimes extra spaces at end of a return, defensive programming!

0000_GET-IP.BAT   Version 0.0.1  (Inception)  Help:  0000_GET-IP.BAT ?
