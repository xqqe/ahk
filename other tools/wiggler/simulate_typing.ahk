#Requires AutoHotkey v2.0

; =======================================================
; Char-by-char retyping with robust newlines + pause/resume
;  - Right-click: toggle pause/resume (no exit)
;  - Ctrl+Alt+J : start if stopped, resume if paused
;  - Loops file if shouldLoop := true
; =======================================================

; --- CONFIG ---
sourceFile      := "C:\Users\honeys\Documents\GitHub\ahk\other tools\wiggler\source.txt"

charDelayMin    := 100      ; ms between characters (min)
charDelayMax    := 310     ; ms between characters (max)

enterHoldMs     := 60      ; hold Enter down (prevents missed breaks)
postEnterMin    := 120     ; ms after newline before next char (min)
postEnterMax    := 200     ; ms after newline before next char (max)
newlineRetries  := 0       ; 0=once, 1=send newline sequence twice (extra safety)

loopDelay       := 500    ; ms pause after finishing the file
shouldLoop      := true    ; repeat file forever

; --- STATE ---
global g_running := false
global g_paused  := false
global g_lines   := []     ; lines array (strings)
global g_li      := 1      ; current line index
global g_ci      := 1      ; current char index within line



Run('notepad++.exe "output.txt"')      ; open the file
WinWaitActive("output.txt ahk_exe notepad++.exe")   ; reliable match

; Select all + delete
Send("^a")
Sleep(Random(200, charDelayMax))
Send("{Del}")

Sleep(Random(200, charDelayMax))
TypeSlow(FormatTime(, "dddd (MM/dd)"))
TypeSlow(" - Saxon Honey.")
Sleep(Random(200, charDelayMax))
EnterSlow()
Sleep(Random(200, charDelayMax))
TypeSlow(FormatTime(, "dddd (MM/dd)"))

ExitApp()


TypeSlow(text) {
    for char in StrSplit(text, "") {
        SendText(char)
        Sleep(Random(charDelayMin, charDelayMax))
    }
}

EnterSlow(num := 3) {	
    Loop num {
        Send("{Enter}")
        Sleep(Random(charDelayMin, charDelayMax))
    }
}