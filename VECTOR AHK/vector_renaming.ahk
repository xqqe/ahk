#Requires AutoHotkey v2.0
#SingleInstance Force
;^!g clicks edit for each file (make sure all the pages have finished loading before the next step)
; MAKE SURE TEXT BOX IS ACTIVE BEFORE ACTIVATING ANY SUBSESEQUENT HOTKEYS
;^!c saves the current names to file (go to the text file and edit the files)
;^!v replaces all the names (check them all the make sure they're right)
;^!h saves all of them

; =========================
; Settings
; =========================
tabDelay   := 50     ; ms between Tab presses
copyDelay  := 200    ; ms after Ctrl+C to let clipboard update
stepDelay  := 100    ; ms between major steps
outFile    := A_ScriptDir "\captured_text.txt"  ; where snippets are saved
abort      := false  ; global flag to cancel

; ── Hotkey 1: Ctrl+Alt+G ──
; Ask for iteration count, then:
;   Tab 12x → Enter → Ctrl+Tab → repeat
^!g:: {
    global tabDelay, stepDelay, abort
    abort := false  ; reset abort flag

    ; Prompt for number of iterations (default = 25)
    result := InputBox("How many times should I run this sequence?", "Run Sequence (G)",, "25")
    if (result.Result = "Cancel")
        return

    times := Trim(result.Value)
    if !RegExMatch(times, "^\d+$") || (times := times + 0) <= 0 {
        MsgBox "Please enter a positive whole number.", "Run Sequence (G)", 48
        return
    }

    Loop times {
        if abort
            break

        ; Tab to field
        Loop 12 {
            Send "{Tab}"
            Sleep tabDelay
        }

        ; Press Enter
        Send "{Enter}"
        Sleep stepDelay

        ; Move on
        Send "^{Tab}"
        Sleep stepDelay
    }

    if abort
        MsgBox "Sequence aborted after " (A_Index-1) " iteration(s).", "Run Sequence (G)"
    else
        MsgBox "Sequence complete.`nRan " times " iteration(s).", "Run Sequence (G)"
}


; ── Hotkey 2: Ctrl+Alt+C ──
^!c:: {
    global tabDelay, copyDelay, stepDelay, outFile, abort
    abort := false  ; reset abort flag

    ; Prompt for number of iterations (default = 25)
    result := InputBox("How many items should I capture?", "Capture & Save",, "25")
    if (result.Result = "Cancel")
        return

    times := Trim(result.Value)
    if !RegExMatch(times, "^\d+$") || (times := times + 0) <= 0 {
        MsgBox "Please enter a positive whole number.", "Capture & Save", 48
        return
    }

    if !FileExist(outFile)
        FileAppend "", outFile, "UTF-8"

    Loop times {
        if abort
            break

        ; Tab to field
        Loop 14 {
            Send "{Tab}"
            Sleep tabDelay
        }

        ; Copy text
        A_Clipboard := ""
        Send "^{c}"
        if !ClipWait(1) {
            text := ""
        } else {
            Sleep copyDelay
            text := A_Clipboard
        }

        ; Move on
        Send "^{Tab}"
        Sleep stepDelay

        ; Normalize and append
        if (text = "")
            text := ""
        else
            text := RegExReplace(text, "\R", " ")

        FileAppend text "`r`n", outFile, "UTF-8"
    }

    if abort
        MsgBox "Capture aborted early.", "Capture & Save"
    else
        MsgBox "Capture complete.`nSaved " times " item(s) to:`n" outFile
}

; ── Emergency stop: press Esc to abort loops ──
Esc:: {
    global abort
    abort := true
}

; ── Hotkey 3: Ctrl+Alt+V ──
; Paste each line from captured_text.txt, replacing existing text, then Ctrl+Tab to advance.
^!v:: {
    global outFile, stepDelay, abort
    abort := false

    if !FileExist(outFile) {
        MsgBox "File not found:`n" outFile, "Paste from File", 48
        return
    }

    ; Read and split lines robustly (handles CRLF/CR/LF)
    text := FileRead(outFile, "UTF-8")
    text := RegExReplace(text, "\r\n?","`n")
    lines := StrSplit(text, "`n")

    pastedCount := 0
    for idx, line in lines {
        if abort
            break

        ; Select all, then replace with clipboard contents
        A_Clipboard := line
        Sleep 50
        Send "^{a}"       ; select all
        Sleep 50
        Send "^{v}"       ; paste (replaces selected text)
        Sleep stepDelay

        ; Move to next target
        Send "^{Tab}"
        Sleep stepDelay

        pastedCount++
    }

    if abort
        MsgBox "Pasting aborted after " pastedCount " line(s).", "Paste from File"
    else
        MsgBox "Pasted " pastedCount " line(s) from:`n" outFile, "Paste from File"
}

; ── Hotkey 4: Ctrl+Alt+H ──
; Ask for iteration count, then:
;   Tab 9x → Enter → Ctrl+Tab → repeat
^!h:: {
    global tabDelay, stepDelay, abort
    abort := false  ; reset abort flag

    ; Prompt for number of iterations (default = 25)
    result := InputBox("How many times should I run this sequence?", "Run Sequence",, "25")
    if (result.Result = "Cancel")
        return

    times := Trim(result.Value)
    if !RegExMatch(times, "^\d+$") || (times := times + 0) <= 0 {
        MsgBox "Please enter a positive whole number.", "Run Sequence", 48
        return
    }

    Loop times {
        if abort
            break

        ; Tab to field
        Loop 9 {
            Send "{Tab}"
            Sleep tabDelay
        }

        ; Press Enter
        Send "{Enter}"
        Sleep stepDelay

        ; Move on
        Send "^{Tab}"
        Sleep stepDelay
    }

    if abort
        MsgBox "Sequence aborted after " (A_Index-1) " iteration(s).", "Run Sequence"
    else
        MsgBox "Sequence complete.`nRan " times " iteration(s).", "Run Sequence"
}
