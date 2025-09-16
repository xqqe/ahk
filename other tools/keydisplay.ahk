#Requires AutoHotkey v2.0
#SingleInstance Force

SetTimer(WatchKeys, 100)
return

WatchKeys() {
    static lastKey := ""

    for key in GetPressedKeys() {
        ; Skip if key is same as before
        if key != lastKey {
            ToolTip "You pressed: " GetKeyName(key)
            lastKey := key
            return
        }
    }

    ; No key change or nothing pressed
    ToolTip ""
    lastKey := ""
}

GetPressedKeys() {
    keys := []
    static ignoredVKs := Map(
        "VKB3", true, ; Media Play/Pause (often falsely reported)
        "VKA6", true, ; Browser Favorites
        "VKB5", true  ; Media Next
        ; Add more if needed
    )

    Loop 255 {
        vk := Format("VK{:02X}", A_Index)
        if ignoredVKs.Has(vk)
            continue
        if GetKeyState(vk, "P")
            keys.Push(vk)
    }
    return keys
}
