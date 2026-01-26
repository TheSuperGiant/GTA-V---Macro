#SingleInstance Force

; ⚠️ WARNING:
; Use of this macro is at your own risk.
; Rockstar may ban you from GTA Online or other Rockstar Games if detected.
; This script is made for personal use only.

KeyDelay := 22
KeyDelay_Enter := 102 - (KeyDelay * 2)
SetKeyDelay, %keyDelay%, %keyDelay%
Menu_Down := 1
program_window_title := "Grand Theft Auto V"
Menu_First_Time := 1
layout := GetKeyboardLayout()

; Reload script if hotkey doesn't work.
Pause::
	Reload
Return


;-----------------------------

; Default (Free Roam) is 3th position from top.
; Some missions need 2th or 4th position from top.
; 'Manage Vehicles' menu position counted from the top.
; Works for 'Health and Ammo' and 'Manage Vehicles' in menu.

; Freemode (Free Roam) — 3th position from the top.
>+1::
<+1::
	if Active_Window(){
		Menu_Down := 1
	}else{
		GetSymbol(1)
	}
	Shift_Up()
Return

; Some missions — 2th position from the top.
>+2::
<+2::
	if Active_Window(){
		Menu_Down := 0
	}else{
		GetSymbol(2)
	}
	Shift_Up()
Return

; Other missions — 4th position from the top.
>+3::
<+3::
	if Active_Window(){
		Menu_Down := 2
	}else{
		GetSymbol(3)
	}
	Shift_Up()
Return

;-----------------------------

; Snacks
; open snack menu
F1::
	if Active_Window(){
		Menu__Snacks()
	}
Return
; open snack menu + eating 1 snack
F2::
	if Active_Window(){
		Menu__Snacks()
		Sleep, %KeyDelay_Enter%
		Send {Enter}
	}
Return

; Armor
; Armor menu
F5::
	if Active_Window(){
		Menu__Body_Armor()
	}
Return
; Armor menu + equip Super Heavy Armor
F4::
	if Active_Window(){
		Menu__Body_Armor()
		Send {Enter}
		Menu()
	}
Return

; Sparrow
; Request Sparrow
<+F2::
	if Active_Window(){
		Menu__Kosatka()
		Send {Down}{Enter}
	}
	Shift_Up()
Return
; Return Sparrow
>+F2::
	if Active_Window(){
		Menu__Kosatka__Return_Options()
		Send {Up 2}{Enter}
	}
	Shift_Up()
Return
; Request Oppressor MK II
<+F4::
	if Active_Window(){
		Menu__Terrorbyte()
		Send {Down 2}{Enter}
		Menu()
	}
	Shift_Up()
Return

; Personal Vehicle
F6::
	if Active_Window(){
		Menu__Manage_Vehicles()
	}
Return
; Request Personal Vehicle
CapsLock & F6::
<+F6::
	if Active_Window(){
		Menu__Manage_Vehicles()
		Send {Enter}
		Menu()
	}
	Shift_Up()
Return
; Return Personal Vehicle to Storage
>+F6::
	if Active_Window(){
		Menu__Manage_Vehicles()
		Send {Up 3}{Enter}
		Menu()
	}
	Shift_Up()
Return

; let GTA process sleep for 10 second so you come in an solo session.
^F8::
	Process_Suspend("GTA5.exe")
	Process_Suspend("GTA5_Enhanced.exe")
Return

; AFK Walking
^F6::
	toggle_AFK := !toggle_AFK
	if(toggle_AFK && Active_Window()){
		Send {w down}{a down}
	}else{
		Send {w up}{a up}
		toggle_AFK := false
	}
return

; AFK Dancing in Nightclub
!F6::
	toggle_AFK_Dancing := !toggle_AFK_Dancing
	if(toggle_AFK_Dancing && Active_Window()){
		; SetTimer, AutoClicker_Left, % Random (500, 600)
		SetTimer, AutoClicker_Left, 475
	}else{
		SetTimer, AutoClicker_Left, Off
	}
return

; Force-save
Insert::
	if Active_Window(){
		Menu__Appearance()
		Send {Down 3}
		Sleep, %keyDelay%
		Send {Enter}
		Sleep, %keyDelay%
		Send {m}
	}
Return

; Close GTA directly.
^F11::
	Process, Close, GTA5.exe
	Process, Close, GTA5_Enhanced.exe
Return

; Auto grabber for example Gold, Cash etc.
>+F5::
<+F5::
	toggle_Grabber := !toggle_Grabber
	if(toggle_Grabber && Active_Window()){
		SetTimer, AutoClicker, 250
	}else{
		SetTimer, AutoClicker, Off
		toggle_Grabber := false
		Shift_Up()
	}
Return

; Auto bike rider.
F10::
<+F10::
	toggle_rider := !toggle_rider
	if(toggle_rider && Active_Window()){
		SetTimer, Speed_Bike, 800
	}else{
		SetTimer, Speed_Bike, Off
		toggle_rider := false
		Shift_Up()
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
	if(toggle_Visual_Timer){
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

AutoClicker_Left()
{
	Random, sleepdelay, 0, 50
	Sleep, sleepDelay
	Click
}
Clock:
	FormatTime, clock, %time%, HH:mm:ss
	time += -1, Seconds
	GuiControl,, text, %clock%
	if(clock = "00:00:00"){
		SetTimer, Clock, Off
	}
	if(clock = "00:00:06"){
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
	if !h
		Return -1
	DllCall("ntdll.dll\NtSuspendProcess", "Int", h)
	Sleep, 10000
	DllCall("ntdll.dll\NtResumeProcess", "Int", h)
	DllCall("CloseHandle", "Int", h)
}
Shift_Up(){
	Send {LShift up}{RShift up}
}
Active_Window(){
	global program_window_title
	WinGetActiveTitle, title
	if InStr(title, program_window_title){
		return 1
	}
}
Speed_Bike(){
	send {LShift}
}
AutoClicker(){
	CoordMode, Mouse, Window
	MouseMove, 0, 0, 0
	Click
}



Menu(){
	global Menu_First_Time, keyDelay
	Menu_sleep := 57 - (KeyDelay * 2)
	if(Menu_First_Time = 1){
		Send {m}
		Menu_sleep := 57 - KeyDelay
		Sleep, %Menu_sleep%
		Send {m}
		Menu_sleep := 57 - KeyDelay
		Menu_First_Time := 0
	}
	Sleep, %Menu_sleep%
	Send {m}
	Sleep, %KeyDelay_Enter%
}
Menu__Health_and_Ammo(){
	Menu()
	global Menu_Down
	Menu__Down_total := 3 + Menu_Down
	Send {Down %Menu__Down_total%}
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
	global Menu_Down
	Menu__Down_total := 1 + Menu_Down
	Send {Down %Menu__Down_total%}
	Sleep, %keyDelay%
	Send {Enter}
	Sleep, %KeyDelay_Enter%
}
Menu__Appearance(){
	Menu()
	Send {Down 5}
	Sleep, %keyDelay%
	Send {Enter}
	Sleep, %KeyDelay_Enter%
}

;-------------------------------

GetKeyboardLayout(){
	WinGet, hWnd, ID, A
	threadID := DllCall("GetWindowThreadProcessId", "UInt", hWnd, "UInt*", 0)
	layoutID := DllCall("GetKeyboardLayout", "UInt", threadID)
	hexLayout := Format("{:08X}", layoutID)
	return SubStr(hexLayout, 1)
}
GetSymbol(index){
	global layout

	symbols := Object()
	symbols[04090409] := ["!", "@", "#"]  ; US - Standard
	symbols["FFFFFFFFF0010409"] := ["!", "@", "#"]  ; US - International
	symbols["040C040C"] := ["1", "2", "3"]  ; French - Standard
	symbols[04130413] := ["!", """", "#"]  ; Dutch - Standard
	symbols[04070407] := ["!", """", "§"]  ; German - Standard
	symbols[0000] := ["!", "@", "#"]  ; fallback

	if !symbols.HasKey(layout)
		layout := "0000"

	SendRaw, % symbols[layout][index]
}
