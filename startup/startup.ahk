#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; browser
#b::
Run, C:\Program Files\Mozilla Firefox\firefox.exe
return
; editor
#e::
Run, C:\Program Files\Microsoft VS Code\code.exe
return
; terminal
#t:: 
Run wt
return

#f::
Run, explorer.exe
return
