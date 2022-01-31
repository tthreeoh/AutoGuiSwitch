class Myicons {
	__New(){

	}

	set(type="idle",base="",debuggg="0"){ ;set icon location in ini?
		I_Icon_type:=((base)?(base . "\" . type . ".ico"):(a_scriptdir . "\lib\icons\" . type . ".ico"))
		if (debuggg = 1){
			MsgBox,,, % I_Icon_type
			}
		IfExist, %I_Icon_type%
			{
			Menu, Tray, Icon, %I_Icon_type%
			}

		return lasticon:=type
	}
}