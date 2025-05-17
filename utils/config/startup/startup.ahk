#SingleInstance

UserProfile := EnvGet("USERPROFILE")

; browser
#b::Run "C:\Program Files (x86)\Microsoft\Edge\Application\msedge"
; editor
#e::Run "C:\Program Files\Microsoft VS Code\code.exe"
; terminal
#t::Run "wezterm-gui"

#f::Run UserProfile . "\utils\FPilot.exe"

#q::!F4

; shrug
::\shrug::¯\_(ツ)_/¯

; capslock to esc
CapsLock::Esc

; copy paste
XButton1::^v
XButton2::^c
