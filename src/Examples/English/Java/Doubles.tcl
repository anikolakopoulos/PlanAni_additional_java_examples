#Copyright (c) 2003 University of Joensuu,
#                   Department of Computer Science

#English java example doubles
proc Doubles {} {
 	AN_createProgramLine 1  1  "public class Doubles \{"
  	AN_createProgramLine 2  1  " "
 	AN_createProgramLine 3  3  "public static void main(String\[\] args) \{"
    AN_createProgramLine 4  6  "int counter, number\;"
    AN_createProgramLine 5  6  "do \{"
    AN_createProgramLine 6  9  "System.out.print(\"Give amount of loops: \")\;"
    AN_createProgramLine 7  9  "counter = UserInputReader.readInt()\;"
    AN_createProgramLine 8  6  "\} while (counter <= 0)\;"
    AN_createProgramLine 9  6  "while (counter > 0) \{"
    AN_createProgramLine 10 9  "System.out.print(\"Give some number: \")\;"
    AN_createProgramLine 11 9  "number = UserInputReader.readInt()\;"
    AN_createProgramLine 12 9  "System.out.println(\"Two times \" + number + \"is \" + 2*number)\;"
    AN_createProgramLine 13 9  "counter = counter - 1\;"
    AN_createProgramLine 14 6  "\}"
    AN_createProgramLine 15 3  "\}"
    AN_createProgramLine 16 3  " "
    AN_createProgramLine 17 1  "\}"
	AN_beginAnimation  

    AN_notice PROGRAM_BEGINS {3 1 end}

	set countId [AN_createVar counter MRH null {4 5 11} null INT]
    set lukuId [AN_createVar number MRH null {4 14 19} null INT]
    
    set ok 1
    AN_notice DO_LOOP_BEGINS {5 1 2}
    while {$ok} { 
		AN_writeln  "Give amount of loops: " {6 1 end} "null" "PRINT_REQUEST"    
	AN_readData $countId {7 1 end} "READ_DATA" _null_ {7 start 7}
		set ok [AN_compare {8 3 7} DO "$countId <= 0 {8 10 21}"] 
    }
    AN_notice WHILE_LOOP_BEGINS {9 1 5}
    AN_properChange $countId STEP
    AN_setExpression $countId "@-1"
    AN_setLim $countId "@>0" null 0
    AN_setDirection $countId left
    while { [AN_compare {9 1 5} WHILE "$countId {9 8 18}"] } {
        AN_writeln  "Give some number: " {10 1 end} "null" "PRINT_REQUEST"
        AN_readData $lukuId {11 1 end} "READ_DATA" _null_ {11 start 6}
        set val [AN_getAttribute $lukuId value]
        AN_writeln  "Two times $val is [expr 2 * $val]" {12 start end} {{"number" 11} {"2*number" 16}} "PRINT_RESULT"
        AN_step $countId {13 start end}
    }
    AN_notice LOOP_ENDS {14 start end}
    AN_notice PROGRAM_ENDS {15 start end}
	
    AN_endAnimation
}



# --------------------------------------------------------------------------------
# 
# The following procedures:
# 
# 	AN_change_lan
# 	AN_createVar
# 	AN_readData
# 	var_set_length
# 
# do not work correctly with all examples :-(
# 
# Therefore, they are redefined by some examples. In case such an example
# is loaded before this one, we first redefine these procedures to their original
# form:
# 
# --------------------------------------------------------------------------------

proc AN_change_lan { } {
    global lan typeTable
        if {$lan == 1} {
            set lan 2
            set typeTable(INT)      integer
            set typeTable(CHAR)     char
            set typeTable(BOOL)     boolean
            set typeTable(REAL)     real
            set typeTable(CONST)    constant
            set typeTable(DOUBLE)   doubl
            set typeTable(LONG)     long
            set typeTable(FLOAT)    float
            
                #change_roleTable
        } else {
            set lan 1
            set typeTable(INT)      kokonaisluku
            set typeTable(CHAR)     merkki
            set typeTable(BOOL)     totuusarvo
            set typeTable(REAL)     liukuluku
            set typeTable(CONST)    Vakio
            set typeTable(DOUBLE)   liukuluku
            set typeTable(LONG)     kokonaisluku
            set typeTable(FLOAT)    liukuluku

                #change_roleTable 
        }
    gb_change_language $lan 
}

proc AN_createVar { name role value mark {coords null} {type INT} {length null} } {
    global lanTable lan AN stepState typeTable
   	# parse parameters
	set role [string toupper $role]
	set type [string toupper $type]
	lappend params -name $name
	if { [lsearch -exact [array names typeTable] $type] == -1} {        
        set type "INT"
    }	
    if { ![string equal -nocase $coords "null"] } {
        lappend params -coords "[lindex $coords 0] [lindex $coords 1]"
    }
    if { [string equal -nocase $length "null"] } {
        if { [string equal $type CONST] } { 
			set mess [format $lanTable([format "%s_CREATE_CONST" $lan]) $name]
		} else {
			set mess [format $lanTable([format "%s_CREATE_VAR" $lan]) $typeTable($type) $name $lanTable([format "%s_%s" $lan $role])]
		}
        set length _null_
    } else {
        set mess [format $lanTable([format "%s_CREATE_ARRAY" $lan]) $typeTable($type) $name $lanTable([format "%s_%s" $lan $role])]
        lappend params -array $length
    }
    if { [string equal -nocase $value "null"] } {
        set val _null_
		set roleState "new"
    } else {
        set val $value
		set roleState "started"
    }
    if { ![string equal -nocase $mark "null"] && !$AN(noSrc)} {
        set markId [eval markIt $mark]
        gb_flash [lindex $markId 0] 5
    }
    showMessage $mess
	if {!$AN(noVarPictures) } {
    	set id [eval gb_var_create $role $params]
    	if { ![string equal -nocase $mark "null"] } {   
			if { !$AN(noSrc) } {
				set arrowId [arrow_create_o2o [lindex $markId 0] $id 1]
        		AN_delay
        		gb_destroy $arrowId
			}
		}
	} else {
		set id _null_
	}
	if { !$AN(noSrc)} {
    	gb_text_unmark_all
	}
	# set varables attributes
    set next [getNextId] 
    lappend attributes "name $name" "role $role" "gbId $id" \
					   "value $val" "roleState $roleState"
    switch -- $role {
        CONS {
            lappend attributes "unCorrValue _null_"
        }
        STEP {
            lappend attributes "direction _null_" "expression _null_" \
							   "comparison _null_" "limitValue _null_" \
							   "limitExpression _null_"    
        } 
        FOLL {
            lappend attributes "variable _null_"
        }
        MRH {
            lappend attributes "unCorrValue _null_" "prevValue _null_"
        }
        GATH {
            lappend attributes "prevValue _null_"
        }
        OWF {
            lappend attributes "direction _null_"
        }
        TEMP {
            lappend attributes "variable _null_" "state _null_"
        }
        MWH { 
            lappend attributes "prevValue _null_"
        }
    }
    lappend attributes "length $length"
    if {![string equal $length _null_]} {
        lappend attributes "values _null_"
    }
    set AN($next) $attributes

    if { ![string equal -nocase $value "null"] } {
        if { [string equal $length "_null_"] } {
            AN_setNewValue $next $value
        } else {
            foreach val $value {
                AN_setNewElementValue $next [lindex $val 0] [lindex $val 1]
            }
        }
    }
    set AN($next) $attributes
	# Stop here if stepmode is on.
    stepStop 
    return $next
}

proc AN_readData {varId coords {notice "null"} {index _null_} } {
    
    global AN lan lanTable stepState
    set name [AN_getAttribute $varId name]
    set role [AN_getAttribute $varId role]
	if {!$AN(noSrc)} {
    	set mark [eval markIt $coords]
    	gb_flash [lindex $mark 0] 5
	}
    if {$notice != "null"} {
	    AN_notice $notice
    }

    set val [gb_text_read]

    AN_write "$val" no
        
    if { [string equal $index _null_] } {
		set state [AN_getAttribute $varId roleState]
		if {[string equal $state new]} {
			set mess [format $lanTable([format "%s_VAR_SET_VALUE" $lan]) $name $lanTable([format "%s_%s" $lan $role])]	
			AN_setAttribute $varId roleState "started"
		} else {
			set mess [format $lanTable([format "%s_VAR_UPDATE_VALUE" $lan]) $name $lanTable([format "%s_%s" $lan $role])]
		}

        showMessage $mess
		#Move previuos value away from new value if it's nessery. Depends on role
		if { [string equal $role "MRH"] || [string equal $role "MWH"] || [string equal $role "GATH"] } { 
        	AN_setAttribute $varId prevValue  [AN_getAttribute $varId value]
        	if { ![string equal [AN_getAttribute $varId prevValue] "_null_"] } {
				if {!$AN(noVarPictures)} {
            		gb_var_set_value [AN_getAttribute $varId gbId] [AN_getAttribute $varId prevValue]  1 2
            		gb_var_set_value [AN_getAttribute $varId gbId] " " 
				}
        	}
    	} 
		if { !$AN(noVarPictures) } {
			if {!$AN(noSrc)} {
        		set ID [gb_animate_entry $val [AN_getAttribute $varId gbId] 1 [lindex $mark 0]]		
			} else {
				set ID [gb_animate_entry $val [AN_getAttribute $varId gbId] 1 ]
			}
    		gb_var_set_value [AN_getAttribute $varId gbId] $val
		}
    	AN_setAttribute $varId value $val 
		if {!$AN(noSrc)} {
			gb_text_unmark_all
		}
    } else {
		#TODOO muista järjestys kuten tavan muuttujassa. Katso IF osa
        set mess [format $lanTable([format "%s_ARRAY_SET_VALUE" $lan]) '[AN_getAttribute $varId name]' $index]
        showMessage $mess
		if { !$AN(noVarPictures) } {
			if {!$AN(noSrc)} {
				gb_animate_entry $val [AN_getAttribute $varId gbId] 1 [lindex $mark 0] $index
			} else {
				gb_animate_entry $val [AN_getAttribute $varId gbId] 1 NULL  $index
			}
		}
        AN_setNewElementValue $varId $val $index
		if {!$AN(noSrc)} {
        	gb_text_unmark_all
		}
    }
    stepStop
    return $val
}

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

# --------------------------------------------------------------------------------
# 
# And then we redefine procedures that must be redefined for this example to work:
# 
# --------------------------------------------------------------------------------

proc AN_readData {varId coords {notice "null"} {index _null_} {coords2 "null"}} {
    
    global AN lan lanTable stepState
    set name [AN_getAttribute $varId name]
    set role [AN_getAttribute $varId role]
        if {!$AN(noSrc)} {
        set mark [eval markIt $coords]
        gb_flash [lindex $mark 0] 5
        }
    if {$notice != "null"} {
            AN_notice $notice
    }

    set val [gb_text_read]

    AN_write "$val" no
        
    if { [string equal $index _null_] } {
                set state [AN_getAttribute $varId roleState]
                if {[string equal $state new]} {
                        set mess [format $lanTable([format "%s_VAR_SET_VALUE" $lan]) $name $lanTable([format "%s_%s" $lan $role])]      
                        AN_setAttribute $varId roleState "started"
                } else {
                        set mess [format $lanTable([format "%s_VAR_UPDATE_VALUE" $lan]) $name $lanTable([format "%s_%s" $lan $role])]
                }

        if {!$AN(noSrc)} {
	if { ![string equal $coords2 "null"] } {
        set mark [eval markIt $coords2]
        gb_flash [lindex $mark 0] 5
        }
        }
        showMessage $mess
                #Move previuos value away from new value if it's nessery. Depends on role
                if { [string equal $role "MRH"] || [string equal $role "MWH"] || [string equal $role "GATH"] } { 
                AN_setAttribute $varId prevValue  [AN_getAttribute $varId value]
                if { ![string equal [AN_getAttribute $varId prevValue] "_null_"] } {
                                if {!$AN(noVarPictures)} {
                        gb_var_set_value [AN_getAttribute $varId gbId] [AN_getAttribute $varId prevValue]  1 2
                        gb_var_set_value [AN_getAttribute $varId gbId] " " 
                                }
                }
        } 
                if { !$AN(noVarPictures) } {
                        if {!$AN(noSrc)} {
                        set ID [gb_animate_entry $val [AN_getAttribute $varId gbId] 1 [lindex $mark 0]]         
                        } else {
                                set ID [gb_animate_entry $val [AN_getAttribute $varId gbId] 1 ]
                        }
                gb_var_set_value [AN_getAttribute $varId gbId] $val
                }
        AN_setAttribute $varId value $val 
                if {!$AN(noSrc)} {
                        gb_text_unmark_all
                }
    } else {
                #TODOO muista järjestys kuten tavan muuttujassa. Katso IF osa
        set mess [format $lanTable([format "%s_ARRAY_SET_VALUE" $lan]) '[AN_getAttribute $varId name]' $index]
        showMessage $mess
                if { !$AN(noVarPictures) } {
                        if {!$AN(noSrc)} {
                                gb_animate_entry $val [AN_getAttribute $varId gbId] 1 [lindex $mark 0] $index
                        } else {
                                gb_animate_entry $val [AN_getAttribute $varId gbId] 1 NULL  $index
                        }
                }
        AN_setNewElementValue $varId $val $index
                if {!$AN(noSrc)} {
                gb_text_unmark_all
                }
    }
    stepStop
    return $val
}
