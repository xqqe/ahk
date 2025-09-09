#Requires AutoHotkey v2.0
SetTimer(Watch, 100)

global ignoredVKs := Map(
        "VKB3", true,  ; Media Play/Pause
        "VKB5", true,  ; Media Next
        "VK01", true,  ; Mouse LB
        "VK02", true,  ; Mouse RB
		"VK10", true,  ; shift
		"VK11", true,  ; ctrl
		"VK12", true,  ; alt
		)

Watch() {
    Loop 255 {
        vk := Format("VK{:02X}", A_Index)
		
        if ignoredVKs.Has(vk)
            continue
        if GetKeyState(vk, "P")
            ToolTip vk
    }
}
