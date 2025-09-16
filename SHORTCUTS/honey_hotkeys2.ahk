
!+'::{ ;;; "text"
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

!+[:: { ;;; [text]
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

!+]:: { ;;; {text}
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

!+9::{ ;;; (text)
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