#Copyright (c) 2003 University of Joensuu,
#                   Department of Computer Science

proc Fibonacci {} {
    AN_createProgramLine 1  1 "public class Fibonacci \{"
    AN_createProgramLine 2  1 " "
    AN_createProgramLine 3  3 "public static void main(String\[\] args) \{"
    AN_createProgramLine 4  3 " "
    AN_createProgramLine 5  6 "int last_fib, fib, temp, number, i\;"
    AN_createProgramLine 6  6 "last_fib = 1\; fib = 1\;"
    AN_createProgramLine 7  6 "System.out.print(\"How many Fibonacci numbers you want: \")\;"
    AN_createProgramLine 8  6 "number = UserInputReader.readInt()\;"
    AN_createProgramLine 9  6 "number = Math.abs(number)\;"
    AN_createProgramLine 10 6 "if (number <= 2) \{"
    AN_createProgramLine 11 9 "System.out.println(\"Both the first and the second numbers are 1.\")\;"
    AN_createProgramLine 12 6 "\} else \{"
    AN_createProgramLine 13 9 "System.out.println(\"1. number is 1\")\;"
    AN_createProgramLine 14 9 "System.out.println(\"2. number is 1\")\;"
    AN_createProgramLine 15 9 "for (i = 3\; i <= number\; i++) \{"
    AN_createProgramLine 16 12 "temp = last_fib\;"
    AN_createProgramLine 17 12 "last_fib = fib\;"
    AN_createProgramLine 18 12 "fib = fib + temp\;"
    AN_createProgramLine 19 12 "System.out.println(i + \". number is \" + fib)\;"
    AN_createProgramLine 20 9 "\}"
    AN_createProgramLine 21 6 "\}" 
    AN_createProgramLine 22 3 "\}"
    AN_createProgramLine 23 3 " "
    AN_createProgramLine 24 1 "\}"

    AN_beginAnimation
    
    AN_notice PROGRAM_BEGINS {3 1 end} 
    set last_fibId [AN_createVar "last_fib" FOLL null {5 5 12} null INT]
    set fibId [AN_createVar "fib" GATH null {5 15 17} {180 40} INT ]
    set tempId [AN_createVar "temp" TEMP null {5 20 23} null INT]
    set numberId [AN_createVar "number" CONS null {5 26 31} null INT]
    set iId [AN_createVar "i" STEP null {5 34 34} null INT]
    
    AN_setNewValue $last_fibId 1 {6 1 12}
    AN_setNewValue $fibId 1  {6 15 21}
    AN_setVariable $last_fibId $fibId	
    AN_setVariable $tempId $last_fibId
    AN_writeln  "How many Fibonacci numbers you want: " {7 start end} "null" "PRINT_REQUEST"
    AN_readData $numberId {8 start end} READ_DATA _null_ {8 start 6}
    AN_setCorrValue $numberId [expr abs([AN_getAttribute $numberId value])] {9 start end} "Math.abs(number)"
   
    AN_notice IF_STATEMENT {10 1 2}
    set eka "$numberId <= 2 {10 5 15}"
    if { [AN_compare {10 5 15} IF $eka] } {
        AN_writeln  "Both the first and the second numbers are 1. " {11 start end} "null" "PRINT_RESULT"
        AN_notice PROGRAM_ENDS {22 start end}
    } else {
        AN_writeln  "1. number is 1" {13 start end} "null" "PRINT_RESULT"
        AN_writeln  "2. number is 1" {14 start end} "null" "PRINT_RESULT" 

        AN_notice FOR_LOOP_BEGINS {15 1 3}
        AN_setNewValue $iId 3 {15 6 10}
        AN_setDirection $iId right
        AN_setExpression $iId "@+1"
        AN_setLim $iId "@<=[AN_getAttribute $numberId value]" $numberId 1

        while {[AN_compare null FOR "$iId {15 13 23}"]} {	    
            AN_setState $tempId ON {16 start end}
            AN_follow $last_fibId {17 start end}
            AN_setNewValue $fibId [expr [AN_getAttribute $fibId value] + [AN_getAttribute $tempId value]] {18 1 end} "fib + temp"
            AN_setState $tempId OFF
            set iValue [AN_getAttribute $iId value]
            set result [AN_getAttribute $fibId value]
            AN_writeln  "$iValue. number is $result" {19 start end} {{i 1} {fib 14}} "PRINT_RESULT"
            AN_step $iId {15 26 28}
        }   

        AN_notice LOOP_ENDS {20 start end}
        AN_notice PROGRAM_ENDS {22 start end}
    }
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
