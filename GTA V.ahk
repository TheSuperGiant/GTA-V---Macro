#SingleInstance Force

KeyDelay := 30
KeyDelay_Enter := 50
; KeyDelay_Enter_Phone := 500
SetKeyDelay, %keyDelay%, %keyDelay%
Snack_menu__Down := 1
program_window_title := "Grand Theft Auto V"

; Restarts this ahk file.
Pause::
	Reload
Return

; Default (Free Roam) is 5th position from top.
; Some missions need 4th or 6th position from top.
; Health and Ammo menu position counted from top.
; Freemode (Free Roam) — 5th position from the top.
>+1::
<+1::
	Snack_menu__Down := 1
Return

; Some missions — 4th position from the top.
>+2::
<+2::
	Snack_menu__Down := 0
Return

; Other missions — 6th position from the top.
>+3::
<+3::
	Snack_menu__Down := 2
Return

; Snacks
; open snack menu
F1::
	WinGetActiveTitle, title
	if InStr(title, program_window_title){
		Menu__Snacks()
	}
Return
; open snack menu + eating 1 snack
F2::
	WinGetActiveTitle, title
	if InStr(title, program_window_title){
		Menu__Snacks()
		Sleep, %KeyDelay_Enter%
		Send {Enter}
	}
Return

; Armor
F5::
	WinGetActiveTitle, title
	if InStr(title, program_window_title){
		Menu__Body_Armor()
	}
Return
; Armor menu + equipe Super Heavy Armor
F4::
	WinGetActiveTitle, title
	if InStr(title, program_window_title){
		Menu__Body_Armor()
		Send {Enter}
		Menu()
	}
Return

; Sparrow
; Request Sparrow
<+F2::
	WinGetActiveTitle, title
	if InStr(title, program_window_title){
		Menu__Kosatka()
		Send {Down}{Enter}
	}
Return
; Return Sparrow
>+F2::
	WinGetActiveTitle, title
	if InStr(title, program_window_title){
		Menu__Kosatka__Return_Options()
		Send {Up 2}{Enter}
	}
Return
; Request Oppressor MK II
<+F4::
	WinGetActiveTitle, title
	if InStr(title, program_window_title){
		Menu__Terrorbyte()
		Send {Down 2}{Enter}
		Menu()
	}
Return

; Personal Vehicle
F6::
	WinGetActiveTitle, title
	if InStr(title, program_window_title){
		Menu__Manage_Vehicles()
	}
Return
; Request Personal Vehicle
CapsLock & F6::
<+F6::
	WinGetActiveTitle, title
	if InStr(title, program_window_title){
		Menu__Manage_Vehicles()
		Send {Enter}
		Menu()
	}
Return
; Return Personal Vehicle to Storage
>+F6::
	WinGetActiveTitle, title
	if InStr(title, program_window_title){
		Menu__Manage_Vehicles()
		Send {Up 3}{Enter}
		Menu()
	}
Return

; Mors Mutual Insurance
; Note have this contacts active to let it work:  
<+F8::
	WinGetActiveTitle, title
	if InStr(title, program_window_title){
		Phone__Contacts()
		;Send {Right}{Down}{Enter}
		;sleep, 100
		Send {Right}
		;sleep, 100
		;Send {Down}
		;sleep, 100
		;Send {Enter}
		;Send {Up 5}{Enter}
		Sleep, %KeyDelay_Enter_Phone%
	}
Return

; let GTA process sleep for 10 second so you come in an solo session.
^F8::
	Process_Suspend("GTA5.exe")
	Process_Suspend("GTA5_Enhanced.exe")
Return

; Close GTA directly.
^F11::
	Process, Close, GTA5.exe
	Process, Close, GTA5_Enhanced.exe
Return

; Auto grabber for example Gold, Cash etc.
>+F5::
<+F5::
	WinGetActiveTitle, title
	if InStr(title, program_window_title){	
		toggle_Clicker := !toggle_Clicker
		if(toggle_Clicker)
			SetTimer, AutoClicker, 250
		else
			SetTimer, AutoClicker, Off
	}
Return

; Auto bike rider.
F10::
<+F10::
>+F10::
	WinGetActiveTitle, title
	if InStr(title, program_window_title){
		toggle_Clicker := !toggle_Clicker
		if(toggle_Clicker)
			SetTimer, Speed_Bike, 700
		else
			SetTimer, Speed_Bike, Off
	}
Return

; invisible 48 minutes timer.
F12::
	timer := 2880000
	toggle_Timer := !toggle_Timer
	if(toggle_Timer){
		SetTimer, DbD1, %timer%,
		SoundPlay, %A_WinDir%\Media\tada.wav
		SetTimer, DbD1_Toggle, %timer%
	}
Return

; visible 48 minutes timer.
F8::
	toggle_Visual_Timer := !toggle_Visual_Timer
	If(toggle_Visual_Timer){
		MouseGetPos, mx, my

		SysGet, monitorsCount, 80
		Loop %monitorsCount% {
			SysGet, monitor, Monitor, %A_Index%
			if (monitorRigth <= mx && mx <= monitorRight && monitorTop <= my && my <= monitorBottom) {
				if (!WinExist("MovableBlank " . A_Index)) {
					Gui, Show, % "W" . Abs(monitorLeft) + Abs(monitorRight) . " H" . A_ScreenHeight . " X" . monitorLeft . " Y" . monitorTop . " NoActivate", MovableBlank %A_Index%
				}
			}
		}
		
		width := 210, time := 20000101004800 ;48m - GTA Day Timer
		Gui -Caption +AlwaysOnTop
		Gui, Font, s32 c008000
		Gui, Add, Text, w%width% x0 y0 vtext
		Gui, Show, w%width% h60, 48M Timer (GTA day)
		Gui, Color, 000000
		SetTimer, Clock, 1000
		WinActivate, %program_window_title%
	}else{
		SetTimer, DbD1, Off
		SetTimer, Clock, Off
		Gui, Destroy
	}
Return

Clock:
	FormatTime, clock, %time%, HH:mm:ss
	time += -1, Seconds
	GuiControl,, text, %clock%
	If(clock = "00:00:00"){
		SetTimer, Clock, Off
	}
	If(clock = "00:00:06"){
		SetTimer, DbD1, 6000
	}
Return

DbD1_Toggle:
    if(toggle_Timer){
        DbD1()
        SetTimer, DbD1_Toggle, 6000
		SetTimer, DbD1, Off
    }else{
        SetTimer, DbD1_Toggle, Off
    }
Return

DbD1(){
	SoundPlay, %A_WinDir%\Media\Alarm01.wav
}
ProcExist(PID_or_Name=""){
	Process, Exist, % (PID_or_Name="") ? DllCall("GetCurrentProcessID") : PID_or_Name
	Return Errorlevel
}
Process_Suspend(PID_or_Name){
	PID := (InStr(PID_or_Name,".")) ? ProcExist(PID_or_Name) : PID_or_Name
	h:=DllCall("OpenProcess", "uInt", 0x1F0FFF, "Int", 0, "Int", pid)
	If !h
		Return -1
	DllCall("ntdll.dll\NtSuspendProcess", "Int", h)
	Sleep, 10000
	DllCall("ntdll.dll\NtResumeProcess", "Int", h)
	DllCall("CloseHandle", "Int", h)
}
Speed_Bike(){
	send {RShift}
	send {LShift}
	Sleep, 100
}
AutoClicker(){
	CoordMode, Mouse, Window
	MouseMove, 0, 0, 0
	Click
}
Menu(){
	Sleep, 5
	Send {m}
	Sleep, %KeyDelay_Enter%
}
Menu__Health_and_Ammo(){
	Menu()
	global Snack_menu__Down
	Snack_menu__Down_total := 3 + Snack_menu__Down
	Send {Down %Snack_menu__Down_total%}
	Sleep, %keyDelay%
	Send {Enter}
	Sleep, %KeyDelay_Enter%
}
Menu__Snacks(){
	Menu__Health_and_Ammo()
	Send {Down 2}
	Sleep, %keyDelay%
	Send {Enter}
}
Menu__Body_Armor(){
	Menu__Health_and_Ammo()
	Send {Down}
	Sleep, %keyDelay%
	Send {Enter}
	Sleep, %KeyDelay_Enter%
	Send {Up 3}
}
Menu__Service_Vehicles(){
	Menu()
	Send {Down 3}
	Sleep, %keyDelay%
	Send {Enter}
	Sleep, %KeyDelay_Enter%
}
Menu__Kosatka(){
	Menu__Service_Vehicles()
	Send {Up 2}
	Sleep, %keyDelay%
	Send {Enter}
	Sleep, %KeyDelay_Enter%
}
Menu__Kosatka__Return_Options(){
	Menu__Kosatka()
	Send {Down 3}
	Sleep, %keyDelay%
	Send {Enter}
	Sleep, %KeyDelay_Enter%
}
Menu__Terrorbyte(){
	Menu__Service_Vehicles()
	Send {Down 3}
	Sleep, %keyDelay%
	Send {Enter}
	Sleep, %KeyDelay_Enter%
}
Menu__Manage_Vehicles(){
	Menu()
	Send {Down 2}
	Sleep, %keyDelay%
	Send {Enter}
	Sleep, %KeyDelay_Enter%
}
Phone(){
	Click Middle
	Sleep, 500
}
Phone__Contacts(){
	Phone()
	Send {Up}{Right}
	Sleep, %keyDelay%
	Send {Enter}
	Sleep, %KeyDelay_Enter_Phone%
}