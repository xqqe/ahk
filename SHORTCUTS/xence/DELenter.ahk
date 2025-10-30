#Requires AutoHotkey v2


SendInput("{Del}")
Sleep(200)   ; Short delay to let VS Code register the first key
SendInput("{Enter}")
ExitApp