; ===== Minimal Perf Overlay (AHK v2) =====
#Requires AutoHotkey v2.0
; Hotkeys:
; x  Ctrl+Alt+O  -> Toggle overlay show/hide
;x   Ctrl+Alt+T  -> Toggle click-through (ignore mouse)
;x   Ctrl+Alt+P  -> Pause/Resume updates
;   Ctrl+Alt+Up/Down/Left/Right -> Nudge position
;x   Ctrl+Alt+= / Ctrl+Alt+- -> Font size up/down

global g := { running: true, clickThrough: true, fontSize: 8, shown: true }

CreateGui() {
    global g
    if g.HasProp("gui")  ; already exists
        return
    g.gui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    g.gui.BackColor := "000000"
    g.gui.SetFont("s" g.fontSize, "Segoe UI")
    g.text := g.gui.Add("Text", "xm ym w110 cFFFFFF", "CPU --%  |  RAM --%")

    g.gui.Show("x600 y0 NoActivate")
}
CreateGui()

SetTimer(UpdateStats, 500)

; ---------- Hotkeys ----------
^!o:: { ; toggle overlay show/hide
    global g
    if !g.HasProp("gui")
        CreateGui()
    if g.shown {
        g.gui.Hide()
        g.shown := false
    } else {
        g.gui.Show("NoActivate")
        if g.clickThrough
            WinSetExStyle("+0x20", "ahk_id " g.gui.Hwnd) ; WS_EX_TRANSPARENT
        g.shown := true
    }
}

^!t:: { ; toggle click-through
    global g
    g.clickThrough := !g.clickThrough
    if g.HasProp("gui")
        WinSetExStyle((g.clickThrough ? "+0x20" : "-0x20"), "ahk_id " g.gui.Hwnd)
}

^!p:: g.running := !g.running

^!Up::    MoveGui(0, -5)
^!Down::  MoveGui(0,  5)
^!Left::  MoveGui(-5, 0)
^!Right:: MoveGui( 5, 0)

^!=:: { ; font size up (Ctrl+Alt+=)
    global g
    g.fontSize += 1
    if g.HasProp("gui") {
        g.gui.SetFont("s" g.fontSize)
        g.text.SetFont("s" g.fontSize)
    }
}

^!-:: { ; font size down (Ctrl+Alt+-)
    global g
    g.fontSize := Max(8, g.fontSize - 1)
    if g.HasProp("gui") {
        g.gui.SetFont("s" g.fontSize)
        g.text.SetFont("s" g.fontSize)
    }
}

; ---------- Functions ----------
UpdateStats() {
    global g
    if !g.running || !g.HasProp("gui") || !g.shown
        return
    cpu := GetCPU()
    ram := GetRAM()
    g.text.Value := Format("CPU {1:2}%  |  RAM {2:2}%", cpu, ram)

}

GetCPU() {
    static svc := ComObjGet("winmgmts:")
    for p in svc.ExecQuery("SELECT PercentProcessorTime FROM Win32_PerfFormattedData_PerfOS_Processor WHERE Name='_Total'")
        return Integer(p.PercentProcessorTime)
    return 0
}

GetRAM() {
    static svc := ComObjGet("winmgmts:")
    for os in svc.ExecQuery("SELECT TotalVisibleMemorySize, FreePhysicalMemory FROM Win32_OperatingSystem") {
        total := os.TotalVisibleMemorySize+0
        free := os.FreePhysicalMemory+0
        return Round(100 * (total - free) / total)
    }
    return 0
}

MoveGui(dx, dy) {
    global g
    if !g.HasProp("gui")
        return
    WinGetPos(&x, &y, , , "ahk_id " g.gui.Hwnd)
    g.gui.Show(Format("x{1} y{2} NoActivate", x+dx, y+dy))
}
