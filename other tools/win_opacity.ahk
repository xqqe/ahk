#Requires AutoHotkey v2.0
; Ctrl+Alt+Up   = +10 opacity
; Ctrl+Alt+Down = -10 opacity
; Ctrl+Alt+0    = reset to 100%
; Ctrl+Alt+T    = quick 70% toggle
; Ctrl+Alt+C    = toggle click-through (on/off)

^!Up::AdjustOpacity(10)
^!Down::AdjustOpacity(-10)
^!0::WinSetTransparent(255, "A"), ShowPct(255)

^!t:: {  ; quick set to ~70%
    win := "A"
    WinSetTransparent(180, win)  ; ~70% (180/255)
    ShowPct(180)
}

^!c:: {  ; click-through toggle
    win := "A"
    ex := WinGetExStyle(win)
    if (ex & 0x20)  ; WS_EX_TRANSPARENT
        WinSetExStyle("-0x20", win)
    else
        WinSetExStyle("+0x20", win)
}

AdjustOpacity(delta) {
    win := "A"

    ; If target window is elevated and script is not, changes won't apply.
    if !A_IsAdmin && IsProcessElevated(WinGetPID(win)) {
        ToolTip("Run script as Admin to affect elevated windows")
        SetTimer(() => ToolTip(), -1200)
        return
    }

    cur := WinGetTransparent(win)
    ; Treat 0 or blank as “not set yet” → start from 255
    if (cur = "" || cur = 0)
        cur := 255

    new := cur + delta
    if (new > 255) new := 255
    if (new < 0)   new := 0

    WinSetTransparent(new, win)
    ShowPct(new)
}

ShowPct(val) {
    ToolTip("Opacity: " Round(val/255*100) "%")
    SetTimer(() => ToolTip(), -800)
}

IsProcessElevated(pid) {
    ; Simple heuristic: try opening the process with PROCESS_QUERY_LIMITED_INFORMATION (0x1000)
    h := DllCall("OpenProcess", "UInt", 0x1000, "Int", 0, "UInt", pid, "Ptr")
    if (!h)
        return true  ; can't open (likely elevated or protected)
    DllCall("CloseHandle", "Ptr", h)
    return false
}
