# Copyright (c) 2003 University of Joensuu,
#                    Department of Computer Science

#{{{ Function: get_object 
#{{{*************************************************************
#	
#	Function: get_object	
#	References:	
#	Description: Returns object identified by tag. Object is list containing:
#						{ID canvaspath}
#	Call: get_object $tag 
#	Input parameters: $tag : Object identifier created by GBI.
#	Output parameters: None.  
#	Return value: List {ID canvaspath} or -1 if error occures.
#	Examble: get_object $tag
#	Fuctionality: Seach object tag from tree main cavases.  
#	Limits: 
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc get_object { tag } {
	
	global gb
    # finds from all canvases	
	foreach area $gb(areas) {
		set obj [$area find withtag $tag]
		if { $obj  > 0 } {
			lappend objs $obj $area
		}
	}
	if { [info exists objs] } {
		return $objs
	} else {
		return -1
	}
}

#}}}
#{{{ Function: get_area
#{{{*************************************************************
#	
#	Function: get_area { tag }
#	References:	
#	Description: Returns area path from given object.
#	Call: set area [get_area $tag] 
#	Input parameters: Tag: Object identifier created by GBI.
#	Output parameters: None.   
#	Return value: Canvas path or -1 if error occures.
#	Examble: get_area $tag
#	Fuctionality: Uses method get_object and returns value of index 1 from result list.
#	Limits: 
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc get_area { tag } {
	
	set obj [get_object $tag]
	
	if {$obj != -1 } {
		return [lindex $obj 1]
	} else {
		return -1
	}
}

#}}}
#{{{ Function: get_bordels
#{{{*************************************************************
#	
#	Function: get_bordels	
#	References:	
#	Description: Returns object borders
#	Call:  get_bordels  $varId
#	Input parameters: tag: object identifier
#	Output parameters:   None.
#	Return value: List containing top left and bottom rigth coordinates.
#	Examble: get_bordels $varId
#	Fuctionality: Uses bbox to get coordiantes. 
#	Limits: 
#   Side effects:
#	See also: get_area
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc get_bordels { tag } {
	
	set area [get_area $tag]	
	if { $area != -1} {
		return [$area bbox $tag]
	} else {
		return -1
	}	
}

#}}}
#{{{ Function: group_obj_tags
#{{{*************************************************************
#	
#	Function: group_obj_tags
#	References:	
#	Description: adds same identifier to given objects
#	Call: group_obj_tags  new_tag objs {tag "NULL"}
#	Input parameters: new_tag: Object which identifier will be used if tag is null
#							objs: object which identifier will be changed
#							tag: user defined tag. optional.
#	Output parameters:  None. 
#	Return value: variable identifier.
#	Examble: group_obj_tags $varId {$tag $tag2} 
#	Fuctionality: finds all needed objects and changes tags 
#	Limits: 
#   Side effects:
#	See also: get_object  
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc group_obj_tags { new_tag objs {tag "NULL"}} {
	if { $tag != "NULL" } {
		set tmp [get_object $new_tag]
		[lindex $tmp 1] itemconfigure [lindex $tmp 0] -tags $tag
		set new_tag $tag 
	}
	foreach key $objs {
		set obj [get_object $key]
		if { $obj != -1} {
			[lindex $obj 1] itemconfigure [lindex $obj 0] -tags $new_tag
		} else {
		  return -1
		}
	}
}

#}}}
#{{{ Function: get_next_objectid
#{{{*************************************************************
#	
#	Function: get_next_objectid 	
#	References:	
#	Description: Creates unique object identifyer.
#	Call: get_next_objectid 
#	Input parameters: None.
#	Output parameters: None.  
#	Return value: Object identifier.
#	Examble: set tag [get_next_objectid]
#	Fuctionality: increace gb(object_id) variable and adds text "gc" in fornt of it.
#	Limits: can be used only MAXINT times after that uniquenes is not quaranted.
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc get_next_objectid { } {
	global gb
	
	return gb[incr gb(object_id)]
}

#}}}
#{{{ Function: get_area_path
#{{{**************************************************************
#	
#	Function: get_area_path
#	References:	
#	Description: Retruns path to given canvas name.
#	Call: get_area_path "src" 
#	Input parameters: area: name of the area/canvas (src,var,io)
#	Output parameters:  None. 
#	Return value: Path or if error occures -1
#	Examble: get_area_path "var"
#	Fuctionality:  
#	Limits: 
#   Side effects:
#	See also: get_area_name
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc get_area_path { area } {
	global gb
		if { $area == "src" } {
			return [lindex $gb(areas) 0]
		} elseif { $area == "var" } {
			return [lindex $gb(areas) 1]
		} elseif {$area == "io" } {
			return [lindex $gb(areas) 2]
		} else {
			return -1
		}	
}

#}}}
#{{{ Function: get_area_name

#{{{*************************************************************
#	
#	Function: get_area_name	
#	References:	
#	Description: Returns the name of the given canvas path.
#	Call: get_area_name { path } 
#	Input parameters: path: Path of the canvas.
#	Output parameters:   None
#	Return value: Name of the canvas used in GBI.
#	Examble: get_area_name $gb(src)
#	Fuctionality:  
#	Limits: 
#   Side effects: 
#	See also: get_area_path
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc get_area_name { path } {
	global gb
	if { $path == $gb(src) } {
			return src
		} elseif { $path == $gb(var) } {
			return var
		} elseif {$path == $gb(io) } {
			return io
		} else {
			return -1
		}	
}

#}}}
#{{{ Function: get_objects_by_type
#{{{*************************************************************
#	
#	Function: get_objects_by_type	
#	References:	
#	Description:  Returns all objects which are given type. 
#	Call:  get_objects_by_type { type }
#	Input parameters: type : type of variable
#	Output parameters: None  
#	Return value: list of object identifiers
#	Examble: get_objects_by_type txt
#	Fuctionality: seacrc througth all canvases searcing for items which are given type. 
#	Limits: 
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc get_objects_by_type { type } {
	global gb
	foreach area $gb(areas) {
		set  tmp [$area find all]
		foreach obj $tmp {
			if { [$area type $obj] == $type } {
					lappend ret "$area $obj"
			}
		}
	}
	return $ret
}

#}}}
#{{{ Function: get_cross_road
#{{{*************************************************************
#	
#	Function: get_cross_road	
#	References:	
#	Description: Calculates the point where line (x,y) (x2,y2) crosses canvas edges.
#	Call:  get_cross_road { area x y area2 x2 y2 }
#	Input parameters: area: area path of start point.
#								x: start point x coordinate
#								y: start point y coordinate
#							area2: area path of end point.
#								x2: end point x coordinate
#								y2: end point y coordinate
#	Output parameters:  None. 
#	Return value: coordinate of intersection.
#	Examble: get_cross_road "src" 10 10 "var" 100 200
#	Fuctionality:  uses winfo to map canvas coordinates to main window coordinates
#						Calculate intersection using function cross_point. 
#	Limits: 
#   Side effects:
#	See also: cross_point 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc get_cross_road { area x y area2 x2 y2 args} {
	
	global gb
	
	set x [expr double($x)]
	set y [expr double($y)]
	set x2 [expr double($x2)]
	set y2 [expr double($y2)]
	
	switch -- $area {
		"src" { 			
			if {$area2 == "var"} {
				set xpoint [winfo width [get_area_path "src"]] 
				
				set xx2 [expr $x2 + $xpoint]
				set yy2 $y2 
				
				set kk [expr  ($yy2 - $y) / ($xx2 - $x) ]
								
				set cross_point [expr ($kk * $xpoint) - ($kk * $x) + $y]
				
			## IO
			} else {
				set xpoint [winfo width [get_area_path "src"]] 
				#[lindex [[get_area_path "src"] configure -width] 4]
				set ypoint [winfo height [get_area_path "var"]]
				#[lindex [[get_area_path "var"] configure -height] 4]
				set tmp_x [expr $x2 + $xpoint]
				set tmp_y [expr $y2 + $ypoint]
				set kk [expr  ($tmp_y - $y) / ($tmp_x - $x) ]
				set cross_point [expr ($kk * $xpoint) - ($kk * $x) + $y]				
				
			}
		}
		"var" { 
			if {$area2 == "src"} {
				set cross_point [get_cross_road $area2 $x2 $y2 $area $x $y]
				
			##io
			} else {
				
				set ypoint [winfo height [get_area_path "var"] ]
				#[lindex [[get_area_path "var"] configure -height] 4]
				if { $ypoint < $y } {
					set cross_point $x2
				} else { 
					set tmp_y [expr $ypoint + $y2] 
					set kk [expr  ($tmp_y - $y) / ($x2 - $x) ]				
					set cross_point [expr (($ypoint-$y) / $kk) + $x]
				}
			}
		}
		"io" { 
			if {$area2 == "src"} {
				
				set cross_point [get_cross_road $area2 $x2 $y2 $area $x $y]
				##var
			} else {
				set cross_point [get_cross_road $area2 $x2 $y2 $area $x $y]
				
			}
		}
		default { }
	}
	return $cross_point
}

#}}}
#{{{ Function: copy_txt_object
#{{{*************************************************************
#	
#	Function: copy_txt_object	
#	References:	
#	Description: creates copy of text object to given canvas.
#	Call:  copy_txt_object { id area x y }
#	Input parameters: id: Object identifier
#						 area: destination canvas
#							 x: x coordinate in destination canvas
#							 y: y coordinate in destination canvas
#	Output parameters: None.  
#	Return value: Object identifier of new text object
#	Examble: copy_txt_object  $varId "src" 10 10
#	Fuctionality: gets the text attribute from old object and creates. finally deletes
#						old object 
#	Limits: 
#   Side effects:
#	See also: get_area_path, gb_text_create
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc copy_txt_object { id area x y } {
	set old_obj [get_object $id]
	set area_tmp [lindex $old_obj 1]
	
	if { [$area_tmp type $id ]== "text" } {
		set txt [lindex [ $area_tmp itemconfig $id -text] 4]  
		set new_obj [gb_text_create $area $x $y $txt]
		$area_tmp delete $id				
		update
		[get_area_path $area] itemconfigure $new_obj -tags $id
		return $id
	}	
} 

#}}}
#{{{ Function: get_char_position
#{{{*************************************************************
#	
#	Function: get_char_position	
#	References:	
#	Description: Returns x an y coordinates of character in the 
#			specified string
#	Call: get_char_position id col  
#	Input parameters:	id: Object identifier
#				col: index of char.
#	Output parameters:   None.
#	Return value: x and y coordiantes
#	Examble: get_cahr_position $tag 10
#	Fuctionality:  
#	Limits: None.
#  	Side effects: None
#	See also: 
#	History:	15.10.2002 Ville Rapa
#	
#*************************************************************}}}

proc get_char_position { id col } {
		
    global gb
	 	
	set area [get_area $id]		
	set txt [lindex [$area itemconfigure $id -text] end ]
	if { [string length $txt] >= $col } {
		set txt [string range $txt 0 [expr $col -1]]
		set co [$area coords $id]
		set tmp_txt [gb_text_create \
				[get_area_name $area] [lindex $co 0] [lindex $co 1] $txt]
		set co [$area bbox $tmp_txt]
		$area delete $tmp_txt
		return "[lindex $co 2] [lindex $co 1]"
	} else {
		return -1
	}	
} 

#}}}
#{{{ Function: update_multi_line
#{{{*************************************************************
#	
#	Function: update_multi_line
#	References:	
#	Description: Updates objects (lines) which are in two canvases.
#	Call:  update_multi_line
#	Input parameters: tag: object identifier 
#	Output parameters:  None 
#	Return value: none
#	Examble:  update_multi_line $tag
#	Fuctionality: Take all neededinformation from object and deletes it 
#						after that creates new one with updated options.
#	Limits: 
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc update_multi_line { tag } {
	global gb
	set obj [get_object $tag]

	if { $obj != -1 } {
		set new_arr [lindex [lindex [[lindex $obj end] itemconfig $tag -tags] end]	end]	
		gb_destroy $tag
		set tagtmp [gb_arrow_create [lindex $new_arr 0]\
										 [lindex $new_arr 1]\
										 [lindex $new_arr 2]\
										 [lindex $new_arr 3]\
										 [lindex $new_arr 4]\
										 [lindex $new_arr 5]\
										 [lindex $new_arr 6] $tag]

		foreach area $gb(areas) {
			$area addtag $tag withtag $tagtmp 	
		}
	}
}

#}}}
#{{{ Function: addtag

proc addtag { tag args } {
	global gb
	foreach area $gb(areas) {
		foreach obj $args {
			$area addtag $tag withtag [lindex $args 0] 
		}
	}
}

#}}}
#{{{ Function: errorHandler
#{{{*************************************************************
#	Function: errorHandler	
#	Description: Prints error messages and terminate execution if wanted. 
#	Call:  errorHandler {nroError {exit no}}
#	Input parameters: nroError: nuber of error which occured.
#							exit:	flag for exit command	
#	Examble: errorHandler {10 yes}
#	Fuctionality: based on nroError puts message and if exit is yes 
#						terminates execution of program. 
#	History:	12.6.2003 Ville Rapa
#*************************************************************}}}

proc errorHandler { nroError {exit no}} {
	switch $nroError {
		10	{
			puts "Error: Couldn't find piclist file"
		}
        11 {
            puts "Error opening file hotspots.txt"
        }
		default { 
			puts "Error"
		}		
	}
	if {[string equal -nocase $exit yes]} { 
		exit 0
	}
}

#}}}
#{{{ Function: load_pic
#{{{*************************************************************
#	
#	Function: load_pic	
#	References:	
#	Description: loads variable picture names. 
#	Call:  load_pic {role {fade OUT}}
#	Input parameters: role: role of variable
#							fade: direction of the picture list
#									Could be OUT or IN, if it's somethingelse then OUT is used.
#	Return value: list of picture names. In case of errors empty list.
#	Examble: load_pic FIXED out
#	Fuctionality: Reads piclist file and finds names for role. 
#	See also: 
#	History:	2.7.2002 Mikko Korhonen
#				14.6.2003 Ville Rapa 
#	
#*************************************************************}}}

proc load_pic { role {fade OUT} } {
   
	global gb debug 
	
	#open, read and close file
	if [catch {
		set fileName [file join $gb(pic_listPath) $gb(pic_list)]
		set fileId [open $fileName r]
		set koko [read $fileId]
		close $fileId
   }] {
		errorHandler 10 yes
	}
	switch $role {
		FIXED   { set expr "(<FIXED-VALUE>)(.*)(</FIXED-VALUE>)" }
		CONS    { set expr "(<CONSTANT>)(.*)(</CONSTANT>)" }
        MRH     { set expr "(<MOST-RECENT_HOLDER>)(.*)(</MOST-RECENT_HOLDER>)" }
        GATH    { set expr "(<GATHERER>)(.*)(</GATHERER>)" }
        FOLL    { set expr "(<FOLLOWER>)(.*)(</FOLLOWER>)" } 
        MWH     { set expr "(<MOST-WANTED_HOLDER>)(.*)(</MOST-WANTED_HOLDER>)" } 
        OWF     { set expr "(<ONE-WAY_FLAG_lamp>)(.*)(</ONE-WAY_FLAG_lamp>)" } 
        ORGA    { set expr "(<ORGANIZER>)(.*)(</ORGANIZER>)" } 
        STEP    { set expr "(<STEPPER>)(.*)(</STEPPER>)" } 
        TEMP    { set expr "(<TEMPORARY_off>)(.*)(</TEMPORARY_off>)" } 
        OTHER   { set expr "(<OTHER>)(.*)(</OTHER>)" }
        OTHE   { set expr "(<OTHER>)(.*)(</OTHER>)" }
        TEMP_ON { set expr "(<TEMPORARY_on>)(.*)(</TEMPORARY_on>)" }
        OWF_BR  { set expr "(<ONE-WAY_FLAG_broken>)(.*)(</ONE-WAY_FLAG_broken>)" }
        MRH-STEP { set expr "(<MOST-RECENT_HOLDER_to_STEPPER>)(.*)(</MOST-RECENT_HOLDER_to_STEPPER>)" }
        TRANS  { set expr "()(.*)()" } 
		default { 
			set expr -1 
		}
	
	}	
	 
	if [catch {
			set result [regexp $expr $koko match] 
			set length [llength $match]
			set path [lindex $match 1]
			set pics [lrange $match 2 [expr $length -2]]
			foreach pic $pics {
				
				lappend ret $path$pic
			}
    	}] {
			# TODO debug 
			# No role found or piclist file malformated
			set ret {}
			}
		
   #Sort list  
	#if param. fade is OUT the first is actual role picture.
	if {[string equal -nocase $fade IN]} {
	    set ret [lsort -dictionary -decreasing $ret]
	} else {
	    set ret [lsort -dictionary -increasing $ret]
	}
	
	return $ret
}

#}}}
#{{{ Function: get_scale_value
proc get_scale_value { args } {
	global gb
	switch -- [lindex $args end] {
		"1" { 
			set gb(speed) 3000
			set gb(flash_speed) 160
			set gb(mscale) 1
		}
		"2" {
			set gb(speed) 2400 
			set gb(flash_speed) 130
			set gb(mscale) 2
		}
		"3" {
			set gb(speed) 1600
			set gb(flash_speed) 100
			set gb(mscale) 3
		}
		"4" {	
			set gb(speed) 800 
			set gb(flash_speed) 70
			set gb(mscale) 4
		}
		"5" {
			set gb(speed) 100 
			set gb(flash_speed) 30
			set gb(mscale) 5
		}
	}	
	
	return $gb(mscale)
}

#}}}
#{{{ Function: about_window
proc about_window { } {
	global gb 
	tk_messageBox -type ok -message \
	"PlanAni  - University of Joensuu, Finland. Version: $gb(version)"
}

#}}}
#{{{ Function: move
#{{{*************************************************************
#	
#	Function: move	
#	References:	
#	Description: Moves object
#	Call:  move { id x2 y2 {arr NULL} }  
#	Input parameters: id:
#							x2:
#							y2:
#							arr:
#	Output parameters:  None 
#	Return value: None
#	Examble: move $tag 10 10  
#	Fuctionality: changes object x and y coordinates. 
#	Limits: 
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc move { id x2 y2 {arr NULL} } {
	
    global gb
	 set hop [expr $gb(mscale)+2] 
	 set x1 [expr double( [ lindex [gb_get_position $id ] 0 ] )]
	 set y1 [expr double( [ lindex [gb_get_position $id ] 1 ] )] 

    set pituus [expr (round(sqrt(pow($x2-$x1,2)+pow($y2-$y1,2))))]

    set X [expr (($hop * ($x2 - $x1)) / $pituus)]
    set Y [expr (($hop * ($y2 - $y1)) / $pituus)]

    for {set i $hop} {$i <= $pituus} {incr i $hop} {
		[get_area $id] move $id $X $Y
		if { ![string equal $arr NULL] } {
			set co [$gb(src) coords $arr] 
			if { [string equal [get_area $id] $gb(io)] } {
				set yy [expr [ winfo height $gb(var) ]  + [lindex [[get_area $id] coords $id] 1 ]] 
			}	else {
				set tmp [lindex [ [get_area $id] coords $id] 1 ] 
				set mul [expr [$gb(var) canvasy $tmp] - $tmp]
				set yy [ expr [lindex [ [get_area $id] coords $id] 1 ] - $mul + 15	]
				
			}
			set new [lreplace $co 2 4  [lindex $co 2] $yy]
			$gb(src) coords $arr $new 
		}
		after $gb(flash_speed)
		update

    }
    set X [expr ($x2 - [ lindex [gb_get_position $id ] 0 ])]
    set Y [expr ($y2 - [ lindex [gb_get_position $id ] 1 ])]
	 [get_area $id] move $id $X $Y
}

#}}}
#{{{ Function: gb_var_pic_borders
#{{{*************************************************************
#	
#	Function: gb_var_pic_borders { tag  }	
#	References:	
#	Description: Returns upper left and bottom right coordinates of object.
#	Call:  gb_var_pic_borders $varId
#	Input parameters: object identifier.
#	Output parameters: None.
#	Return value: list containing upper left and bottom right coordinates of object.
#	Examble:  gb_var_pic_borders $varId
#	Fuctionality: uses tk box method. 
#	Limits: None
#   Side effects: Tag identifies all cavas item which belongs to object.
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_var_pic_borders { tag  } {
	global 	gb	 
	return [$gb(var) bbox $tag] 
}

#}}}
#{{{ Function: var_get_picture
#{{{*************************************************************
#	
#	Function:var_get_picture { tag }	
#	References:	 
#	Description: Return attribute image from gb_var object.
#	Call: var_get_picture $tag 
#	Input parameters: tag: object identifier.
#	Output parameters: None   
#	Return value: Name of used image.
#	Examble: var_get_picture tag 	
#	Fuctionality:  Retruns image attribute
#	Limits: 
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc var_get_picture { tag } {
	set obj [get_object $tag] 
	set id [lindex [lindex $obj 0] end]
	return 	[file tail [lindex [ [ lindex $obj end ] itemconfig $id -image] end ]]
		
}

#}}}
#{{{ Function: getHS
#{{{*************************************************************
#	
#	Function: getHS {role number place}	
#	References:	
#	Description:
#	Call:  
#	Input parameters: 
#	Output parameters:   
#	Return value:
#	Examble: 
#	Fuctionality:  
#	Limits: 
#   Side effects:
#	See also: 
#	History:	15.8.2002 Mikko Korhonen
#	
#*************************************************************}}}

proc getHS {role number place} {
        set tmp [load_spots $role]
        set ret [lindex [lindex $tmp $number] $place]
        if {[llength $ret] == 0} {
               set ret "1 1"
        }
        puts "$ret"
        return $ret
		
}

#}}}
#{{{ Function: load_spots
#{{{*************************************************************
#	
#	Function: load_spots	
#	References:	
#	Description: loads variables hotspots. 
#	Call:  load_spots {role {fade OUT}}
#	Input parameters: role: role of variable
#							fade: direction of the hotspot list
#									Could be OUT or IN, if it's somethingelse then OUT is used.
#	Return value: list of hotspots. In case of errors empty list.
#	Examble: load_spots FIXED out
#	Fuctionality: Reads piclist file and finds names for role. 
#	See also: 
#	History:	2.7.2002 Mikko Korhonen
#				10.6.2003 Ville Rapa 
#	
#*************************************************************}}}
proc load_spots { role {fade OUT} } {
   
	global gb debug 
	
	#open, read and close file
	if [catch {
		set fileName [file join $gb(hotspotFilePath) $gb(hotspotFile)]
		set fileId [open $fileName r]
	    set koko [read $fileId]
		close $fileId
   }] {
		errorHandler 11 no
	}
	switch $role {
		FIXED { set expr "(<FIXED-VALUE>\n)(.*)(\n</FIXED-VALUE>)" }
		CONS { set expr "(<CONSTANT>\n)(.*)(\n</CONSTANT>)" }
        MRH     { set expr "(<MOST-RECENT_HOLDER>\n)(.*)(\n</MOST-RECENT_HOLDER>)" }
        GATH    { set expr "(<GATHERER>\n)(.*)(\n</GATHERER>)" }
        FOLL    { set expr "(<FOLLOWER>\n)(.*)(\n</FOLLOWER>)" } 
        MWH     { set expr "(<MOST-WANTED_HOLDER>\n)(.*)(\n</MOST-WANTED_HOLDER>)" } 
        OWF     { set expr "(<ONE-WAY_FLAG_lamp>\n)(.*)(\n</ONE-WAY_FLAG_lamp>)" } 
        ORGA    { set expr "(<ORGANIZER>\n)(.*)(\n</ORGANIZER>)" } 
        STEP    { set expr "(<STEPPER>\n)(.*)(\n</STEPPER>)" } 
        TEMP    { set expr "(<TEMPORARY_off>\n)(.*)(\n</TEMPORARY_off>)" } 
        OTHER   { set expr "(<OTHER>\n)(.*)(\n</OTHER>)" }
        OTHE   { set expr "(<OTHER>\n)(.*)(\n</OTHER>)" }
        TEMP_ON { set expr "(<TEMPORARY_on>\n)(.*)(\n</TEMPORARY_on>)" }
        OWF_BR  { set expr "(<ONE-WAY_FLAG_broken>\n)(.*)(\n</ONE-WAY_FLAG_broken>)" }
        MRH-STEP { set expr "(<MOST-RECENT_HOLDER_to_STEPPER>\n)(.*)(\n</MOST-RECENT_HOLDER_to_STEPPER>)" }
        TRANS  { set expr "()(.*)()" } 
		default { 
			set expr -1 
		}
	
	}	
    
	if [catch {
			set result [regexp $expr $koko match eka toka]            
                set ret [split $toka "\n"]
            if {[string equal -nocase $fade IN]} {
	            set ret [lsort -dictionary -decreasing $ret]
	        } else {
	            set ret [lsort -dictionary -increasing $ret]
	        }
        
        
        }] {
			# TODO debug 
			# No role found or piclist file malformated
			set ret -1
			}
		
   #Sort list  
	#if param. fade is OUT the first is actual role picture.
	return $ret
}

#}}}
#{{{ Function: countHS
#{{{*************************************************************
#	
#	Function: ountHS {borders HS}	
#	References:	
#	Description:
#	Call:  
#	Input parameters: 
#	Output parameters:   
#	Return value:
#	Examble: 
#	Fuctionality:  
#	Limits: 
#   Side effects:
#	See also: 
#	History:	15.8.2002 Mikko Korhonen
#	
#*************************************************************}}}

proc countHS {borders HS} {
    set x1 [lindex $borders 0].000
    set y1 [lindex $borders 1].000
    set width [expr [lindex $borders 2] - [lindex $borders 0]]
    set heigth [expr [lindex $borders 3] - [lindex $borders 1]]
    set HSx [lindex $HS 0]
    set HSy [lindex $HS 1]
    return "[expr ($width*$HSx)+$x1] [expr ($heigth*$HSy)+$y1]"
}

#}}}
#{{{ Function: get_txt

proc get_txt { tag } {
	global gb
	return [lindex [$gb(var) itemconfig $tag -text] end ]
}

#}}}
#{{{ Function: animate_gifs

proc animate_gifs  { area type x y fade} {
	
	global gb 
	set pics [load_pic $type yes $fade]
	foreach pic_name $pics {
		set tmp [gb_pic_create $area $x $y $gb(path_pic)/$pic_name]
		update
		after $gb(speed)	
		gb_destroy $tmp
		#update 
	}
}

#}}}
#{{{ Function: scrolled_canvas
#{{{*************************************************************
#	
#	Function:	scrolled_canvas { c sidey top_bottom args }
#	References:	
#	Description: Creates scrollable cavas with sidebar
#	Call: scrolled_canvas 
#	Input parameters: c: frame path
#							sidey: side of the linear scrollbar
#							top_bottom: side of the vertical scrollbar
#							args: rest of the argument to canvas item.
#	Output parameters:  none 
#	Return value: canvas path
#	Examble: scrolled_canvas .main left top
#	Fuctionality:  creates canvas.
#	Limits: 
#   Side effects:
#	See also:  
#	History:	15.8.2002 Ville Rapa. Copy from First version of PlanAni
#	
#*************************************************************}}}

proc scrolled_canvas { c sidey top_bottom args } {
	canvas $c
	eval {canvas $c.canvas \
		-xscrollcommand [list $c.xscroll set] \
		-yscrollcommand [list $c.yscroll set] \
		-highlightthickness 0 \
		-borderwidth 0} $args
	scrollbar $c.xscroll -orient horizontal \
		-command "scroll_x [list $c.canvas xview]"
	scrollbar $c.yscroll -orient vertical \
		-command "scroll_y [list $c.canvas yview]"
	pack $c.yscroll -side $sidey -fill y
	pack $c.xscroll -side $top_bottom -fill x
	pack $c.canvas -side top -fill both -expand true
	pack $c 
	return $c.canvas
}

#}}}
#{{{ Function: scroll_x
#{{{*************************************************************
#	
#	Function: scroll_x { args }	
#	References:	
#	Description: move object which are in are drown in multible canvases.
#	Call: scroll_y $canvas_path 
#	Input parameters: args: canvas_path which moved.
#	Output parameters:  none 
#	Return value: none
#	Examble: scroll_x $canvas_path 
#	Fuctionality:  
#	Limits: 
#   Side effects:
#	See also: update_multi_line
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc scroll_x { args } { 
	global gb
	eval $args
	set objs [[lindex $args 0] find with $gb(multi)]
	if { [llength $objs] > 0 } {
		foreach obj $objs {
			set tags [[lindex $args 0] itemconfig $obj -tags] 
			set tags [lindex $tags end]
			update_multi_line [lindex $tags 0]
		}
	}
}

#}}}
#{{{ Function: scroll_y
#{{{*************************************************************
#	
#	Function: scroll_y { args }	
#	References:	
#	Description: move object which are in are drown in multible canvases.
#	Call: scroll_y $canvas_path 
#	Input parameters: args: canvas_path which moved.
#	Output parameters:  none 
#	Return value: none
#	Examble: scroll_y $canvas_path 
#	Fuctionality:  
#	Limits: 
#   Side effects:
#	See also: update_multi_line
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}
 
proc scroll_y { args } { 
global gb
	eval $args
	set objs [[lindex $args 0] find with $gb(multi)]
	
	if { [llength $objs] > 0 } {
		foreach obj $objs {
			set tags [[lindex $args 0] itemconfig $obj -tags] 
			set tags [lindex $tags end]
			update_multi_line [lindex $tags 0]
		}
	}

}

#}}}
#{{{ Function: get_place_and_values
#{{{*************************************************************
#	
#	Function: get_place_and_values { tag }
#	References:	
#	Description:
#	Call:  
#	Input parameters: 
#	Output parameters:   
#	Return value:
#	Examble: 
#	Fuctionality:  
#	Limits: 
#   Side effects:
#	See also: gb_var_get_values
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc get_place_and_values { tag } {
	global gb
	 set pl {}
	 set spots [gb_var_get_values $tag]
		foreach spot $spots {
			lappend pl [lindex [lindex [$gb(var) itemconfig $spot -tags] end ] end ]
		} 
	return $pl
	
}

#}}}
#{{{ Function: empty
proc empty { } { }
#}}}
#{{{ Function: not_in_function
#{{{*************************************************************
#	
#	Function: not_in_function { {mess NULL} }
#	References:	
#	Description: Creates message box 
#	Call:  not_in_function 
#	Input parameters: mess: message to message box. Default is null which adds 
#									text from global variable txt(nif)
#	Output parameters:  None. 
#	Return value: None
#	Examble: not_in_function
#				not_in_function "Examble message"
#	Fuctionality: Creates message box with text $mess or global $txt(nif)  
#	Limits: 
#   Side effects:
#	See also: $txt(nif)
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc not_in_function { {mess NULL} } {
	global txt
	if { [string equal $mess "NULL"]} {
		 set mess $txt(nif)
	} 
	tk_messageBox -type ok -message $mess
	update

}
#}}}
#{{{ Function: update_font
#{{{*************************************************************
#	
#	Function: update_font	
#	References:	
#	Description: Updates all text objects font atribute.
#	Call: update_font 
#	Input parameters:  None.
#	Output parameters:   None.
#	Return value:None.
#	Examble: update_font
#	Fuctionality: Configure items text atribute using $gb(font_family), $gb(font_size) and 
#						$gb(font_style)
#	Limits: 
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc update_font { } {
	global gb
	
	lappend new_font $gb(font_family)
	lappend new_font $gb(font_size)
	lappend new_font $gb(font_style)
	set gb(gb_font) $new_font
	foreach area $gb(areas) {
		set txt_objs [$area find withtag "txt" ]
		foreach obj $txt_objs {
			$area itemconfigure $obj -font $gb(gb_font)
		}
	}
	
}
#}}}
#{{{ Function: help_window
#{{{*************************************************************
#	
#	Function: help_window
#	References:	
#	Description: Opens new window and add text from help file to that window. 
#	Call: help_window 
#	Input parameters: None.
#	Output parameters:   None
#	Return value: None
#	Examble: help_window
#	Fuctionality: Creates new window and adds text from help.txt file.  
#	Limits: 
#   Side effects: None
#	See also: 
#	History:	3.1.2002 Ville Rapa
#	
#*************************************************************}}}

proc help_window { } { 
	global txt gb
	
	set w .helpmode
   	catch { destroy $w }
	
	
	toplevel $w
	wm title $w $txt(help_title)
	wm iconname $w $txt(help_title)
	wm geometry $w 600x600
	
	if {[file exists "$gb(path)/help.txt"]} {
		
		set fileId [open $gb(path)/help.txt r]
	
		scrollbar $w.vscroll -command "$w.text yview"
		pack $w.vscroll -side right -fill y

		set t [text $w.text -yscrollcommand "$w.vscroll set"]
		pack $t -fill both -expand yes
		set line1 "Planani"
		set line2 "University of Joensuu, Finland"
		set line3 "Version: $gb(version)"
		$t insert end "$line1\n"
		$t insert end "$line2\n"
		$t insert end "$line3\n\n\n"
		while  { [gets $fileId line] >= 0 } {
		
			$t insert end "$line\n"
		}	
		close $fileId
	} else {
		destroy $w
	}	
}
#}}}
#{{{ Function: findArgs
#{{{*************************************************************
#	Function: findArgs	
#	Description: finds values for parameter from given list.  
#	Call:  findArg { token parameters }
#	Input parameters: token : parameter to be searched.
#					  parameters : list of parameters and values 
#	Examble: findArg coords {-coords 10 10 -color red}
#	Fuctionality: splits parameter list and gets values. 
#	History:	16.6.2003 Ville Rapa
#*************************************************************}}}

proc findArg { token parameters } {
    set ret ""
    set params [split $parameters "-"]
    foreach index $params {
        if { [string equal -nocase [lindex $index 0] $token] } {
            if { [llength $index] > 0 } {
                set ret [lrange $index 1 end]
            } 
        }
    }    
    return $ret
}
#}}}
