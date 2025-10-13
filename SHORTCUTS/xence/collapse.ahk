#Requires AutoHotkey v2

; Collapse all code in VS Code when the script is launched
SendInput("{Ctrl down}k{Ctrl up}")
Sleep(100)   ; Short delay to let VS Code register the first key
SendInput("{Ctrl down}0{Ctrl up}")
ExitApp
