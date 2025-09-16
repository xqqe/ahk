; ===== Minimal Perf Overlay (AHK v2) =====
#Requires AutoHotkey v2.0
; Hotkeys: Ctrl+Alt+Up/Down/Left/Right -> Nudge position


global g := { running: true, clickThrough: true, fontSize: 10, shown: true }

CreateGui() {
    global g
    if g.HasProp("gui")  ; already exists
        return
    g.gui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    g.gui.BackColor := "202020"
    g.gui.SetFont("s" g.fontSize, "Segoe UI")
    g.text := g.gui.Add("Text", "xm ym w150 cFFFFFF", "CPU --%  |  RAM --%")

    g.gui.Show("x3100 y1398 NoActivate") ;y0 is top y1420 is bottom
}
CreateGui()

SetTimer(UpdateStats, 500)

; ---------- Hotkeys ----------
^!Up::    MoveGui(0, -10)
^!Down::  MoveGui(0,  10)
^!Left::  MoveGui(-10, 0)
^!Right:: MoveGui( 10, 0)


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
