#Copyright (c) 2003 University of Joensuu, Department of Computer Science.

# File: ANFunctions.tcl
# Common functions needed to implement ANInterface.tcl
# 
#  

#####################################################################
#
# Comparison related functions
# 
#####################################################################
# Function: compare {{{
#/*{{{***************************************************************
#  Function: compare
#  Description: Dispatcher for different comparison commands
#  Call: 
#  Input parameters:
#  Example:
#  Functionality:
#  History:  Wed Mar  3 15:06:46 EET 2004 Ville Rapa
#***********************************************************/*}}}*/
proc compare { varId args} {
    
    set role [AN_getAttribute $varId role]
    set length [AN_getAttribute $varId length]
    if { ![string equal $length "_null_"] } {
        set ret [eval array_compare $varId $args]
    } else {
        	switch -- $role {
            	STEP {
                	set ret [eval cmpStepper $varId $args]
            	}
            	OWF {
                	set ret [eval cmpOwf $varId $args]
            	}
            	default {
                	if {[llength $args] > 5} {
                    	set ret [eval cmpTwo $varId $args]
                	} else {
                    	set ret [eval cmp $varId $args]
              		}
            	}
        	}
		
    }
   
   return $ret
}
# End of function compare }}}
# Function: cmpStepper {{{
#/*{{{*/***************************************************************
#Function: cmpStepper			
#Description: Compares role stepper	
#Call: 				
#Input parameters:		
#	varId		Id of variable
#	coords		place what is marked and flashed on source code
#			This parameter is a list with 3 values, {line start end}
#			start and end parameters can also have values "start" and "end"
#			Can be null(default)	
#	type		Is type WHILE or FOR 	
#Return value:
#	Boolean value is limit reached or not
#Examble:
#	set ok [AN_cmpStepper $iId {13 5 20} FOR]
#History:	
#	3.1.1992 Mikko Korhonen
#	Wed Mar  3 15:16:53 EET 2004 Ville Rapa
#*****************************************************************/}}}*/

proc cmpStepper {varId coords {type NULL} } {

    global stepState AN lan lanTable
    
	set name [AN_getAttribute $varId name]
    set role [AN_getAttribute $varId role]

	if { !$AN(noSrc)} {	
    	set markId [eval markIt $coords]
    	gb_flash [lindex $markId 0] 5
    	AN_delay
	}
	if {!$AN(noVarPictures) && !$AN(noSrc)} {
    	set arrId [arrow_create_o2o [lindex $markId 0] [AN_getAttribute $varId gbId] ]
	}
    set exp [AN_getAttribute $varId expression]
    set lim [AN_getAttribute $varId comparison]
    set value [AN_getAttribute $varId value]
    set limitExp [AN_getAttribute $varId limitExpression]
    set limitVal [AN_getAttribute $varId limitValue]
	set place [string first "@" $lim]
    set replaced [string replace $lim $place $place $value]
    if {[string equal $limitExp _null_]} {
        set limmi ""
        set limitValue $limitVal
    } else {
        if { [regexp {(^AN)(([0-9]+)$)} $limitExp] } {
            set limmi " ([AN_getAttribute $limitExp name])"
             set limitValue [AN_getAttribute $limitExp value]
        } else {
            set limmi " ($limitExp)"
            set limitValue $limitVal   
        }
	}
    set equ [string first "=" $lim]
    if { [string equal -nocase [AN_getAttribute $varId direction] "right" ]} {
        if {$equ != -1} {
            set mess [format $lanTable([format "%s_STEPPER_CHECK_END_LESS_EQUAL" $lan]) $name $limitValue$limmi]
	    } else {
            set mess [format $lanTable([format "%s_STEPPER_CHECK_END_LESS" $lan]) $name $limitValue$limmi]
        }
       
	} else {
        if {$equ != -1} {
            set mess [format $lanTable([format "%s_STEPPER_CHECK_END_GREATER_EQUAL" $lan]) $name $limitValue$limmi]
        } else {
            set mess [format $lanTable([format "%s_STEPPER_CHECK_END_GREATER" $lan]) $name $limitValue$limmi]
        }
    }
    if {[string equal -nocase $lim ODD]} {
        set mess [format $lanTable([format "%s_VAR_IS_ODD" $lan]) $lanTable([format "%s_%s" $lan $role]) $name]
    }
    if {[string equal -nocase $lim EVEN]} {
        set mess [format $lanTable([format "%s_VAR_IS_EVEN" $lan]) $lanTable([format "%s_%s" $lan $role]) $name]
    }

    showMessage $mess
    if { ![string equal [AN_getAttribute $varId comparison] _null_] } {
		if {!$AN(noVarPictures)} {
        	set ret [gb_compare_STEP [AN_getAttribute $varId gbId] [AN_getAttribute $varId comparison]]
		}
	}
	
    	if {[string equal -nocase $type "BASIC"]} {
		if {$ret} {
			AN_notice IF_YES
		} else {
			AN_notice IF_NO
		}
	}
	if {!$AN(noVarPictures)} {
		lappend ret "gb_clear_STEP [AN_getAttribute $varId gbId]"
	} else {
		set lim [AN_getAttribute $varId comparison]
		if {[ string equal -nocase odd $lim]} {
        	set lim "\[expr fmod(@,2)\]"
    	} 
    	if {[ string equal -nocase even $lim]} {
        	set lim "!\[expr fmod(@,2)\]"
    	} 
        set place [string first "@" $lim ]	
        set replaced [string replace $lim $place $place $value]
        	set eva { 	if {$replaced} {
	                		set ret 1
                    	} else {
	                		set ret 0
                    	}
               		}
        eval [subst $eva]
	}
	if { !$AN(noSrc)} {	
		lappend ret "gb_text_unMark $markId"
	}
   	if { !$AN(noSrc) && !$AN(noVarPictures)} {  
		lappend ret "ANClear $arrId"
	}
	return $ret

}
# End of function cmpStepper }}}
# Function: cmpOwf {{{
proc cmpOwf {varId mark {type IF} {not 0}} {

    global lanTable lan AN
   	if { !$AN(noSrc)  } {
		set markId [eval markIt $mark]
    	gb_flash [lindex $markId 0] 5
	}
    set name [AN_getAttribute $varId name]
    if { $not != 0} {
		set mess [format $lanTable([format "%s_OWF_QUERY_OFF" $lan]) $name]
    } else {
		set mess [format $lanTable([format "%s_OWF_QUERY" $lan]) $name]
    }
	showMessage $mess
	stepStop
    set ret 1	
    set res [AN_getAttribute $varId direction]
	if { [string equal -nocase $res true] && $not == 1} {
		set ret 0
	}
    if { [string equal -nocase $res false] && $not == 0} {
        set ret 0
    }
	if { !$AN(noVarPictures) && !$AN(noSrc) } {
    	set arrId [arrow_create_o2o [lindex $markId 0] [AN_getAttribute $varId gbId] 3]
    	gb_compare_OWF [AN_getAttribute $varId gbId] $ret
	}
	if { $type == "BASIC" } {
		if {! $ret } {
			AN_notice IF_NO
		} else {
 			AN_notice IF_YES
 		}
	}
	if { !$AN(noVarPictures) } {
		lappend ret "ANClear $arrId"
	}
	if { !$AN(noSrc) } {
	lappend ret "gb_text_unMark $markId"
	}
	if { !$AN(noVarPictures) } {
		lappend ret "gb_clear_OWF [AN_getAttribute $varId gbId]"
	}
	return $ret
}
# End of function cmpOwf }}}
# Function: cmp {{{
proc cmp {varId sign  target coords {type null} {abs 0}} {
    
    global lanTable lan stepState AN
	set name [AN_getAttribute $varId name]
    set role $lanTable([format "%s_%s" $lan [AN_getAttribute $varId role]])
	if { !$AN(noSrc) } {
    	set markId [eval markIt $coords]
    	gb_flash [lindex $markId 0] 5    
    	AN_delay
	}
    set value  [AN_getAttribute $varId value]
    set comp { if {$value $sign $target} {        
	    			set ret 1
    			} else { set ret 0}
    		}
	if {$abs} {
		if {$lan == 1} {
			set abs_text ":n itseisarvo"
    	} else {
			set abs_text "s absolute value"
    	}
	} else {
		set abs_text " "	
	}
    set ret [eval [subst $comp]]
### FORM MESSAGE    
    switch -- $sign {
        "<" {
            set mess [format $lanTable([format "%s_VAR_COMP_LESS" $lan]) $role $name $abs_text $target]
        }
        ">" {
            set mess [format $lanTable([format "%s_VAR_COMP_GREATER" $lan]) $role $name $abs_text $target]
        }
        "<=" {
            set mess [format $lanTable([format "%s_VAR_COMP_LESS_OR_EQUAL" $lan]) $role $name $target]
        }
        ">=" {
            set mess [format $lanTable([format "%s_VAR_COMP_GREATER_OR_EQUAL" $lan]) $role $name  $target]
        }
        "!=" {
            set mess [format $lanTable([format "%s_VAR_COMP_NOT_EQUAL" $lan]) $role $name  $target]
        }
        "==" {
            set mess [format $lanTable([format "%s_VAR_COMP_EQUAL" $lan]) $role $name  $target]
        }
        default {
            set mess [format $lanTable([format "%s_VAR_COMP_LESS" $lan]) $role $name "" ""  $target]
        }
    }
    showMessage $mess
### END FORM MESSAGE
	#Create arrow
	if { !$AN(noVarPictures)  && !$AN(noSrc) } { 
    	set arrId [arrow_create_o2o [lindex $markId 0] [AN_getAttribute $varId gbId]]
	}
	#Calculate array head at the comparison picture
    set head 1    
    set tmp [expr $value - $target]
    if {$tmp > 2} {
	    set head 3
    } else {
        if {$tmp < -2} {
	        set head -3
        } else {
	        set head $tmp
        }
    }

    if {$head <= 0 && ([string equal $sign ">"] || [string equal $sign "<="])} {
	    set head [expr $head - 1]
    }

    if {$head >= 0 && ([string equal $sign "<"] || [string equal $sign ">="])} {
	    set head [expr $head + 1]
    }


    set compThis [AN_getAttribute $varId value]
    switch $sign {
	    ">" {set sign "<"; set target [expr $target + 1]}
	    "<" {set sign ">"}
	    "<=" {set sign ">=";set target [expr $target + 1]}
	    ">=" {set sign "<="}
    }
	if { [string equal $sign "=="]  ||  [string equal $sign "!="] } {
		set head  [expr $value - $target]
		if {$head > 0 && $head < 5} {
			set head [expr $head + 2]
		}
		if {$head < 0 && $head > -5} {
			set head [expr $head - 2]
		}		
		if {$head > 6} {
			set head 6
		}
		if {$head < -6} {
			set head -6
		}



	}
    if { [string equal $sign "=="] } {
		if { !$AN(noVarPictures) } {
        	set compId [gb_compare2_MRH [AN_getAttribute $varId gbId] $target $target $head 0] 
		}
    } elseif { [string equal $sign "!="] } {
		if { !$AN(noVarPictures) } {
        	set compId [gb_compare2_MRH [AN_getAttribute $varId gbId] $target $target $head 1]
		}
    } else {
		if { !$AN(noVarPictures) } {
        	set compId [gb_compare [AN_getAttribute $varId gbId] $sign $target $value $head]
		}
    }
    AN_delay
	if { $type == "BASIC" } {
		if { $ret } {
			AN_notice IF_YES
		} else {
 			AN_notice IF_NO
 		}
	}
    stepStop 
	if { !$AN(noVarPictures) } {
		lappend ret "ANClear $compId"
	}
	if { !$AN(noSrc)} {
		lappend ret "gb_text_unMark $markId"
	}
	if { !$AN(noVarPictures)  && !$AN(noSrc)} {
		lappend ret "ANClear $arrId"
	}
    return $ret
}
# end of function cmp }}}
# Function: AN_compare_abs {{{
proc AN_compare_abs {varId sign target coords {type "LOOP"} {elseCoords null} {notice null} } {

    global lanTable lan stepState AN
    set name [AN_getAttribute $varId name]
    set role [AN_getAttribute $varId role]

    # marking
	if { !$AN(noSrc) } {
    	set mark [markIt [lindex $coords 0] [lindex $coords 1] [lindex $coords 2]]
    	gb_flash [lindex $mark 0] 5
    	AN_delay
	}
    set value [expr abs([lindex $AN($varId) 2])]
    set comp { if {$value [subst $sign] $target} {
		set ret 1
    } else { set ret 0}
    }
    eval [subst $comp]

    if {$lan == 1} {
	set abs_text ":n itseisarvo"
    } else {
	set abs_text "s absolute value"
    }

    set role $lanTable([format "%s_%s" $lan $role)

    if {$sign == "<"} {
		set mess [format $lanTable([format "%s_VAR_COMP_LESS" $lan]) $role $name $abs_text $target]
    	showMessage $mess
	}

    if {$sign == ">"} {
	set mess [format $lanTable([format "%s_VAR_COMP_GREATER" $lan]) $role $name $abs_text $target]
    	showMessage $mess
	}

    if {$sign == "<="} {
		set mess [format $lanTable([format "%s_VAR_COMP_LESS_OR_EQUAL" $lan]) $role $name $target]
		showMessage $mess
    }

    if {$sign == ">="} {
		set mess [format $lanTable([format "%s_VAR_COMP_GREATER_OR_EQUAL" $lan]) $role $name $target]
    	showMessage $mess
	}

    if {$sign == "!="} {
		set mess [format $lanTable([format "%s_VAR_COMP_NOT_EQUAL" $lan]) $role $name $target]
		showMessage $mess
    }

	if { !$AN(noSrc) } {
    	set arrId [arrow_create_o2o [lindex $mark 0] [AN_getAttribute $varId gbId]]
	}
    set head 1
    set tmp [expr $value - $target]
    if {$tmp > 2} {
	set head 3
    } else {if {$tmp < -2} {
	set head -3
    } else {
	set head $tmp
    }
    }

    if {$head <= 0 && ([string equal $sign ">"] || [string equal $sign "<="])} {


	set head [expr $head - 1]
    }

    if {$head >= 0 && ([string equal $sign "<"] || [string equal $sign ">="])} {
	set head [expr $head + 1]
    }


    set compThis [AN_getAttribute $varId value]
    switch $sign {
	">" {set sign "<"; set target [expr $target + 1]}
	"<" {set sign ">"}
	"<=" {set sign ">="; set target [expr $target + 1]; set compThis [expr $compThis -1]}
	">=" {set sign "<="; set target [expr $target - 1]}
    }
    set compId [gb_compare [AN_getAttribute $varId gbId] $sign $target $value $head]
    AN_delay

	stepStop

    if {$type == "LOOP"} {
		if {$ret == 0} {
	    	AN_notice WHILE_AND_FALSE_IN
		}  else {
	    	AN_notice WHILE_AND_TRUE_OUT
		}
	}

    if {$type == "IF"} {
		if {$ret == 0} {
			if { ![string equal $notice null] } {
		 		AN_notice [lindex $notice 1]
		 	}
	    	gb_text_unmark_all
	    	ANClear $arrId $compId
	    	AN_notice [lindex $notice 1]
		}  else {
		 if {![string equal $notice  null]} {
		 	AN_notice [lindex $notice 0]
		 }

	}
   }
	if { !$AN(noVarPictures)  && !$AN(noSrc)} {
    	gb_text_unmark_all
    	ANClear $arrId 
	}
	AN clear $compId
    return $ret
}
# End of function AN_compare_abs }}}
# Function: cmpTwo {{{
#/*{{{*/***************************************************************
#	
#Function: cmpTwo 
#Description: Compares variable value to 2 target values.
#Call: 				
#	proc cmpTwo {varId sign sign2 target target2 coords {compType OR} {type "LOOP"} {elseCoords null} {color 1}} {
#Input parameters:		
#	varId		Id of first variable
#	sign		type of first comparison
#	sign2		type of second comparison
#	target		first compared value
#	target2 	second compared value
#	coords		place what is marked and flashed on source code
#			This parameter is a list with 3 values, {line start end}
#			start and end parameters can also have values "start" and "end"
#			Can be null(default)	
#	compType	OR(default) or AND
#	type		where comparison is done, LOOP(default) or IF
#	elseCoords	If going to else part coordinates are needed to mark place on 
#			program code. Same kind as coords parameter. Can be null. (default)
#	color		TODO	
#Return value:
#	Boolean result of comparison
#Examble:
#	set compId [gb_compare2_MRH [AN_getAttribute $varId gbId] [expr $target2 + 1] $target $head $color]
#Fuctionality:
#	Same as AN_compare except this one compares value of variable to two target values.
#See also:					
#	AN_compare
#History:	
#	3.1.1992 Mikko Korhonen
#	Wed Mar  3 15:18:24 EET 2004 Ville Rapa
#***************************************************************/*}}}*/
proc cmpTwo {varId sign sign2 target target2 coords oper {type LOOP}} {

    global lanTable lan stepState AN
    #get role and name 
	set name [AN_getAttribute $varId name]
    set role [AN_getAttribute $varId role]
    
#### marking and flashing
	if { !$AN(noSrc)} {
    	set markId [eval markIt $coords]
    	gb_flash [lindex $markId 0] 5    
    	AN_delay
	}
	
##### Create notice strings and 
	# parameter values to gb_compare!
	
	# Only "AND" and "OR" are supported
    if {[string equal -nocase $oper "OR"] } {
		set color 1
	    set str4Oper $lanTable([format "%s_OR" $lan])
	    set sign3 "||"
    } else {
		set color 0
	    set str4Oper $lanTable([format "%s_AND" $lan])
		set sign3 "&&"
    }
	
	#Values in the comparison "picture"
	set downValue $target
	set upValue $target2
	
	switch -- $sign {
        "!=" { 
			set str4Sign1 $lanTable([format "%s_NOT_EQUAL" $lan])
        }
		"==" {
			set str4Sign1 $lanTable([format "%s_EQUAL" $lan])
		}
		"<" {
			set str4Sign1 $lanTable([format "%s_SMALLER" $lan])
			set downValue [expr $target -1]
		}
		">" {
			set str4Sign1 $lanTable([format "%s_GREATER" $lan])
		}
		"<=" {
			set str4Sign1 $lanTable([format "%s_SMALLER_EQUAL" $lan])
		}
		">=" {
			set str4Sign1 $lanTable([format "%s_GREATER_EQUAL" $lan])
			set downValue [expr $target -1]
		} default {
			set str4Sign1 ""
		}
	}
	
	switch -- $sign2 {
        "!=" { 
			set str4Sign2 $lanTable([format "%s_NOT_EQUAL" $lan])
        }
		"==" {
			set str4Sign2 $lanTable([format "%s_EQUAL" $lan])
		}
		"<" {
			set str4Sign2 $lanTable([format "%s_SMALLER" $lan])
		}
		">" {
			set str4Sign2 $lanTable([format "%s_GREATER" $lan])
			set upValue [expr $target2 +1]
		}
		"<=" {
			set str4Sign2 $lanTable([format "%s_SMALLER_EQUAL" $lan])
			set upValue [expr $target2 +1]
		}
		">=" {
			set str4Sign2 $lanTable([format "%s_GREATER_EQUAL" $lan])
		} default {
			set str4Sign2 ""
		}
	}
	
	# String to role apprevation 
	set str4Role $lanTable([format "%s_%s" $lan [string toupper $role]])	
	set str4Is  $lanTable([format "%s_IS" $lan ])
	
	# Form the final message
	set msg "$str4Is $str4Role '$name' $str4Sign1 $target $str4Oper $str4Sign2 $target2?"
	# And finally show the message. Damn, notice messagebox:)
	showMessage $msg
	
#### End of part notice

#### form parameter to the GB command and call it
	
	set value [AN_getAttribute $varId value]
	# set result of comparison to the variable ret
	set comp {	if {$value [subst $sign] $target [subst $sign3] $value [subst $sign2] $target2} {
					set ret 1
    				} else { set ret 0}
    			}
    eval [subst $comp]
	#Create array from source code to the variable
    if { !$AN(noVarPictures)  && !$AN(noSrc)} {
		set arrId [arrow_create_o2o [lindex $markId 0] [AN_getAttribute $varId gbId]]
	}
    
	set compThis $value
    set head 0
   	
	if { $value >= $upValue } {
		# Arrow to the upper part of the comp.
		set head [expr ($value - $upValue) + 3]
		if { $head > 6 } { set head 6 } 
		
	} elseif { ($value > $downValue) && ($value < $upValue) } {
		# To the middle
		if { $value == [expr $downValue + 1] } {
			set head -1
		} elseif { $value == [expr $upValue - 1]  } {
			set head 1
		}
	} elseif { $value <= $downValue } {
		# Arrow to the lower part of the comp.
		set head [expr ($value - $upValue) - 3]
		if { $head < -6 } { set head -6 } 
	}	
	
	if { !$AN(noVarPictures) } {
		# Animate using GBI	
		set compId [gb_compare2_MRH [AN_getAttribute $varId gbId] $upValue $downValue $head $color]
    }

	AN_delay
	
	# Stop if step mode is on
	stepStop

#### Notice results	
    if { $type == "BASIC" } {
		if {! $ret } {
			AN_notice IF_NO
		} else {
 			AN_notice IF_YES
 		}
	}

#####  Create return value. Which is list of result and clear-command
	#  Result of comparison must be at the first element!!!
	#  This is done to make "recursive" comparisons possible:)
	
	# The reason for  noVarPictures noSrc is expained at the file where 
	# variables those are set(start.tcl)
	
	if { !$AN(noVarPictures) } {
		lappend ret "ANClear $arrId"
		lappend ret "ANClear $compId"
	}
	if { !$AN(noSrc) } {
		lappend ret "gb_text_unMark $markId"
	}
	
    return $ret
}
# End of function cmpTwo }}}
#####################################################################
#
#  End of comparison functions
#
#####################################################################

# Function: updateValue {{{
#/*{{{***************************************************************
#  Function: updateValue
#  Description:
#  Call:
#  Input parameters:
#  Example:
#  Functionality:
#  History:  Wed Mar  3 15:07:01 EET 2004 Ville Rapa
#***********************************************************/*}}}*/

proc updateValue { varId exp {coords null} {txt _null_}} {
    global AN lan lanTable 
    set role [AN_getAttribute $varId role]
    if { ![string equal -nocase $coords "null"] } {
	    set mark [markIt [lindex $coords 0] [lindex $coords 1] [lindex $coords 2]]
	    gb_flash [lindex $mark 0] 5    
	    AN_delay	    
	    set name [AN_getAttribute $varId name]
	    set mess [format $lanTable([format "%s_VAR_UPDATE_VALUE" $lan]) $name $lanTable([format "%s_%s" $lan $role)]
        showMessage $mess
        set arrId [arrow_create_o2o [lindex $mark 0] [AN_getAttribute $varId gbId] 1]
	    
    }
    
    if { [string equal $role "MRH"] || [string equal $role "MWH"] || [string equal $role "GATH"] } { 
        
            setAttribute $varId prevValue  [AN_getAttribute $varId value]
            if { ![string equal [AN_getAttribute $varId prevValue] "_null_"] } {
                gb_var_set_value [AN_getAttribute $varId gbId] [AN_getAttribute $varId prevValue]  1 2
                gb_var_set_value [AN_getAttribute $varId gbId] " "
                AN_delay
            }
        
    }
	if { ![string equal $txt _null_] } {
        set printId [print_update $varId $txt]
    	AN_delay
	}
    set value $exp
    gb_var_set_value [AN_getAttribute $varId gbId] $value
    setAttribute $varId value $value
    if {![string equal $txt "null"] } {
		ANClear $printId
	}
	if {![string equal $coords "null"] } {
	    ANClear $arrId
    }
    update
    stepStop

}
# End of function updateValue }}}
# Function: stepStop {{{
#/*{{{***************************************************************
#  Function: stepStop
#  Description:
#  Call:
#  Input parameters:
#  Example:
#  Functionality:
#  History:
#***********************************************************/*}}}*/

proc stepStop { } {
    global stepState
    if { $stepState } {
	    gb_change_button_state "step" "active"
	    gb_change_button_state "stop" "disabled"
	    gb_change_button_state "run" "active"
	    vwait stepState
    }
}
#end of function stepState }}}
# Function: showMessage {{{
#/*{{{***************************************************************
#  Function: showMessage
#  Description: Creates tk_messageBox with text mess
#  Call: showMessage 
#  Input parameters: mess: text to be shown in the msgBox.
#  Example: showMessage "RTFM"
#  Functionality: 
#  History:  Wed Mar  3 14:19:14 EET 2004 Ville Rapa
#***********************************************************/*}}}*/

proc showMessage { mess } {
    global AN gb eternityLoop
    if {!$AN(debug)} {
        #set fileId [open ./jee "w"]
        #puts -nonewline $fileId $mess
        #close $fileId
        #catch {
        #    exec "/mrapa/src/PlanAni/PlanAni/src/muuta.sh"
        #}
        #catch {
        #    exec "/mrapa/src/PlanAni/PlanAni/src/soita.sh"
        #}
	    tkMessageBox -type ok -message $mess
	}
}
#End of function showMessage }}}
# Function: setLimVar {{{
#/*{{{***************************************************************
#  Function: setLimVar
#  Description: Add steppers parameter limVar value.
#  Call: setLimVar $varId
#  Input parameters: varId: identifier of the variable. 
#  Example: setLimVar $tempId
#  Functionality: If Value is variable identifier then 
#  History: Wed Mar  3 14:20:32 EET 2004
#***********************************************************/*}}}*/


proc setLimVar { varId } {
    set limExp [AN_getAttribute $varId limitExpression]
    if { [regexp {(^AN)(([0-9]+)$)} $limExp] } {
        set limName  [AN_getAttribute $limExp name]
        set limValue [AN_getAttribute $limExp value]
        set stepValue [AN_getAttribute $varId value]
        set varId [AN_getAttribute $varId gbId]
        if { ![string equal $stepValue _null_] } {
            set diff [expr $limValue-$stepValue]
            switch -- $diff {
                1 {
                    gb_stepper_set_lim_var $varId 6 $limName
                }
                2 {
                    gb_stepper_set_lim_var $varId 7 $limName
                }
                3 {
                    gb_stepper_set_lim_var $varId 8 $limName
                }
                0 {
                    gb_stepper_set_lim_var $varId 1 $limName
                }
                -1 {
                    gb_stepper_set_lim_var $varId 5 $limName
                }
                -2 {
                    gb_stepper_set_lim_var $varId 4 $limName
                }
                -3 {
                    gb_stepper_set_lim_var $varId 3 $limName
                }
                
            }
            if {$diff > 3 } {
                gb_stepper_set_lim_var $varId 9 $limName
            }
            if { $diff < -3 } {
               gb_stepper_set_lim_var $varId 2 $limName 
            }
        }
   }

}
# End of function setLimVar }}}
# Function: isAnArray {{{
#/*{{{***************************************************************
#  Function: isAnArray
#  Description: Checks is variable array.
#  Call: isAnArray $numbers
#  Input parameters: varId : identifier of th variable
#  Example: isAnArray $numbersId
#  Functionality: Checks variables attribute length. If it is _null_
#				  then variable is not array and 0 is returned otherwise 
#				  return value is 1
#  History:  Wed Mar  3 14:32:29 EET 2004 Ville Rapa
#***********************************************************/*}}}*/
proc isAnArray { varId } {
    set length [AN_getAttribute $varId length]
    if { ![string equal $length _null_] } {    
        return 1
    } else {
        return 0
    }
}
# End of function isAnArray }}}
# Function: changeSize {{{
#
# Changes font size of the source code
# This is maybe in the wrong layer:)
#
proc changeSize {size} {
    
    global textIdList textList
    gb_set_font_size $size
    for {set i 0} {$i < [llength $textIdList]} {incr i} {
		gb_destroy [lindex $textIdList $i]	
	}
    set textIdList ""
    set pituus [llength $textList]

    for {set i 0} {$i < $pituus } {incr i} {
		set tmp [lindex $textList $i]
		AN_create_program_line [lindex $tmp 0] [lindex $tmp 1] [lindex $tmp 2]
    }

}
# End of function changeSize }}}
# Function: markIt {{{
### VÄRJÄÄ JA PITÄÄ TALLESSA VÄRJÄYKSET
proc markIt {line first last} {

    global textIdList markList
    set line [expr $line - 1]
    if {![string equal -nocase "start" $first]} {
		set first [expr $first - 1]
    } else {
		set first 0
    }
    if {![string equal -nocase "end" $last]} {
		set last [expr $last - 1]
    } else {
		set last "end"
    }

    lappend markList "$line $first $last"
    if {$line >= 0 && $line < [llength $textIdList] } {
        set ID [lindex $textIdList $line]
    } else {
        set ID [lindex $textIdList 0]
    }
    return [gb_text_mark $ID $first $last]
    
}
# End of funtion markIt }}}
# function: getNextId {{{
proc getNextId {} {

    global AN
    return AN[incr AN(idCounter)]

}
#end of function getNextId }}}
# Function: AN_eval {{{
#/*{{{*/**************************************************************
#  Function: AN_eval
#  Description:
#  Call:
#  Input parameters:
#  Example:
#  Functionality:
#  History:
#***********************************************************/*}}}*/
proc AN_eval { exp } {
    global AN
    set ret $exp
    set length [llength $exp]
    for {set i 0} {$i < $length} { incr i} {
        set token [lindex $exp $i]
        switch -regexp $token {
            (^AN)(([0-9]+)$) {
                set ret [lreplace $ret $i $i [AN_getAttribute $token value]]
            }
            ((^AND)$) {
                set ret [lreplace $ret $i $i "&&"]
            }
            ((^OR)$) {
                set ret [lreplace $ret $i $i "||"]    
            }
        }
    }
    return $ret
}
# End of function AN_eval }}}
# Function: ANClear {{{
#/*{{{*/***************************************************************
#	
#Function: ANClear
#Description: Clears example code part. 	
#Call: 	ANClear $args 
#Input parameters:	args: list of destroyable gb ids
#Examble: ANClear $gbArrowId
#Fuctionality:
#	Clears all marks on example code part and destroys gb objects that ids 
#	are on args. 
#History:	
#	3.1.1992 Mikko Korhonen
#	Wed Mar  3 15:12:13 EET 2004 Ville Rapa
#****************************************************************/*}}}*/

proc ANClear {args} {

	foreach i $args {
		gb_destroy $i
		if {[llength $i] > 1} {
			foreach i2 $i {
				gb_destroy $i2
			}
		}
	}
}
# End of function ANClear }}} 
# Function: print_update {{{
#/*{{{***************************************************************
#  Function: print_update
#  Description: creates update text and. 
#  Call:
#  Input parameters: varId: identifier of the variable
#					 txt: text to be shown
#					 spot: spot where array from text points at.
#  Example: $temId "temp := temp + 1" 1
#  Functionality: Delay animation and update screen. Uses gb_print_locate
#  History:  Wed Mar  3 14:28:01 EET 2004 Ville Rapa
#***********************************************************/*}}}*/

proc print_update { varId txt {spot 1}} {
    global lan lanTable AN
    AN_delay
    set iD [gb_print_locate [AN_getAttribute $varId gbId] $txt $spot]
    update
    return $iD
}
# End of function print_update }}}
# Function: AN_print_locate {{{
proc AN_print_locate { varId txt {coords null} {spot 1} {doThis null}} {
	
    global lan lanTable AN
	
    if {$coords != "null" && !$AN(noSrc) } {
		set mark [markIt [lindex $coords 0] [lindex $coords 1] [lindex $coords 2]]
		gb_flash [lindex $mark 0] 5    
		AN_delay
		set arrId [arrow_create_o2o [lindex $mark 0] [AN_getAttribute $varId gbId] 3]
		AN_delay
    }
    if {$doThis != "null"} {
		eval $doThis
    }
    set iD [gb_print_locate [AN_getAttribute $varId gbId] $txt $spot]
    update
    AN_delay
	if { !$AN(noSrc) } {
		return $iD
	} else {
    	return "$iD $arrId"
	}
} 
# End of function AN_print_locate }}}
# Function: repeat {{{
#this is not working:(
#damn there is something wrong in condition evaluation
proc repeat {body whileword condition} {
      global errorInfor errorCode
      if {![string equal $whileword until]} {
          error "should be \"repeat body until condition\""
      }
      while {1} {
          set code [catch {uplevel 1 $body} message]
          switch -- $code {
            1 { return  -code      error \
                        -errorinfo $errorInfo \
                        -errorcode $errorCode $message }
            2 { return -code return $message }
            3 { return {} }
            4 { }
            default { return -code $code $message }
          }
          if {![uplevel 1 [list expr [eval $condition]]]} {break}
	}
}
# End of function repeat }}}
# Function: getStr {{{
#/*{{{***************************************************************
#  Function: getStr
#  Description: Returns string from global variable lantable
#  Call: getStr $keyStr
#  Input parameters: key : Key of the string in the lantable array.
#  Example: getStr MWH
#  Functionality: Forms real key using lan variable. 
#  History: Wed Mar 10 12:59:31 EET 2004
#***********************************************************/*}}}*/
proc getStr { key } {
	global lan lanTable 
	return $lanTable([format "%s_$key" $lan])
}
# End of function getStr }}}
# Function: ADS {{{
#proc ADS { speed } {
#    global gb AN
#    if {$speed == 1} {
# 	set gb(speed) 		150
# 	set gb(mscale) 		5
# 	set gb(flash_speed) 	8
#	set AN(debug) 1
#    }
#    if {$speed == 2} {
# 	set gb(speed) 		800
# 	set gb(mscale) 		3
# 	set gb(flash_speed) 	8
#	set AN(debug) 1
#    }
#    if {$speed == 3} {
# 	set gb(speed) 		1500
# 	set gb(mscale) 		1
# 	set gb(flash_speed) 	8
#	set AN(debug) 0
#    }
#}
# End of Function ADS }}}
# Function: start{{{
#/*{{{***************************************************************
#  Function: start
#  Description: Start first example
#  Call: start
#  Input parameters:
#  Example:
#  Functionality:
#  History: Fri Mar 19 16:33:40 EET 2004
#***********************************************************/*}}}*/

proc start { } {
	global eternityLoop
	foreach component [gbGetExampleList] {
	if { [llength $component] == 4 } {
		set f [file join [gbSetExamplePath] [lindex $component 0] \
				[lindex $component 1] [lindex $component 2]]				
				lappend examples  "[file rootname \
				[file tail $f]] [lindex $component 2]"
		gb_set_example [lindex $component 3]
	}
	if  {[info exists f]} {
		set e [file rootname [file tail $f]] 
		source $f
		while { $eternityLoop } {
			gb_set_randomInput 1
			eval $e
		}
		eval $e
	}
}

}
#}}}


