﻿#$language = "VBScript"
#$interface = "1.0"

crt.Screen.Synchronous = True

' This automatically generated script may need to be
' edited in order to work correctly.

Sub Main
	crt.Screen.Send "w" & chr(13)
	crt.Screen.WaitForString "[weilaidb@localhost " & chr(126) & "]$ "
	crt.Screen.Send "w" & chr(13)
End Sub
