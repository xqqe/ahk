; ! is alt ___ ^ is control ___ + is shift

!^+#a::{
    SendInput("{Ctrl down}k{Ctrl up}")   ; Tap Ctrl+K
    Sleep(75)                            ; Short delay to let VS Code register the sequence
    SendInput("0")                       ; Press 0 (while Ctrl is still logically held)
}

