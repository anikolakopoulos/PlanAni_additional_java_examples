#Copyright (c) 2003 University of Joensuu,
#                   Department of Computer Science
proc Palindrome {} {
    AN_createProgramLine 1  1   "public class Palindrome \{"
    AN_createProgramLine 2  1   " "
    AN_createProgramLine 3  3   "static final int MaxLen = 8\;"
    AN_createProgramLine 4  3   " "
    AN_createProgramLine 5  3   "public static void main(String\[\] args) \{"
    AN_createProgramLine 6  6   " "
    AN_createProgramLine 7  6   "int len, i\;"
    AN_createProgramLine 8  6   "char\[\] candidate = new char\[MaxLen\]\;"
    AN_createProgramLine 9 	6   "boolean pali\;"
    AN_createProgramLine 10	6   "do \{"
    AN_createProgramLine 11	9	"System.out.print(\"Enter the length: \")\;"
    AN_createProgramLine 12	9	"len = UserInputReader.readInt()\;"
    AN_createProgramLine 13	9	"if ((len < 1) || (len > MaxLen)) \{"
    AN_createProgramLine 14	12	"System.out.println(\"Must be between 1..\" + MaxLen)\;"
    AN_createProgramLine 15 9   "\}"
    AN_createProgramLine 16 6   "\} while ((len < 1) || (len > MaxLen))\;"
    AN_createProgramLine 17 6   " "
    AN_createProgramLine 18	6   "for (i = 1\; i <= len\; i++ ) \{"
    AN_createProgramLine 19	9   "System.out.print(\"Enter the \" + i + \". letter: \")\;"
    AN_createProgramLine 20	9	"candidate\[i-1\] = UserInputReader.readChar()\;"
    AN_createProgramLine 21 6   "\}"
    AN_createProgramLine 22	6   "pali = true\;"
    AN_createProgramLine 23	6   "for (i = 1\; i <= len\; i++ ) \{"
    AN_createProgramLine 24	9	"pali = (pali && (candidate\[i-1\] == candidate\[len-i\]))\;"
    AN_createProgramLine 25 6   "\}"
    AN_createProgramLine 26	6   "if (pali) \{"
    AN_createProgramLine 27	9	"System.out.print(\"String is\")\;"
    AN_createProgramLine 28 6   "\} else \{"
    AN_createProgramLine 29	9	"System.out.print(\"String is not\")\;"
    AN_createProgramLine 30 6   "\}"
    AN_createProgramLine 31	6   "System.out.println(\"a palindrome.\")\;"
    AN_createProgramLine 32 3   "\}"
    AN_createProgramLine 33 1   "\}"
    
    AN_beginAnimation
    set MaxLenId [AN_createVar MaxLen FIXED 8 {3 18 end} NULL CONST]
    AN_notice PROGRAM_BEGINS {5 1 end}
    set lenId [AN_createVar len MRH NULL {7 5 7}]
	set iId [AN_createVar i STEP NULL {7 10 10}]
	set candidateId [AN_createVar candidate CONS NULL {8 8 16} NULL CHAR 8]
	set paliId [AN_createVar pali OWF NULL {9 9 12} NULL BOOL]
    
    AN_notice DO_LOOP_BEGINS {10 1 2}
	set ok 1
	
	while {$ok} { 
    	AN_writeln  "Enter the length: " {11 start end} null "PRINT_REQUEST"   
	    AN_readData $lenId {12 start end} READ_DATA _null_ {12 start 3}
    	AN_notice IF_STATEMENT {13 1 2}
    	if { [AN_compare {13 1 2} IF_SKIP_ELSE "$lenId < > 1 [AN_getAttribute $MaxLenId value] {13 4 32} OR"] } { 
        	AN_writeln  "Must be between 1..[AN_getAttribute $MaxLenId value]" {14 1 end} {{MaxLen 20}} "PRINT_RESULT"
    	}
    	set ok [AN_compare {16 3 7} DO "$lenId < > 1 [AN_getAttribute $MaxLenId value] {16 10 38} OR"]
	}
	AN_notice FOR_LOOP_BEGINS {18 1 3}
	AN_setNewValue $iId 1 {18 6 10}
	AN_setDirection $iId right
	AN_setExpression $iId "@+1"
	AN_setLim $iId "@<=[AN_getAttribute $lenId value]" $lenId 

    while {[AN_compare null FOR "$iId {18 13 20}" ]} {
        AN_writeln  "Enter the [AN_getAttribute $iId value]. letter: " {19 start end} {{i 11}} "PRINT_REQUEST"
        set val [AN_readData $candidateId {20 start end} READ_DATA [AN_getAttribute $iId value] {20 start 14}]
        AN_step $iId {18 23 25}
    }

   AN_change $paliId true {22 start end}

   AN_notice FOR_LOOP_BEGINS {23 1 3}
   AN_setNewValue $iId 1 {23 6 10}
   while {[AN_compare null FOR "$iId {23 13 20}" ]} {
		set ex "AN_compareElements $candidateId [AN_getAttribute $iId value] \
				[expr [AN_getAttribute $lenId value] - \
				[AN_getAttribute $iId value] + 1  ] i-1 len-i {24 18 54} =="  
        AN_change $paliId false {24 1 15} $ex    
    	AN_step $iId {23 23 25} 
	}
	
	AN_notice IF_STATEMENT {26 1 2}
	if {[AN_compare {26 1 2} IF "$paliId {26 5 8}"] } {
		AN_writeln  "String is" { 27 1 end } null PRINT_RESULT
	} else {
		AN_writeln  "String is not" { 29 1 end } null PRINT_RESULT
	}
	AN_write " a palindrome." { 31 1 end } PRINT_RESULT
    
	AN_notice PROGRAM_ENDS {32 start end}
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
        set mess [format $lanTable([format "%s_ARRAY_SET_VALUE" $lan]) '[AN_getAttribute $varId name]' [expr $index-1]]
	if {!$AN(noSrc)} {
	if { ![string equal $coords2 "null"] } {
        set mark [eval markIt $coords2]
        gb_flash [lindex $mark 0] 5
        }
        }
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
            lappend attributes "direction right" "expression _null_" \
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
                        -text $i -anchor c -fill $gb(help_color) -tags "index_$id"
        addtag "PIC_[expr $i+1] $id" $varId
    }
    
        set co [$gb(var) bbox [gb_var_get_picture $varId]]      
        set x [expr [lindex $co 0]+(([lindex $co 2] - [lindex $co 0]) / 2)]
        set y [expr [lindex $co 1] -5]
        $gb(var) create text  $x $y \
                        -text 0 -anchor c -fill $gb(help_color) -tags "index_[gb_var_get_picture $varId]"       
}



