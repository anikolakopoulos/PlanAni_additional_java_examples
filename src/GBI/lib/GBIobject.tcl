# Copyright (c) 2003 University of Joensuu,
#                    Department of Computer Science

#global variable to correct curves at arrows.
global arrowCorrection
set arrowCorrection 21
global tcl_platform
switch -regexp $tcl_platform(platform) {
    ^[wW][iI]* {
        set arrowCorrection 17
    }
}
#################################################################
#
#		TEXT OBJECT
#
#{{{ Function: gb_text_create 
#{{{*************************************************************
#	
#	Function: gb_text_create.	
#	References:	
#	Description: Create text object.		
#	Call: gb_text_create area x y text [color] [anchor].
#				
#	Input parameters:
#				area :Cansvas name where text object is created to.
#				x,y : Coordinates where object is created to.
#				text : Text to be displayed
#				color : color of text. This is optional.
#				anchor : tk text object parameter. 
#	Output parameters:   
#	Return value:Id of the created object.
#	Examble: gb_text_create "var" 1 1 "Hello World!". 
#				gb_text_create "var" 1 1 "Hello World!" blue.
#			 	gb_text_create "var" 1 1 "Hello World!" NULL c
#	Fuctionality: 	 
#	Limits: Area parameter must be "var" ,"src" or "io".
#   Side effects:
#	See also:
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}
proc gb_text_create {area x y txt {color NULL} {anchor nw}} {
	
	global gb
	set area_path [get_area_path $area]
	if { $area_path != -1 } {
		if { [string equal $color NULL] } {
			set color $gb(color)
		}
		# get next object identifier. Set to objects tag.
		set id [get_next_objectid]
		# Create text
		$area_path create text $x $y -text $txt \
					-fill $color -font $gb(gb_font) \
					-anchor $anchor -tag "$id txt"
			
		return $id
	} else {
		return -1
	}
}

#}}}
#{{{ Function: gb_text_mark
#{{{*************************************************************
#	
#	Function: gb_text_mark	
#	References:	
#	Description: Mark the spesified part of the text.	
#	Call: gb_text_mark id [start 0] [end end] [color red] 
#	Input parameters: id : Identification of object.
#							start : Starting point of marking. Character position in the string.
#							end : End poind of marking.
#							color : mark color. 
#	Output parameters:   
#	Return value: Id to the mark object.
#	Examble: gb_text_mark objId 1 3 green. 
#				gb_text_mark objId 1 3.
#				gb_text_mark objId 1.
#				gb_text_mark objId 0 end.
#				gb_text_mark objId.
#	Fuctionality: Creates colored rectancle under the text.	 
#	Limits: In the function call there is tree optional parameter, but you can't leave middle parameter out of the call.
#  		example: gb_text_mark objId 1 red is illecal.
#   Side effects:
#	See also: usage of optional parameters in tcl. 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}
proc gb_text_mark { id {start 0} {end end} {color red} } {
	global gb
	set obj [get_object $id]
	set area [lindex $obj 1]
	set obj_id [lindex $obj 0]
	#Find text
	set txt [ $area itemcget $obj_id -text ]
	#find position at the string
	set tmp_to_mark [string range $txt $start $end]
	#Get sub string which vill be marked. This way one knows the size
	#of the mark rec.
	set tmp_txt [string range $txt 0 [expr $start -1]]
	
	set first [$area create text [gb_get_position $id] -text $tmp_txt -font $gb(gb_font) -fill red -anchor nw]

	set start_x [lindex [$area bbox $first] 2]
	set start_y [lindex [gb_get_position $id] 1]
	set newId [get_next_objectid]	
	$area delete $first 
	set first [$area create text $start_x $start_y\
				-text $tmp_to_mark -font $gb(gb_font) -fill $gb(bg_color) -anchor nw] 
	#set tmp_txt [ $area create text ]
	set sq_co [$area bbox $first]
	set r [$area create rec\
				[lindex $sq_co 0]\
				[lindex $sq_co 1]\
				[lindex $sq_co 2]\
				[lindex $sq_co 3]\
				-fill $gb(mark_color)\
				-width 0\
				-outline white -tags "korostus korostus$newId"]
	
	$area lower $r
	$area delete $first
	update
	return "korostus$newId [lindex $obj 1] [ get_bordels korostus$id ]"
}

#}}}
#{{{ Function: gb_text_unmark
#{{{*************************************************************
#	
#	Function: gb_text_unmark	
#	References:	
#	Description: unmark spesified text.	
#	Call:	unmark id
#	Input parameters: id : identification of the object.
#	Output parameters:   
#	Return value: none.
#	Examble:  gb_text_unmark objId.
#	Fuctionality: Deletes alla objects identified by parameter ID.	 
#	Limits: 
#   Side effects: 
#	See also:
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}
proc gb_text_unmark { id } {
	global gb
	foreach key $gb(areas) {
		[lindex $id 1] delete [lindex $id 0]	
	}	
}

#}}}
#{{{ Function: gb_text_unMark

proc gb_text_unMark { id path args} {
	$path delete $id
}

#}}}
#{{{ Function: gb_text_unmark_all
#{{{*************************************************************
#	
#	Function: gb_text_unmark_all	
#	References:	
#	Description: unmark all texts.	
#	Call: gb_text_unmark_all
#	Input parameters: none
#	Output parameters: none  
#	Return value: none
#	Examble: gb_text_unmark_all  
#	Fuctionality: deletes all objects identified by tag korostus.	 
#	Limits: 
#   Side effects:
#	See also:
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}
proc gb_text_unmark_all { } {
	global gb
	foreach key $gb(areas) {
		$key delete korostus	
	}
}

#}}}
#{{{ Function: gb_text_read
#{{{*************************************************************
#	
#	Function: gb_text_read
#	References:	
#	Description: Reads input from entry field.	
#	Call: gb_text_read.
#	Input parameters: none
#	Output parameters: none  
#	Return value: value of input.
#	Examble: gb_text_read 
#	Fuctionality: Set focus to the entry field and waits until user press enter. 
#	Limits: 
#   Side effects: Input length is limited by property of entry field.
#	See also:
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}
proc gb_text_read { } {
	global syotetty entry_field enter gb 
	
	set correct 0
	$gb(io) delete $gb(input_id)
	set gb(input_id)	[gb_pic_create "io" 225 45 $gb(input_pic)]
	focus $gb(ent)
	while { !$correct } {
		$gb(ent) delete 0 end
	    set gb(syotetty) 0
		if  { $gb(randomInput) } {
	    	set gb(entry_value) [expr int(20 * rand())]
	    	after $gb(speed) set syotetty 1
		}
		vwait syotetty
		set gb(entry_value) [$gb(ent) get]
		if { ([string is wordchar $gb(entry_value) ] || [string is integer $gb(entry_value)]) &&  $gb(entry_value) != ""  } {
		    set correct 1
	    }
	}
	
	set tmp $gb(entry_value)
	focus $gb(ent)
	set gb(syotetty) 0
	focus .
	set gb(entry_txt) [gb_text_create "io" [expr [lindex $gb(ent_co) 0]-5] [expr [lindex $gb(ent_co) 1]-2] $tmp]
	$gb(io) itemconfigure $gb(entry_txt) -fill $gb(bg_color)
	$gb(io) delete $gb(input_id)
	set gb(input_id)	[gb_pic_create "io" 225 45  inputpas.gif]
	$gb(io) raise $gb(entry_txt)
	return $tmp
}

#}}}
#{{{ Function: gb_animate_entry
#{{{*************************************************************
#	
#	Function: gb_animate_entry 
#	References:	
#	Description: Animate text object from Entry field to the variable object.	
#	Call: gb_animate_entry value varId place tag NULL
#	Input parameters: value : value to be animated.
#							varId : destination object.
#							place : Variables hotspot where value is assigned.
#							tag : object from area "src". if Tag not NULL then there will be arrow following the animation. 
#	Output parameters: none   
#	Return value: none
#	Examble: gb_animate_entry "ada" $varId 1 NULL
#				gb_animate_entry "5" $varId 1 $txtId 
#	Fuctionality: Move objects between varId ad entry field. In the edge of canvases cgeate copies and deletes old ones.	 
#	Limits:  
#   Side effects:
#	See also:
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}
proc gb_animate_entry { value varId place { tag NULL} {array 0}} {
	
	global gb
	$gb(ent) delete 0 end
	$gb(io) itemconfigure $gb(entry_txt) -fill $gb(color)
	set arr NULL
	if { ![string equal $tag "NULL"] } {
        if { [catch {
			set co [$gb(src) bbox $tag]
			set y_pos [expr (([ lindex $co 3] - [ lindex $co 1]) / 2) + [lindex $co 1]]
			set arr [gb_arrow_create src [ lindex $co 2] $y_pos \
											 src [winfo width $gb(src)] \
											 [expr ([winfo height $gb(var)] + [lindex $gb(ent_co) 1])-10 ]\
											 2 ]	
			} result ]} {
						
						}	
	}
    
	set role [gb_var_get_role $varId]
    set spots [lindex [load_spots $role] 0]  
    if {$array == 0} {
        set spot [map_spot_coords $varId [lindex $spots 1]]
    } else {
        set spot [lrange [$gb(var) bbox "$varId 0 1 $array"] 0 2]
    }
	set v $gb(entry_txt)
   $gb(var) itemconfig $v -anchor c
   update
		
	set cross [get_cross_road io [lindex $gb(ent_co) 0] [lindex $gb(ent_co) 1] var [lindex $spot 0] [lindex $spot 1]]
	
	move $v  $cross 0 $arr
	set h [ winfo height $gb(var)] 
	set wh [$gb(var) canvasy $h]
	
	set v [copy_txt_object $v "var" [$gb(var) canvasx $cross] $wh]
   $gb(var) itemconfig $v -anchor c
	
	move $v [lindex $spot 0] [lindex $spot 1] $arr
	if {!$array} {
		gb_var_set_value $varId $value
	}
	gb_destroy $v
    
	gb_destroy $arr
	
}

#}}}
#{{{ Function: gb_text_change_color

proc gb_text_change_color {tag color} {
	global gb
	[get_area $tag] itemconfig $tag -fill $color
}
#}}}
#
#		END OF TEXT OBJECT
#
#######################################################################

#######################################################################
#
#		ARROW OBJECT
#

#{{{ Function: gb_arrow_create
#{{{*************************************************************
#	
#	Function: gb_arrow_create	
#	References:	 
#	Description: Choose the arrow creation function depending on parameters.	
#	Call: gb_arrow_create "var" 100 100 "src" 100 100 3 "tämä on tagi"
#	Input parameters: args : list of parameters.
#	Output parameters:   
#	Return value: Object identification
#	Examble: gb_arrow_create "var" 100 100 "src" 100 100 3 "tämä on tagi"
#				gb_arrow_create "var" 100 100 "src" 100 100 3 	
#				gb_arrow_create  $varId $varId
#				gb_arrow_create  $varId $varId 6  
#	Fuctionality: Choose the arrow creation function depending on parameters.	 
#	Limits: args length must be: 2, 3 ,7 or 8.
#   Side effects:
#	See also:
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_arrow_create { args } {
	
	#global gb
	
	set len [llength $args]
	if { $len == 8 } {
		set ret [arrow_create2 [lindex $args 0] [lindex $args 1] [lindex $args 2] \
						  [lindex $args 3] [lindex $args 4] [lindex $args 5] [lindex $args 6] [lindex $args 7]]
	} elseif { $len == 7} {
		set ret [arrow_create2 [lindex $args 0] [lindex $args 1] [lindex $args 2] \
						  [lindex $args 3] [lindex $args 4] [lindex $args 5] [lindex $args 6] ]
	} elseif { $len == 2} {
		set ret [arrow_create_o2o [lindex $args 0] [lindex $args 1]]
	}	elseif { $len == 3 } {
		set ret [arrow_create_o2o [lindex $args 0] [lindex $args 1] [lindex $args 2]]
	} else {
	 set ret -1
	}
 	return $ret
}

#}}}
#{{{ Function: arrow_create_o2o
#{{{*************************************************************
#	
#	Function: arrow_create_o2o	
#	References:	
#	Description: Creates arrow between two objects.	
#	Call: arrow_create_o2o { obj1 obj2 { thickness 3 } }
#	Input parameters: obj1: object identifier 
#							obj2: object identifier
#							thickness: thickness of array
#	Output parameters:   None.
#	Return value: Identifier to object.
#	Examble: arrow_create_o2o $startObj $endObj 7 
#	Fuctionality: calculate start and end point and creates arrow 	 
#	Limits: 
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}
proc arrow_create_o2o { obj1 obj2 { thickness 3 } } {
	global gb
	set area_obj1 [lindex [get_object $obj1] end]
	set area_obj2 [lindex [get_object $obj2] end]
	set start_x [lindex [$area_obj1 bbox $obj1] 2]
	set start_y [expr  (([lindex [$area_obj1 bbox $obj1] 3] - [lindex [$area_obj1 bbox $obj1] 1]) / 2) + \
				    [lindex [$area_obj1 bbox $obj1] 1] ]
	set end_x [lindex [$area_obj2 bbox $obj2] 0]
	set end_y [expr  (([lindex [$area_obj2 bbox $obj2] 3] - [lindex [$area_obj2 bbox $obj2] 1]) / 2) + \
				    [lindex [$area_obj2 bbox $obj2] 1] ]
	set ret [gb_arrow_create [get_area_name $area_obj1] $start_x $start_y [get_area_name $area_obj2] \
						 $end_x $end_y 3]
	return $ret
}

#}}}
#{{{ Function: arrow_create
#{{{*************************************************************
#	
#	Function: arrow_create
#	References:	
#	Description: Creates arrow 	
#	Call: arrow_create { area x y xx yy thickness {tag "arrow"}}
#	Input parameters: area: name of the canvas 
#							x: start point x-coordinate
#							y: start point y-coordiante
#							xx: end point xx-coordinate
#							yy: end point y-coordinate
#							thickness:thickness of the arrow
#							tag: tag to arrow.
#	Output parameters:  none 
#	Return value: identifier to created arrow
#	Examble:  arrow_create "src" 10 10 100 100 3 
#	Fuctionality: create arrow.	 
#	Limits: 
#   Side effects:
#	See also:
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}
proc arrow_create { area x y xx yy thickness {tag "arrow"}} {
	global gb 
	set area_path [get_area_path $area]
	if { $area_path != -1 } {
		set id [get_next_objectid] 
		$area_path create line $x $y $xx $yy \
				-arrow last -fill $gb(mark_color) \
				-width $thickness -tag $id 
		$area_path addtag $tag withtag $id
		return $id
	} else {
		return -1
	}
}

#}}}
#{{{ Function: arrow_create2
#{{{*************************************************************
#	
#	Function: arrow_create2	
#	References:	
#	Description: Creates arrow between two canvases.	
#	Call: arrow_create2 { area x y area2 x2 y2 thickness   {tag "arrow"} }
#	Input parameters: area :name of the start point canvas							
#							x: start point x-coordinate
#							y: start point y-coordiante
#							area2: name of the end point canvas
#							xx: end point xx-coordinate
#							yy: end point y-coordinate
#							thickness:thickness of the arrow
#							tag: tag to arrow.
#	Output parameters: None  
#	Return value: identifier to created arrow
#	Examble: arrow_create2 "src" 10 10 "var" 10 10 4
#	Fuctionality: calculates intersection of canvases. Creates line to start point canvas and
#						arrow to end point canvas. All cavas combinations are handled seperately.	 
#	Limits: 
#   Side effects:
#	See also:
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}
proc arrow_create2 { area x y area2 x2 y2 thickness   {tag "arrow"} } {
	
	global gb arrowCorrection 
	set clone "$area $x $y $area2 $x2 $y2 $thickness"	
	if {$area == $area2 } {
		return [arrow_create $area $x $y $x2 $y2 $thickness]
	
	} else {
			
		set area_1 [get_area_path $area]
		set area_2 [get_area_path $area2]
		
		switch -- $area {
				"src" {
					set x_tmp [[get_area_path $area] canvasx $x]
					set y_tmp [[get_area_path $area] canvasy $y]		
					set xpoint 	[winfo width $area_1]
					update idletasks
					
					if { $area2 == "var" } {
						set x2_tmp [$area_2 canvasx $x2]
						set y2_tmp [$area_2 canvasy $y2]			
						set cross [get_cross_road $area  [expr $x - ($x_tmp - $x)] [expr $y - ($y_tmp - $y)] \
						$area2 [expr $x2 - ($x2_tmp - $x2) ] [expr $y2 - ($y2_tmp - $y2)] ]
						set x2_tmp2 [$area_2 canvasx 0]
						set y2_tmp2 [$area_2 canvasy  $cross]
						set x_tmp2  [$area_1 canvasx $xpoint] 
						set y_tmp2	[$area_1 canvasy $cross]
						
						set l [gb_line_create $area $x $y $area $x_tmp2 [expr $y_tmp2 + $arrowCorrection] $thickness]
						set a [arrow_create $area2 $x2_tmp2 $y2_tmp2 $x2 $y2  $thickness $gb(multi)]						
						
						group_obj_tags $a $l
						addtag $gb(multi) $a $l 
						addtag $clone $a $l
						update
						return $a
						
					} else {
						set area_var [get_area_path "var"]
						set ypoint_tmp [winfo height $area_var]
						#[lindex [$area_var configure -height] 4]
						
						set ypoint [$area_var canvasy $ypoint_tmp]
						set cross [get_cross_road $area [expr $x - ($x_tmp - $x) ] [expr $y - ($y_tmp - $y)] $area2 $x2 $y2 ]
						
						if { $cross < $ypoint_tmp } {
							set x_tmp2 [$area_var canvasx 0]
							set y_tmp2 [$area_var canvasy $cross]
							set cross_x [$area_var $x_tmp2 $y_tmp2 $area2 $x2 $y2]
							set x_tmp3 [$area_var canvasx $cross_x]
							set y_tmp3 $ypoint
							set x_tmp4 [$area_var canvasx $xpoint]
							set y_tmp4 [[get_area_path "src"] canvasy $cross]
							
							set l [gb_line_create $area $x $y $area  $x_tmp4 [expr $y_tmp4 ] $thickness $tag]
							set l2 [gb_line_create "var" $x_tmp2 [expr $y_tmp2 - $arrowCorrection] "var" $x_tmp3 $y_tmp3 $thickness $tag]
							set a [arrow_create $area2 $x_tmp3 0 $x2 $y2 $thickness $gb(multi)]
							
							group_obj_tags $a $l
							group_obj_tags $a $l2
							addtag $gb(multi) $a $l $l2
							addtag $clone $a							
							return $a
							
						} else { 		
							
							set x_tmp2 [$area_1 canvasx $xpoint]
							set y_tmp2 [$area_1 canvasy $cross]						
							set l [gb_line_create $area $x $y $area $x_tmp2 $y_tmp2 $thickness $tag]	
							
							#set DifferenceBetweenWinAndUx 21
							set a [arrow_create $area2 0 [expr ($cross - $ypoint_tmp)-$arrowCorrection] $x2 $y2 $thickness $tag]
							group_obj_tags $a $l
							addtag $gb(multi) $a $l	
							
							addtag $clone $a
							
							return $a
						}
					}
					
				}
				
				"var" {
					if {$area2 == "src" } {
						set a [gb_arrow_create $area2 $x2 $y2 $area $x $y $thickness $tag]
						[get_area_path $area] itemconfig $a -arrow none
						[get_area_path $area2] itemconfig $a -arrow first
						addtag $clone $a
						return $a
					} else {
						
						set area_p [get_area_path $area]
						set y_cross_tmp [winfo height $area_p] 
						#[lindex [$area_p configure -height] 4] 
						set y_cross_tmp2 [$area_p canvasy $y_cross_tmp]
						set y_cross [expr $y_cross_tmp - ($y_cross_tmp - $y_cross_tmp2)]						
						set x_tmp [$area_p canvasx $x]
						set y_tmp [$area_p canvasy $y]
						
						set x_real [expr $x - ($x_tmp- $x)]
						set y_real [expr $y - ($y_tmp- $y)]
						
						set x_cross_tmp [get_cross_road $area $x_real $y_real $area2 $x2 $y2 ]
						set x_cross_tmp2 [$area_p canvasx $x_cross_tmp]
						set x_cross [expr $x_cross_tmp - ($x_cross_tmp - $x_cross_tmp2)] 
						
						set l [gb_line_create $area $x $y $area $x_cross $y_cross $thickness $tag]
						set a [arrow_create $area2 $x_cross_tmp 0 $x2 $y2 $thickness $tag]
						group_obj_tags $a $l
						addtag $gb(multi) $a $l
						addtag $clone $a
						return $a
					}
					
				}
				"io" {
					
					if { $area2 == "var" } {												
						set a [gb_arrow_create $area2 $x2 $y2 $area $x $y $thickness $tag]
						[get_area_path $area] itemconfig $a -arrow none
						[get_area_path $area2] itemconfig $a -arrow first
						$area_1 dtag "$area2 $x2 $y2 $area $x $y $thickness"
						$area_1	addtag $clone withtag $a
						addtag $gb(multi) $a
						return $a						
					} else {
						set a [gb_arrow_create $area2 $x2 $y2 $area $x $y $thickness $tag]
						[get_area_path $area] itemconfig $a -arrow none
						[get_area_path $area2] itemconfig $a -arrow first
						$area_1 dtag "$area2 $x2 $y2 $area $x $y $thickness"
						addtag $gb(multi) $a
						$area_1	addtag $clone withtag $a
						
						return $a
					}
					
				}			
		}
		update
	}
}

#}}}
#{{{ Function: gb_arrow_change_color

proc gb_arrow_change_color {tag color} {
	global gb
	[get_area $tag] itemconfig $tag -fill $color
}

#}}}
#
#		END OF ARROW OBJECT
#
#######################################################################

#######################################################################
#
#		LINE OBJECT
#
#{{{ Function: gb_line_create
#{{{*************************************************************
#	
#	Function: gb_line_create	
#	References:	
#	Description: Creates line.	
#	Call: gb_line_create { area x y area2 xx yy thickness {tag line}} 
#	Input parameters: area :name of the start point canvas							
#							x: start point x-coordinate
#							y: start point y-coordiante
#							area2: name of the end point canvas
#							xx: end point xx-coordinate
#							yy: end point y-coordinate
#							thickness:thickness of the arrow
#							tag: tag to arrow. 
#	Output parameters:   
#	Return value: identifier to object.
#	Examble: gb_line_create "src" 10 10 "src" 20 20 4 
#	Fuctionality: 	 
#	Limits: 
#   Side effects:
#	See also:
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}
proc gb_line_create { area x y area2 xx yy thickness {tag line}} {
	global gb
	set area_path [get_area_path $area]
	if { $area == $area2} {
	
		if { $area_path != -1 } {
			set id [get_next_objectid]
			$area_path create line $x $y $xx $yy \
			-fill $gb(mark_color) -width $thickness  -tag "$id $tag"
			
			return $id
		
		} else {
			return -1
		}
	} else {
		set area2_path [get_area_path $area2]
		set arr [gb_arrow_create $area $x $y $area2 $xx $yy $thickness]
		set end [$area2_path find $arr]
		if { [llength $end] == 1 } {
			 $area2_path itemconfigure $end -arrow none
		}

	}
}

#}}}
#
#		END OF LINE OBJECT
#
#######################################################################

#######################################################################
#
#		PICTURE OBJECT
#
#{{{ Function: gb_pic_create
#{{{*************************************************************
#	
#	Function: gb_pic_create	
#	References:	
#	Description:	
#	Call:gb_pic_create { area x y pic_name {tag pic}}
#	Input parameters:
#	Output parameters:   
#	Return value: identifier to picture object. -1 if error occurs.
#	Examble:  gb_pic_create "var" 200 200 picture.gif
#	Fuctionality: Cretes picure item . loads picture from $gb(path_pic) directory	 
#	Limits: 
#   Side effects:
#	See also:
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}
proc gb_pic_create { area x y pic_name {tag pic}} {
	global gb
	# get canvas path	
	set area_path [get_area_path $area]
	if { $area_path != -1 }  {
		set id [get_next_objectid]
		# Create picture
		set pix [file join $gb(path_pic) $pic_name]
		image create photo $pic_name -file $pix
		set pic_id [$area_path create image $x $y -image $pic_name -anchor nw -tags $id]
         $area_path addtag "$id $tag" withtag $id
		return $id
	} else {
		return -1
	}
}

#}}}
#
#		END OF PICTURE OBJECT
#
#######################################################################

#######################################################################
#
#		VARIABLE OBJECT
#
#{{{ Function: gb_var_create

proc gb_var_create {role args} {
    global gb 
    #parse args
	
	set container {}
    set name [findArg name $args]
    set value [findArg value $args]
    set coords [findArg coords $args]
    set array [findArg array $args]
	
    if {[string equal $role STEP]} {
        set direction [findArg direction $args]
        if { ![string equal $direction "rigth"] } {
            set direction "left"
        }
        lappend container $direction
    }
     
    if { [string equal $name ""] } {
        set name " "
    }
    
    if { [string equal $value ""]} {
        set value " "
    }
	# set coordinates
    if { [string equal $coords ""] && [llength $coords] < 2} {
        set co [$gb(var) bbox all]
	    if { [llength $co] == 0 } {
			set coords {10 40}
		} else {
          	if {[string equal -nocase $array ""] } {
				set coords "10 [expr [lindex $co 3] + 45]"
			} else {
				# more space for array indexes.
            	set coords "10 [expr [lindex $co 3] + 60]"
			}
        }
        #expand scrollregion if needed.
		set scrr [ lindex [$gb(var) configure -scrollregion]  end ]
		if { [lindex $scrr 3] < [expr [lindex $coords 3] + 120] } {
			set jelp [lreplace $scrr 3 3 [expr [lindex $scrr 3] + 500]]
			$gb(var) configure -scrollregion $jelp
								
		}
    } else {
        set coords "[lindex $coords 0] [lindex $coords 1]"
    }
    
    if { [string equal $array ""]} {
        set array "NULL"
    }
    return [tmp_var_create $role $coords $name $value $array $container]
}

#}}}
#{{{ Function: tmp_var_create

proc tmp_var_create {role coords name value array args} {
    
	global gb
    
	set area_path $gb(var)
    set nameId [gb_text_create "var" [lindex $coords 0] [lindex $coords 1] $name]	
	set co_name [get_bordels $nameId]
	set x2 [expr [lindex $co_name 2] + 2]		
	#Calculate middle x of name text.
	set yHelp [lindex $co_name 1]
	set y2Help [lindex $co_name 3]		
	set y2 [expr ((($y2Help - $yHelp) / 2) + $yHelp )]
    if { [string equal $role OWF] } {
        if { [string equal -nocase $value true] } {
            set pic [lindex [load_pic $role] 0]
        } else {
            if { [string equal -nocase $value false] } {
                set pic [lindex [load_pic OWF_BR] 0]
            } else {
                set pic [lindex [load_pic $role] 7]
            }
        }
    } else {        
        set pic [lindex [load_pic $role] 0]
    }
	set picId [gb_pic_create "var" $x2 $y2 $pic]
	set co_pic [get_bordels $picId]
	set h  [expr [lindex $co_pic 3] - [lindex $co_pic 1]] 
	$area_path move $picId 0 -[expr $h / 2]
    $area_path addtag "$nameId name" withtag $nameId 
    $area_path addtag "ROLE $role" withtag $nameId
    $area_path addtag "PIC_1 $picId" withtag $nameId
    if {![string equal -nocase $array null]} {
        var_set_length $nameId $array $role $pic
        $area_path addtag "Array $array" withtag $nameId
        for {set i 2} { $i <= $array } {incr i} {
            gb_var_set_value $nameId " " 0 1 $i
        }
    }

    #Extra bells and wishles to stepper.
    if {[string equal $role "STEP"] } {
            set tmp_co [$area_path bbox $picId]
		    set start_x [expr ((([lindex $tmp_co 2] - [lindex $tmp_co 0]) / 2) -23) + [lindex $tmp_co 0]]
	        set start_y [expr [lindex $tmp_co 1] - 15 ]
		    set arr [gb_arrow_create "var" $start_x $start_y "var" [expr $start_x + 40] $start_y 6]
		    $area_path itemconfig $arr -fill $gb(bg_color)
            if {[string equal "rigth" [lindex $args 0]]} {
                $gb(var) itemconfig $arr -arrow last
            } else {
                $gb(var) itemconfig $arr -arrow first 
            }
	        $area_path addtag "DIRECTION [lindex $args 0]" withtag $nameId
	        $area_path addtag "StepDirection$nameId" withtag $arr
    }
    gb_var_set_value $nameId $value
    $area_path addtag $nameId withtag $picId
    update
    return $nameId
}

#}}}
#{{{ Function: gb_var_get_position
#{{{*************************************************************
#	
#	Function:gb_var_get_position	
#	References:	
#	Description: Returns upperleft corner coordinates of object.	
#	Call: gb_var_get_position id
#	Input parameters: id : Object identifier.
#	Output parameters:  
#	Return value: list of coordinates. list position 0 is x and 1 is y.
#	Examble:gb_var_get_position $varId  
#	Fuctionality: 	 
#	Limits: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}

proc gb_var_get_position { id } {
	return [lrange [get_bordels $id] 0 1] 
}        

#}}}
#{{{ Function: tmp_proper
#{{{*************************************************************
#  Function: tmp_proper
#  Description: Proper role change.
#  Call: tmp_proper { varId new_role args }
#  Input parameters: varId: A handle to the variable.
#					new_role : new role of the variable.
#					args: Not need at the moment. 
#  Example: tmp_proper $tmpId STEP
#  Functionality: Animate role change using gif pictures. Finally
#  				  delete old variable and create new one at the 
#				  same position than old.
#  History: Sat Nov 22 11:33:13 EET 2003 Ville Rapa
#*************************************************************}}}

proc tmp_proper { varId new_role args } {
    global gb
    set old_role [gb_var_get_role $varId]
    set value [gb_var_get_value $varId]
    gb_var_del_values $varId
    set pic [gb_var_get_picture $varId]
    
    #Change picture.    
    set role [set_new_role $varId "$old_role-$new_role"]
    set pics [load_pic "$old_role-$new_role" ]
    set count 0	
    foreach pic_name $pics {
		set pic_file [file join $gb(path_pic) $pic_name]        
		set im [image create photo $pic_name -file $pic_file]
		$gb(var) itemconfigure "$pic" -image $im
		gb_var_set_value $varId $value $count 1
        update
		after $gb(flash_speed)
        incr count
				
	}
	# get old name and place.	
    set name [lindex [$gb(var) itemconfig "$varId name" -text] end]
    set coords [lrange [$gb(var) bbox "$varId name"] 0 1]
	#delete old variable and create new one.
    $gb(var) delete $varId
    set id [gb_var_create $new_role -name $name -direction rigth -coords $coords ]
    gb_var_set_value $id $value
    return $id
}

#}}}
#{{{ Function: tmp_sporadic
#{{{*************************************************************
#  Function: tmp_sporadic
#  Description:  Sporadic role change.
#  Call: tmp_proper { varId new_role }
#  Input parameters: varId: A handle to the variable.
#					new_role : A new role of the variable.
#  Example: tmp_proper $tmpId STEP
#  Functionality: Animate role change using gif pictures. Finally
#  				  delete old variable and create new one at the 
#				  same position than old.
#  History: Sat Nov 22 11:33:13 EET 2003 Ville Rapa
#*************************************************************}}}
proc tmp_sporadic { varId newRole } {
    global gb
    set old_role [gb_var_get_role $varId]
    set value [gb_var_get_value $varId] 
    gb_var_del_values $varId
    set pic [gb_var_get_picture $varId]
    set outPics [load_pic $old_role OUT]
    set inPics [load_pic $newRole IN]
    
    set count 0
	#animate change
    foreach pic_name $outPics {
        set pic_file [file join $gb(path_pic) $pic_name]
        
		set im [image create photo $pic_name -file $pic_file]
		$gb(var) itemconfigure "$pic" -image $im
		gb_var_set_value $varId $value $count 1
        update
		after $gb(flash_speed)
        incr count
				
	}
    gb_var_del_values $varId 
    set role [set_new_role $varId $newRole]
    foreach pic_name $inPics {
        set pic_file [file join $gb(path_pic) $pic_name]
        
		set im [image create photo $pic_name -file $pic_file]
		$gb(var) itemconfigure "$pic" -image $im
        update
		after $gb(flash_speed)
        incr count
				
	}
	# delete old variable and create new.
    set name [lindex [$gb(var) itemconfig "$varId name" -text] end]
    set coords [lrange [$gb(var) bbox "$varId name"] 0 1]
    $gb(var) delete $varId
    set id [gb_var_create $newRole -name $name -direction rigth -coords $coords ]
    return $id
}

#}}}
#{{{ Function: gb_var_array_set_value
#{{{*************************************************************
#	
#	Function: gb_var_array_set_value 
#	References:	
#	Description: sets value to variable object
#	Call:gb_var_array_set_value  { varId place value {position 0} }
#	Input parameters: varId: Object identifier
#							place: index/place to value.
#							value: new value
#							position: hotspot number.
#	Output parameters:   None.
#	Return value: object identifier.
#	Examble:  gb_var_array_set_value $varId 1 a
#	Fuctionality: Erase previous value and set new.	 
#	Limits: 
#   Side effects:
#	See also:
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}
proc gb_var_array_set_value  { varId place value {position 0} } {
	global gb
	set sfx ARR 
	$gb(var) delete "a$place$position$varId$sfx"
	update
	if { [string equal $position 0] } {
		$gb(var) delete "a$place$varId" 
		set ret [gb_var_set_value $varId 1 $value]
		set val $ret
			} else {	
		set picId [$gb(var) find withtag "position$position$varId"]
		
		set role [lindex [lindex [$gb(var) itemconfig $varId -tags] end] end]
		set spot [get_picture_hs  $picId 1 $role $place ]
		set val [gb_text_create var [lindex $spot 0] [lindex $spot 1] $value]
		$gb(var) itemconfig $val -anchor c
		
		set ret $val
		addtag "hotspot$varId" $val
		addtag $varId $val
		addtag "$place $value" $val
		addtag "a$place$position$varId$sfx" $val

	}
	addtag "a$place$position$varId$sfx" $val
	return $ret
}

#}}}
#{{{ Function: gb_var_array_get_value

proc gb_var_array_get_value {varId place {position 1} } {
	global gb
	set sfx ARR
	set objId [$gb(var) find withtag "a$position$place$varId$sfx"]
	return [lindex [$gb(var) itemconfigure $objId -text] end]

}

#}}}
#{{{ Function: gb_var_get_array_index_id
#{{{*************************************************************
#	
#	Function: gb_var_get_array_index_id	
#	References:	
#	Description: Returns id of value in the specified array index. 	
#	Call: gb_var_get_array_index_id { varId position }
#	Input parameters: varId: object identifier.
#							position: Index of array.
#	Output parameters: None
#	Return value: Identifier to object
#	Examble: gb_var_get_array_index_id $varId 1 
#	Fuctionality: 	Finds object specified by string "position$position$varId"
#	Limits: None
#   Side effects:
#	See also:
#	History:	1.12.2001 Ville Rapa
#	
#*************************************************************}}}
proc gb_var_get_array_index_id { varId position } {
	global gb
    set ret [$gb(var) find withtag "$varId 0 1 $position"]
	return $ret
}

#}}}
#{{{ Function: gb_var_array_compare
#{{{*************************************************************
#	
#	Function: gb_var_array_compare	
#	References:	
#	Description: Animate comparation of two indexes of same array.	
#	Call: gb_var_array_compare $varId pos1 pos2 txt1 txt2 boo
#	Input parameters: varId: Object identifier.
#							pos1: First index to compare
#							pos2: second index to compare
#							txt1: Text below first compared element
#							txt2: text below seconf compared element
#							boo: Result of comparation.
#	Output parameters: None  
#	Return value: None
#	Examble:  gb_var_array_compare $varId 2 2 "i" "10-i+1" TRUE
#	Fuctionality: 	 
#	Limits:  
#   Side effects:
#	See also:
#	History:	15.8.2002 Ville Rapa
#	$gb(var) itemconfigure $com_arr -fill $arr_color
#*************************************************************}}}
proc gb_var_array_compare { varId pos1 pos2 txt1 txt2 boo} {
	global gb
	set sfx ARR
    set movement 30
	if { ![string equal $pos1 $pos2] } {
		set value1 [gb_var_get_array_index_id $varId $pos1]
		set value2 [gb_var_get_array_index_id $varId $pos2]
        set picture1 [gb_var_get_picture $varId $pos1]
        set picture2 [gb_var_get_picture $varId $pos2]
		$gb(var) move $value1 0 -$movement
		$gb(var) move $value2 0 -$movement
        $gb(var) move $picture1 0 -$movement
        $gb(var) move $picture2 0 -$movement
        $gb(var) move "index_$picture1" 0 -$movement
        $gb(var) move "index_$picture2" 0 -$movement
		#set text
		if { [string equal -nocase $boo "TRUE"] } {
			set txt_color green
		} else {
			set txt_color red
		}
        #middle point if picture
		set middle [expr ([lindex [$gb(var) bbox $picture2 ] 2] - [lindex [$gb(var) bbox $picture2 ] 0]) / 2]
	    set x1 [ expr [lindex [$gb(var) bbox $picture1 ] 0] + $middle]
        set x2 [ expr [lindex [$gb(var) bbox $picture2 ] 0] + $middle]
        set y [expr [lindex [$gb(var) bbox $picture2 ] 3] - $movement + 40]
        
		$gb(var) create text $x1 $y \
			-text $txt1 -anchor c -fill $gb(help_color) -tags left$varId
	
		$gb(var) create text $x2 $y \
			-text $txt2 -anchor c -fill $gb(help_color) -tags left$varId
	
		$gb(var) create line $x1 [expr $y + $movement -40 ] $x1  [expr $y - 10] \
				-arrow first -fill $gb(help_color) \
				-width 3 -tag left$varId
				
		$gb(var) create line $x2 [expr $y + $movement -40 ] $x2 [expr $y - 10] \
				-arrow first -fill $gb(help_color) \
				-width 3 -tag left$varId			 
		after $gb(speed)
		$gb(var) itemconfigure $value1 -fill $txt_color
		$gb(var) itemconfigure $value2 -fill $txt_color
		update
	} else {
		set value1 [gb_var_get_array_index_id $varId $pos1]
        set picture1 [gb_var_get_picture $varId $pos1]
		$gb(var) move $value1 0 -$movement
        $gb(var) move $picture1 0 -$movement
        $gb(var) move "index_$picture1" 0 -$movement
		#set text
		if { [string equal -nocase $boo "TRUE"] } {
			set txt_color green
		} else {
			set txt_color red
		}
        #middle point if picture
		set middle [expr ([lindex [$gb(var) bbox $picture1 ] 2] - [lindex [$gb(var) bbox $picture1 ] 0]) / 2]
	    set x1 [ expr [lindex [$gb(var) bbox $picture1 ] 0] + $middle]
        set y [expr [lindex [$gb(var) bbox $picture1 ] 3] - $movement + 40]
        
		$gb(var) create text $x1 $y \
			-text $txt1 -anchor c -fill $gb(help_color) -tags left$varId
	
		$gb(var) create text $x1 [ expr $y + 13] \
			-text $txt2 -anchor c -fill $gb(help_color) -tags left$varId
	
		$gb(var) create line $x1 [expr $y + $movement -40 ] $x1  [expr $y - 10] \
				-arrow first -fill $gb(help_color) \
				-width 3 -tag left$varId
				
		after $gb(speed)
		$gb(var) itemconfigure $value1 -fill $txt_color
		update

        
    }
	update
	after [expr $gb(speed) *2 ]
	update
}

#}}}
#{{{ Function: gb_clear_array
#{{{*************************************************************
#
#	Function: gb_clear_array	
#	References:	
#	Description: Clears the texts of the comparation.	
#	Call: gb_clear_array varId pos1 pos2
#	Input parameters: varId: Object identifier.
#							pos1:  index which will be cleared
#							pos2: index which will be cleared.
#	Output parameters: None.  
#	Return value: None.
#	Examble:  
#	Fuctionality:
#	Limits: 
#   Side effects:
#	See also:
#	History:	15.8.1992 Ville Rapa
#	
#*************************************************************}}}

proc gb_clear_array { varId pos1 pos2} {
	global gb
	set movement 30
	set sfx ARR
    $gb(var) delete withtag left$varId
    if { ![string equal $pos1 $pos2] } {
	    set value1 [gb_var_get_array_index_id $varId $pos1]
		set value2 [gb_var_get_array_index_id $varId $pos2]
        set picture1 [gb_var_get_picture $varId $pos1]
        set picture2 [gb_var_get_picture $varId $pos2]
		$gb(var) move $value1 0 +$movement
		$gb(var) move $value2 0 +$movement
        $gb(var) move $picture1 0 +$movement
        $gb(var) move $picture2 0 +$movement
        $gb(var) move "index_$picture1" 0 +$movement
        $gb(var) move "index_$picture2" 0 +$movement
        
        $gb(var) itemconfigure $value1 -fill $gb(color)
		$gb(var) itemconfigure $value2 -fill $gb(color)
    }  else {
        set value1 [gb_var_get_array_index_id $varId $pos1]
        set picture1 [gb_var_get_picture $varId $pos1]
        $gb(var) move $value1 0 +$movement
        $gb(var) move $picture1 0 +$movement
        $gb(var) move "index_$picture1" 0 +$movement
	    $gb(var) itemconfigure $value1 -fill $gb(color)
	}
	update
}

#}}}
#{{{ Function: gb_var_set_length
#{{{*************************************************************
#	
#	Function: gb_var_set_length	
#	References:	
#	Description: creates array from variable	
#	Call: gb_var_set_length $varId 3
#	Input parameters: tag : object identifier.
#							length : amout of array indexes.
#	Output parameters: None.
#	Return value: None
#	Examble: gb_var_set_length 3 
#	Fuctionality: Adds new pictures side by side to the rigth side of variable. 
#	Limits: 
#   Side effects: 

#	See also: load_pic, get_bordels, gb_pic_create, gb_var_get_array_index_id
#	History:	15.8.2002 Ville Rapa

#	
#*************************************************************}}}
proc var_set_length { varId length role pic} {
	global gb
    set id [gb_var_get_picture $varId]
	for {set i 1} {$i < $length } { incr i} {
	    set xxx [expr [lindex [$gb(var) bbox "$id"] 2] -2]
		set yyy [lindex  [$gb(var) bbox "$id"] 1]
		set id [gb_pic_create "var" $xxx $yyy $pic]
        set id $id
		addtag "position [expr $i+1] $varId" $id
		#addtag $varId $id
        
		set co [$gb(var) bbox $id]
		set x [expr [lindex $co 0]+(([lindex $co 2] - [lindex $co 0]) / 2)]
		set y [expr [lindex $co 1] -5]
		
		$gb(var) create text  $x $y \
			-text [expr $i+1] -anchor c -fill $gb(help_color) -tags "index_$id"
        addtag "PIC_[expr $i+1] $id" $varId
    }
    
	set co [$gb(var) bbox [gb_var_get_picture $varId]]	
	set x [expr [lindex $co 0]+(([lindex $co 2] - [lindex $co 0]) / 2)]
	set y [expr [lindex $co 1] -5]
	$gb(var) create text  $x $y \
			-text 1 -anchor c -fill $gb(help_color) -tags "index_[gb_var_get_picture $varId]"	
}

#}}}
#{{{ Function: arraySetValue
#{{{*************************************************************
#  Function: arraySetValue
#  Description: sets value to the array elent
#  Call:
#  Input parameters:
#  Example:
#  Functionality:
#  History:
#*************************************************************}}}

proc arraySetValue { varId value {picture 0} {index 1} {spot 1} } {
    global gb
    set length [isArray $varId]
    set val -1
    if { $length > 0 && $length >= $index && $index > 0} {
        arrayDeleteValue $varId $index $spot
        set role [gb_var_get_role $varId]
        set hotSpot [lindex [lindex [load_spots $role] 1] $spot]        
        set co [$gb(var) bbox "position $index $varId"]
        set val [gb_text_create var [expr [lindex $co 0]  + [lindex $hotSpot 0]] \
                [expr [lindex $co 1] + [lindex $hotSpot 1]] $value $gb(color)] 
        $gb(var) itemconfig $val -anchor c
        addtag "Value $index $spot $varId" $val
        addtag "$varId $picture $spot $index" $val
    }
    return $val
}
#}}}
#{{{ Function: arrayDeleteValue
#{{{*************************************************************
#  Function: arrayDeleteValue
#  Description: Delete value from array element.
#  Call:
#  Input parameters:
#  Example:
#  Functionality:
#  History:  Mon Nov 24 14:46:00 EET 2003 Ville Rapa
#*************************************************************}}}

proc arrayDeleteValue { varId {index 1} {spot 1} } {
    global gb
    set length [isArray $varId]
    if { $length > 0 && $length >= $index && $index > 0} {
        $gb(var) delete "Value $index $spot $varId"
    }
}

#}}}
#{{{ Function: gb_var_set_value
#{{{*************************************************************
#	
#	Function: gb_var_set_value	
#	References:	
#	Description: assign value to variable object	
#	Call: gb_var_set_value $varId $place $value {number 1}
#	Input parameters: varId: variable identifier.
#							place: hotspot number.
#							value: value which you want to set.
#							number: pic number. number of picture incase of animation.
#	Output parameters: None.  
#	Return value: Identifier of value.
#	Examble: gb_var_set_value $apu 1 3 
#	Fuctionality: creates text object from value and set place it to right position.
#	Limits: 
#   Side effects:
#	See also:
#	History:	15.8.2002 Ville Rapa
#*************************************************************}}}

proc var_set_value { varId value {picture 0} {spot 1} {index 1}} {
	global gb
	set role [gb_var_get_role $varId]
    set hotSpot [lindex [lindex [load_spots $role] $picture] $spot]
    set picId [gb_var_get_picture $varId]
    set borders [$gb(var) bbox $picId]
    set x [expr [lindex $borders 0] + [lindex $hotSpot 0] ]
    set y  [expr [lindex $borders 1] + [lindex $hotSpot 1] ]
    
	if { $hotSpot != -1 } {
        if {$spot == 1} {
		    set color $gb(color)
        } else {
            set color $gb(color_2)
        }
        if {$index > 1 && [isArray $varId] > 0} {
            set ret [arraySetValue $varId $value $picture $index $spot]
        } else {
            gb_var_del_value $varId $spot
		    set val [gb_text_create var $x $y $value $color]
		    $gb(var) itemconfig $val -anchor c
		
            #add some identification tags
		    $gb(var) addtag "$varId $spot" withtag $val
		    $gb(var) addtag "$varId $picture $spot $index" withtag $val
		    $gb(var) addtag $varId withtag $val
            $gb(var) addtag "$varId Values" withtag $val
		    set ret $val
        }
	} else {
		set ret -1
	}
	return $ret
}

#}}}
#{{{ Function: gb_var_get_valueId
#{{{*************************************************************
#  Function:
#  Description:
#  Call:
#  Input parameters:
#  Example:
#  Functionality:
#  History:  Mon Nov 24 14:46:18 EET 2003 Ville Rapa
#*************************************************************}}}

proc gb_var_get_valueId {varId {picture 0} {spot 1} {index 1} } {
    global gb
    return [$gb(var) find withtag "$varId $picture $spot $index"]
    

}

#}}}
#{{{ Function: gb_var_set_value_from_variable
#{{{*************************************************************
#  Function: gb_var_set_value_from_variable
#  Description:
#  Call:
#  Input parameters:
#  Example:
#  Functionality:
#  History:  Mon Nov 24 14:46:30 EET 2003 Ville Rapa
#*************************************************************}}}

proc gb_var_set_value_from_variable { fromId toId {index null} {toIndex null} {erase null} } {
    global gb
    if { [string equal $index null] } {
        set index 1 
    }        
	if { [string equal $toIndex null] } {
        set toIndex 1 
    }  
    set var  "$fromId 0 1 $index"
    set role [gb_var_get_role $fromId]
    set hotSpot [lindex [lindex [load_spots $role] 0] 1]
    set picId [gb_var_get_picture $fromId $index]
    set borders [$gb(var) bbox $picId]
    set x [expr [lindex $borders 0] + [lindex $hotSpot 0] ]
    set y  [expr [lindex $borders 1] + [lindex $hotSpot 1] ]   	 
    set value [gb_var_get_value $fromId 0 1 $index]
	if { ![string equal $erase null]} { 
		$gb(var) delete [gb_var_get_valueId $fromId 0 1 $index]
	}
    set tmpId [gb_text_create var [expr [lindex $borders 0] + [lindex $hotSpot 0]]   [expr [lindex $borders 1] + [lindex $hotSpot 1] ] $value NULL c]
    set role [gb_var_get_role $toId]
    set hotSpot [lindex [lindex [load_spots $role] 0] 1]
    set picId [gb_var_get_picture $toId $toIndex]
    set borders [$gb(var) bbox $picId]
    set x [expr [lindex $borders 0] + [lindex $hotSpot 0] ]
    set y  [expr [lindex $borders 1] + [lindex $hotSpot 1] ]
    move $tmpId $x $y
    #gb_var_set_value $fromId $value
    set ret [gb_var_set_value $toId $value 0 1 $toIndex]
    $gb(var) delete $tmpId
    return $ret
}

#}}}
#{{{ Function: tmp_gb_var_get_value
#{{{*************************************************************
#  Function:  tmp_gb_var_get_value 
#  Description:
#  Call:
#  Input parameters:
#  Example:
#  Functionality:
#  History: Mon Nov 24 14:46:56 EET 2003 Ville Rapa
#*************************************************************}}}

proc tmp_gb_var_get_value {varId {picture 0} {spot 1} {index 1} } {
    global gb
    
    return [lindex [$gb(var) itemconfig [gb_var_get_valueId $varId $picture $spot $index] -text] end]
}

#}}}
#{{{ Function: gb_var_set_value

proc gb_var_set_value { varId args} {
    global gb
    set role [gb_var_get_role $varId]
    set length [llength $args]
    set prevValue [gb_var_get_value $varId]
    # Checkout parameters for var_set_value.
    # This is not the nice way to do this, because there is no error detection and
    # same could be done with out this or just passing args to var_set_value.    
    switch $length {
        1 {
           set ret [var_set_value $varId [lindex $args 0] ]
        }
        2 {
           set ret [var_set_value $varId  [lindex $args 0]  [lindex $args 1] ]
        }
        3 {
          set ret [var_set_value $varId  [lindex $args 0]  [lindex $args 1] [lindex $args 2]]
        }
        4 {
          set ret [var_set_value $varId  [lindex $args 0]  [lindex $args 1] [lindex $args 2] [lindex $args 3]]  
        }
        default {
          set ret [var_set_value $varId " " ]
        }
    }
    if {$length > 0} {
        set value [lindex $args 0]
    } else {
        set value " "
    }
    if {[string equal $role STEP] && ![string equal $value " "]} {
        var_set_value $varId ... 0 2
        var_set_value $varId [expr $value -3] 0 3
        var_set_value $varId [expr $value -2] 0 4
        var_set_value $varId [expr $value -1] 0 5
        var_set_value $varId [expr $value +1] 0 6
        var_set_value $varId [expr $value +2] 0 7
        var_set_value $varId [expr $value +3] 0 8
        var_set_value $varId ... 0 9
        $gb(var) itemconfig "StepDirection$varId" -fill $gb(color_2)
        
    }
    if { [string equal -nocase $role OWF] } {
        #owf_switch
    }

}

#}}}
#{{{ Function: gb_var_del_values

#Delete all values
proc gb_var_del_values { varId } {
	global gb
	$gb(var) delete "$varId Values"   
}

#}}}
#{{{ Function: gb_var_del_value
proc gb_var_del_value { varId {spot 1}} {
    global gb
	$gb(var) delete "$varId $spot"
}

#}}}
#{{{ Function: gb_var_get_values
#{{{*************************************************************
#	
#	Function: gb_var_get_values	
#	References:	
#	Description: Returns values assigned to spesified variable object.	
#	Call: gb_var_get_values $varId
#	Input parameters: tag: variable identifier.
#	Output parameters:   
#	Return value: list of text objects which are values assign to tag variable.
#	Examble:  gb_var_get_values $varId
#	Fuctionality: 	finds all objects with tag "hotspot$tag"  
#	Limits: do not sort values 
#   Side effects:
#	See also: 
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}
proc gb_var_get_values { tag } {
	
	global gb
	return [$gb(var) find withtag "hotspot$tag"]
	
}

#}}}
#{{{ Function: gb_var_get_hs
#{{{*************************************************************
#	
#	Function: gb_var_get_hs
#	References:	
#	Description: returns the coordinates of hotspot 	
#	Call: gb_var_get_hs VarId number place
#	Input parameters: varId: Object identifier
#							number: number which specifies place of hotspot in picture.
#							place: Number of picture 
#	Output parameters:  None 
#	Return value:	list of coordinates {x, y}
#	Examble: set co [gb_var_get_hs $id 2 1]
#				set co [gb_var_get_hs $id 2 3] in case of array index 3		 
#	Fuctionality: Gets all needed information from variable to call getHS function.
#					 Finally calls countHS to calculate actual coordinates in canvas. 	 
#	Limits: Function is limited to variable canvas.
#   Side effects:	
#	See also:
#	History:	15.8.2001 Ville Rapa

#*************************************************************}}}
proc gb_var_get_hs {varId number place} {
	 global gb


	 set role [lindex [lindex [$gb(var) itemconfig $varId -tags] end] end]
	 if { [string length $role] > 2 } {
	 	set obj [get_object $varId] 
	 	set picId [lindex [lindex $obj 0] 1]
		
		if {[string length $picId] < 1} {
			set picId $varId
			
		}
     	set hs [getHS $role $number $place]
		

    	set ret [countHS [gb_var_pic_borders $picId] $hs]
	} else {
	    set ret -1
	}
    return $ret
}

#}}}
#{{{ Function: get_picture_hs
#{{{*************************************************************
#	
#	Function: get_picture_hs
#	References: 	
#	Description: Get coordinates of given hotspot from given role(/picrure)	.
#	Call: get_picture_hs picId number role place
#	Input parameters: picId: id of picture in the canvas. 
#							number: number of picture incase of animation.
#							role: role of th e varioable.
#							place: hotspot number.
#	Output parameters:   
#	Return value: list of coordnates [x y]
#	Examble:  get_picture_hs $picId 1 "MRH" 1
#	Fuctionality: 	 
#	Limits:  This function uses two other hotspot related functions and those functions uses hotspots.txt
#				 file. Also roles and file names are important. This is quite planani spesific.
#   Side effects:
#	See also: getHS, countHS
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}
proc get_picture_hs { picId number role place} {
	set hs [getHS $role $number $place]
	set ret [countHS [gb_var_pic_borders $picId] $hs]
	return $ret
}

#}}}
#{{{ Function: gb_var_erase_hs
#{{{*************************************************************
#	
#	Function:gb_var_erase_hs	
#	References:	
#	Description: Erase variables value or all values.	
#	Call: gb_var_erase_hs $varIs $plase
#	Input parameters: Tag: variable identifier.
#							place: variables hotspot number. opitional, 
#									if nothing then all values will be derased.
#	Output parameters:   
#	Return value: 
#	Examble:  gb_var_erase_hs $varId 1: deletes value from hotspot 1.
#				 gb_var_erase_hs $varId : all value are erased.
#	Fuctionality: Deletes all objects identified by tag "a$place$tag" or incase off all "hotspot$tag"	 
#	Limits: 
#   Side effects:
#	See also:
#	History:	15.8.2002 Ville Rapa
#	
#*************************************************************}}}
proc gb_var_erase_hs { tag { place ALL} } {
	global gb
	
	if { [string equal $place "ALL"] } {
		$gb(var) delete "hotspot$tag"
	} else {
		$gb(var) delete "a$place$tag"
	}
}

#}}}
#
#		END OF VARIABLE OBJECT
#
#######################################################################
#{{{ Function: gb_var_get_role

proc gb_var_get_role { varId } {
    global gb
    set tags [lindex [$gb(var) itemconfigure $varId -tags ] end]
    set role -1
    foreach tag $tags {
        if { [string equal [lindex $tag 0] "ROLE"] } {
            set role [lindex $tag 1]
        }
   }
    return $role
}

#}}}
#{{{ Function: gb_var_get_picture

proc gb_var_get_picture { varId {nro 1}} {
    global gb
    set tags [lindex [$gb(var) itemconfigure $varId -tags ] end]
    set picId -1
    foreach tag $tags {
        if { [lindex $tag 0] == "PIC_$nro"} {
            set picId [lindex $tag 1]
        }
    }
    return $picId
}

#}}}
#{{{ Function: gb_stepper_get_direction
proc gb_stepper_get_direction { varId } {
    global gb
    set dir -1
    if {[string equal [gb_var_get_role $varId] STEP]} {
        set tags [lindex [$gb(var) itemconfigure $varId -tags ] end]
        foreach tag $tags {
            if { [string equal -nocase [lindex $tag 0] "DIRECTION"] } {
                set dir [lindex $tag 1]
            }
        }
    }
    return $dir  
}

#}}}
#{{{ Function: gb_stepper_set_direction
#{{{*************************************************************
#  Function: gb_stepper_set_direction 
#  Description:
#  Call:
#  Input parameters:
#  Example:
#  Functionality:
#  History: Mon Nov 24 14:47:23 EET 2003 Ville Rapa
#*************************************************************}}}

proc gb_stepper_set_direction { varId newDir} {
    global gb
    set dir [gb_stepper_get_direction $varId]
    $gb(var) dtag "DIRECTION $dir"
    $gb(var) addtag "DIRECTION $newDir" withtag $varId
    if { [string equal -nocase $newDir right] } {
        $gb(var) itemconfigure "StepDirection$varId" -arrow last
    } else {
        $gb(var) itemconfigure "StepDirection$varId" -arrow first
    }
    update
}

#}}}
#{{{ Function: gb_stepper_set_lim_var

proc gb_stepper_set_lim_var { varId position name } {
    global gb 
    set hotSpot [lindex [lindex [load_spots STEP] 0] $position]
    set picId [gb_var_get_picture $varId]
    set borders [$gb(var) bbox $picId]
    set x [expr [lindex $borders 0] + [lindex $hotSpot 0] ]
    set y [expr [lindex $borders 3] + 3]
	$gb(var) delete "LIM$varId"
    set id [gb_text_create "var" $x $y $name NULL c]
    addtag "LIM$varId" $id
    addtag $varId $id
}

#}}}
#{{{ Function: map_spot_coords
#{{{*************************************************************
#  Function: map_spot_coords
#  Description:
#  Call:
#  Input parameters:
#  Example:
#  Functionality:
#  History: Mon Nov 24 14:47:43 EET 2003 Ville Rapa
#*************************************************************}}}

proc map_spot_coords { varId co } {
    global gb 
    set pic [gb_var_get_picture $varId]
    set coords [$gb(var) bbox $pic]
    return "[expr [lindex $coords 0] + [lindex $co 0] ] [expr [lindex $coords 1] + [lindex $co 1]]"
}

#}}}
#{{{ Function: set_new_role
#{{{*************************************************************
#  Function: set_new_role
#  Description: Set new role tag to object
#  Call: set_new_role $varId TEMP
#  Input parameters: varId: identifier of the variable.
#					 newRole: newRole tag of the object.
#  Example:
#  Functionality:
#  History:  Mon Nov 24 14:47:55 EET 2003 Ville Rapa
#*************************************************************}}}

proc set_new_role { varId newRole} {
    global gb
    set role [gb_var_get_role $varId]
    if { $role != -1} {
        $gb(var) dtag $varId "ROLE $role"
        $gb(var) addtag "ROLE $newRole" withtag $varId 
    }
}

#}}}
#{{{ Function: gb_var_get_value
#{{{*************************************************************
#  Function: gb_var_get_value 
#  Description: Returns the value of the variable.
#  Call:
#  Input parameters:
#  Example:  gb_var_get_value $varId
#  Functionality: Finds object with tag "$varId $picture $spot $index"
#					and retruns it's text attribute.
#  History:  Mon Nov 24 14:42:54 EET 2003 Ville Rapa
#*************************************************************}}}

proc gb_var_get_value {varId {picture 0} {spot 1} { index 1} } {
    global gb
    return [lindex [$gb(var) itemconfigure "$varId $picture $spot $index" -text] end]
}

#}}}
#{{{ Function: isArray
#{{{*************************************************************
#  Function: isArray
#  Description: Checks if variable is array
#  Call: isArray $varId
#  Input parameters: varId : Variable identifier.
#  Example: isArray $someVariableIdentifier
#  Functionality: Search trough variables tag list and fids if there is array indicator.
#                 returns 0 if variable is not an array otherwise the length of array is returned.
#  History: 26.6.2003 Ville Rapa
#*************************************************************}}}

proc isArray {varId} {
    global gb
    
    set tags [lindex [$gb(var) itemconfigure $varId -tags ] end]
    set ret 0
    foreach tag $tags {
        if { [lindex $tag 0] == "Array"} {
            set ret [lindex $tag 1]
        }
    }
    return $ret
}
#}}}

