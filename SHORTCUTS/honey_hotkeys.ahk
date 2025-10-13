; ! is alt ___ ^ is control ___ + is shift ___ # is windows

!a::SendText "α"
!b::SendText "β"
!c::SendText "✓"
!d::SendText "∆"
!e::SendText "saxon.honey@contractors.roche.com"
!h::SendText "♥"
!m::SendText "μ"

; make sticky notes shortcut
!n::SendText "note"

!o::SendText "°"
!s::SendText "☠"
!t::SendText "✦"
!w::SendText "❖"
!x::SendText "✗"
!y::SendText "γ"
!z::{
    CurrentDateTime := FormatTime(, "M-d-yy")
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

; screenshot with snipping tool — comment out if using shareX
;!1::Send("#+s")

!'::Send '""{Left}'
![:: Send '[]{Left}'

!]::{
SendText("{}")
Send '{Left}'
}

!9::Send '(){Left}'

:*:e'mail::saxon.honey@contractors.roche.com

:*:n'ame::Saxon Honey
:*:u'ser::honeys
:*:p'ass::1sunforJupiter.{Enter}
:*:--::—

;DAYS OF THE WEEK

; --- Hotstrings ---
; today
:*:to'day::{
    Send(FormatTime(, "dddd (MM/dd)"))
}




; --- Helper: last specific weekday ---
GetLastWeekday(targetDay) {
    todayW := Integer(FormatTime(, "WDay")) ; Sun=1..Sat=7
    dayNum := Map("sun",1, "mon",2, "tue",3, "wed",4, "thu",5, "fri",6, "sat",7)[targetDay]
    diff := todayW - dayNum
    if (diff <= 0)
        diff += 7                 ; ensure "last" weekday, even if today is the same
    dt := DateAdd(A_Now, -diff, "Days")
    return FormatTime(dt, "dddd (MM/dd)")
}

; --- Hotstrings ---


; last Monday (test this one first)
:*:m'on::{ 
    SendText(GetLastWeekday("mon")) 
}
:*:t'ue::{ 
    SendText(GetLastWeekday("tue")) 
}
:*:w'ed::{ 
    SendText(GetLastWeekday("wed")) 
}
:*:t'hu::{ 
    SendText(GetLastWeekday("thu")) 
}
:*:f'ri::{ 
    SendText(GetLastWeekday("fri")) 
}
:*:s'at::{ 
    SendText(GetLastWeekday("sat")) 
}
:*:s'un::{ 
    SendText(GetLastWeekday("sun")) 
}

; --- Helper: next specific weekday ---
GetNextWeekday(targetDay) {
    todayW := Integer(FormatTime(, "WDay")) ; Sun=1..Sat=7
    dayNum := Map("sun",1,"mon",2,"tue",3,"wed",4,"thu",5,"fri",6,"sat",7)[targetDay]
    diff := Mod(dayNum - todayW + 7, 7)     ; 0..6 (0 means today)
    dt := DateAdd(A_Now, diff, "Days")
    return FormatTime(dt, "dddd (MM/dd)")
}


; --- Hotstrings ---


; last Monday (test this one first)
:*:m/on::{ 
    SendText(GetNextWeekday("mon")) 
}
:*:t/ue::{ 
    SendText(GetNextWeekday("tue")) 
}
:*:w/ed::{ 
    SendText(GetNextWeekday("wed")) 
}
:*:t/hu::{ 
    SendText(GetNextWeekday("thu")) 
}
:*:f/ri::{ 
    SendText(GetNextWeekday("fri")) 
}
:*:s/at::{ 
    SendText(GetNextWeekday("sat")) 
}
:*:s/un::{ 
    SendText(GetNextWeekday("sun")) 
}
