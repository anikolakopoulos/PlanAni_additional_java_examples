# Copyright (c) 2003 University of Joensuu,
#                    Department of Computer Science

#{{{ Global variable gb
# GBI version
set gb(version)         0.55
# General speed of GBI
set gb(speed)           1600
set gb(mscale)          3
# Animation flash delay
set gb(flash_speed) 	100
# state os the execution
set gb(state) 			-1
# Object identifier counter.
set gb(object_id) 	    0
# Name of the picture list file
set gb(pic_list)		"piclist.txt"
set gb(pic_listPath)	[pwd]
set gb(hotspotFile)		"hotspots.txt"
set gb(hotspotFilePath)	[pwd]
# language settings 1 finnish and 2 english
set gb(language)		2		
# previus language
set gb(prev_language)   1		
# path settings 
set gb(path) 			[pwd]		
# path to picture
set gb(path_pic) 		[file join $gb(path) Pics]		
#path to needed libraries
set gb(path_lib)		[file join $gb(path)  GBI lib ] 
# Name of the picture list file
set gb(pic_list)		"piclist.txt"
# Path  to previous file
set gb(pic_listPath)	$gb(path)
# Name of the hotspot file
set gb(hotspotFile)		"hotspots.txt"
# Path  to previous file
set gb(hotspotFilePath)	$gb(path)

# name of the current animation procedure
set gb(example)			""
# Comaand bindings
set gb(resetCommand)  ""
set gb(stopCommand)	  ""
set gb(runCommand) 	  ""
set gb(stepCommand)   ""
set gb(languageCommand) ""
# RandomImput
set gb(randomInput)		0
#
set gb(exampleMenuList) ""
# Path to Examples root
set gb(exampleRoot)		[file join [pwd] Examples]
# used font.
set gb(gb_font) 		{times 10 bold} 
# font family settings
set gb(font_family)	    [lindex $gb(gb_font) 0] 
# font size settings
set gb(font_size)		[lindex $gb(gb_font) 1]		
# font style settings
set gb(font_style)	    [lindex $gb(gb_font) 2]	
# text color
set gb(color) 			black 
# background color
set gb(bg_color) 		white	
# Color for values of variables
set gb(help_color)	    #486ad7	
# other needed color
set gb(color_2)		    #a0a0c0	
# text mark color
set gb(mark_color) 	    "lightBlue" 
# entry indicator flag. if 0 then new entry has been entered.
set gb(syotetty) 		1  
# character for enter.
set gb(enter) 			\n 
# stores paths to source, variable and IO canvases.
set gb(areas) 			{}  
# value of entry field
set gb(entry_field) 	-1 
# output text
set gb(out_lines)		{}	
# initialize value for entry field
set gb(entry_value)		" " 
#
set gb(wait)			0
#
set gb(entry_txt)		NULL	
#path to main frame
set gb(f)				.main	
#path to source canvas
set gb(src)				.main.src	
#path to variable canvas
set gb(var)				.main.var	
# path to input/output canvas
set gb(io)				.main.io		
# path to control canvas
set gb(control)		    .main.control	
# path to entry window
set gb(ent) 			.main.io.ent	
	#part of the tag which uses more than one canvas.
set gb(multi)			multi

set gb(vars)			vars	
	# common part of path to all menu items.
set gb(menu)			.main.
# coordinates of entry box
set gb(ent_co)			{ 275 43 } 

set gb(input_pic)       input.gif
set gb(input2_pic)      inputpas.gif
set gb(output_pic)      output.gif
#}}}
#{{{ Global variable txt. For texts used in GBI
#
# initial language settings
#
set txt(title)						"PlanAni  - University of Joensuu, Finland. $gb(version)"
set txt(nif)						"Toimintoa ei viel‰ ole toteutettu."
set txt(speed_dialog_title) 		"Nopeuden s‰‰din"
set txt(speed_dialog_caption) 	    "Nopeus"
set txt(button_run) 				"Suorita"
set txt(button_stop) 				"Pys‰yt‰"
set txt(button_reset) 				"Alkuun"
set txt(button_step) 				"Askella"
set txt(button_speed) 				"Nopeus"

set txt(menu_file) 					"Tiedosto"
set txt(menu_file_example)			"Esimerkit"
set txt(menu_file_exit) 			"Lopeta"
			
set txt(menu_settings) 				"Asetukset"
set txt(menu_settings_player) 		"Soitin"
set txt(menu_settings_speed)		"Nopeus"
set txt(menu_settings_language) 	"Kieli"
set txt(menu_settings_language_1) 	"Englanti"
set txt(menu_settings_language_2) 	"Suomi"
set txt(menu_help)					"Ohje"
set txt(menu_help_about)			"Tietoa ohjelmasta"
set txt(authors)					"Tekij‰t"
set txt(version)					"Versio"
set txt(menu_settings_font)			"Kirjasin"

set txt(menu_settings_font_normal) 	"Normaali"
set txt(menu_settings_font_bold)	"Lihavoitu"
set txt(menu_controls)				"Ohjaus"
set txt(help_title)					"Planani $gb(version) - Ohje"			
#}}}
#{{{ Function: gb_init 
#{{{*************************************************************
#	
#	Function: gb_init   	
#	References:	
#	Description: Create and initialize GUI.
#	Call: gb_init { args }
#	Input parameters:  args : cavas sizes.  example: {src 100 100} {var 200 100}
#	Output parameters: None  
#	Return value: None
#	Examble:  gb_init
#	Fuctionality: 	 Creates all necessarely components, bind all functions and loads all librarys.
#	Limits: 
#   Side effects:
#	See also:  
#	History:	13.10.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_init { args } {
		
	global gb txt
	
	#load libraries
	
	foreach component [glob $gb(path_lib)/*.tcl] {
   
    	source $component 
	}
	
	#set default sizes
	set sizes(src) { 380 600 }
	#set sizes(var) { 305 270 }
	set sizes(var) { 1 1 }
	set sizes(io) { 250 150 }
	
	#Handle args 
	
	if { ([llength $args] == 1) } {
				frame $gb(f) -width [lindex [lindex $args 0] 1 ] \
						-height  [lindex [lindex $args 0] 1]		
	}
	#844x489
	#wm  maxsize . 844 489
	wm title . $txt(title)
	wm protocol . WM_DELETE_WINDOW "gb_exit"
		
	#bindings 
	pack $gb(f) -fill both -expand true

	bind . <Control-Key-x> { deliverBindigs  %W gb_exit }
	#bind . <Control-Key-a> { deliverBindigs %W about_window }
	#bind . <Control-Key-r> { deliverBindigs %W run }
	#bind . <Control-Key-s> { deliverBindigs %W puts "step"}
	#bind . <Control-Key-t> { deliverBindigs %W stop }	
	#bind . <Control-Key-e> { deliverBindigs %w Puts "reset" }
	#bind . <Control-Key-v> { deliverBindigs %w gb_set_animation_speed }
	bind . <r> {deliverBindigs %W eval $gb(runCommand)}
	bind . <s> {deliverBindigs %W eval $gb(stopCommand)}
	bind . <p> {deliverBindigs %W eval $gb(stopCommand)}
	bind . <t> {deliverBindigs %W eval $gb(stepCommand)}
	bind . <a> {deliverBindigs %W eval $gb(stepCommand)}
	bind . <e> {deliverBindigs %W eval $gb(resetCommand)}
	bind . <l> {deliverBindigs %W eval $gb(resetCommand)}
	bind . <h> {deliverBindigs %W help_window}
	bind . <o> {deliverBindigs %W help_window}
	bind . <n> {deliverBindigs %W gb_set_animation_speed}
	bind . <Configure> {gb_update}
	bind . <Key-plus> {deliverBindigs %W eval get_scale_value [expr $gb(mscale) +1 ]}
	bind . <Key-minus> {deliverBindigs %W eval get_scale_value [expr $gb(mscale) - 1]}
	#menu
	frame 	$gb(f).mbar 		-relief sunken
	set gb(mbar) $gb(f).mbar

	#File menu
	menubutton 	$gb(mbar).file 	-text $txt(menu_file) \
					-underline 0 \
					-menu $gb(mbar).file.menu
	set menu $gb(mbar).file.menu 	
	menu 		$menu
	$menu add cascade 	-label juu \
						-menu $menu.ali
	set ali [menu $menu.ali]
	
	setNamesForExampleMenu
	foreach elem $gb(exampleMenuList) {
		switch -- 	[llength $elem] {
		 	"1" { 
				set lang [string tolower [lindex $elem 0]]
					$menu.ali add cascade 	-label [lindex $elem 0] \
						-menu $ali.$lang
					menu $ali.$lang
			}
			"2" {
				set lang [string tolower [lindex $elem 0]]
				set progLang [string tolower [lindex $elem 1]]
				$menu.ali.$lang add cascade -label [lindex $elem 1] \
						-menu $ali.$lang.$progLang
					menu $ali.$lang.$progLang
			}
			"4" {
				set lang [string tolower [lindex $elem 0]]
				set progLang [string tolower [lindex $elem 1]]
				set ex [string tolower [lindex $elem 2]]
				set number [lindex $elem 3]
				$menu.ali.$lang.$progLang add radio -label [file rootname [lindex $elem 2]] \
								-variable gb(example) -value $number -command \
								{eval $gb(resetCommand)}

			}
		 }
	} 	
	#foreach  ex $gb(exampleNames) {	
	#	$ali add radio	-label "$ex" \
	#				-variable gb(example) -value $ex 
	#}
    #    set gb(example) [lindex $gb(exampleNames) 0]
	#$ali add separator
	$menu add command -label "$txt(menu_file_exit) C-c"\
					-command "gb_exit"
	
		
	pack 	$gb(mbar).file -side left

	#Settings menu
	menubutton 	$gb(mbar).settings 	-text $txt(menu_settings) \
						-underline 0 \
						-menu $gb(mbar).settings.menu 
	set menu1 $gb(mbar).settings.menu 
	menu 		$menu1
	
	$menu1 add cascade 	-label $txt(menu_settings_font) \
						-menu $menu1.ali1
	set ali1 [menu $menu1.ali1]	
		set allfonts {times abobe Helvetica}
		foreach family $allfonts {
		
		$ali1 add radio	-label $family \
				-variable gb(font_family) -value $family -command "update_font"	
		}
	$ali1 add separator
		for {set i 6} {$i < 19} {incr i} {
			$ali1 add radio	-label $i \
				-variable gb(font_size) -value $i -command "update_font"
		}								
	$ali1 add separator
		$ali1 add radio	-label $txt(menu_settings_font_normal) \
					-variable gb(font_style) -value normal -command "update_font"
		$ali1 add radio	-label $txt(menu_settings_font_bold) \
					-variable gb(font_style) -value bold -command "update_font"	
							
	
	$menu1 add cascade 	-label $txt(menu_settings_language) \
						-menu $menu1.ali2
	set ali2 [menu $menu1.ali2]
	$ali2 add radio 	-label  $txt(menu_settings_language_1) \
						-variable gb(language) -value 2 -command \
						"eval $gb(languageCommand)"
	$ali2 add radio 	-label  $txt(menu_settings_language_2)\
						-variable gb(language) -value 1	-command \
						"eval $gb(languageCommand)"
						
	$menu1 add command 	-label $txt(menu_settings_player) \
						-command "not_in_function"
	$menu1 add command 	-label "$txt(menu_settings_speed) +/-"\
						-command "gb_set_animation_speed"
	
	pack 	$gb(mbar).settings -side left
	
	
	#controls menu
	
	menubutton 	$gb(mbar).controls 	-text $txt(menu_controls) \
						-underline 0 \
						-menu $gb(mbar).controls.menu 
	set menu2 $gb(mbar).controls.menu 
	menu 		$menu2	
	$menu2 add command 	-label  "$txt(button_run)" \
						-command "eval $gb(runCommand)"
	$menu2 add command 	-label  "$txt(button_stop)" \
						-command "eval $gb(stopCommand)"	
	$menu2 add command 	-label  "$txt(button_step)" \
						-command "eval $gb(stepCommand)"
	$menu2 add command 	-label  "$txt(button_reset)"\
						-command "eval $gb(resetCommand)"					
	
	pack $gb(mbar).controls -side left
	
	menubutton      $gb(mbar).help -text $txt(menu_help) \
                                -underline 0 \
										  -menu $gb(mbar).help.menu
	set help $gb(mbar).help.menu
	menu  $help
	$help add command -label $txt(menu_help_about) \
						-command "about_window" 
	$help add command -label $txt(menu_help) \
						-command "help_window" 
	pack            $gb(mbar).help -side right 
							
	pack 	$gb(mbar) -side top -fill x

	
	
	#Canvas for source code

	set tmp [scrolled_canvas $gb(src) left bottom\
					 	-width [lindex $sizes(src) 0] \
						-height [lindex $sizes(src) 1] \
						-scrollregion {0 0 1000 1000} ] 
	pack 	$gb(src) -side left -fill y -expand false 
	$tmp configure -background white
	set gb(src) $tmp
	
	#Canvas for varibles
	set tmp [scrolled_canvas $gb(var) right top \
						-width [lindex $sizes(var) 0] \
						-height [lindex $sizes(var) 1]\
						-scrollregion {0 0 1000 2700} ]
	pack $gb(var) 	-side top -expand true -fill both 
	$tmp configure -background white
	set gb(var) $tmp
		
	
	#Canvas for input / output 
	canvas 	$gb(io) -background white -width 250 -height 120 	
	entry 	$gb(ent) 	-textvariable value
	set gb(co) [$gb(io) create window 275 45 -window $gb(ent) \
					-width 30 \
					-tag syo]
	
	set $gb(ent_co) [$gb(io) bbox $gb(co)] 				
	$gb(ent) configure 	-relief flat \
					-background $gb(bg_color) \
					-borderwidth 0 \
					-highlightthickness 0 \
					-width 3 \
					-font $gb(gb_font) \
					-fg $gb(color) \
					-textvariable gb(entry_value) \
					-justify center
	#kursorin vilkuntatiheys 500 millisekuntia
	$gb(ent) configure 	-insertofftime 500
	#asetetaan syˆttˆkentt‰ tyhj‰ksi 
	
	#
	bind $gb(ent) <Return> "set syotetty 1"
	set entry_field $gb(f).siirranta.syo
	
	#Control buttons
	canvas 	$gb(control) 		-width [lindex $sizes(io) 0] -height [lindex $sizes(var) 1]
	button 	$gb(control).stop 	-text "$txt(button_stop)" -command \
													"eval $gb(stopCommand)" -state disabled
	button 	$gb(control).speed 	-text "$txt(button_speed)" -command gb_set_animation_speed		
	button 	$gb(control).reset 	-text "$txt(button_reset)" -command \
														"eval $gb(resetCommand)" -state disabled
	button 	$gb(control).step 	-text "$txt(button_step)" -command \
													"eval $gb(stepCommand)" -state normal
	button 	$gb(control).run 	-text "$txt(button_run)" -command "eval $gb(runCommand)"  
	pack 	$gb(control) -side bottom -fill x -expand false
	pack	$gb(io) -side bottom -fill x -expand false

	grid $gb(control).run 	-row 1 -column 1 -padx 4 -pady 10
	grid $gb(control).step        -row 1 -column 3 -padx 4 -pady 10
	grid $gb(control).reset         -row 1 -column 4 -padx 4 -pady 10
	grid $gb(control).stop           -row 1 -column 2 -padx 4 -pady 10
	grid $gb(control).speed 	-row 1 -column 5 -padx 4 -pady 10	
	 	
	
	set gb(areas)			"$gb(src) $gb(var) $gb(io)"
	
	#output picture
	
	set gb(output_id) [gb_pic_create "io" 5 20  $gb(output_pic) ]
	set gb(input_id)	[gb_pic_create "io" 225 45  $gb(input2_pic)]
	$gb(io) raise $gb(input_id)
	
	gb_change_language 

	update idletasks
	
}
#}}}
#{{{ Function: listResources
proc listResources { w } {
    set retval {}
    set head [tk appname]$w
    foreach tuple [$w configure] {
        if { [llength $tuple] == 5 } {
            lappend retval $head.[lindex $tuple 1]
        }
    } return $retval
}
#}}}
#{{{ Function: gb_wait
#{{{*************************************************************
#	
#	Function: gb_wait	
#	References:	
#	Description: Waits given time.
#	Call: gb_wait { {tim -1} }
#	Input parameters: tim : time to wait in seconds 
#	Output parameters:  None 
#	Return value:None
#	Examble:  gb_wait
#	Fuctionality: 	waits given time or if no parameters passed the waits $gb(speed)
#						milliseconds. 
#	Limits: None
#   Side effects:
#	See also:  tk / after
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}


proc gb_wait { {tim -1} } {
	global gb
	if { $tim < 0 } {
		after $gb(speed)
	} else {
		after [expr $tim * 1000]
	}
	update
}
#}}}
#{{{ Function: gb_exit
#{{{*************************************************************
#	
#	Function: 	gb_exit
#	References:	
#	Description:  Destroy main frame and end execution.
#	Call: gb_exit { } 
#	Input parameters: None
#	Output parameters:  None
#	Return value: None
#	Examble: gb_exit 
#	Fuctionality: 	Destroy main frame and exit 
#	Limits: None
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_exit { } {
	destroy .
	exit
}
#}}}
#{{{ Function: gb_change_language
#{{{*************************************************************
#	
#	Function: gb_change_language	
#	References:	
#	Description: Changes GUI language
#	Call: gb_change_language { {lang 1}}
#	Input parameters: lang : identifier of language (1 english, 2 finnish)
#	Output parameters:None   
#	Return value:None
#	Examble: gb_change_language 2 
#	Fuctionality: modifies GUI components text attribute. 	
#	Limits: None
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}


proc gb_change_language { {lang -1} } {
global txt gb
	if { $lang > 0} {
		set gb(language) $lang
	}
	if { $gb(language) == 1 } {
		set txt(help_title)					"Planani $gb(version) - Ohje"	
			set txt(nif)						"Toimintoa ei viel‰ ole toteutettu."
			set txt(speed_dialog_title) 		"Nopeuden s‰‰din"
			set txt(speed_dialog_caption) 		"Nopeus"
			set txt(button_run) 				"Suorita"
			set txt(button_stop) 				"Pys‰yt‰"
			set txt(button_reset) 				"Alkuun"
			set txt(button_step) 				"Askella"
			set txt(button_speed) 				"Nopeus"

			set txt(menu_file) 					"Tiedosto"
			set txt(menu_file_example)			"Esimerkit"
			set txt(menu_file_exit) 			"Lopeta"
			
			set txt(menu_settings) 				"Asetukset"
			set txt(menu_settings_player) 		"Soitin"
			set txt(menu_settings_speed)		"Nopeus"
			set txt(menu_settings_language) 	"Kieli"
			set txt(menu_settings_language_1) 	"Englanti"
			set txt(menu_settings_language_2) 	"Suomi"
			set txt(menu_help)					"Ohje"
			set txt(menu_help_about)			"Tietoa ohjelmasta"
			set txt(authors)					"Tekij‰t"
			set txt(version)					"Versio"
			set txt(menu_settings_font)			"Kirjasin"
			
			set txt(menu_settings_font_normal) 	"Normaali"
			set txt(menu_settings_font_bold)	"Lihavoitu"
			set txt(menu_controls)				"Ohjaus"
			set $gb(language) 2
			set $gb(prev_language) 1
		} else {
			set txt(help_title)					"Planani $gb(version) - Help"
			set txt(nif)						"Feature is not implemented."
			set txt(speed_dialog_title) 		"Speed control"
			set txt(speed_dialog_caption) 		"Speed"
			set txt(button_run) 				"Run"
			set txt(button_stop) 				"Stop"
			set txt(button_reset) 				"Reset"
			set txt(button_step) 				"Step"
			set txt(button_speed) 				"Speed"

			set txt(menu_file) 					"File"
			set txt(menu_file_example)			"Examples"
			set txt(menu_file_exit) 			"Exit"

			set txt(menu_settings) 				"Settings"
			set txt(menu_settings_player) 		"Player"
			set txt(menu_settings_speed)		"Speed"
			set txt(menu_settings_language) 	"Language"
			set txt(menu_settings_language_1) 	"English"
			set txt(menu_settings_language_2) 	"Finnish"
			set txt(menu_help)					"Help"
			set txt(menu_help_about)			"About"
			set txt(authors)					"Authors"
			set txt(version)					"Version"
			set txt(menu_settings_font)			"Font"
			
			set txt(menu_settings_font_normal) 	"Normal"
			set txt(menu_settings_font_bold)	"Bold"
			set txt(menu_controls)				"Controls"
			set $gb(language) 1
			set $gb(prev_language) 2

	}
	if { $gb(language) == 1 } { set r 3; set s 0; set t 0; set e 1; set d 0}
	if { $gb(language) == 2 } { set r 0; set s 0; set t 1; set e 1;set d 4 }
		$gb(control).run configure -text $txt(button_run) -underline $r
		$gb(control).stop configure -text $txt(button_stop) -underline $s
		$gb(control).step configure -text $txt(button_step) -underline $t
		$gb(control).reset configure -text $txt(button_reset) -underline $e
		$gb(control).speed configure -text $txt(button_speed) -underline $d 
		
		$gb(mbar).file configure -text $txt(menu_file)
			$gb(mbar).file.menu entryconfigure 1 -label $txt(menu_file_example) 		
			$gb(mbar).file.menu entryconfigure 2 -label $txt(menu_file_exit)
		
		$gb(mbar).settings configure -text $txt(menu_settings)
			$gb(mbar).settings.menu entryconfigure 1 -label $txt(menu_settings_font)
			$gb(mbar).settings.menu entryconfigure 2 -label $txt(menu_settings_language)
			$gb(mbar).settings.menu entryconfigure 3 -label $txt(menu_settings_player)	
			$gb(mbar).settings.menu entryconfigure 4 -label "$txt(menu_settings_speed) +/-"
				$gb(mbar).settings.menu.ali1 entryconfigure 19 -label $txt(menu_settings_font_normal) 	
				$gb(mbar).settings.menu.ali1 entryconfigure 20 -label $txt(menu_settings_font_bold)
			#$gb(mbar).settings.menu.ali1 entryconfigure 2 -label $txt(menu_settings_font_type)
			
			$gb(mbar).settings.menu.ali2 entryconfigure 1 -label $txt(menu_settings_language_1) 	
			$gb(mbar).settings.menu.ali2 entryconfigure 2 -label $txt(menu_settings_language_2)
			 			
		$gb(mbar).help configure -text $txt(menu_help)
			$gb(mbar).help.menu entryconfigure 1 -label $txt(menu_help_about)
			$gb(mbar).help.menu entryconfigure 2 -label $txt(menu_help)
		$gb(mbar).controls configure -text $txt(menu_controls)
			$gb(mbar).controls.menu entryconfigure 1 -label $txt(button_run)
			$gb(mbar).controls.menu entryconfigure 2 -label $txt(button_stop)	
			$gb(mbar).controls.menu entryconfigure 3 -label $txt(button_reset)
			$gb(mbar).controls.menu entryconfigure 4 -label $txt(button_step)
			
	update
	
}
#}}}
#{{{ Function: gb_switch_TEMP
#{{{*************************************************************
#	
#	Function: 	gb_switch_TEMP 
#	References:	
#	Description: 
#	Call: gb_switch_TEMP { tag {state 1}}
#	Input parameters: tag : object identifier
#							state : picture selector.
#	Output parameters: None.  
#	Return value: None.
#	Examble:  gb_switch_TEMP $tag 
#	Fuctionality: Loads new picture and changes it to variable identi
#						fied by tag.	
#	Limits: None
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_switch_TEMP { varId {state 1}} {
	global gb
    if { $state == 1 } {
        set pic_name [lindex [load_pic "TEMP_ON" OUT] 0 ]
    } else {
        set pic_name [lindex [load_pic "TEMP" OUT] 0 ]
    }
	set pic [file join $gb(path_pic) $pic_name]
	set im [image create photo $pic_name -file $pic]
	$gb(var) itemconfigure [gb_var_get_picture $varId] -image $im
	$gb(var) lower $im
	update

}
#}}}
#{{{ Function: gb_compare 
#{{{*************************************************************
#	
#	Function: gb_compare	
#	References:	
#	Description: Animate comapison for variables.
#	Call: gb_compare { tagi sign limit value head {role MRH}}
#	Input parameters: tagi: object identifier 
#							sign:	result of comparison (>,<, =)
#							limit: border on value to compare
#							value: value to compare							
#						 	head: value where arrow must point
#							role: role of the variable.
#	Output parameters:  None 
#	Return value:none
#	Examble:  
#	Fuctionality: calls needed function.	
#	Limits: None.
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}


proc gb_compare { tagi sign limit value head {role MRH}} {
	
	# T‰h‰n laitetaan roolien eri erinlaiset vertailut ja p‰‰tet‰‰n mihin menn‰‰n
	switch -- $role {
		"MRH" {gb_compare_MRH $tagi $sign $limit $value $head }
		default {gb_compare_MRH $tagi $sign $limit $value $head }
	}
	
}
#}}}
#{{{ Function: gb_compare_STEP
#{{{*************************************************************
#	
#	Function: gb_compare_STEP 	
#	References:	
#	Description: 
#	Call: gb_compare_STEP { tag color args} 
#	Input parameters: tag: Object identifier
#							color: Used color
#							args: indexes  of the compared elements
#	Output parameters: None
#	Return value: None
#	Examble:  gb_compare_STEP $tag blue args 
#	Fuctionality: Animate compared functions	
#	Limits: None
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_compare_STEP { varId lim} {
	global gb
	
	set colorYes green
    set colorNo red
	# even or odd values
    if {[ string equal -nocase odd $lim]} {
        set lim "\[expr fmod(@,2)\]"
    } 
    if {[ string equal -nocase even $lim]} {
        set lim "!\[expr fmod(@,2)\]"
    } 
	for {set i 3} {$i < 9 } {incr i} {
        set id [ $gb(var) find withtag "$varId 0 $i 1"]
        set value [lindex [$gb(var) itemconfig $id -text] end]
        set place [string first "@" $lim ]	
        set replaced [string replace $lim $place $place $value]
        set eva { if {$replaced} {
	                set ret 1
                    } else {
	                set ret 0
                    }
                }
        eval [subst $eva]
        if {$ret == 1} {
            $gb(var) itemconfig $id -fill $colorYes
        } else {
           $gb(var) itemconfig $id -fill $colorNo 
        }
    }   
    set id [ $gb(var) find withtag "$varId 0 1 1"]
    set value [lindex [$gb(var) itemconfig $id -text] end]
    set place [string first "@" $lim ]	
    set replaced [string replace $lim $place $place $value]
    set eva { if {$replaced} {
               set ret 1
               } else {
               set ret 0
               }
           }
    eval [subst $eva]
    if {$ret == 1} {
        set retu $ret
       $gb(var) itemconfig $id -fill $colorYes
    } else {
        set retu 0
      $gb(var) itemconfig $id -fill $colorNo 
    }

	update
   return $retu 
	
}
#}}}
#{{{ Function: gb_clear_STEP
#{{{*************************************************************
#	
#	Function: 	gb_clear_STEP
#	References:	
#	Description: Clears stepper.
#	Call: gb_clear_STEP { tag }
#	Input parameters: varId : object identifier.
#	Output parameters:   None
#	Return value: None
#	Examble:  gb_clear_STEP $varId
#	Fuctionality:change initial color to value. 	
#	Limits: 
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}


proc gb_clear_STEP { varId } {
	global gb
    set gb(font) {$gb(font_family) $gb(font_size) $gb(font_style)}
	$gb(var) itemconfig "$varId Values" -fill $gb(color_2)
	$gb(var) itemconfig "$varId 0 1 1" -fill $gb(color)
	$gb(var) itemconfig "$varId Values" -font $gb(gb_font)
	set gb(font) {$gb(font_family) $gb(font_size) $gb(font_style)} 
	update

}
#}}}
#{{{ Function: gb_compare_MRH
#{{{*************************************************************
#	
#	Function: gb_compare_MRH	
#	References:	
#	Description: AnimateMRH comparison
#	Call: gb_compare_MRH { tagi sign limit value head }
#	Input parameters: tagi: Object identifier
#							sign: Result of the comparation
#							limit: Border between true and false values
#							value: firts true value
#							head: Position of array
#	Output parameters:  None 
#	Return value: Identifyer to coparations objects.
#	Examble: gb_compare_MRH  $tag ">" 5 4 2
#	Fuctionality: 	Creates value table and paint area of true values green and rest red.
#	Limits: None
#   Side effects: None
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_compare_MRH { tagi sign limit value head } {
	global gb
	set tag [get_next_objectid]
	set var_co [gb_get_borders $tagi]
	set x [expr ([lindex $var_co 2] - [ lindex $var_co 0] + 50) + [lindex $var_co 0]]
	set y [expr (([lindex $var_co 3] - [ lindex $var_co 1]) / 2) + [lindex $var_co 1]]
	set result 1
	set test { if {$value $sign $limit} {
						 set result true
					}	else {
						 set result false
					}
    }

    eval [subst $test]
	if { $sign == ">" || $sign == ">="} {
		set up_color red
		set down_color green
	} else {
		set up_color green
		set down_color red
	}	
	set dist 20
	$gb(var) create text [expr $x + $dist] [expr $y -10 ] -text $limit  -anchor c -fill black -tags $tag
	$gb(var) create text [expr $x + $dist] [expr $y -25 ] -text "." -anchor c -fill black -tags $tag
	$gb(var) create text [expr $x + $dist] [expr $y -35 ] -text "." -anchor c -fill black -tags $tag
	$gb(var) create text [expr $x + $dist] [expr $y -45 ] -text "." -anchor c -fill black -tags $tag
											
	$gb(var) create text [expr $x + $dist] [expr $y +10 ] -text [expr $limit -1]  -anchor c -fill black -tags $tag
	$gb(var) create text [expr $x + $dist] [expr $y +25 ] -text "." -anchor c -fill black -tags $tag
	$gb(var) create text [expr $x + $dist] [expr $y +35 ] -text "." -anchor c -fill black -tags $tag
	$gb(var) create text [expr $x + $dist] [expr $y +45 ] -text "." -anchor c -fill black -tags $tag
	set rec_co [gb_get_borders $tag]
	set rec_c [expr (([lindex $rec_co 3] - [lindex $rec_co 1]) / 2) + [lindex $rec_co 1]]
	set wi 10
	$gb(var) create rec [expr [lindex $rec_co 0] - $wi ] [lindex $rec_co 1] \
										[expr [lindex $rec_co 2] + $wi] $rec_c \
												-fill $up_color\
												-width 0\
												-outline white -tags "rec$tag"
	$gb(var) create rec  [expr [lindex $rec_co 0] - $wi ] $rec_c \
								[expr [lindex $rec_co 2] + $wi ] [lindex $rec_co 3] \
												-fill $down_color\
												-width 0\
												-outline white -tags "rec$tag"	
	$gb(var) raise "$tag"
	set sca [expr $head * 10]
	update
	after $gb(speed)
	update
	set com_arr [gb_arrow_create var [expr $x - 50] $y var [expr [lindex [gb_get_borders rec$tag ] 0] -5] [expr $rec_c - $sca] 3]
	if { $head > 0 } {
		set arr_color $up_color
	} else {
		set arr_color $down_color
	} 
	$gb(var) itemconfigure $com_arr -fill $arr_color 
	update
	after  $gb(speed)
	update
	addtag $tag $com_arr 
	addtag $tag "rec$tag" 
	
	return $tag
}
#}}}
#{{{ Function: gb_compare2_MRH
#{{{*************************************************************
#	
#	Function: gb_compare2_MRH
#	References: 	
#	Description: Compare role MRH if two edges is needed (6 > x <3) 
#	Call: gb_compare2_MRH {tag up_limit down_limit head color}
#	Input parameters: tag: Object identifier
#							up_limit: Upper limit border
#							down_limit: bottom limit border
#							head: Position of array
#							color: color of array
#	Output parameters:  None 
#	Return value: Identifier to created objects
#	Examble: gb_compare2_MRH  $tag 4 1 0 1 
#	Fuctionality: 	
#	Limits: 
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_compare2_MRH {tag up_limit down_limit head color} {
	global gb
	set var_co [gb_get_borders $tag]
	set x [expr ([lindex $var_co 2] - [ lindex $var_co 0] + 50) + [lindex $var_co 0]]
	set y [expr (([lindex $var_co 3] - [ lindex $var_co 1]) / 2) + [lindex $var_co 1]]
	
	if { $color } {
		set edge_color green
		set middle_color red
	} else {
		set edge_color red
		set middle_color green 
	} 
	set wi 10
	set dist 20
	set tagi compare$tag
    if { $up_limit == $down_limit} {
        set up [expr $up_limit +1]
        set down [expr $down_limit -1]
        set middle1 $up_limit
    } else {
        set up $up_limit
        set down $down_limit
        set middle1 [expr $up_limit -1]
        set middle2 [expr $down_limit +1]
	}
	$gb(var) create text [expr $x + $dist] [expr $y -55 ] -text "." -anchor c -fill black -tags up$tagi
	$gb(var) create text [expr $x + $dist] [expr $y -50 ] -text "." -anchor c -fill black -tags up$tagi
	$gb(var) create text [expr $x + $dist] [expr $y -45 ] -text "." -anchor c -fill black -tags up$tagi
	$gb(var) create text [expr $x + $dist] [expr $y -30 ] -text $up  -anchor c -fill black -tags up$tagi
    if { $up_limit == $down_limit} {
        $gb(var) create text [expr $x + $dist] [expr $y -10 ] -text " "  -anchor c -fill black -tags mid$tagi
	    $gb(var) create text [expr $x + $dist] [expr $y -5 ] -text " " -anchor c -fill black -tags mid$tagi
	    $gb(var) create text [expr $x + $dist] $y  -text $middle1 -anchor c -fill black -tags mid$tagi
	    $gb(var) create text [expr $x + $dist] [expr $y +5 ] -text " " -anchor c -fill black -tags mid$tagi
	    $gb(var) create text [expr $x + $dist] [expr $y +17 ] -text " "  -anchor c -fill black -tags mid$tagi
    } else {
	    $gb(var) create text [expr $x + $dist] [expr $y -10 ] -text $middle1  -anchor c -fill black -tags mid$tagi
	    $gb(var) create text [expr $x + $dist] [expr $y -5 ] -text "." -anchor c -fill black -tags mid$tagi
	    $gb(var) create text [expr $x + $dist] $y  -text "." -anchor c -fill black -tags mid$tagi
	    $gb(var) create text [expr $x + $dist] [expr $y +5 ] -text "." -anchor c -fill black -tags mid$tagi
	    $gb(var) create text [expr $x + $dist] [expr $y +17 ] -text $middle2  -anchor c -fill black -tags mid$tagi
	}
	$gb(var) create text [expr $x + $dist] [expr $y +35 ] -text $down  -anchor c -fill black -tags do$tagi	
	$gb(var) create text [expr $x + $dist] [expr $y +42 ] -text "." -anchor c -fill black -tags do$tagi
	$gb(var) create text [expr $x + $dist] [expr $y +47 ] -text "." -anchor c -fill black -tags do$tagi
	$gb(var) create text [expr $x + $dist] [expr $y +52 ] -text "." -anchor c -fill black -tags do$tagi
	
	set wi 10
	set dist 20
	set rec_co [gb_get_borders up$tagi]
	set left [expr [lindex $rec_co 0]-$wi]
	set rigth  [expr [lindex $rec_co 2]+$wi]
 		
	#yl‰kerta
	$gb(var) create rec $left  [lindex $rec_co 1] \
				$rigth [expr [lindex $rec_co 3] +3]   \
				-fill $edge_color\
				-width 0\
				-outline white -tags "rec$tag"
	#keskusta
	set rec_co [gb_get_borders mid$tagi]											
	$gb(var) create rec $left  [expr [lindex $rec_co 1]-3] \
				$rigth [expr [lindex $rec_co 3] +2]   \
				-fill $middle_color\
				-width 0\
				-outline white -tags "rec$tag"
														
	#alakerta
	set rec_co [gb_get_borders do$tagi]											
	$gb(var) create rec $left  [expr [lindex $rec_co 1]-2] \
				$rigth [expr [lindex $rec_co 3] +7]  \
				-fill $edge_color\
				-width 0\
				-outline white -tags "rec$tag"
														
	if { $head > -3 && $head < 3 } {
		set arr_color $middle_color
		switch -- $head {
			"2" {set arr_y [expr $y - 10]}
			"1" {set arr_y [expr $y - 5]}
			"0" {set arr_y $y}
			"-1" {set arr_y [expr $y + 5]}
			"-2" {set arr_y [expr $y + 15]}			
		}
	} else {
		set arr_color $edge_color
		switch -- $head {
			"6" {set arr_y [expr $y - 55]}
			"5" {set arr_y [expr $y - 50]}
			"4" {set arr_y [expr $y - 45]}
			"3" {set arr_y [expr $y - 30]}
			"-3" {set arr_y [expr $y + 30]}
			"-4" {set arr_y [expr $y + 40]}
			"-5" {set arr_y [expr $y + 50]}
			"-6" {set arr_y [expr $y + 55]}
		}
	}
    
	$gb(var) raise "do$tagi"
	$gb(var) raise "up$tagi"
	$gb(var) raise "mid$tagi"
	update
	after $gb(speed)
	update
	set com_arr [gb_arrow_create var [expr $x - 50] $y var [expr $left- 5] $arr_y 3]
	$gb(var) itemconfigure $com_arr -fill $arr_color 
	update
	after  $gb(speed)
	addtag $tagi $com_arr 
	addtag $tagi "rec$tag"
	addtag $tagi up$tagi
	addtag $tagi mid$tagi
	addtag $tagi do$tagi
	return $tagi
}
#}}}
#{{{ Function: gb_switch_OWF
#{{{*************************************************************
#	
#	Function:  gb_switch_OWF 	
#	References:	
#	Description: Changes state of variable OWF
#	Call:  gb_switch_OWF {tag {state 0} }
#	Input parameters: tag:  Object identifier
#							state: state of object 0|1|2|3|4.
#									0: Init state. Lamp is slictly visible
#									1: Turns Lamp on.
#									2: Turn off animation. After this lamp is broken.
#									3: Turn on animation.
#									4: Broken lamp with false label
#	Output parameters:  None 
#	Return value: None
#	Examble:  gb_switch_OWF  $tag 1
#	Fuctionality: Changes picture of variable OWF
#	Limits: 
#   Side effects:None
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_switch_OWF {varId {state 0} } {
	global gb
	switch -- $state {
	"0" {
			set pic_name [lindex  [load_pic "OWF"] 8] 
			set pic [file join $gb(path_pic) $pic_name]
		    set im [image create photo $pic_name -file $pic]
			$gb(var) itemconfigure [gb_var_get_picture $varId] -image $im
			$gb(var) lower $im
			update
			after $gb(flash_speed)
		}
    "1" {
            set pic_name [lindex  [load_pic "OWF"] 0] 
			set pic [file join $gb(path_pic) $pic_name]
		    set im [image create photo $pic_name -file $pic]
			$gb(var) itemconfigure [gb_var_get_picture $varId] -image $im
			$gb(var) lower $im
			update
			after $gb(flash_speed)
    }
	"2"	{	   
			set pics [lrange [load_pic "OWF" IN] 3 end]
			foreach pic $pics {
			    set im [image create photo $pic -file  [file join $gb(path_pic) $pic]]
			    $gb(var) itemconfigure [gb_var_get_picture $varId] -image $im
			    $gb(var) lower $im
			    #set v [gb_var_set_value $tag 1 true]
			    #$gb(var) itemconfigure $v -fill red
			    update
                after $gb(flash_speed)
		    }
    }
	"3" {
		    set pics [load_pic "OWF" OUT] 
			foreach pic_name $pics {				
				set pic [file join $gb(path_pic) $pic_name]
				set im [image create photo $pic_name -file $pic]
				$gb(var) itemconfigure [gb_var_get_picture $varId] -image $im
				$gb(var) lower $im
				update
				after $gb(flash_speed)
			}
			
			    set pic_name [lindex [load_pic "OWF_BR" OUT] 0] 
				set pic [file join $gb(path_pic) $pic_name]
				set im [image create photo $pic_name -file $pic]
				$gb(var) itemconfigure [gb_var_get_picture $varId] -image $im
				$gb(var) lower $im
				update
		}
    "4" {
                set pic_name [lindex [load_pic "OWF_BR" OUT] 0] 
				set pic [file join $gb(path_pic) $pic_name]
				set im [image create photo $pic_name -file $pic]
				$gb(var) itemconfigure [gb_var_get_picture $varId] -image $im
				$gb(var) lower $im
				update
    }
    "5"	{	   
			set pics [load_pic "OWF_BR" OUT] 
			foreach pic_name $pics {				
				set pic [file join $gb(path_pic) $pic_name]
				set im [image create photo $pic_name -file $pic]
				$gb(var) itemconfigure [gb_var_get_picture $varId] -image $im
				$gb(var) lower $im
				update
				after $gb(flash_speed)
			}
		    gb_switch_OWF $varId 0	
			
        }
    }
	
}
#}}}
#{{{ Function: gb_destroy
#{{{*************************************************************
#	
#	Function: gb_destroy	
#	References:	
#	Description: Delete object identifyed by tag.
#	Call: gb_destroy $objId (all items have tag "all")
#	Input parameters: tag: object identifier
#	Output parameters:  None 
#	Return value: None
#	Examble:  gb_destroy $objId 
#	Fuctionality: delete items which have is identified by parameter tag	
#	Limits: None
#   Side effects:
#	See also: 
#	History:	15.9.2002 Ville Rapa
#	
#*************************************************************}}}


proc gb_destroy { tag } {
	global gb
	foreach area $gb(areas) {
		set tmp [$area find withtag $tag]
		foreach obj $tmp {
			if { [string equal $area $gb(io)] } {
				set ent_area [$area find withtag "syo"]
				if { $ent_area != $obj } {
					$area delete $obj
				}
			} else {
				$area delete $obj
			}
		}	
	}
	update
}
#}}}
#{{{ Function: gb_end gb_step gb_stop gb_run
#{{{*************************************************************
#	
#	Functions: gb_end, gb_step, gb_stop, gb_run
#	References:	
#	Description: Modifies state of GUI buttons.
#	Call: gb_end, gb_step, gb_stop, gb_run
#	Input parameters: None
#	Output parameters: None  
#	Return value: None
#	Examble:  gb_end, gb_step, gb_stop, gb_run
#	Fuctionality: Modifies button item state attribute.	
#	Limits: None
#   Side effects: None
#	See also: --
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_end { } {
	global gb
	$gb(control).run config -state disabled
	$gb(control).stop config -state disabled
	$gb(control).step config -state disabled
	$gb(control).reset config -state normal
}
proc gb_step { } {
    global gb
    $gb(control).run config -state disabled
    $gb(control).stop config -state normal
    $gb(control).step config -state disabled
    $gb(control).reset config -state normal
}
proc gb_stop { } {
	global gb
	
	$gb(control).stop config -state disabled
	$gb(control).step config -state normal
	$gb(control).run config -state normal
	
}
proc gb_run { } {
	global gb
	$gb(control).run config -state disabled
	$gb(control).stop config -state normal
	$gb(control).step config -state disabled
	$gb(control).reset config -state normal
}
#}}}	
#{{{ Function: gb_reset
#{{{*************************************************************
#	
#	Function: gb_reset 	
#	References:	
#	Description: Resets animation execution and initialize GUI to begining state.
#	Call: gb_reset
#	Input parameters: None
#	Output parameters: None  
#	Return value: None
#	Examble:  gb_reset
#	Fuctionality: Destroy all objects and but GUI to start stete	
#	Limits: none
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_reset { } {
	global gb
	
	gb_destroy all 
	set gb(syotetty) 		1
	set gb(wait)			0
	$gb(control).run config -state normal
	$gb(control).stop config -state disabled
	$gb(control).step config -state normal
	$gb(control).reset config -state disabled
	
	set gb(output_id) [gb_pic_create "io" 5 5 output.gif ]
	set gb(input_id)	[gb_pic_create "io" 225 45  inputpas.gif]
	focus .	
}
#}}}
#{{{ Function: gb_set* gb_get*
#{{{*************************************************************
#	
#	Function: gb_get_area, gb_get_speed, gb_get_flash_speed, 
#				gb_get_borders, gb_get_path, gb_get_lib_path,
#				gb_get_pic_path, gb_get_version, gb_get_example_state,
#				gb_get_state, gb_get_help_color, gb_get_font_size, 
#				gb_get_font_name
#	References:	
#	Description: Returns global gb varable related to function name 
#	Call: gb_get_flash_speed 
#	Input parameters: Nane or VariableID 
#	Output parameters: None  
#	Return value: Value of GB variable
#	Examble: gb_get_speed 
#	Fuctionality: Returns value of gb variable 	
#	Limits: None
#   Side effects: None
#	See also: Beginning of this file where variables usage is explaind. 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_get_speed { } {
	global gb
	return $gb(speed)
}

proc gb_get_flash_speed { } {
	global gb
	return $gb(flash_speed)
}

proc gb_get_borders { tag } {
	
	return [get_bordels $tag]
}

proc gb_get_path {} {
	global gb
	return $gb(path)
}

proc gb_get_area { tag } {
	
	return [get_area_name [get_area $tag]]
}

proc gb_get_lib_path {} {
	global gb
	return $gb(path_lib)
}

proc gb_get_pic_path {} {
	global gb
	return $gb(path_pic)
}

proc gb_get_version {} {
	global gb
	return $gb(version)
}
proc gb_get_example_state { } {
	global gb
	set ret ""
	foreach ex $gb(exampleMenuList) {
		if { [llength $ex] == 4 } {
			if { $gb(example) == [file rootname [lindex $ex 3]] } {
				set f [file join [gbSetExamplePath] [lindex $ex 0] \
				[lindex $ex 1] [lindex $ex 2]]				
				lappend examples  "[file rootname \
				[file tail $f]] [lindex $ex 3]"
				source $f
				set ret [file rootname [lindex $ex 2]]
			}
		}
	}
	return $ret
}
proc gb_set_example {ex} {
	global gb
	set gb(example) $ex
}
proc gb_set_randomInput {r} {
	global gb
	set gb(randomInput) $r
}
proc gb_get_state {} {
	global gb 
	return $gb(state)
}

proc gb_get_help_color { } {
	global gb
	return $gb(help_color)
}

proc gb_get_font_size { } {
	global gb
	return [lindex $gb(gb_font) 1]
}


proc gb_get_font_name { } {
	global gb
	return [lindex $gb(gb_font) 0]
}
#}}}
#{{{ Function: gb_set_lib_path, gb_set_path ...

#{{{*************************************************************
#	
#	Functions: gb_set_lib_path, gb_set_path, gb_set_pic_path, 
#					gb_set_speed, gb_set_color, gb_set_state
#	References:	
#	Description: Set value to global variable  
#	Call: gb_set_speed 10
#	Input parameters: New value of global variable 
#	Output parameters:  None 
#	Return value: None
#	Examble: gb_set_speed 10 
#	Fuctionality: 	Sets New value to global variable
#	Limits: None
#   Side effects:
#	See also: Beginning of this file where variables usage is explaind.
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}
proc gb_set_lib_path {p} {
	
	global gb
	set gb(path_lib) $p
}
proc gb_set_path {p} {
	
	global gb
	set gb(path) $p
}

proc gb_set_pic_path {p} {
	
	global gb
	set gb(path_pic) $p
}

proc gb_set_speed {s} {
	global gb
	set gb(speed) $s
}

proc gb_set_color { color } {
	clobal gb
	set gb(text_color) $color
}


proc gb_set_state {s} {
	global gb
	set gb(state) $s
}
proc gb_set_exampleNames { names } {
	global gb
	set gb(exampleNames) [lsort -ascii $names]
}

proc addExampleToTitle { nameOfTheExample } {
	global txt
	wm title . "$txt(title) - $nameOfTheExample"
}

# Picture lists and hotspots related files and paths 

proc gbSetPiclist { fileName } { 
	global gb
	set gb(pic_list) $fileName
}

proc gbSetPiclistPath { pathToFile } {
	global gb
	set gb(pic_listPath) $pathToFile
}

proc gbSetHotSpotFile {fileName } {
	global gb
	set gb(hotspotFile) $fileName
}

proc gbSetHotSpotFilePath { pathToFile } {
	global gb
	set gb(hotspotFilePath) $pathToFile
}
#}}}
#{{{ Function: gb_bind
#{{{*************************************************************
#	
#	Function: gb_bind	
#	References:	
#	Description: binds GUI items to spesified function. 
#	Call: gb_bind $foo step
#	Input parameters: foo : function call
#							b : Gui items name
#	Output parameters:   None
#	Return value: Nonw
#	Examble:  gb_bind foo run
#	Fuctionality: modifies spesified items command attribute.	
#	Limits: None
#   Side effects:
#	See also: 
#	History:	21.11.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_bind { foo B} {
	global gb
	switch -- $B {
		reset { 
					$gb(control).reset configure -command $foo
					$gb(mbar).controls.menu entryconfigure 3 -command $foo
					set gb(resetCommand) $foo
		}
		stop { 
			$gb(control).stop configure -command $foo 
			$gb(mbar).controls.menu entryconfigure 2 -command $foo
			set gb(stopCommand) $foo
		}
		run	{ 
		    $gb(control).run configure -command $foo 
			 $gb(mbar).controls.menu entryconfigure 1 -command $foo
			 set gb(runCommand) $foo
		}
		step {
			$gb(mbar).controls.menu entryconfigure 4 -command $foo
			$gb(control).step configure -command $foo
			set gb(stepCommand) $foo
		}	
		language {
			$gb(mbar).settings.menu.ali2 entryconfigure 1 -command $foo
			$gb(mbar).settings.menu.ali2 entryconfigure 2 -command $foo
			set gb(languageCommand) $foo
 		}
		debug {
			#bind . <Key-1> { ADS 1 }
			#bind . <Key-2> { ADS 2 }
			#bind . <Key-3> { ADS 3 }
		}
	}
}
#}}}
#{{{ Function: gb_flash
#{{{*************************************************************
#	
#	Function: gb_flash	
#	References:	
#	Description: 
#	Call: gb_flash {objs {times 20} args}
#	Input parameters: obj: Object identifier
#							times: Number of flashes
#							args: Delay between flashes
#	Output parameters:   None
#	Return value: None
#	Examble:  gb_flash $tag 
#	Fuctionality: 	
#	Limits: 
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_flash {objs {times 20} args} {
	global gb
	if { [llength $args] == 1 } {
		set delay [lindex $args 0]
	} else {
		set delay $gb(flash_speed)
	} 
	for { set i 1} {$i < $times } { incr i } {
		
		foreach area $gb(areas) {
			
			foreach obj $objs {
				set tmp [$area find withtag $obj ]
				foreach real_obj $tmp {
					if { ([$area type $real_obj] == "text") ||  ([$area type $real_obj] == "line") } {
						$area itemconfig $real_obj -fill $gb(bg_color)
					} else {
						
						set b [$area bbox $real_obj]					
						set r [$area create rec $b -fill $gb(bg_color)\
													-width 0\
													-outline white -tags "flash"]
					}
				}								
			}														
		}
		
		
		update
		after $delay
		
		#poisto
		foreach area $gb(areas) {
			foreach obj $objs {
				set tmp [$area find withtag $obj ]
				foreach real_obj $tmp {
					if { ([$area type $real_obj] == "text") ||  ([$area type $real_obj] == "line") } {
						$area itemconfig $real_obj -fill $gb(color)
					} else {
						$area delete "flash"
					}
				}								
			}														
		}
		
		update
		after $delay
		
	}
	update
}
#}}}
#{{{ Function: gb_change_button_state
#{{{*************************************************************
#	
#	Function: gb_change_button_state
#	References: 	
#	Description: Changes state of the given button to given state.
#	Call: gb_change_button_state {button state}
#	Input parameters: button: name of the button
#							state: new state to button
#	Output parameters: None  
#	Return value: None
#	Examble: gb_change_button_state $button1 disable 
#	Fuctionality: modifies buttons state attribute	
#	Limits: None
#  	Side effects: None
#	See also: 
#	History:	13.7.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_change_button_state {button state} {
	global gb
	switch -- $button {
		"run" {
			$gb(control).run config -state $state
		}
		"stop" {
			$gb(control).stop config -state $state
		}
		"step" {
			$gb(control).step config -state $state
		}
		"speed" {
			$gb(control).speed config -state $state
		}
		"reset" {
			$gb(control).reset config -state $state
		}

	}
}
#}}}
#{{{ Function: gb_print_locate gb_print_array_locate

#{{{*************************************************************
#	
#	Function: 	gb_print_locate
#	References:	
#	Description: Prints text and make arrow to point from text to object
#	Call: gb_print_locate { varId txt  {spott 1}} 
#	Input parameters: varId: Object identifier
#							txt: text to create.
#							spott: spot of the array
#	Output parameters:  None 
#	Return value: id to created objects
#	Examble: b_print_locate $tag "jahuu" 3
#	Fuctionality: 	
#	Limits: 
#   Side effects:
#	See also: gb_arrow_create
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}
proc gb_print_locate { varId txt  {spott 0}} {
    global gb
    set role [gb_var_get_role $varId]
    set spots [lindex [lindex [load_spots $role] 0] $spott]
    set spot [map_spot_coords $varId $spots]
    set tmpid [gb_text_create var [expr [lindex $spot 0]+15] [expr [lindex $spot 1] - 55] "$txt" $gb(help_color)]
    set tmparr [gb_arrow_create var [expr [lindex $spot 0]+15] [expr [lindex $spot 1]-45] var [expr [lindex $spot 0 ]+5] [expr [lindex $spot 1]-7] 2]
    $gb(var) itemconfigure $tmparr -fill $gb(help_color)

	 addtag $tmpid $tmparr
    return $tmpid
}

proc gb_print_array_locate { varId txt index } {
	global gb
	set valueId [gb_var_get_array_index_id $varId $index]	
	set box [$gb(var) bbox $valueId]
	set spot "[lindex $box 2] [lindex $box 1]"
	set tmpid [gb_text_create var [expr [lindex $spot 0]+15] [expr [lindex $spot 1] - 55] "$txt" $gb(help_color)]
    set tmparr [gb_arrow_create var [expr [lindex $spot 0]+15] [expr [lindex $spot 1]-45] var [expr [lindex $spot 0 ]+5] [expr [lindex $spot 1]-7] 2]
    $gb(var) itemconfigure $tmparr -fill $gb(help_color)

	 addtag $tmpid $tmparr
    return $tmpid

	
}
#}}}
#{{{ Function: gb_rotate_stepper
#/*{{{***************************************************************
#  Function: gb_rotate_stepper
#  Description:
#  Call:
#  Input parameters:
#  Example:
#  Functionality:
#  History:
#***********************************************************/*}}}*/

proc gb_rotate_stepper { varId {moveLim 0} } {
    global gb
    set role [gb_var_get_role $varId]
    set direction [gb_stepper_get_direction $varId]
    set spots [lindex [load_spots $role] 0]
    set value  [lindex [$gb(var) itemconfigure "$varId 0 1 1" -text] end]
    set x [lindex [$gb(var) bbox [gb_var_get_picture $varId] ] 0] 
    if {[string equal $direction right]} {
        lappend movement [list "$varId 0 1 1" [expr $x + [lindex [lindex $spots 5] 0]]]
        lappend movement [list "$varId 0 2 1" [expr $x + [lindex [lindex $spots 2] 0]]]
        lappend movement [list "$varId 0 3 1" [expr $x + [lindex [lindex $spots 2] 0]]]
        lappend movement [list "$varId 0 4 1" [expr $x + [lindex [lindex $spots 3] 0]]]
        lappend movement [list "$varId 0 5 1" [expr $x + [lindex [lindex $spots 4] 0]]]
        lappend movement [list "$varId 0 6 1" [expr $x + [lindex [lindex $spots 1] 0]]]
        lappend movement [list "$varId 0 7 1" [expr $x + [lindex [lindex $spots 6] 0]]]
        lappend movement [list "$varId 0 8 1" [expr $x + [lindex [lindex $spots 7] 0]]]
        lappend movement [list "$varId 0 9 1" [expr $x + [lindex [lindex $spots 8] 0]]]
        if {$moveLim != 0} {
            set tmpCo [$gb(var) bbox "LIM$varId" ]
            lappend movement [list "LIM$varId" [expr ([lindex $tmpCo 0] - 35) + (([lindex $tmpCo 2] - [lindex $tmpCo 0]) / 2)]]
        }

        set ok 0
        set counter 0
        while {!$ok} {
            set ok 1
            after $gb(flash_speed)
            foreach movem $movement {
                set valueBorders [$gb(var) bbox [lindex $movem 0]]
                set correction [expr ([lindex $valueBorders 2] - [lindex $valueBorders 0]) / 2] 
                if { [expr [lindex $movem 1] - $correction] < [ lindex [$gb(var) bbox [lindex $movem 0] ] 0] } {
                    set ok 0
                    $gb(var) move [lindex $movem 0] -1 0
                }
                if {$counter == 15} {
                    $gb(var) itemconfig "$varId 0 1 1" -fill $gb(color_2)
                    $gb(var) itemconfig "$varId 0 6 1" -fill $gb(color)
                    $gb(var) itemconfig "$varId 0 3 1" -text "..."
                    $gb(var) itemconfig "$varId 0 9 1" -text [expr $value + 4]
                }
                if {$counter == 21} {
                $gb(var) itemconfig "$varId 0 3 1" -text ".."
                }
                if {$counter == 26} {
                $gb(var) itemconfig "$varId 0 3 1" -text "."
                }
 
            }
            incr counter
            after $gb(flash_speed)
            update
        }
        set ret [expr $value + 1]
        gb_var_set_value $varId $ret
    } else {
        lappend movement [list "$varId 0 1 1" [expr $x + [lindex [lindex $spots 6] 0]]]
        lappend movement [list "$varId 0 2 1" [expr $x + [lindex [lindex $spots 3] 0]]]
        lappend movement [list "$varId 0 3 1" [expr $x + [lindex [lindex $spots 4] 0]]]
        lappend movement [list "$varId 0 4 1" [expr $x + [lindex [lindex $spots 5] 0]]]
        lappend movement [list "$varId 0 5 1" [expr $x + [lindex [lindex $spots 1] 0]]]
        lappend movement [list "$varId 0 6 1" [expr $x + [lindex [lindex $spots 7] 0]]]
        lappend movement [list "$varId 0 7 1" [expr $x + [lindex [lindex $spots 8] 0]]]
        lappend movement [list "$varId 0 8 1" [expr $x + [lindex [lindex $spots 9] 0]]]
        lappend movement [list "$varId 0 9 1" [expr $x + [lindex [lindex $spots 9] 0]]]
        if {$moveLim != 0} {
            set tmpCo [$gb(var) bbox "LIM$varId" ]
            lappend movement [list "LIM$varId" [expr ([lindex $tmpCo 0] + 35) + (([lindex $tmpCo 2] - [lindex $tmpCo 0]) / 2)]]
        }

        set ok 0
        set counter 0
        while {!$ok} {
            set ok 1
            after $gb(flash_speed)
            foreach movem $movement { 
                set valueBorders [$gb(var) bbox [lindex $movem 0]]
                set correction [expr ([lindex $valueBorders 2] - [lindex $valueBorders 0]) / 2] 
                if { [expr [lindex $movem 1] - $correction] > [ lindex [$gb(var) bbox [lindex $movem 0] ] 0] } {
                    set ok 0
                    $gb(var) move [lindex $movem 0] +1 0
                }
                if {$counter == 15} {
                    $gb(var) itemconfig "$varId 0 1 1" -fill $gb(color_2)
                    $gb(var) itemconfig "$varId 0 5 1" -fill $gb(color)
                    $gb(var) itemconfig "$varId 0 2 1" -text [expr $value - 4]
                    $gb(var) itemconfig "$varId 0 8 1" -text "..."
                }
                if {$counter == 21} {
                $gb(var) itemconfig "$varId 0 8 1" -text ".."
                }
                if {$counter == 26} {
                $gb(var) itemconfig "$varId 0 8 1" -text "."
                }

            
            }
            incr counter
            update
        }
        set ret  [expr $value - 1]
        gb_var_set_value $varId $ret
    }
    return $ret
}
#}}}
#{{{ Function: gb_update
#{{{*************************************************************
#	
#	Function: gb_update	
#	References:	
#	Description: Updates GBIobject which have parts in many canvases  
#	Call: gb_update
#	Input parameters: None 
#	Output parameters: None	  
#	Return value: None
#	Examble: gb_update  
#	Fuctionality: 	finds all items which are identified by tag $gb(multi)
#						and calls update_multi_line function.
#	Limits: None
#   Side effects: None
#	See also: update_multi_line
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_update { } {
	global gb
	
	foreach area $gb(areas) {
		set objs [$area find with $gb(multi)]
		if { [llength $objs] > 0 } {
			foreach obj $objs {
				set tags [$area itemconfig $obj -tags] 
				set tags [lindex $tags end]
				update_multi_line [lindex $tags 0]
			}
		}
	}	
}
#}}}
#{{{ Function: gb_set_animation_speed
#{{{*************************************************************
#	
#	Function: gb_set_animation_speed 	
#	References:	
#	Description: Opens speed dialog which contains scale item to change speed value.
#	Call:  gb_set_animation_speed 
#	Input parameters: None
#	Output parameters:  None 
#	Return value: None
#	Examble: gb_set_animation_speed { } 
#	Fuctionality: Cretes toplevel dialog and scale item. Scale is used for chancing speed 
#						value.  	
#	Limits: None 
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_set_animation_speed { } {
	global gb txt
	
	set gb(wait) 1
	# Delete old dialog if exists.
	catch {destroy .d}
	toplevel 	.d 		-class Dialog
	wm title 	.d 		$txt(speed_dialog_title)
	frame 	.d.top 	-relief raised -bd 1
	pack 		.d.top 	-side top -fill both
	frame 	.d.bot 	-relief raised -bd 1
	pack 		.d.bot 	-side bottom -fill both
	set s .d.bot.scale
	scale 	$s -from 1 -to 5 -length 250 \
				-orient horizontal -label $txt(speed_dialog_caption) \
				-tickinterval 1 \
				-showvalue true \
				-command "get_scale_value $s" 
	button 	.d.bot.ok 	-text OK -command "ok_button_pressed destroy .d" 
	pack 		.d.bot.scale 
	pack 		.d.bot.ok 	-side bottom -padx 2m -pady 2m
	
	set oldFocus [focus]
	focus .d.bot.ok
	$s set $gb(mscale)
	bind .d <Left> {.d.bot.scale set [expr [.d.bot.scale get] -1] } 
	bind .d <Right> {.d.bot.scale set [expr [.d.bot.scale get] +1] }
	bind .d <Key-plus> {.d.bot.scale set [expr [.d.bot.scale get] +1] }
	bind .d <Key-minus> {.d.bot.scale set [expr [.d.bot.scale get] -1] }
	bind .d <Return> {ok_button_pressed destroy .d }
	.d.bot.scale configure -label $txt(speed_dialog_caption)
	wm title .d $txt(speed_dialog_title)
	vwait gb(wait)
	focus $oldFocus
	
}
#}}}
#{{{ Function: gb_get_position
#{{{*************************************************************
#	
#	Function: gb_get_position	
#	References:	
#	Description: returns coordinates of object identified by tag.
#	Call: gb_get_position { tag } 
#	Input parameters: tag: Object identifier.
#	Output parameters: None  
#	Return value: list of Objects coordinates 
#	Examble:  b_get_position $tag
#	Fuctionality: 	
#	Limits: 
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}


proc gb_get_position { tag } {
	set obj [get_object $tag]
	if { $obj != -1 } {
		set area [lindex $obj 1]
		if { [llength [lindex $obj 0]] > 1 } {
			#useampi objecti samassa
			foreach key [lindex $obj 0] {
				#voisi laittaa alue tunnuksen TODO
				lappend co [$area coords $key] 
			}
			
			return $co
		} else {
			return [$area coords $tag] 
		} 	
	} else {
		return -1
	}
}
#}}}
#{{{ Function: gb_print_output
#{{{*************************************************************
#	
#	Function: gb_print_output	
#	References:	
#	Description: 
#	Call: gb_print_output { txt {newline 0} {start NULL} }
#	Input parameters: txt: text 
#							newline: newline flag
#							start: flag for array
#	Output parameters:   
#	Return value:
#	Examble:  gb_print_output "jee" 
#	Fuctionality: 	
#	Limits: 
#   Side effects:
#	See also: 
#	History:	14.10.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_print_output { txt {newline 0} {start NULL} } {

    global gb 
    
    set area $gb(io)	
    
    set tmp_font [gb_get_font_size]
    set x [expr [lindex [$area bbox $gb(output_id)] 0]+3]
    set y [expr [lindex [$area bbox $gb(output_id)] 3]-3]
    set hight [expr [lindex [$area bbox $gb(output_id)] 2] - $x]
    set width [expr $y - [lindex [$area bbox $gb(output_id)] 1] ]
 
    set max_lines [expr $hight / $tmp_font]
 	 
	 if {$tmp_font <= 12} {
	 	set max_lines 6
	 } else {
	 	set max_lines 5
	}	
	 
	 if { [llength $gb(out_lines)] > 0 && $newline} {
	
		if { [llength $gb(out_lines)] >= $max_lines } {		
	    	$area delete [ lindex $gb(out_lines) 0 ]
	    	set gb(out_lines) [lrange $gb(out_lines) 1 [expr [llength $gb(out_lines)] -1]]
	    	update
	}
	foreach key $gb(out_lines) {				
	    $area move $key 0 -$tmp_font	
	}
    }

    if {[llength $gb(out_lines)] == 0} {
			set newline 1
    }
 
	 set arr NULL
    if { $newline  != 0} {
			set last [gb_text_create "io" $x [expr $y - $tmp_font] [string range $txt 0 0]]
			if { ![string equal $start NULL ]} {
					if {[catch {set arr [gb_arrow_create $start $last 5]} err ]} {
						set arr NULL
					}
    		}
	 }

     
    update
	 after $gb(flash_speed)
	 set tmpLine ""
    set lastLine ""
    set lastLineId ""

    if {$newline} {
		lappend gb(out_lines) $last
    } else {
	if {[llength $gb(out_lines)] == 0} {
	    lappend gb(out_lines) $last
	} else {
	    set lastLineId [lindex $gb(out_lines) [expr [llength $gb(out_lines)] - 1]]
	    set lastLine [$area itemcget $lastLineId -text]
	}
    }	

    set i 1
    set done 1

    if {!$newline} {
	set newTxt [format %s%s $lastLine $txt]
	set i [string length $lastLine]
	set txt $newTxt
	set last $lastLineId
    }

    while { $done } {
		
	set len [string length $txt]			
	$area itemconfigure $last -text [ string range $txt 0 $i]
	after $gb(flash_speed)
	
	update
	if {$i >= $len} {
	    set done 0
	}
	incr i

    }
    gb_destroy $arr
    $area select from $last 3

    #palautetaan tekstin Id
    return $last
}
#}}}
#{{{ Function: ok_button_pressed
#{{{*************************************************************
#	
#	Function: 	ok_button_pressed
#	References:	
#	Description: changes state of gb(wait) variable.
#	Call: ok_button_pressed
#	Input parameters: 
#	Output parameters:   
#	Return value:
#	Examble:  ok_button_pressed
#	Fuctionality: 	
#	Limits: 
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc ok_button_pressed { args } {
	global gb
	eval $args
	set gb(wait) 0
}
#}}}
#{{{ Function: gb_compare_OWF
#{{{*************************************************************
#	
#	Function: gb_compare_OWF	
#	References:	
#	Description: Animate comparison of role OWF
#	Call: gb_compare_OWF {tag bool}
#	Input parameters: tag:
#							bool: 
#	Output parameters:  None 
#	Return value: None
#	Examble: gb_compare_OWF $tag true 
#	Fuctionality: 	change color of value assign to variable
#	Limits: 
#   Side effects:
#	See also: 
#	History:	15.10.2001 Ville Rapa
#	
#*************************************************************}}}


proc gb_compare_OWF {tag bool} {
	global gb
	set id [ $gb(var) find withtag "$tag 0 1 1"]

	if { $bool } {
		$gb(var) itemconfigure $id -fill green
	} else {
		$gb(var) itemconfigure $id -fill red	
	}
	
	update

}
#}}}
#{{{ Function: gb_clear_OWF
#{{{*************************************************************
#	
#	Function: gb_clear_OWF	
#	References:	
#	Description: Clears variable of type OWF
#	Call: gb_clear_OWF { tag }
#	Input parameters: tag : object identifier
#	Output parameters:   None
#	Return value: None
#	Examble:  gb_clear_OWF $tag
#	Fuctionality: change initial color to value.
#	Limits: None
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_clear_OWF { tag } {
	global gb
	set id [ $gb(var) find withtag "$tag 0 1 1"]
	$gb(var) itemconfigure $id -fill  $gb(color)
	update
}
#}}}
#Function: gb_animate_run_pressing {{{
#/*{{{***************************************************************
#  Function: gb_animate_run_pressing
#  Description: Automate run button pressing used in the "showMode"
#  Call: gb_animate_run_pressing
#  Input parameters: none
#  Example: gb_animate_run_pressing
#  Functionality: Moves cursor to the top of the run button
#				  and creates needed wm enevents
#  History:  Tue Mar 16 15:19:22 EET 2004 Ville Rapa
#***********************************************************/*}}}*/

proc gb_animate_run_pressing { } {
	global gb
	event generate $gb(control).run <Motion> -warp 1 -x 10 -y 10
	gb_wait
	event generate $gb(control).run <ButtonPress-1>
	after 100 event generate $gb(control).run <ButtonRelease-1> 
}
#}}}
#Function: setNamesForExampleMenu{{{
#/*{{{***************************************************************
#  Function: setNamesForExampleMenu
#  Description: traveles trough Example directory and finds names.
#  Call: setNamesForExampleMenu
#  Input parameters:-
#  Example:
#  Functionality:
#  History: Thu Mar 18 17:36:31 EET 2004
#***********************************************************/*}}}*/

proc setNamesForExampleMenu { } {
	global gb
	# find languages of the examples
	set number 0
	set gb(exampleMenuList) ""
	foreach l [glob -nocomplain $gb(exampleRoot)/*] {
		if {[file exists $l] } {
			if { [file isdirectory $l] } {
				lappend gb(exampleMenuList) [file tail $l]
				foreach p [glob $l/*] {
					if { [file exists $p]} {
						if { [file isdirectory $p] } {
							lappend gb(exampleMenuList) \
							"[file tail $l] [file tail $p]"
							foreach e [glob -nocomplain $p/*.tcl] {
								lappend gb(exampleMenuList) \
								"[file tail $l] [file tail $p] [file tail $e] $number"
								incr number
							}
						}
					}
				}
			}
		}
	}

}
#}}}
#Function: gbGetExampleList {{{
#/*{{{***************************************************************
#  Function: gbGetExampleList
#  Description: Retruns example list!
#  Call:
#  Input parameters:
#  Example: gbGetExampleList
#  Functionality: setNamesForExampleMenu gets list from the Examble path
#  History: Mon Mar 22 13:01:30 EET 2004
#***********************************************************/*}}}*/

proc gbGetExampleList { } {
	global gb
	if { [llength $gb(exampleMenuList)] == 0 } {
		setNamesForExampleMenu
	}
	return $gb(exampleMenuList)
}
#}}}
#Function: gbSetExamplePath{{{
#/*{{{***************************************************************
#  Function: gbSetExamplePath 
#  Description: set or query example path variable.
#  Call: 
#  Input parameters: args: New path
#  Example: gbSetExamplePath
#			gbSetExamplePath /PlanAni/Examples
#  Functionality: 
#  History: Mon Mar 22 13:01:14 EET 2004
#***********************************************************/*}}}*/

proc gbSetExamplePath { args } {
	global gb 
	if { [llength $args] == 1 } {
		set gb(exampleRoot) [lindex $args 0]
	} else {
		return $gb(exampleRoot)
	}
}
#}}}


#Function: Function: deliverBindigs {{{
#/*{{{***************************************************************
#  Function: deliverBindigs
#  Description: GBI frontend for bind command
#  Call: widget cmd
#  Input parameters: widget: invoked videget
#					 cmd: command to execute	
#  Example:	deliverBindigs %w gb_exit
#  Functionality: 
#  History: Tue Mar 30 13:17:11 EEST 2004
#***********************************************************/*}}}*/

proc deliverBindigs { w cmd args} {
	global gb
	if { ![string equal $gb(ent) $w] } {
		eval $cmd $args	
	}
}

#}}}


