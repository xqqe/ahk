#Requires AutoHotkey v2.0
#SingleInstance Force

; REMOVED COMBO PART BECAUSE IT WAS STUPID

; Setup GUI
global keyGui := Gui("+AlwaysOnTop -Caption +ToolWindow +LastFound", "KeyDisplay")
keyGui.BackColor := "3D3D3D"
keyGui.SetFont("s10 cWhite", "Segoe UI")
global keyText := keyGui.AddText("Center vKeyText w240", "")  ; 240px wide text box

; Initialize queue
global recentKeys := []

SetTimer(WatchKeys, 60)
return

WatchKeys() {
    global recentKeys
    static lastKeySignature := ""

    pressedKeys := GetPressedKeys()
    if pressedKeys.Length = 0 {
        lastKeySignature := ""
        return
    }

    signature := ""
    for key in pressedKeys
        signature .= (signature ? "+" : "") key

    if (signature != lastKeySignature) {
        if (pressedKeys.Length = 1) {
            readable := GetKeyName(pressedKeys[1])

            if (readable = "Space") {
                recentKeys := []
                HideOverlay()
				Tooltip
                lastKeySignature := signature
                return
            }

            AddToRecentKeys(readable)
        } 

        ShowKeyOverlay()		
        lastKeySignature := signature
    }
}


ShowKeyOverlay() {
    global keyGui, keyText, recentKeys
    display := ""
    for k in recentKeys
        display .= k ""
    keyText.Text := RTrim(display)
	Tooltip display
    keyGui.Show("NoActivate x1700 y85 AutoSize")
    ;SetTimer(HideOverlay, -1500) ; hide after 1.5 seconds
}

HideOverlay() {
    global keyGui
    keyGui.Hide()
}

AddToRecentKeys(key) {
    global recentKeys
    if recentKeys.Length >= 10
        recentKeys.RemoveAt(1)  ; remove oldest
    recentKeys.Push(key)
}

GetPressedKeys() {
    keys := []
    static ignoredVKs := Map(
        "VKB3", true,  ; Media Play/Pause
        "VKB5", true,  ; Media Next
        "VK01", true,  ; Mouse LB
        "VK02", true,  ; Mouse RB
		"VK10", true,  ; shift
		"VK11", true,  ; ctrl
		"VK12", true,  ; alt
		"VK08", true,  ; backspace
    )
	
NormalizeKeyName(name) {
    switch name {
        case "LControl", "RControl": return "Ctrl"
        case "LAlt", "RAlt": return "Alt"
        case "LShift", "RShift": return "Shift"
        case "LWin", "RWin": return "Win"
        default: return name
    }
}


    Loop 255 {
        vk := Format("VK{:02X}", A_Index)
		
        if ignoredVKs.Has(vk)
            continue
        if GetKeyState(vk, "P")
            keys.Push(vk)
    }
    return keys
}
