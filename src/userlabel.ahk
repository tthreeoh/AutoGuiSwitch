#Include <MonitorWindows>

MonitorToggle:
		Sound_click()
		GuiControl Hide, x%xi%
		xi := 3 - xi
		GuiControl Show, x%xi%
		if (xi = 1){
			_on=C:\Windows\System32\DisplaySwitch.exe /extend
			Run, %  _on,, hide
			MsgBox,,,% "press ok when ready", 4
			MonitorWindows.Set(windowlist)
			;MonitorWindows.Set(windows)
			}
		if (xi = 2){
			;windows:= new MonitorWindows
			windowlist:=MonitorWindows.Get()
			_off=C:\Windows\System32\DisplaySwitch.exe /internal
			Run, %  _off,,hide
			}

		Return

SoundToggle1:
		MsgBox,,, % A_ThisLabel
		Sound_click()
		GuiControl Hide, y%yi%
		yi := 3 - yi
		GuiControl Show, y%yi%

		if (yi = 1){
			;MsgBox,,, % ci,% (1/3)
			SoundSet, +1,, Mute
			}
		if (yi = 2){
			;MsgBox,,, % ci,% (1/3)
			SoundSet, +1,, Mute
			}

		Return

turnoffmon:
	SendMessage, 0x112, 0xF170, 2,, Program Manager   ; 0x112 is WM_SYSCOMMAND, 0xF170 is SC_MONITORPOWER.
	BlockInput, on
	Input, doesntmatter,, {Escape}{Space}{Control}{Shift}{CapsLock}
	BlockInput, off
	return

