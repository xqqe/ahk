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
charDelayMax    := 110     ; ms between characters (max)

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

ShowStatus(msg := "") {
    ToolTip(msg)
    if (msg != "")
        SetTimer(() => ToolTip(), -1000)
}

; Right-click: STOP + RELOAD (fresh instance)
~RButton:: {
    global g_running, g_paused
    if g_running {
        g_paused := true
        g_running := false
        ShowStatus("Reloading...")
        Sleep(200) ; brief pause to avoid partial keystrokes
        Reload     ; restart this script cleanly
    }
}


; Start/Resume: Ctrl+Alt+J
^!j:: {
    global g_running, g_paused, g_lines, g_li, g_ci

    if !g_running {
        if !FileExist(sourceFile) {
            MsgBox("Source file not found:`n" sourceFile, "Error", 16)
            return
        }
        text := FileRead(sourceFile, "UTF-8")
        ; Normalize newlines to LF, then split while preserving empty lines
        text := StrReplace(text, "`r`n", "`n")
        text := StrReplace(text, "`r", "`n")
        g_lines := []
        seg := ""
        loop StrLen(text) {
            ch := SubStr(text, A_Index, 1)
            if (ch = "`n") {
                g_lines.Push(seg)  ; may be empty (blank line)
                seg := ""
            } else {
                seg .= ch
            }
        }
        ; If file doesn't end with LF, keep last segment
        if (seg != "" || (StrLen(text) > 0 && SubStr(text, -0) != "`n"))
            g_lines.Push(seg)

        if (g_lines.Length = 0) {
            MsgBox("No content to type.", "Info", 64)
            return
        }

        g_li := 1
        g_ci := 1
        g_paused  := false
        g_running := true
        ShowStatus("Started")
        TyperLoop()
        return
    }

    if g_paused {
        g_paused := false
        ShowStatus("Resumed")
    } else {
        ShowStatus("Already running")
    }
}

TyperLoop() {
    global g_running, g_paused, g_lines, g_li, g_ci, shouldLoop, loopDelay

    while g_running {
        ; Type remaining lines
        while (g_li <= g_lines.Length) && g_running {
            while g_paused && g_running
                Sleep(50)
            if !g_running
                break

            TypeLineCharByChar(g_lines[g_li])
            if !g_running
                break
            ; After finishing a line, send robust newline
            RobustNewline()
            g_li += 1
            g_ci := 1
        }

        if !g_running
            break

        if !shouldLoop {
            ShowStatus("Finished")
            g_running := false
            break
        }

        ; Loop: reset to start
        Sleep(loopDelay)
        g_li := 1
        g_ci := 1
    }
}

TypeLineCharByChar(line) {
    global g_running, g_paused, g_ci, charDelayMin, charDelayMax

    ; Type each character literally
    while (g_ci <= StrLen(line)) && g_running {
        while g_paused && g_running
            Sleep(50)
        if !g_running
            return
        ch := SubStr(line, g_ci, 1)
        SendText(ch)
        Sleep(Random(charDelayMin, charDelayMax))
        g_ci++
    }
}

RobustNewline() {
    global enterHoldMs, postEnterMin, postEnterMax, newlineRetries
    ; Send both a literal LF and a physical Enter (with hold), possibly twice
    tries := newlineRetries + 1
    loop tries {
        ; Literal newline (some apps accept this best)
        SendText("`n")
        Sleep(30)
        ; Physical Enter (others need this)
        Send("{Enter down}")
        Sleep(enterHoldMs)
        Send("{Enter up}")
        Sleep(Random(postEnterMin, postEnterMax))
    }
}