; ! is alt ___ ^ is control ___ + is shift

!a::SendText "α"
!b::SendText "β"
!c::SendText "✓"
!d::SendText "∆"
!e::SendText "saxon.honey@contractors.roche.com"
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

!+,::SendText "↓"
!+.::SendText "↑"


!=::SendText "⸰"
!-::SendText "—"
!+-::SendText "________________________"


; ctrl shift paste to paste with native formatting
!v::Send '^+{v}'

; Always on Top
^SPACE:: WinSetAlwaysOnTop -1, WinExist("A")

; screenshot
!1::Send("#+s")

!'::Send '""{Left}'
![:: Send '[]{Left}'

!]::{
SendText("{}")
Send '{Left}'
}

!9::Send '(){Left}'

:*:e'mail::saxon.honey@contractors.roche.com
:*:to'day::{
    CurrentDateTime := FormatTime(, "dddd (MM/dd)")
    Send(CurrentDateTime)
}

:*:u'ser::honeys
:*:p'ass::1sunforJupiter.{Enter}