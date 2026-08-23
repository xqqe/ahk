#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

global DashRunLength := 0
global DashPauseMs := 250

dashWatcher := InputHook("V")
dashWatcher.OnChar := WatchTypedCharacters
dashWatcher.Start()

WatchTypedCharacters(inputHook, characters)
{
    global DashRunLength, DashPauseMs

    for character in StrSplit(characters)
    {
        if (character = "-")
        {
            DashRunLength++

            ; Restart the countdown after every consecutive dash.
            SetTimer(FinishDashRun, 0)
            SetTimer(FinishDashRun, -DashPauseMs)
        }
        else
        {
            SetTimer(FinishDashRun, 0)

            if (DashRunLength = 2)
            {
                ; The new character is already on screen.
                ; Remove it and the two dashes, then restore it
                ; after inserting the em dash.
                Send("{Backspace 3}")
                SendText("—" character)
            }

            DashRunLength := 0
        }
    }
}

FinishDashRun()
{
    global DashRunLength

    ; A pause converts only a run of exactly two dashes.
    if (DashRunLength = 2)
        Send("{Backspace 2}—")

    DashRunLength := 0
}