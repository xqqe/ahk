; ! is alt ___ ^ is control ___ + is shift

!a::SendText "α"
!b::SendText "β"
!c::SendText "✓"
!d::SendText "∆"
!h::SendText "♥"
!m::SendText "μ"
!o::SendText "°"
!s::SendText "☠"
!t::SendText "✦"
!w::SendText "❖"
!x::SendText "✗"
!y::SendText "γ"
!z::{
    CurrentDateTime := FormatTime(, "ddMMMyyyy")
    Send(CurrentDateTime)
}
!2::SendText "²"

!.::SendText "➜"
!,::SendText "⊣"

;FIND NEW HOTKEYS FOR THESE
;!]::SendText "↓"
;![::SendText "↑"

!`::SendText "________________________"
!=::SendText "⸰"
!-::SendText "—"


; ctrl shift paste to paste with native formatting
!v::Send '^+{v}'

; Always on Top
^SPACE:: WinSetAlwaysOnTop -1, WinExist("A")

!1::Send("#+s")

^`::Send("saxon.honey@contractors.roche.com")

!'::
{
    ; Clear the clipboard and copy the selected text
    A_Clipboard := ""
    Send("^c")
    if !ClipWait(0.5)
    {
		Send '""{Left}'
		return
	}

    ; Store the copied text
    selectedText := A_Clipboard

    ; Add quotes around it
    quoted := '"' selectedText '"'

    ; Replace the selection with the quoted text
    A_Clipboard := quoted
    Send("^v")

    ; Optional: Restore original clipboard after a short delay
    ; Sleep(100)
    ; A_Clipboard := origClip
}

![::
{
    ; Clear the clipboard and copy the selected text
    A_Clipboard := ""
    Send("^c")
    if !ClipWait(0.5)
    {
		Send '[]{Left}'
		return
	}

    ; Store the copied text
    selectedText := A_Clipboard

    ; Add quotes around it
    quoted := '[' selectedText ']'

    ; Replace the selection with the quoted text
    A_Clipboard := quoted
    Send("^v")

    ; Optional: Restore original clipboard after a short delay
    ; Sleep(100)
    ; A_Clipboard := origClip
}

;alt shift [
!+[:: 
{
    ; Clear the clipboard and copy the selected text
    A_Clipboard := ""
    Send("^c")
    if !ClipWait(0.5)
    {
		Send '{}{Left}'
		return
	}

    ; Store the copied text
    selectedText := A_Clipboard

    ; Add quotes around it
    quoted := '{' selectedText '}'

    ; Replace the selection with the quoted text
    A_Clipboard := quoted
    Send("^v")

    ; Optional: Restore original clipboard after a short delay
    ; Sleep(100)
    ; A_Clipboard := origClip
}


!9::
{
    ; Clear the clipboard and copy the selected text
    A_Clipboard := ""
    Send("^c")
    if !ClipWait(0.5)
    {
		Send '(){Left}'
		return
	}

    ; Store the copied text
    selectedText := A_Clipboard

    ; Add quotes around it
    quoted := '(' selectedText ')'

    ; Replace the selection with the quoted text
    A_Clipboard := quoted
    Send("^v")

    ; Optional: Restore original clipboard after a short delay
    ; Sleep(100)
    ; A_Clipboard := origClip
}