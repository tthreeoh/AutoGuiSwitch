
if not A_IsAdmin 
run *RunAs "%A_ScriptFullPath%"
#SingleInstance Force
#Persistent
	Process, Priority, , A
	SetBatchLines, -1
	ListLines, off
#Include <Myicons>
Myicons.set("restart")



;configuration
this_ini=config.ini
switchesini=switch.ini
auto_width_array:={}
control_width_array:={}
text_width_array:={}
switch_width_array:={}
;functions


	numbers_into_letters(in) {   ; in: 1 origined number
	    Loop % ((in-1) // 26) + 1 { ; same as your script.
	        out .= Chr(Mod(in-1, 26) + asc("a"))  ; append corresponding character
	    }
	    return out
		}

	StringWidth(String, Font:="", FontSize:=10){
		Gui StringWidth:Font, s%FontSize%, %Font%
		Gui StringWidth:Add, Text, R1, %String%
		GuiControlGet T, StringWidth:Pos, Static1
		Gui StringWidth:Destroy
		return TW
		}
	GetImageSize(imageFilePath) {
	   if !hBitmap := LoadPicture(imageFilePath, "GDI+")
	      throw "Failed to load the image"
		   VarSetCapacity(BITMAP, size := 4*4 + A_PtrSize*2, 0)
		   DllCall("GetObject", "Ptr", hBitmap, "Int", size, "Ptr", &BITMAP)
		   DllCall("DeleteObject", "Ptr", hBitmap)
		   Return { W: NumGet(BITMAP, 4, "UInt"), H: NumGet(BITMAP, 8, "UInt") }
		}

	Default_switch_state(default_state=1, byref ishiddenon="ishiddenon", byref ishiddenoff="ishiddenoff", byref switch="", state_label=""){


		if (default_state = 1)
			{
				;MsgBox,,, % a_loopfield
				ishiddenon=
				ishiddenoff:=" hidden"
				switch=1
			} else if (default_state = 2)
			{
				;MsgBox,,, % a_loopfield
				ishiddenon:=" hidden"
				ishiddenoff=
				switch=2
			} else if (default_state = 3)
			{	
				if IsLabel(state_label)
				Gosub, %state_label%
			}
		}

	button_switch(var){
		msgbox,,, % var
		vari=%var%i
		GuiControl Hide, var%vari%
		vari := (3 - vari)
		GuiControl Show, var%vari%
		if (vari = 0){

				}
		if (vari = 1){ ;on
			
			}
		if (vari = 2){ ;off

			}
	}
;include functions
	;#include functions.ahk
	;
;gui
	IniRead, imagebase, %this_ini%, Images, imagebase ,

	IniRead, image_bg_, %this_ini%, Images, image_bg ,
	IniRead, image_on_, %this_ini%, Images, image_on ,
	IniRead, image_off_, %this_ini%, Images, image_off ,
	IniRead, image_close_, %this_ini%, Images, image_close ,
	IniRead, image_min_, %this_ini%, Images, image_min ,
	IniRead, sound_click_, %this_ini%, Audio, sound_click ,
	IniRead, audiobase, %this_ini%, Audio, audiobase ,
	

	control_bg=control_bg_black.png

	default_caption=
	IniRead, title_, %this_ini%, Images, image_title , %default_caption%

	if (title_ = default_caption){
		;MsgBox,,, ok
	} else {
	title=%imagebase%%title_%
	image_title_overlay=%imagebase%%image_title_overlay%
	title_size:=GetImageSize(title)
	title_size_width:=title_size.w
	title_size_height:=title_size.h

	}
	;IniRead, image_title_overlay, %this_ini%, Images, image_title_overlay , %title_%
	;	if(image_title_overlay = ""){
		;	MsgBox,,, % image_title_overlay
	;		image_title_overlay:=title_
		;	MsgBox,,, % image_title_overlay
	;	}



	image_bg=%imagebase%%image_bg_%
	

	image_on=%imagebase%%image_on_%
	image_on_size:=GetImageSize(image_on)
	image_on_size_width:=image_on_size.w
	image_on_size_height:=image_on_size.h
	switch_width_array.push(image_on_size_width)
	image_off=%imagebase%%image_off_%
	image_off_size:=GetImageSize(image_off)
	image_off_size_width:=image_off_size.w
	image_off_size_height:=image_off_size.h
	switch_width_array.push(image_off_size_width)

	image_min=%imagebase%%image_min_%
	image_close=%imagebase%%image_close_%
	image_control_bg=%imagebase%%control_bg%
	sound_click=%audiobase%%sound_click_%


	Default_Tcolomn=10
	;AUTOMATE THIS
	IniRead, Tcolomn , %this_ini%, controls, Tcolomn, %Default_Tcolomn%
		if (Tcolomn = ""){
			Tcolomn:=Default_Tcolomn
		}
	Default_Pcolomn=160
	IniRead, Pcolomn , %this_ini%, controls, Pcolomn, %Default_Pcolomn%
		if (Pcolomn = ""){
			Pcolomn:=Default_Pcolomn
		}
	Default_Zero_pixel:=0

	;font
		DEFAULT_titlefontsize=22

		IniRead, titlefontsize, %this_ini%, Font, titlefontsize , %DEFAULT_titlefontsize%
			if (titlefontsize = "") {
				titlefontsize:=DEFAULT_titlefontsize
			}
		Gui, font, s%titlefontsize%
		IniRead, Defualt_color, %this_ini%, Font, Defualt_color , White
			if(Defualt_color = ""){
				Defualt_color=White
			}
		IniRead, Shadow_color, %this_ini%, Font, Shadow_color ,	Black
			if(Shadow_color = ""){
				Shadow_color=Black
			}
		auto_title_Shadow_color=Black
		IniRead, title_Shadow_color, %this_ini%, Font, title_Shadow_color , %auto_title_Shadow_color%
			if(title_Shadow_color = ""){
				title_Shadow_color:=auto_title_Shadow_color
			}
		auto_title_Shadow_drop=0
		IniRead, title_Shadow_dropX, %this_ini%, Font, title_Shadow_dropX , %auto_title_Shadow_drop%
			if (title_Shadow_dropX = ""){
				title_Shadow_dropX:=auto_title_Shadow_drop
				}
		IniRead, title_Shadow_dropY, %this_ini%, Font, title_Shadow_dropY , %auto_title_Shadow_drop%
			if (title_Shadow_dropY = ""){
				title_Shadow_dropY:=auto_title_Shadow_drop
			}
		Gui, Font, c%Defualt_color%
	;titlebar
		Gui, -Caption +AlwaysOnTop
		IniRead, tX, %this_ini%, Title, title_image_X, %Default_Zero_pixel%
			if (tX = ""){
					tX:=(Default_Zero_pixel)
					}
		IniRead, tY, %this_ini%, Title, title_image_Y, %Default_Zero_pixel%
			if (tY = ""){
					tY:=(Default_Zero_pixel)
					} 
		IniRead, tLabel, %this_ini%, Title, titleLabel , UImove
			if (tLabel = ""){
					tLabel=UImove
					} 
		IniRead, tname, %this_ini%, Title, titleName , %A_ScriptName%
			if (tname = ""){
					tname:=A_ScriptName
					}
		auto_title_size:=StringWidth(tname,, titlefontsize)
		text_width_array.push_this(auto_title_size)


		auto_tnameX=10
		IniRead, tnameX, %this_ini%, Title, titleNameX , %auto_tnameX%
			if (tnameX = ""){
					tnameX:=auto_tnameX
					}
		auto_tnameY=3
		IniRead, tnameY, %this_ini%, Title, titleNameY , %auto_tnameY%
			if (tnameY = ""){
					tnameY:=auto_tnameY
					}
		;Gui, Add, Picture, x%tX% y%tY% g%tLabel%, %title%
		drop_title_X:=(tX-1)
		drop_title_Y:=(tY-1)
		;Gui, Add, Picture, x%drop_title_X% y%drop_title_Y% g%tLabel% +BackgroundTrans, %image_title_overlay% ; transparency with label to move
		;Gui, Add, Picture, x%tX% y%tY% g%tLabel% +BackgroundTrans, %title% ; bg title


		drop_tnameX:=(tnameX+title_Shadow_dropX)
		drop_tnameY:=(tnameY+title_Shadow_dropY)
		;Gui, Font, c%title_Shadow_color%
		;Gui, Add, Text, x%drop_tnameX% y%drop_tnameY% +BackgroundTrans, %tname%
		;Gui, Font, c%Defualt_color%
		;Gui, Add, Text, x%tnameX% y%tnameY% +BackgroundTrans, %tname%
	;background
		IniRead, bgX, %this_ini%, Images, bgX , %Default_Zero_pixel%
			if (bgX = ""){
				bgX:=Default_Zero_pixel
			}
		IniRead, bgY, %this_ini%, Images, bgY , %title_size_height%
			if (bgY = ""){
				bgY:=title_size_height
			}
		Gui, Add, Picture, x%bgX% y%bgY%, %image_bg% ;background
	;control

			auto_window_button_size:=title_size_height ;?
			auto_size_min:=GetImageSize(image_min)
			auto_size_min_width:=auto_size_min.w
			control_width_array.Push(auto_size_min_width)
			;auto_size_close:=GetImageSize(image_close)
			auto_size_close:=GetImageSize(image_close)
			auto_size_close_width:=auto_size_close.w
			control_width_array.Push(auto_size_close_width)
			

			IniRead, window_button_size, %this_ini%, controls, window_button_size %auto_size_min_width%
				if ( window_button_size = ""){
					window_button_size:=auto_size_min_width
				}
	Default_control_height:=image_on_size_height
			IniRead, control_height, %this_ini%, controls, control_height , %Default_control_height%
				if (control_height = ""){
					control_height = %Default_control_height%
				}


		default_switch_size:=16
		IniRead, switch_font_size, %this_ini%, Font, switch_font_size, %default_switch_size%
			if ( switch_font_size = ""){
					switch_font_size:=default_switch_size
				}
		Gui, font, s%switch_font_size%
;SWITCH LOADER
	IniRead, subcats, %switchesini%,
	;MsgBox ,,, % subcats
	switches:={}
	switch_count:=0
	loop parse, subcats, `n`r,
		{
			if (a_loopfield ~= "^switch-.+"){
				++switch_count
				;MsgBox,,, % switch_count
			{	;name
				this_name=%a_loopfield%_name
				IniRead, this_name , %switchesini%, %a_loopfield%, name
				switches.Push(this_name)
				switch_count:=switches.MaxIndex()
				;%this_name%auto_title_size=push_this_name
				push_this_name_lenght:=StringWidth(this_name,, titlefontsize)
				text_width_array.push(push_this_name_lenght)
				}
			{	;nX
				this_nx=%a_loopfield%_nX
				IniRead, this_nX , %switchesini%, %a_loopfield%, textX , %Tcolomn%
					if (this_nX = ""){	
							this_nX=%Tcolomn%
							}
				}
			{	;nY THIS ONE
				this_nY:=(switch_count * control_height)-control_height
				;MsgBox,,, % control_height

				}
			{	;sX
				this_sX=%a_loopfield%_sX			
				IniRead, this_sX , %switchesini%, %a_loopfield%, switchX, %Pcolomn%
					if (this_sX = "")
					this_sX = %Pcolomn%
				}
			{	;sY THIS ONE
				this_sY:=(switch_count * control_height)-control_height
				}
			{	;var
				this_var=%a_loopfield%_var
				this_new_var:=numbers_into_letters(switch_count)

				;msgbox,,, % this_var .  " " . this_new_var, % (1/7)
				IniRead, this_var , %switchesini%, %a_loopfield%, var
				;msgbox,,, % this_var, % (1/7)
				}
			{	;label
				this_label=%a_loopfield%_label
				IniRead, this_label , %switchesini%, %a_loopfield%, label
				}
			{	;state
				this_default_state=	%a_loopfield%_default_state
				IniRead, this_default_state , %switchesini%, %a_loopfield%, default_state
					if (this_default_state)
						{	
							;MsgBox,,, % this_default_state
							%this_var%i:=this_default_state
							}
					Default_switch_state(this_default_state,ishiddenon,ishiddenoff,this_state)
					if (this_default_state = 3)
			{		;if state is a label
							;MsgBox,,, % this_default_state
							%this_var%i:=2
							this_default_state_label=%a_loopfield%_default_state_label
							IniRead, this_default_state_label , %switchesini%, %a_loopfield%, default_state_label
							if IsLabel(this_default_state_label)
							{
								Gosub, %this_default_state_label%
								}
				}
				}
			
	;drop shadow
		Gui, Font, c%Shadow_color%
		drop_X:=(this_nX+1)
		drop_Y:=(this_nY+3)
		Gui, Add, Text, x%drop_X% y%drop_Y% +BackgroundTrans, %this_name%
		Gui, Font, c%Defualt_color%
		Gui, Add, Text, x%this_nX% y%this_nY% +BackgroundTrans, %this_name%

		Gui, Add, Picture,x%this_sX% y%this_sY% +BackgroundTrans v%this_var%1 g%this_label% %ishiddenon%, %image_on%
		Gui, Add, Picture,x%this_sX% y%this_sY% +BackgroundTrans v%this_var%2 g%this_label% %ishiddenoff%, %image_off%
			}
	}	;END SWITCH LOADER
;FINAL GUI BUILDER
	;total_control_width=0
	;for index,param in control_width_array{
	;	total_control_width:=param+total_control_width
	;	}

	max_text_width=0
	for index,param in text_width_array{
		if ( param > lastparam ){ 
			max_text_width:=param
		}
		total_text_width+=param
		lastparam:=param
		}
	for index,param in switch_width_array{
		if ( param > lastswitchparam ){ 
			max_text_width:=param
		}
		total_switch_width+=param
		lastswitchparam:=param
		}

	;	;min
	;		auto_minX:=(max_text_width+total_control_width+(control_height*3))
	;		IniRead, minX, %this_ini%, controls, minX , %auto_minX%
	;			if (minX = ""){
	;				minX=%auto_minX%
	;				}
	;				
	;		IniRead, minY, %this_ini%, controls, minY , %Default_Zero_pixel%
	;			if (minY = ""){
	;				minY=%Default_Zero_pixel%
	;				}
	;				
	;		IniRead, minLabel, %this_ini%, controls, minLabel , UImin
	;			if (minLabel = "" ){
	;				minLabel=UImin
	;				}
	;		
	;	;close
	;		auto_closeX:=(auto_minX+auto_size_close_width)
	;		IniRead, closeX, %this_ini%, controls, closeX, %auto_closeX%
	;			if (closeX = ""){
	;					closeX:=auto_closeX
	;					}
	;		;auto_closeY=10
	;		IniRead, closeY, %this_ini%, controls, closeY , %auto_closeY%
	;			if (closeY = ""){
	;					closeY=%Default_Zero_pixel%
	;					
	;				}
	;		IniRead, closeLabel, %this_ini%, controls, closeLabel , close
	;			if (closeLabel = ""){
	;				closeLabel=close 
	;				}

	auto_height:=switch_count * control_height
	auto_width:=(max_text_width+total_switch_width)
	
	IniRead, window_height, %this_ini%, controls, window_height , %auto_height%
		if (window_height = "")
			{
				window_height:=auto_height
				}
	IniRead, window_width, %this_ini%, controls, window_width , %auto_width%
		if (window_width = "")
			{
				window_width:=auto_width
				}


	if (window_width = auto_width) {
		minX:=(auto_width - total_control_width)
		closeX:=(minX+auto_size_min_width)
		
	}

	;Gui, Add, Picture, x%closeX% y%closeY% g%closeLabel% +BackgroundTrans, %image_control_bg%
	;Gui, Add, Picture, x%closeX% y%closeY% g%closeLabel% +BackgroundTrans, %image_close%
	;Gui, Add, Picture, x%minX% y%minY% g%minLabel% +BackgroundTrans, %image_control_bg%
	;Gui, Add, Picture, x%minX% y%minY% g%minLabel% +BackgroundTrans, %image_min%


	Menu, Tray, Add, Show Gui, hidegui
	Menu, Tray, ToggleCheck, Show Gui
	;Menu, Tray, Default, Show Gui 
	;Gui, Add, Button, , Hide Gui
Gui, Show, w%window_width% h%window_height%, %A_ScriptName%

return ;END OF AUTO_EXECUTE
;window control
	ButtonHideGui:
		Gui Cancel
		Return
	show: 
		Gui Show 
		Return
	UImove:
		PostMessage, 0xA1, 2,,, A
		return
	UImin:
		WinMinimize, A
		return
	close:
		GuiClose:
		Exitapp
		return
;include labels
	#include userlabel.ahk
	;
;variable dependent functions
	Sound_click(othersound_click="none"){
			if (othersound_click!="none"){
				SoundPlay, % othersound_click
			} else {
				global sound_click
				SoundPlay, % sound_click
			}
		}
;function labels
	hidegui:
		hidegui_toggle:=!hidegui_toggle
		if (hidegui_toggle = 0 ){
			Gui, Show
			Menu, Tray, ToggleCheck, Show Gui
		} else if (hidegui_toggle = 1 ){
			Gui, hide
			Menu, Tray, ToggleCheck, Show Gui
		}
	return
;hotkeys
	~F13 & Tab::
		Sound_click()
		sleep 250
		reload
		return

	~F13 & .::
		GoSub,  hidegui

		return



