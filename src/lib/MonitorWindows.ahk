MonitorWindows(){
		Msgbox,,, this works, % (1/10)
	}

class MonitorWindows {
	;MyKey := "key"
	__New() {
	this.Get()
	}

	Get(){ ;
			return_this:={}
			SysGet, Mon1, Monitor, 1
			SysGet, Mon2, Monitor, 2
			Mon1Right:=A_ScreenWidth ;SysGet, Mon1, Monitor, 1 ;to enumerate Monitor one Dimension for Mon1Right
			WinGet _windowlist, List
			_count:=0
			Loop %_windowlist% 
				{
					id := _windowlist%A_Index% ,
					WinGetTitle _wintitle, ahk_id %id% , 
					WinGetPos, _winposX, _winposY, _winposWidth, _winposHeight, %_WinTitle% ,
					_check:=% _wintitle . _winposX . _winposY . _winposWidth . _winposHeight
					if (_check){
						if ( _winposX > (Mon1Right-10) ){
							++_count
							return_this[_count,1]:=id , 
							return_this[_count,2]:=_winposX
							return_this[_count,3]:=_winposY
							return_this[_count,4]:=_winposWidth
							return_this[_count,5]:=_winposHeight
							} 
						}
				}
			return return_this
		}
	Set(array_of_windows){
		window_count:=array_of_windows.MaxIndex()
		loop %window_count%
		{
			temp_id:=array_of_windows[A_Index,1]
			temp_x:=array_of_windows[A_Index,2]
			temp_y:=array_of_windows[A_Index,3]
			temp_width:=array_of_windows[A_Index,4]
			temp_height:=array_of_windows[A_Index,5]
			winmove,% "ahk_id " . temp_id,,% (temp_x+0),% (temp_y+0),% temp_width,% temp_height
		}


	}
}