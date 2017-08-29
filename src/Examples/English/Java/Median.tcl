# Copyright (c) 2004 University of Joensuu,
#                   Department of Computer Science

proc Median {} {
    
    AN_createProgramLine  1   1    "public class Median \{"
    AN_createProgramLine  2   5    "static final int sentinel = -999\;"
    AN_createProgramLine  3   5    "static final int maxCount = 10\;"
    AN_createProgramLine  4   1    " "
    AN_createProgramLine  5   5    "public static void main(String\[\] args) \{"    
    AN_createProgramLine  6   1    " "
    AN_createProgramLine  7   10   "float\[\] a = new float\[maxCount\]\;"
    AN_createProgramLine  8   10   "float closest, temp\;"
    AN_createProgramLine  9   10   "int n, i\;"
    AN_createProgramLine  10  10   "boolean inOrder\;"
    AN_createProgramLine  11  1    ""   
    AN_createProgramLine  12  10   "n = 0\; closest = sentinel\;"
    AN_createProgramLine  13  10   "System.out.print(\"Enter a number: \")\;" 
    AN_createProgramLine  14  10   "temp = UserInputReader.readFloat()\;"
    AN_createProgramLine  15  10   "while ((temp != sentinel) \&\& (n < maxCount)) \{"
    AN_createProgramLine  16  15   "n = n+1\;"
    AN_createProgramLine  17  15   "a\[n-1\] = temp\;"
    AN_createProgramLine  18  15   "if (Math.abs(temp) < Math.abs(closest)) \{" 
    AN_createProgramLine  19  20   "closest = temp\;"
    AN_createProgramLine  20  15   "\}"
    AN_createProgramLine  21  16   "System.out.print(\"Enter a number: \")\;" 
    AN_createProgramLine  22  15   "temp = UserInputReader.readFloat()\;"
    AN_createProgramLine  23  10   "\}"
    AN_createProgramLine  24  10   "System.out.println(\"Closest to zero is \" + closest)\;"
    AN_createProgramLine  25  10   "inOrder = false\;"
    AN_createProgramLine  26  10   "while (!inOrder) \{"
    AN_createProgramLine  27  15   "inOrder = true\;"
    AN_createProgramLine  28  15   "for ( i = 1\; i < n\; i++ ) \{"
    AN_createProgramLine  29  20   "if (a\[i-1\] > a\[i\]) \{" 
    AN_createProgramLine  30  25   "temp = a\[i-1\]\;"
    AN_createProgramLine  31  25   "a\[i-1\] = a\[i\]\;"
    AN_createProgramLine  32  25   "a\[i\] = temp\;"
    AN_createProgramLine  33  25   "inOrder = false\;"
    AN_createProgramLine  34  20   "\}"
    AN_createProgramLine  35  15   "\}"
    AN_createProgramLine  36  10   "\}"
    AN_createProgramLine  37  10   "System.out.print(\"Median is \")\;"
    AN_createProgramLine  38  10   "i = (n+1) / 2\;"
    AN_createProgramLine  39  10   "if ( ((n+1) \& 1) == 0) \{"
    AN_createProgramLine  40  15   "System.out.println(a\[i-1\])\;"
    AN_createProgramLine  41  10   "\} else \{"
    AN_createProgramLine  42  15   "System.out.println(0.5*(a\[i-1\]+a\[i+1\]))\;"
    AN_createProgramLine  43  10   "\}"
    AN_createProgramLine  44  5    "\}"
    AN_createProgramLine  45  1    "\}"

    AN_beginAnimation

    #Create constants and variables  
    set sentinelId [AN_createVar sentinel FIXED -999 {2 18 end} {10 50} CONST]
    set maxCountId [AN_createVar maxCount FIXED 10 {3 18 end} {130 50} CONST]
	
    AN_notice PROGRAM_BEGINS {5 1 end}
    
    set aId [AN_createVar "a" ORGA null {7 9 9} null FLOAT 10]
    set closestId [AN_createVar closest MWH null {8 7 13} null FLOAT]
    set tempId [AN_createVar temp MRH null {8 16 19} null FLOAT]
    set nId [AN_createVar n STEP null {9 5 5} null INT]
    set iId [AN_createVar i STEP null {9 8 8} null INT]
    set inOrderId [AN_createVar inOrder OWF null {10 9 end} null BOOL]
   
	AN_setNewValue $nId 0 {12 1 5}
    AN_setNewValue $closestId $sentinelId {12 8 25}
    AN_writeln "Enter a number: " {13 19 34} "null" "PRINT_REQUEST"
    AN_readData $tempId {14 1 end} "READ_DATA" _null_ {14 start 4}

    AN_setLim $nId @<[AN_getAttribute $maxCountId value] $maxCountId 1
    AN_setExpression $nId "@+1"
    AN_setDirection $nId right
    
	AN_notice WHILE_LOOP_BEGINS {15 1 5}
    
	
	set eka "$tempId != [AN_getAttribute $sentinelId value] {15 8 23} BASIC"
	set toka "&&"
	set kolmas "$nId {15 30 42} BASIC"	
	while {[AN_compare {15 1 5} WHILE $eka $toka $kolmas]} {
 		AN_step $nId {16 1 end}
 		AN_setNewElementValue $aId $tempId [AN_getAttribute $nId value]  {17 1 end}
 		AN_notice IF_STATEMENT {18 1 2}
        set cmpExp "$tempId < [expr abs([AN_getAttribute $closestId value])] {18 5 37} null 1"
        if {[AN_compare {18 1 2} IF_SKIP_ELSE $cmpExp] } {
           AN_setNewValue $closestId $tempId {19 1 end} 
        }
 		AN_writeln "Enter a number: " {21 1 end} "null" "PRINT_REQUEST"
	    AN_readData $tempId {22 1 end} "READ_DATA" _null_ {22 start 4}
    }
   AN_writeln "Closest to zero is [AN_getAttribute $closestId value]" {24 start end} {{"closest" 20}} PRINT_RESULT
   AN_change $inOrderId false {25 1 end}
   AN_notice WHILE_LOOP_BEGINS {26 1 5}
   while { [AN_compare {26 1 5} WHILE "$inOrderId {26 8 15} null 1"] } {
        AN_change $inOrderId true {27 start end}
        AN_notice FOR_LOOP_BEGINS {28 1 3}
        AN_setDirection $iId right
        AN_setLim $iId "@<=[expr [AN_getAttribute $nId value]-1]" "n-1" [expr [AN_getAttribute $nId value] - 1] 
        AN_setExpression $iId "@+1"
        AN_setNewValue $iId 1 {28 6 10}
        while { [AN_compare null FOR "$iId {28 13 18}"] } {
            set index1 [AN_getAttribute $iId value]
            set index2 [expr $index1 + 1]
            AN_notice IF_STATEMENT {29 1 2}
            if { [AN_compareElements $aId $index1 $index2 "a\[i\]" "a\[i+1\]" {29 5 18} ">" THEN] } {
                AN_swap $aId [AN_getAttribute $iId value] [expr [AN_getAttribute $iId value] +1] $tempId {30 1 end} {31 1 end} {32 1 end}
                AN_change $inOrderId false {33 start end} 
            }
            AN_step $iId {28 20 22}
        }
   } 

   AN_writeln "Median is " {37 1 end} null PRINT_RESULT
   set n [AN_getAttribute $nId value]
   set iResult [expr (($n + 1) / 2)]
   #set oddN [expr fmod($n,2) != 0]
   AN_sporadicChange $iId CONS
   AN_setNewValue $iId $iResult {38 1 end} "(n+1) div 2" 
   AN_setLim $nId ODD
   if { [AN_compare {39 1 2} IF "$nId {39 4 22}"] } {
       AN_writeln "[AN_getElementValue $aId [AN_getAttribute $iId value]]" {40 1 end} {{"a\[i\]" 11}} "PRINT_RESULT" 0
   } else {
       set res [expr 0.5*( [AN_getElementValue $aId $iResult] + [AN_getElementValue $aId [expr $iResult +1]] )]
       AN_writeln "$res" {42 1 end} {{"0.5*a\[$iResult\]+a\[[expr $iResult+1]\]" 14}} "PRINT_RESULT" 0
   }
   AN_notice PROGRAM_ENDS {44 start end}
   

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
