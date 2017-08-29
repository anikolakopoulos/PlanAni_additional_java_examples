#Copyright (c) 2003 University of Joensuu, Department of Computer Science.

# File: ANInterface.tcl
# Implementation of AN functions

#--------------------------------------------------------------------
# Functions for all roles. 
#--------------------------------------------------------------------
# Function: AN_createVar {{{
#/*{{{***************************************************************
#  Function: AN_createVar
#  Description: Creates Variable of given role and name.
#  Call: AN_createVar { name role value mark {coords null} {type INT} {length null} }
#  Input parameters:    
#       name  : Name of the Varibale 
#       role  : Abbreviation of the variables role.
#               [ MRH | FIXED | FOLL | CONS | GATH | MWH | OWF | ORGA | STEP | 
#                 TEMP | OTHE | ARRAY]
#       value : Initial value of the variable. If no there is no initial value
#               use string "null"
#       mark  : Coordinates of source code which will be flashed before creation.
#               {3 10 13} --> line number, start character and end character.      
#       coords: Coordinate of varibles position. {100 100} -> x and y.
#       type  : Type of the variable. [ INT | CHAR | BOOL | REAL | CONST ]
#               This parameter is only used at the creation even messagebox.
#               There is no type checking based on this parameter.
#       length: Indicator of array variable. This is length of array.
#  Return value: Indentifier to the created variable.
#  Example: AN_createVar tmp TEMP 8 {3 10 13}
#  Functionality: Creates varibale and sets up all attributes.
#  See also: file start.tcl which contains all used role and type abbreviations
#  History: 19.8.2003 Ville Rapa
#***********************************************************/*}}}*/

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
# End of function AN_createVar }}}
# Function: AN_setNewValue {{{
#/*{{{**************************************************************zo*
#  Function: AN_setNewValue
#  Description: Sets new value to variable or updates previous value.
#  Call: AN_setNewValue { varId value {mark null} {txt _null_} {hs 1} }
#  Input parameters: 	
#       varId : Variable's identifier.
#       value : New value of the variable.
#		mark  : Coordinates of source code which will be flashed before creation.
#               {3 10 13} --> line number, start character and end character. 
#	    txt   : Text to be shown before value is assigned. Clarify how the new value is form.
#               "sum + 1"
#		hs    : HotSpot of the variable where value is set. Usually not needed.
#  Example: AN_setNewValue $iId 10 {3 start end}
#           AN_setNewValue $iId 10 {3 start end} "tmp + sum"
#  Functionality: First mark and flash source code, if specified. 
#                 Then if role has prevValue attribute, it is set.
#                  Finally sets new value and cleans the mess:)
#  History: 19.8.2003
#***********************************************************/*}}}*/

proc AN_setNewValue { varId value {mark null} {txt _null_} {hs 1} } {
    global AN lan lanTable 
    set role [AN_getAttribute $varId role]
	# Mark and notice
    if { ![string equal $mark "null"] } {
		if { !$AN(noSrc) } {
	    	set markId [eval markIt $mark]
	    	gb_flash [lindex $markId 0] 5    

	    	AN_delay
		}
	    set name [AN_getAttribute $varId name]
		set state [AN_getAttribute $varId roleState]
		if {[string equal $state new]} {
			set mess [format $lanTable([format "%s_VAR_SET_VALUE" $lan]) $name $lanTable([format "%s_%s" $lan $role])]	
			AN_setAttribute $varId roleState "started"
		} else {
			set mess [format $lanTable([format "%s_VAR_UPDATE_VALUE" $lan]) $name $lanTable([format "%s_%s" $lan $role])]
		}
		if {!$AN(noVarPictures) && !$AN(noSrc)} {
        		set arrId [arrow_create_o2o [lindex $markId 0] [AN_getAttribute $varId gbId] 1]
		}
        showMessage $mess
        AN_delay
        
    }
    # set secondary value. This value int the hotspot 2 and color is gray.
    
	if { [string equal $role "MRH"] || [string equal $role "MWH"] || [string equal $role "GATH"] } { 
		AN_setAttribute $varId prevValue [AN_getAttribute $varId value]
        if { ![string equal [AN_getAttribute $varId prevValue] "_null_"] } {
			if {!$AN(noVarPictures)} {
            	gb_var_set_value [AN_getAttribute $varId gbId] [AN_getAttribute $varId prevValue] 1 2
            	gb_var_set_value [AN_getAttribute $varId gbId] " " 
            	AN_delay
			}
        }
    }
	# create array and text 
	if { ![string equal $txt _null_] } {
		if {!$AN(noVarPictures)} {
        	set printId [print_update $varId $txt]
    		AN_delay
		}
	}
	# get value if variable
    if { [regexp {(^AN)(([0-9]+)$)} $value] } {
		if {!$AN(noVarPictures)} {
			gb_var_set_value_from_variable [AN_getAttribute $value gbId] [AN_getAttribute $varId gbId]
		}
		AN_setAttribute $varId value [AN_getAttribute $value value]
	} else {
		if {!$AN(noVarPictures)} {
			gb_var_set_value [AN_getAttribute $varId gbId] $value
		}
		AN_setAttribute $varId value $value
	}
    if {[string equal $role "STEP"] && ![string equal [AN_getAttribute $varId limitExpression] _null_] } {
		if {!$AN(noVarPictures)} {
       		setLimVar $varId
		}
    }
    
   	if { ![string equal $txt _null_] } {
		if {!$AN(noVarPictures)} {
			ANClear $printId
		}
	}
	
    if {![string equal $mark null]} {
		if {!$AN(noVarPictures) && !$AN(noSrc) } {
			ANClear $arrId
		}
		if { !$AN(noSrc) } {
        		gb_text_unmark $markId
		}
		
    }
    stepStop
}

# End of function AN_setNewValue }}}
#--------------------------------------------------------------------
# TODO. DO NOT USE
# Function: AN_reStart {{{
#/*{{{***************************************************************
#  Function: AN_reStart
#  Description: Restarts variables episode.
#  Call:  AN_reStart { varId { mark null } }
#  Input parameters:
#       varId   :   Identifier of the variable
#       mark    :   Coordinates of source code which will be flashed before creation.
#                   {3 10 13} --> line number, start character and end character. 
#  Example: 
#  Functionality:
#  History:
#***********************************************************/*}}}*/
proc AN_reStart { varId { mark null } } {
    global AN
    #Mark and make event
    set role [AN_getAttribute $varId role]
    if { ![string equal -nocase $mark "null"] } {
    
    }
    lappend attrib "role $role"
    lappend attrib "name [AN_getAttribute $varId name]"
    lappend attrib "length _null_"
    lappend attrib "value _null_"
    lappend attrib  "roleState new"
    switch -- $newRole {
        STEP {                
            lappend attrib "expression _null_"
            lappend attrib "direction _null_"
            lappend attrib "comparison _null_"
            lappend attrib "limitExpression _null_"
            lappend attrib "limitValue _null_"
        }
        CONS {
        
            lappend attrib "unCorrValue _null_"
        }
        FOLL {
        
            lappend attrib "variable _null_"
        }
        MRH {
            lappend attrib "unCorrValue _null_"
            lappend attrib "prevValue _null_"
        }
        GATH {
        
            lappend attrib "prevValue _null_"
        }
        OWF {
        
            lappend attrib "direction _null_"
        }
        TEMP {
        
            lappend attrib "variable _null_"
            lappend attrib "state _null_"
        }
    }
    
    lappend attrib "gbId $newId"
    set AN($varId) $attrib
  
    
}
# End of function AN_reStart }}}
# Function: AN_compare {{{
#/*{{{***************************************************************
#  Function: AN_compare
#  Description: Animates comparison of variables. Animations depends on role.
#  Call: 
#  Input parameters:
#       coords: Coordinates of source code which will be flashed before creation.
#               {3 10 13} --> line number, start character and end character. 
#       type  : Type of the control statement where comparison occures.
#               [ IF | WHILE | REPEAT | IF_SKIP_ELSE ] 
#               IF_SKIP_ELSE is for if statement where is no else part.
#       ars   : List of compare parts. (sum > 10) and ( tmp < 2) includes two 
#               parts. first animations is sum > 10 then tmp < 2
#               after that resuls of whole sentence is evaluated.
#               "sum > 10 {3 6 10}" "&&" "tmp < 2 {3 12 17}"
#               
#  Example:  AN_compare { 3 1 end} IF "sum > 10 {3 6 10}" "&&" "tmp < 2 {3 12 17}"
#  Functionality: -Notice Start of statement.
#                 -Animate all comparisons.
#                 -Notice result
#                 -return result [ 1 | 0 ] 
#  History: 20.8.2003 Ville Rapa 
#***********************************************************/*}}}*/

proc AN_compare { coords {type WHILE} args } {
	global AN
	if { ![string equal -nocase $coords null] && !$AN(noSrc)} {
		set markId [eval markIt $coords]
    	gb_flash [lindex $markId 0] 5
	}
	# notice type of statement
	switch -- $type {
		"IF" {
			AN_notice IF_STATEMENT_TEST 
		}
		"WHILE" {
			AN_notice WHILE_LOOP_TEST 
		}
		"REPEAT" {
			AN_notice REPEAT_LOOP_TEST 
		}
		"IF_SKIP_ELSE" {
			AN_notice IF_STATEMENT_TEST 
		}
		"DO" {
			AN_notice DO_LOOP_TEST 
		}
	}
	if { ![string equal -nocase $coords null] && !$AN(noSrc)} {
		gb_text_unmark $markId
	}
	# compare all conditions
	set clearCommands {}
	foreach test $args {
		if { [string equal $test "||"] || [string equal $test "&&"]} {
			lappend result $test
		} else {
			set tmp [eval compare $test]
			if {[llength $tmp] > 1} {
				lappend result [lindex $tmp 0]
				set clearCommands [concat $clearCommands [lrange $tmp 1 end]]
			} else {
				lappend result $tmp
			}
		}
	}
	set ret [eval expr $result]
	# notice result of the whole condition	
	switch -- $type {
		"IF" {
			if { $ret == 1} {
				AN_notice THEN 
			} else {
				AN_notice ELSE
			}
		}
		"WHILE" {
			if { $ret == 1} {
				AN_notice WHILE_AND_TRUE_IN
			} else {
				AN_notice WHILE_AND_FALSE_OUT	
			}
		}
		"REPEAT" {
			if { $ret == 1} {
				AN_notice WHILE_AND_TRUE_OUT
			} else {
				AN_notice WHILE_AND_FALSE_IN
			}
		}
		"IF_SKIP_ELSE" {
			if { $ret == 1} {
				AN_notice THEN 
			} else {
				AN_notice THEN_SKIP
			}
		}
 		"FOR" {
			if { $ret == 1} {
				AN_notice WHILE_AND_TRUE_IN
			} else {
				AN_notice WHILE_AND_FALSE_OUT	
			}

		}
		"DO" {
			if { $ret == 1} {
				AN_notice WHILE_AND_TRUE_IN
			} else {
				AN_notice WHILE_AND_FALSE_OUT
			}
		}
	}

    set len [expr [llength $clearCommands]-1]
    for { set i $len } { $i >=0 } { incr i -1 } {
        eval [lindex $clearCommands $i]
    }
	#foreach commands $clearCommands {
	#		eval $commands	
	#}
	return $ret
}
# End of function AN_compare }}}
# Function: AN_properChange {{{
#/*{{{***************************************************************
#  Function: AN_properChange
#  Description: Animate proper change of the role.
#  Call: AN_properChange { varId newRole }
#  Input parameters: 
#       varId   : Variable's identifier
#       newRole : Abbreviation of the variable's new role.
#                 [ MRH | FIXED | FOLL | CONS | GATH | MWH | OWF | ORGA | STEP | 
#                 TEMP | OTHE ]
#  Example: AN_properChange $tmpId STEP
#  Functionality: Fixes attributes to fit requirements of the new role and changes picture.
#  History: 21.8.2003
#***********************************************************/*}}}*/

proc AN_properChange { varId newRole } {
    
    global lanTable lan AN
    set name [AN_getAttribute $varId name]
    set value [AN_getAttribute $varId value]
	set newRole [string toupper $newRole]
    set mess [format $lanTable([format "%s_ROLE_CHANGE" $lan]) $name $lanTable([format "%s_%s" $lan $newRole])]
    set gbId [AN_getAttribute $varId gbId]
    showMessage $mess
    
	#Set new attribute values
    lappend attrib "role $newRole"
    lappend attrib "name $name"
    lappend attrib "length _null_"
    lappend attrib "value _null_"

    switch -- $newRole {
        STEP {                
            lappend attrib "expression _null_"
            lappend attrib "direction _null_"
            lappend attrib "comparison _null_"
            lappend attrib "limitExpression _null_"
            lappend attrib "limitValue _null_"
        }
        CONS {
            
           lappend attrib "unCorrValue _null_"
            }
        FOLL {
            
           lappend attrib "variable _null_"
        }
        MRH {
           lappend attrib "unCorrValue _null_"
           lappend attrib "prevValue _null_"
        }
        GATH {
            
           lappend attrib "prevValue _null_"
        }
        OWF {
            
           lappend attrib "direction _null_"
        }
        TEMP {
            
            lappend attrib "variable _null_"
           lappend attrib "state _null_"
        }
    }
	if { !$AN(noVarPictures) } {
    	set newId [tmp_proper  $gbId $newRole]
    	lappend attrib "gbId $newId"
	} else {
		lappend attrib "gbId _null_"
	}
    set AN($varId) $attrib
    if { ![string equal $value _null_]} {
        AN_setNewValue $varId $value
    }
   

}
# End of function AN_properChange }}}
# Function: AN_sporadicChange {{{
#/*{{{***************************************************************
#  Function: AN_sporadicChange
#  Description: Changes role and re-initialize attributes. Animate sporadic change.
#  Call: AN_sporadicChange { varId newRole }
#  Input parameters:
#       varId   : Identifier of the variable
#       newRole : Variables new role
#                 [ MRH | FIXED | FOLL | CONS | GATH | MWH | OWF | ORGA | STEP | 
#                 TEMP | OTHE | ARRAY]  
#  Example: AN_sporadicChange $mrhId STEP
#  Functionality: Initialize attributes debending on new role.
#                 and erase old attributes. After this operation variable
#                 is in the same state than after creating variable of the same role.
#  History: 20.6.2003
#***********************************************************/*}}}*/

proc AN_sporadicChange { varId newRole } {
    global lanTable lan AN
	set newRole [string toupper $newRole]
    if {[AN_getAttribute $varId role] != $newRole} {
		
        set name [AN_getAttribute $varId name]
        set gbId [AN_getAttribute $varId gbId]
			
        set mess [format $lanTable([format "%s_ROLE_CHANGE" $lan]) $name $lanTable([format "%s_%s" $lan $newRole])]
        showMessage $mess
		
        lappend attrib "role $newRole"
        lappend attrib "name $name"
        lappend attrib "length _null_"
        lappend attrib "value _null_"
        lappend attrib  "roleState new"
        switch -- $newRole {
            STEP {                
                lappend attrib "expression _null_"
                lappend attrib "direction _null_"
                lappend attrib "comparison _null_"
                lappend attrib "limitExpression _null_"
                lappend attrib "limitValue _null_"
            }
            CONS {
            
                lappend attrib "unCorrValue _null_"
            }
            FOLL {
            
                lappend attrib "variable _null_"
            }
            MRH {
                lappend attrib "unCorrValue _null_"
                lappend attrib "prevValue _null_"
            }
            GATH {
            
                lappend attrib "prevValue _null_"
            }
            OWF {
            
                lappend attrib "direction _null_"
            }
            TEMP {
            
                lappend attrib "variable _null_"
                lappend attrib "state _null_"
            }
        }
       	if {!$AN(noVarPictures)} {  
        	set newId [tmp_sporadic [AN_getAttribute $varId gbId] $newRole]
        	lappend attrib "gbId $newId"
		} else {
			lappend attrib "gbId _null_"
		}
        set AN($varId) $attrib
    }

}

# End of AN_sporadicChange }}}
# Function: AN_getAttribute {{{
#/*{{{***************************************************************
#  Function: AN_getAttribute
#  Description: returns attribute's value.
#  Call: AN_getAttribute { varId {attribute null} }
#  Input parameters: 
#       varId     : Variable's identifier.
#       attribute : Name of the attribute. If "null" or not specified
#                   then all attribute names is returned.
#  Example: AN_getAttribute $someVarId name
#  Functionality:
#  Return value: value of the attribute or incase of error "".
#  History: 3.7.2003
#***********************************************************/*}}}*/

proc AN_getAttribute { varId {attribute null} } {
    global AN
    set ret ""
    if { [string equal $attribute null] } {
        foreach attrib $AN($varId) {
            lappend ret [lindex $attrib 0]
        }
    } else {
        foreach attrib $AN($varId) {
            if { [string equal -nocase [lindex $attrib 0] $attribute] } {
                set ret [lindex $attrib 1]
            }
        }
    }
    return $ret

}
# End of function AN_getAttribute }}}
# Function: AN_getAll {{{
#/*{{{***************************************************************
#  Function: AN_getAll
#  Description: Returns all variable's attributes.
#  Call: AN_getAll { varId }
#  Input parameters:
#       varId : Identifier of the variable.
#  Example: AN_getAll $tmpId
#  Functionality: returns array of attributes assigned to this variable.
#  return value: Array of attributes. List of attribute name and value pairs.
#                In case of error -1
#  History: 30.5.2003 Ville Rapa
#***********************************************************/*}}}*/

proc AN_getAll { varId } {
    global AN
    if { [catch {
                set ret $AN($varId)
            }]} {
        return -1
    } else {
        return $AN($varId)
    }
}
# End of function AN_getAll }}}
# Function: AN_setAttribute {{{
#/*{{{***************************************************************
#  Function: AN_setAttribute
#  Description: sets value to attribute. 
#  Call: AN_setAttribute {varId attribute value}
#  Input parameters:
#       varId     : Identifier of the variable
#       attribute : Name of the attribute where value is set.
#       value     : New value of the attribute.
#  Example: AN_setAttribute {varId name "tmpVar"}
#  Functionality: Checks that variable contains attribute 
#                   and sets value.
#  History: 20.6.2003 Ville Rapa
#***********************************************************/*}}}*/

proc AN_setAttribute {varId attribute value} {
    global AN
    set oldValue [AN_getAttribute $varId $attribute]
    if { ![string equal $oldValue ""] } {
        set index 0
        foreach att $AN($varId) {
            if {[string equal $attribute [lindex $att 0] ]} {
                set AN($varId) [lreplace $AN($varId) $index $index "$attribute $value"]
            } 
            incr index            
         }   
    }
}
# End of Function AN_setAttribute }}}
# Function: AN_deleteAttributes {{{
#/*{{{***************************************************************
#  Function: AN_deleteAttributes
#  Description: Deletes all variable's attributes.
#  Call: AN_deleteAttributes { varId }
#  Input parameters: 
#       varId : Identifier of the variable
#  Example: AN_deleteAttributes $countId
#  Functionality: unset attributes array assigned to variable.
#  History: 20.8.2003 Ville Rapa
#***********************************************************/*}}}*/
proc AN_deleteAttributes { varId } {
    global AN
    unset AN($varId)

}
# End of function AN_deleteAttributes  }}}
# Function: AN_destroyVariable {{{
#/*{{{***************************************************************
#  Function: AN_destroyVariable
#  Description: Delete variable and unset all variables related to it. 
#  Call: AN_destroyVariable { varId }
#  Input parameters:
#       varId: Identifier of the variable.
#  Example: AN_destroyVariable $tmpId
#  Functionality: Uses gb_destroy to delete all graphics related to variable
#                 and unset variable's data structure.
#  History: 20.8.2003 Ville Rapa
#***********************************************************/*}}}*/

proc AN_destroyVariable { varId } {
    global AN
    if { [info exists AN($varId)] } {
        gb_destroy [AN_getAttribute $varId gbId]
        unset AN($varId)
    } 
}
# End of function AN_destroyVariable }}}
#--------------------------------------------------------------------
#Constant
#--------------------------------------------------------------------
# Function: AN_setCorrValue {{{
#/*{{{***************************************************************
#  Function: AN_setCorrValue
#  Description: Correct value of variable of role constant.
#  Call: AN_setCorrValue { varId newValue {mark null} {txt _null_} }
#  Input parameters:
#       varId    : Identifier of the variable. 
#       newValue : Variable's new value.
#       mark     : Coordinates of source code which will be flashed before creation.
#                  {3 10 13} --> line number, start character and end character. 
#	    txt      : Text to be shown before value is assigned. Clarify how the 
#                  new value is formed. 
#  Example: AN_setCorrValue $numberId [expr abs([AN_getAttribute $numberId value])] \ 
#            {7 start end} "abs(number)"
#  Functionality: Sets prevuos value to spot 2 and new value to spot 1
#  History: 30.6.2003
#***********************************************************/*}}}*/

proc AN_setCorrValue { varId newValue {mark null} {txt _null_} } {
        
    global AN lan lanTable
    set role [AN_getAttribute $varId role]
    if {[string equal $role CONS] } {
       	if { ![string equal $mark "null"] } {
			if { !$AN(noSrc) } {
        		set markId [eval markIt $mark]]
        		gb_flash [lindex $markId 0] 5    
        		AN_delay
			}
        	set name [AN_getAttribute $varId name]
            set state [AN_getAttribute $varId roleState]
            if {[string equal $state new]} {
			    set mess [format $lanTable([format "%s_VAR_SET_VALUE" $lan]) $name $lanTable([format "%s_%s" $lan $role])]	
			    AN_setAttribute $varId roleState "started"
		    } else {
			    set mess [format $lanTable([format "%s_VAR_UPDATE_VALUE" $lan]) $name $lanTable([format "%s_%s" $lan $role])]
		    }
           	showMessage $mess
			if {!$AN(noVarPictures)} {			                                                                  
           		set arrId [arrow_create_o2o [lindex $markId 0] [AN_getAttribute $varId gbId] 1]
			}
		}
  		        
        AN_setAttribute $varId unCorrValue  [AN_getAttribute $varId value]
        if { ![string equal [AN_getAttribute $varId unCorrValue] "_null_"] } {
			if {!$AN(noVarPictures)} {
        		gb_var_set_value [AN_getAttribute $varId gbId] [AN_getAttribute $varId unCorrValue]  1 2
            	gb_var_set_value [AN_getAttribute $varId gbId] " "
			}
        }
        
    }
	if { ![string equal $txt _null_] } {
		if {!$AN(noVarPictures)} {
        	set printId [print_update $varId $txt]
		}
	}
    AN_delay
    if {!$AN(noVarPictures)} {
    	gb_var_set_value [AN_getAttribute $varId gbId] $newValue
	}
    AN_setAttribute $varId value $newValue	
	if {![string equal $txt "null"] } {
		if {!$AN(noVarPictures)} {
			ANClear $printId
		}
	}	
    if { ![string equal -nocase $mark "null"] } {
		if {!$AN(noVarPictures)} {
        	ANClear $arrId
		}
		if { !$AN(noSrc)} {
			gb_text_unmark $markId
		}
    }
	
}
# End of function AN_setCorrValue }}}
#--------------------------------------------------------------------
#Stepper
#--------------------------------------------------------------------
# Function: AN_step {{{
#/*{{{***************************************************************
#  Function: AN_step
#  Description: 
#  Call:  AN_step {varId coords }
#  Input parameters:
#       varId   :   Identifier of the variable.
#       coords  :   Coordinates of source code which will be flashed before creation.
#                   {3 10 13} --> line number, start character and end character.
#  Example: AN_step $iId {13 11 13}
#  Functionality: Animate values depending on direction.
#  History: 20.8.2003
#***********************************************************/*}}}*/

proc AN_step {varId coords } {
    global lanTable  lan stepState AN
    
    set name [AN_getAttribute $varId name]
    set role [AN_getAttribute $varId role]
    set mess [format $lanTable([format "%s_STEPTONEXT" $lan]) $name]
	if { !$AN(noSrc)} {
    	set markId [eval markIt $coords]    
    	gb_flash [lindex $markId 0] 5
	}

    showMessage $mess
    
    set exp [AN_getAttribute $varId expression]
    set lim [AN_getAttribute $varId limValue]
    set value [AN_getAttribute $varId value]
    set place [string first "@" $exp]
    set replaced [string replace $exp $place $place $value]
    set eva { set newVal [expr $replaced] }
    eval [subst $eva]
    
	if {!$AN(noVarPictures) && !$AN(noSrc)} {
    	set arrId [arrow_create_o2o [lindex $markId 0] [AN_getAttribute $varId gbId]]
	}
	set limVal 0
    set limExp [AN_getAttribute $varId limitExpression]
    if { [regexp {(^AN)(([0-9]+)$)} $limExp] } { 
        set diff [expr $newVal - [AN_getAttribute $limExp value]]
        if { [expr abs($diff)] < 4 } {
            set limVal 1
        }
    }
	if {!$AN(noVarPictures)} {
    	gb_rotate_stepper [AN_getAttribute $varId gbId] $limVal
	}
	if {!$AN(noVarPictures) && !$AN(noSrc)} {
    	ANClear $arrId
	}
   	AN_setAttribute $varId value $newVal 
	if { !$AN(noSrc)} {
		gb_text_unmark $markId
	}
    stepStop
    
}
#end of function AN_step }}}
# Function: AN_setLim {{{
#/*{{{***************************************************************
#  Function: AN_setLim
#  Description: Sets stepper attribute comparison and opitionally 
#               also attributes limitExpression and limitValue.
#  Call: AN_setLim { varId cmp { limExp null } { lim null } }
#  Input parameters: 
#       varId : Identifier of the variable. 
#       cmp   : Statement which gives allowed values of the variable.
#               @<=10, @>0, ODD and even. Or everything that is valid 
#               for expr command. @ is replaced for variable's value. 
#               Set value to attribute comparison.
#       limExp: Value of attribute limitExpression. Statement that express
#               limiting value of the variable. If variable identifier then
#               it's value is used as a limiting value otherwise not used in
#               comparison.
#       lim   : Limiting value of the variable. Value of the attribute
#              
#  Example: AN_setLim $countId "@>0" null 0
#           AN_setLim $iId "@<=[AN_getAttribute $numberId value]" $numberId 1
#           AN_setLim $nId ODD
#  Functionality: Sets variables attributes.
#  History: 5.8.2003 Ville Rapa
#***********************************************************/*}}}*/

proc AN_setLim { varId cmp { limExp null } {lim null } } {
	global AN
     set role [AN_getAttribute $varId role]
        if { [string equal $role STEP] } {
           	AN_setAttribute $varId comparison $cmp
            if { ![string equal -nocase $limExp null] } {
                AN_setAttribute $varId limitExpression $limExp
				if {!$AN(noVarPictures)} {
                	setLimVar $varId
				}
            }
            if { ![string equal -nocase $lim null] } {
                AN_setAttribute $varId limitValue $lim
            }
        }
}
# End of  function AN_setLim }}}
# Function: AN_setExpression {{{
#/*{{{***************************************************************
#  Function: AN_setExpression
#  Description: Sets attribute expression for variable of role stepper.
#               statement which gives new value depending on old value.
#  Call: AN_setExpression { varId exp }
#  Input parameters: 
#       varId : Identifier of the variable.
#       exp   : Value to attribute expression
#               @+1, @ character is replaced for current value of the variable. 
#  Example:  AN_setExpressi n $countId "@-1"
#            AN_setExpression $countId "@+1"
#  Functionality: Check if the variable's role is stepper and set attribute.
#  History: 1.8.2003 Ville Rapa
#***********************************************************/*}}}*/

proc AN_setExpression { varId exp } {
    
    set role [AN_getAttribute $varId role]
    if { [string equal $role STEP] } {
        AN_setAttribute $varId expression $exp
        
    }

}
# End of function AN_setExpression }}}
# Function: AN_setDirection {{{
#/*{{{***************************************************************
#  Function: AN_setDirection
#  Description: Sets attribute direction. Only role stepper.  
#  Call: AN_setDirection {varId dir}
#  Input parameters:
#       varId : Identifier of the variable.
#       dir   : new direction. [left|rigth|LEFT|RIGHT] 
#  Example: AN_setDirection $stepId right
#  Functionality: sets attribute direction and creates arrow above picture.
#  History: 1.8.2003 Ville Rapa
#***********************************************************/*}}}*/

proc AN_setDirection {varId dir} {
	global AN
    set role [AN_getAttribute $varId role]
    if { [string equal $role STEP] } {
        if {[string equal -nocase $dir left] || [string equal -nocase $dir right]} {
            AN_setAttribute $varId direction $dir 
			if {!$AN(noVarPictures)} {
           		gb_stepper_set_direction [AN_getAttribute $varId gbId] $dir
			}
        }
    } 
}

# End of function AN_setDirection }}}
#--------------------------------------------------------------------
#OWF
#--------------------------------------------------------------------
# Function: AN_change {{{
#/*{{{***************************************************************
#  Function: AN_change
#  Description:
#  Call: AN_change { varId {value _null_} {coords null} {doThis _null_} }
#  Input parameters:
#       varId   :  Identifier of the variable. 
#       value   :  New value of the variable.
#       coords  :  Coordinates of source code which will be flashed before creation.
#                  {3 10 13} --> line number, start character and end character. 
#       doThis  :  Everything which is evaluable and returns 1 or 0, effects to new value.   
#  Example: AN_change $paliId false {19 start 11} $ex
#           where ex is: set ex "AN_compareElements $candidateId [AN_getAttribute $iId value] \
#                                 [expr [AN_getAttribute $lenId value] - [AN_getAttribute $iId value] + 1  ] \
#                                 i len-1+1 {19 16 end} =="
#  Functionality:
#  History:
#***********************************************************/*}}}*/

proc AN_change { varId {value _null_} {coords null} {doThis _null_}} {
    global lan lanTable AN
    if { [string equal [AN_getAttribute $varId role] OWF] } {
        set dir [AN_getAttribute $varId direction]
        set gbId [AN_getAttribute $varId gbId]
        set name [AN_getAttribute $varId name]
	    set role [AN_getAttribute $varId role]
        if { ![string equal $doThis _null_] } {
             if {$coords != "null" } {
			 	if { !$AN(noSrc)} {
	            	set markId [eval markIt $coords]
	            	gb_flash [lindex $markId 0] 5  
	            	AN_delay
				}
	            set mess [format $lanTable([format "%s_OWF_UPDATE" $lan]) $name]
                showMessage $mess
				if {!$AN(noVarPictures)} {
                	set arrId [arrow_create_o2o [lindex $markId 0] [AN_getAttribute $varId gbId] 1]
				}
                AN_delay
            }
                
            set direc [AN_getAttribute $varId direction]
            if {[eval $doThis]} {
                set mess [format $lanTable([format "%s_OWF_ON" $lan]) $name]
                showMessage $mess
                set value NOACTION
				
            } else {
                set value false
                if { [string equal $direc true] } {
                    set mess [format $lanTable([format "%s_OWF_OFF" $lan]) $name]
                    
                } else {
                    set mess [format $lanTable([format "%s_OWF_OFF_ALREADY" $lan]) $name]
					set value NOACTION
                }
                showMessage $mess
			
            }
        } else {
            if {$coords != "null"} {
				if { !$AN(noSrc) } {
	            	set markId [eval markIt $coords]
	            	gb_flash [lindex $markId 0] 5    
	            	AN_delay	
				}
	            if { [string equal -nocase $value "true"] } {
		            set mess [format $lanTable([format "%s_OWF_SET_ON" $lan]) $name]
                    showMessage $mess
	            } elseif { [string equal -nocase $value "false"] } {
		            set mess [format $lanTable([format "%s_OWF_SET_OFF" $lan]) $name]
                    showMessage $mess
	            }
				if {!$AN(noVarPictures)} {
                	set arrId [arrow_create_o2o [lindex $markId 0] [AN_getAttribute $varId gbId] 1]
				}
            }
   		}
		if { [string equal -nocase $value true] || [string equal -nocase $value false] } {
            if {![string equal $coords null]} {
				if {!$AN(noVarPictures)} {
                	set printId [print_update $varId $value]
				}
                AN_delay
            }
		}
        switch -- $dir {
                 true {                    
                    if { [string equal -nocase $value false] } {
						if {!$AN(noVarPictures)} {
                        	gb_switch_OWF $gbId 4
						}
                        AN_setAttribute $varId direction false
                    } else {
                        if { [string equal -nocase $value new] } {
							if {!$AN(noVarPictures)} {
                            	gb_switch_OWF $gbId 0
							}
                            AN_setAttribute $varId direction _null_
                        }
                    }
                 }
                 _null_ {
                     
                    if { [string equal -nocase $value false] } {
						if {!$AN(noVarPictures)} {
                        	gb_switch_OWF $gbId 4 
						}
                        AN_setAttribute $varId direction false
                    } else {
                        if { [string equal -nocase $value true] } {
							if {!$AN(noVarPictures)} {
                            	gb_switch_OWF $gbId 2
							}
                            AN_setAttribute $varId direction true
                        }
                    }
                    
                 }
                 false {
                    if { [string equal -nocase $value true] } {
						if {!$AN(noVarPictures)} {
                        	gb_switch_OWF $gbId 5
                        	gb_switch_OWF $gbId 1
						}
                        AN_setAttribute $varId direction true
                    } else {
                        if { [string equal -nocase $value _null_] } {
							if {!$AN(noVarPictures)} {
                            	gb_switch_OWF $gbId 5
							}
                            AN_setAttribute $varId direction _null_
                        }
                    }
                 }
		}
        if { [string equal -nocase $value true] || [string equal -nocase $value false] } {
            AN_setNewValue $varId $value
            if {![string equal $coords null] || ![string equal -nocase $value NOACTION] } {
				if {!$AN(noVarPictures)} {
                	ANClear $printId
				}
            }
		}
        if {![string equal $coords null]} {
			if {!$AN(noVarPictures)} {
            	ANClear $arrId
			}
			if { !$AN(noSrc) } {
            	gb_text_unmark $markId
			}
        }
    }
}

# End of function AN_change }}} 
#--------------------------------------------------------------------
#TEMP
#--------------------------------------------------------------------
# Function: AN_setVariable {{{
#/*{{{***************************************************************
#  Function: AN_setVariable
#  Description: Sets attribute variable. [varId] 
#               Only for roles follower and temporary.
#  Call: AN_setVariable {varId varToFollow}
#  Input parameters: 
#       varId       : Identifier of the variable.
#       varToFollow : Identifier of the variable, 
#                     which will be set to attribute.
#  Example:  AN_setVariable $tmp $container
#  Functionality: Check that role is correct and sets Atrributes
#  History: 1.6.2003
#***********************************************************/*}}}*/

proc AN_setVariable {varId varToFollow} {
    set role [AN_getAttribute $varId role]
    if { [string equal $role FOLL] || [string equal $role TEMP] } {
        if { [isAnArray $varToFollow] } {
            AN_setAttribute $varId variable "$varToFollow"
        } else { 
            AN_setAttribute $varId variable $varToFollow
        }
    }
}

# End of  function AN_setVariable }}}
# Function: AN_setState {{{
#/*{{{***************************************************************
#  Function: AN_setState
#  Description:
#  Call: AN_setState { varId {state on} {coords null} {index _null_}
#  Input parameters:
#       varId   :
#       state   :
#       coords  :
#       index   :
#  Example:
#  Functionality:
#  History:
#***********************************************************/*}}}*/

proc AN_setState { varId {state on} {coords null} {index _null_}  } {
    global AN lanTable lan 
    set role [AN_getAttribute $varId role]
    set name [AN_getAttribute $varId name]
    if { [string equal $role TEMP] } {
        if { [string equal -nocase $state on] } { 
            set var [AN_getAttribute $varId variable]
            if { ![string equal $var _null_] } {
				if { !$AN(noSrc)} {
                	set mark [markIt [lindex $coords 0] [lindex $coords 1] [lindex $coords 2]]
                	gb_flash [lindex $mark 0] 5
                	AN_delay
				}
                set state [AN_getAttribute $varId roleState]
                if {[string equal $state new]} {
			        set mess [format $lanTable([format "%s_VAR_SET_VALUE" $lan]) $name $lanTable([format "%s_%s" $lan $role])]	
			        AN_setAttribute $varId roleState "started"
		        } else {
			        set mess [format $lanTable([format "%s_VAR_UPDATE_VALUE" $lan]) $name $lanTable([format "%s_%s" $lan $role])]
		        }

                showMessage $mess
				if {!$AN(noVarPictures)} {
                	set arrId [arrow_create_o2o [lindex $mark 0] [AN_getAttribute $varId gbId] ]
                	gb_switch_TEMP [AN_getAttribute $varId gbId] 1
				}
                AN_setAttribute $varId state on
 
                if { ![isAnArray $var] } {
					if {!$AN(noVarPictures)} {
                    	gb_var_set_value_from_variable [AN_getAttribute $var gbId] [AN_getAttribute $varId gbId]
					}
                    AN_setNewValue $varId [AN_getAttribute $var value]
                } else {
                    if {[string equal $index _null_]} {
                        set index 1
                    }
					set roleFrom [AN_getAttribute $var role]
					set erase null
					if { [string equal $roleFrom ORGA] } {
						set erase 1
					}
					if {!$AN(noVarPictures)} {
                    	gb_var_set_value_from_variable [AN_getAttribute $var gbId] [AN_getAttribute $varId gbId] $index null $erase
					}
                    AN_setNewValue $varId [AN_getElementValue $var $index]
                }
				if {!$AN(noVarPictures)} {
                	ANClear $arrId
				}
				if { !$AN(noSrc)} {
                	gb_text_unmark_all
				}
                
            }
            
        } elseif  { [string equal -nocase $state off] } {
			if {!$AN(noVarPictures)} {
            	gb_switch_TEMP [AN_getAttribute $varId gbId] 0
			}
            AN_setAttribute $varId state off
            if {!$AN(noVarPictures)} {
				gb_var_set_value [AN_getAttribute $varId gbId] " "
			}
            AN_setAttribute $varId value _null_
            
        }
    }
}
# End of function AN_setState }}}
# Function: AN_follow {{{
#/*{{{***************************************************************
#  Function: AN_follow
#  Description: 
#  Call: AN_follow { varId coords }
#  Input parameters:
#       varId   :   Identifier of the variable.
#       coords  :   Coordinates of source code which will be flashed before creation.
#                   {3 10 13} --> line number, start character and end character.
#  Example: AN_follow $last_fibId {15 start end}
#  Functionality:
#  History: 20.8.2003 Ville Rapa
#***********************************************************/*}}}*/

proc AN_follow { varId coords } {
    global AN lanTable lan
    set role [AN_getAttribute $varId role]
    set name [AN_getAttribute $varId name] 
    if { [string equal $role FOLL] } {
            
            set var [AN_getAttribute $varId variable]
            if { ![string equal $var _null_] } {
                #normal variable
				if { !$AN(noSrc) } {
                	set mark [markIt [lindex $coords 0] [lindex $coords 1] [lindex $coords 2]]
                	gb_flash [lindex $mark 0] 5
                	AN_delay
				}
                set state [AN_getAttribute $varId roleState]
                if {[string equal $state new]} {
			        set mess [format $lanTable([format "%s_VAR_SET_VALUE" $lan]) $name $lanTable([format "%s_%s" $lan $role])]	
			        AN_setAttribute $varId roleState "started"
		        } else {
			        set mess [format $lanTable([format "%s_VAR_UPDATE_VALUE" $lan]) $name $lanTable([format "%s_%s" $lan $role])]
		        }

                showMessage $mess
				if {!$AN(noVarPictures)} {
                	set arrId [arrow_create_o2o [lindex $mark 0] [AN_getAttribute $varId gbId] ]
				}
                if { [llength $var] == 1 } {
					if {!$AN(noVarPictures)} {
                    	gb_var_set_value_from_variable [AN_getAttribute $var gbId] [AN_getAttribute $varId gbId]
					}
                    AN_setNewValue $varId [AN_getAttribute $var value]
                } else {
                    set index [lindex $var 1]
                    set var [lindex $var 0]
                    #TODOO Array
                }
			
			if {!$AN(noVarPictures)} {
            	ANClear $arrId
			}
			if { !$AN(noSrc)} {
            	gb_text_unmark_all
            }        
        
     	}       
    } 

}

# End of function AN_follow }}}
#--------------------------------------------------------------------
#ARRAY
#--------------------------------------------------------------------
# Function: AN_setNewElementValue {{{
#/*{{{***************************************************************
#  Function: AN_setNewElementValue
#  Description: Set value to array element.
#  Call:  AN_setNewElementValue {varId value index {coords null} {txt _null_} }
#  Input parameters: 
#       varId   :   Identifier of the element
#       value   :   Variables new value.
#       index   :   Element index where value is set.
#       coords  :   Coordinates of source code which will be flashed before creation.
#                   {3 10 13} --> line number, start character and end character. 
#       txt     :   Text to be shown before value is assigned. Clarify how the new value is form.
#                   "sum + 1"
#  Example:   AN_setNewElementValue $aId $tempId [AN_getAttribute $nId value]  {13 1 end}
#  Functionality: 
#  History:
#***********************************************************/*}}}*/

proc AN_setNewElementValue {varId value index {coords null} {txt _null_} } {
    global AN lan lanTable
    set length [AN_getAttribute $varId length]
    if { ![string equal $length _null_] && ($index <= $length) && ($index > 0) } {
        if { ![string equal $coords null]} {
            set placeId [gb_var_get_valueId [AN_getAttribute $varId gbId] 0 1 $index ]
            if { !$AN(noSrc)} {
				set mark [markIt [lindex $coords 0] [lindex $coords 1] [lindex $coords 2]]
	        	gb_flash [lindex $mark 0] 5    	        
				AN_delay
			}
            set name [AN_getAttribute $varId name]
	        set role [AN_getAttribute $varId role]
	        set mess [format $lanTable([format "%s_CHANGE_VAR_VALUE" $lan]) $lanTable([format "%s_%s" $lan $role]) $name ]
            showMessage $mess
            if { !$AN(noVarPictures) } {
				set arrId [arrow_create_o2o [lindex $mark 0] [AN_getAttribute $varId gbId] ]
			}
            AN_delay
        }
        if { ![string equal $txt _null_] } {
			if { !$AN(noVarPictures) } {
            	set iD [ gb_print_array_locate [AN_getAttribute $varId gbId] $txt $index]
            	update
            	AN_delay
			}
        }
		
        #set gbId [AN_getAttribute $varId gbId]
		if { [regexp {(^AN)(([0-9]+)$)} $value] } {
			if { !$AN(noVarPictures) } {
				gb_var_set_value_from_variable [AN_getAttribute $value gbId] [AN_getAttribute $varId gbId] null $index  
			}
			AN_setAttribute $varId value [AN_getAttribute $value value]
            set value [AN_getAttribute $value value]
		} else {
			if { !$AN(noVarPictures) } {
				gb_var_set_value [AN_getAttribute $varId gbId] $value 0 1 $index
			}
			AN_setAttribute $varId value $value
		}

        #gb_var_set_value $gbId $value 0 1 $index
        set values [AN_getAttribute $varId values]
        if { [string equal $values _null_] } {
            AN_setAttribute $varId values [lappend prevValues [list "$index $value"]]
        } else {
            if { [string equal [AN_getElementValue $varId $index] ""] } {
               AN_setAttribute $varId values [list [lappend values "$index $value"]] 
            } else {
                set idx [lsearch $values "$index [AN_getElementValue $varId $index]"]
                AN_setAttribute $varId values [list [lreplace $values $idx $idx "$index $value"]]
            }
        }
		if { !$AN(noVarPictures) } {
        	if { ![string equal $txt _null_]} { ANClear $iD }
        	if { ![string equal $coords null] } {ANClear $arrId }
		}
		if { !$AN(noSrc)} {
        	gb_text_unmark_all 
		}
        
    }
}

#End of function AN_setNewElementValue }}} 
# DO NOT USE THIS. TODO
# Function: AN_getElementAttribute {{{
#/*{{{***************************************************************
# DO NOT USE THIS. RETURNS LENGTH OF THE ARRAY VARIABLE, NOTHING ELSE
#  Function: AN_getElementAttribute
#  Description: returns length 
#  Call: AN_getElementAttribute { }
#  Input parameters: --
#  Example: AN_getElementAttribute
#  Functionality: return length
#  History: 20.8.2003 Ville Rapa
#***********************************************************/*}}}*/

proc AN_getElementAttribute {varId } {
    set length [AN_getAttribute $varId length]
    
}

# End of function AN_getElementAttribute }}}
# Function: AN_getElementValue {{{
#/*{{{***************************************************************
#  Function: AN_getElementValue
#  Description: Returns value of the array element.
#  Call: AN_getElementValue { varId element}
#  Input parameters: 
#       varId   : Identifier of the element.
#       element : Index of the element.
#  Example: AN_getElementValue $aId 5
#  Functionality: Checks if the variable is array and returns element value. 
#  Return value : Value of the element or in case of the error ""   
#  History: 2.6.2003 Ville Rapa
#***********************************************************/*}}}*/

proc AN_getElementValue { varId element} {
    set ret ""
    if { [isAnArray $varId] } {
        set values [AN_getAttribute $varId values]
        foreach value $values {
            if { $element == [lindex $value 0] } {
                set ret  [lindex $value 1]
            }
        }
    }
    return $ret
}

# End of function AN_getElementValue }}}
# Function: AN_compareElements {{{
#/*{{{***************************************************************
#  Function: AN_compareElements
#  Description: Compare two array elements. 
#  Call: AN_compareElements { varId index index2 txt txt2 coords {exp "=="} {notice null} }
#  Input parameters:
#       varId  : Identifier of the object. 
#       index  : Index of the first element that will be in the comparison.
#       index2 : Index of the second elemet that will be in the comparison.
#       txt    : Text to be shown under value.
#       txt2   : Text to be shown under value. 
#               
#       coords :  Coordinates of source code which will be flashed before creation.
#                 {3 10 13} --> line number, start character and end character.
#       exp    :  Compare sign. [<|>|<=|>=|==|!=]  
#       notice :  Key to language table. Function calls AN_notice with this value if
#			      not null.
#
#
#  Example: AN_compareElements $aId $index1 $index2 "a\[i\]" "a\[i+1\]" {22 4 17} ">" THEN
#  Functionality: Creates message event and calls gb_var_array_compare. 
#  History: 5.6.2003
#***********************************************************/*}}}*/

proc AN_compareElements { varId index index2 txt txt2 coords {exp "=="} {notice null} } {
    global AN lan lanTable
    
    set gbId [AN_getAttribute $varId gbId]	
    set name [AN_getAttribute $varId name]
    set value [AN_getElementValue $varId $index]
    set value2 [AN_getElementValue $varId $index2]
    if { !$AN(noSrc) } {
		set markId [eval markIt $coords]
    	gb_flash [lindex $markId 0] 5
	}
	if { !$AN(noVarPictures) } {
		set arrId [arrow_create_o2o [lindex $markId 0] [AN_getAttribute $varId gbId] ]
	}
    if { [string equal $exp "=="]} {	
    	if { [string equal $value $value2] } {
	        set yes 1
	    } else {
	        set yes 0
	    }
	    set mess [format $lanTable([format "%s_ARRAY_COMPARE_EQUAL" $lan]) $txt $txt2]
    } elseif { [string equal $exp "<"] } {
	    set mess [format $lanTable([format "%s_ARRAY_COMPARE_LESS" $lan]) $txt $txt2]
	    if {$value <  $value2} {
	        set yes 1
	    } else {
	        set yes 0
	    }
    } elseif { [string equal $exp ">"] } {
    	if {$value > $value2} {
	        set yes 1
	    } else {
	        set yes 0
	    }
	    set mess [format $lanTable([format "%s_ARRAY_COMPARE_GREATER" $lan]) $txt $txt2]
    }
    showMessage $mess
   	if { $yes } {
		if { !$AN(noVarPictures) } {
			gb_var_array_compare $gbId $index $index2 $txt $txt2 TRUE
		}
		if { [string equal $notice THEN] } {
			AN_notice THEN
        } else {
			AN_notice IF_YES
		}
	} else {
		if { !$AN(noVarPictures) } {
			gb_var_array_compare $gbId $index $index2 $txt $txt2 FALSE
		}
		if { [string equal $notice IF_FALSE] } {
			AN_notice IF_FALSE
		} else {
			AN_notice IF_NO	
		}
    }
    set ret $yes
	if { !$AN(noVarPictures) } {
    	gb_clear_array $gbId $index $index2
    	ANClear $arrId
	}
	if { !$AN(noSrc)} {
    	gb_text_unmark $markId
	}
    return $ret
}
# End of function AN_compareElements }}}
#--------------------------------------------------------------------
#ORGA
#--------------------------------------------------------------------
# Function: AN_swap {{{
#/*{{{***************************************************************
#  Function: AN_swap
#  Description: Swaps two values of organinizer array. Uses temp variable
#               to hold value for a short time.
#  Call: AN_swap { varId from to tempVarId args}
#  Input parameters: 
#       varId     : Identifier of the variable.
#       from      : Index of the first value, which will be swapped.
#       to        : Index of the second value, which will be swapped.
#       tempVarId : Identifier of the variable which will be used as
#                   a temporary variable during swapping.
#       args      : list of coordinates to flash source. 
#  Example:  AN_swap $aId [AN_getAttribute $iId value] \ 
#            [expr [AN_getAttribute $iId value] +1] $tempId {23 1 end} {24 1 end} {25 1 end}
#  Functionality: Checks that varId's role is orga then transforms tempVarId's role  if needed.
#                 After that make all assignments. First assigns value from "from" index to temp
#                   variable, then "to" to "from" and finally temp to "to" 
#  History: 10.8.2003
#***********************************************************/*}}}*/

proc AN_swap { varId from to tempVarId args} {
    global AN lan lanTable
    
    if { [string equal [AN_getAttribute $varId role] ORGA] } {
        if { ![string equal [AN_getAttribute $tempVarId role] TEMP] } {
            AN_sporadicChange $tempVarId TEMP
        }
        AN_setVariable $tempVarId $varId
        AN_setState $tempVarId on [lindex $args 0] $from
        AN_setNewElementValue $varId [AN_getElementValue $varId $to] $from [lindex $args 1]  "[AN_getAttribute $varId name]\[$from\]"
        AN_setNewElementValue $varId $tempVarId $to [lindex $args 2] 
        AN_setState $tempVarId OFF 
    }

}

# End of function AN_swap }}}
# Function: AN_readData {{{
#/*{{{***************************************************************
#  Function: AN_readData
#  Description: Reads value from PlanAni's input field and animate 
#               value assignment to variable.
#  Call: AN_readData {varId coords {notice "null"} {index _null_} } 
#  Input parameters: 
#       varId  : Identifier of the variable. Value will be assigned to
#                this variable.
#       coords : Coordinates of source code which will be flashed before creation.
#                {3 10 13} --> line number, start character and end character. 
#       notice : Key to language table. Function calls notice with this value if
#			     not null.
#       index  : Index of array element where value will be assignt.
#  Example: AN_readData $lukuId {4 35 end} "READ_DATA"
#  Functionality: Flash code, make notice, read a value, prepare variable to animation,
#                 animate value to variable and sets new value to variable.
#  History: 20.8.2003
#***********************************************************/*}}}*/

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

# End of function AN_readData }}}
# Function: AN_createProgramLine {{{
#*/*{{{***************************************************************
#	
#Function: AN_createProgramLine
#Description: 			
#	Creates program lines to source code part of GUI.
#Call: 				
#	AN_createProgramLine {row col text}
#Input parameters:		
#	row 		line number of program line
#	col		column number of program line
#	text		text of program line
#Return value:
#	-
#Examble:
#	AN_createProgramLine 1 1 "program palindrome;"
#Fuctionality:
#	Creates program lines to source code part.
#See also:					
#	
#History:	
#	3.1.1992 Mikko Korhonen
#	Thu Mar  4 00:37:14 EET 2004
#****************************************************************/*}}}*/

proc AN_createProgramLine {row col text} { 

    global textList textIdList AN

    lappend textList "$row $col {$text}"

    set row [expr ($row-1)]
    set col [expr ($col-1)]

    set fontSize [gb_get_font_size]
    set row [expr (($fontSize + 5) * $row)]
    set col [expr (($fontSize/2) * $col)]
	if { !$AN(noSrc) } {
    	lappend textIdList [gb_text_create src $col $row $text]
	}
}

# End of function AN_createProgramLine }}}
# Function: AN_writeln {{{
#/*{{{*/***************************************************************
#	
#Function: AN_writeln 
#References:					
#	-
#Description: 			
#	Writes line and line break to I/O area.
#Call: 				
#	proc writeln {text {coords no} {extra null} {notice null}}
#Input parameters:		
#	text 		Output text
#	coords		place what is marked and flashed on source code
#			This parameter is a list with 3 values, {line start end}
#			start and end parameters can also have values "start" and "end"
#			Can be null(default)	
#	extra		This is a double list with a character potitions and extra texts. 
#			Text is created above line and arrow from text spots to 
#			the right splace on output text.
#	notice		Key to language table. Function calls notice with this value if
#			not null.
#Return value:
#	-
#Examble:
#	writeln "Anna [getAttribute $iId value]. kirjain: " {14 start end} {{i 6}} OUTPUT
#Fuctionality:
#	Prints text with value descriptions. If text contains variable values, names of variables
#	are also printed.
#Limits: 
#							
#See also:					
#	AN_write, notice
#History:	
#	3.1.1992 Mikko Korhonen
#	
#****************************************************************/*}}}*/

proc AN_writeln {text {coords no} {extra null} {notice null} {newline 1} } {
    
    global stepState AN
    set idList ""	
    set mark NULL
    if {![string equal -nocase "no" $coords] && !$AN(noSrc)} {
		set mark [markIt [lindex $coords 0] [lindex $coords 1] [lindex $coords 2]]
		gb_flash [lindex $mark 0] 5
    }    

    if {$notice != "null"} {
		AN_notice $notice
    }
	
    set txtId [gb_print_output $text $newline [lindex $mark 0] ]    
    if {$extra != "null"} {
		set incH 15
		set incW 15
		set origH 50
		set origW 20

		foreach i $extra {
	    	set pos [get_char_position $txtId [lindex $i 1]] 
	    	set posX [lindex $pos 0]
	    	set posY [lindex $pos 1]
	    	set tmparr [gb_arrow_create io [expr $posX + $origW] [expr $posY - $origH] io  $posX $posY 1]
	    	lappend idList $tmparr
	    	gb_arrow_change_color $tmparr [gb_get_help_color]
	    	set flashit [gb_text_create io [expr $posX + $origW] [expr $posY - $origH - 15] [lindex $i 0]]
	    	gb_text_change_color $flashit [gb_get_help_color]
	    	lappend idList $flashit
	    	for {set i 0} {$i < 6} {incr i} {
				[get_area $flashit] lower $flashit
				update
				after [gb_get_flash_speed]
				[get_area $flashit] raise $flashit
				update
				after [gb_get_flash_speed]
			}	
	    	set origH [expr $origH - $incH]
	    	set origW [expr $origW + $incW]
		}
	}

    set pos [get_char_position $txtId 5] 
    if { !$AN(noSrc)} {
		AN_delay
    	gb_text_unmark_all
	}
    stepStop
    foreach i $idList {
	gb_destroy $i
    }
	#FIX
    return $txtId
}

# End of function AN_writeln }}}
# Function: AN_write {{{
#/*{{{*/**************************************************************
#	
#Function: AN_write
#References:					
#	-
#Description: 			
#	Prints text to I/O area without line break.
#Call: 				
#	AN_write {text {coords no} {notice null}}
#Input parameters:		
#	text		Output text
#	coords		place what is marked and flashed on source code
#			This parameter is a list with 3 values, {line start end}
#			start and end parameters can also have values "start" and "end"
#			Can be null(default)	
#	notice		Key to language table. Function calls notice with this value if
#			not null.
#Return value:
#	-
#Examble:
#	AN_write " palindromi." { 23 1 end } PRINT_RESULT
#Fuctionality:
#	
#Limits: 
#							
#See also:					
#	
#History:	
#	3.1.2003 Mikko Korhonen
#	
#***************************************************************/*}}}*/

proc AN_write {text {coords no} {notice null}} {
    global AN
	set mark NULL
    if {![string equal -nocase "no" $coords] && !$AN(noSrc)} {
		set mark [eval markIt $coords]
		gb_flash [lindex $mark 0] 5
    }

    if {$notice != "null"} {
		AN_notice $notice 
    }
    set txtId [gb_print_output $text 0 [lindex $mark 0]]
	
    AN_delay
	if { !$AN(noSrc)} {
		gb_text_unmark_all
	}
}

# End of function AN_write }}}
# Function: AN_notice {{{
#/*{{{*/**************************************************************
#	
#Function: AN_notice
#References:					
#	-
#Description: 			
#	Creates and shows message window.
#Call: 				
#	AN_notice {action {coords null}}
#Input parameters:		
#	action		Language code from language table
#	coords		place what is marked and flashed on source code
#			This parameter is list with 3 values, {line start end}
#			start and end can also have values "start" and "end"
#			Can be null(default)
#	
#Return value:
#	-
#Examble:
#	AN_notice LOOP_ENDS {16 start 6}
#Fuctionality:
#	Creates message window with accept(ok) button and shows message.
#Limits: 
#							
#See also:					
#	AN_notice_name
#History:	
#	3.1.1992 Mikko Korhonen
#	
#**************************************************************/*}}}*/

proc AN_notice {action {coords null}} {
    
	global lan lanTable stepState AN
	if {!$AN(debug)} {
		set mess $lanTable([format "%s_%s" $lan $action])
	
		if {$coords != "null" && !$AN(noSrc)} {
			set mark [markIt [lindex $coords 0] [lindex $coords 1] [lindex $coords 2]]
			gb_flash [lindex $mark 0] 5
		}
		showMessage $mess
		update
	
		AN_delay
	
		if {$coords != "null" && !$AN(noSrc)} {
	   	    gb_text_unmark_all
		}
	}
}

# End of function AN_notice }}}
#--------------------------------------------------------------------
# Commands for animation control
# Not related to roles/variables!!!
#--------------------------------------------------------------------
# Function: AN_endAnimation {{{
#/*{{{*/**************************************************************
#  Function: AN_endAnimation
#  Description: Stop animation and puts planani to start state. 
#  Call: AN_endAnimation
#  Input parameters: --
#  Example: AN_endAnimation
#  Functionality: Clears GUI modifies buttons state and reset PlanAni.
#  History: 10.5.2003
#***********************************************************/*}}}*/

proc AN_endAnimation { } {
	 gb_stop
	 gb_change_button_state "run" "disabled"
	 gb_change_button_state "step" "disabled"
     AN_reset

}

# End of function AN_endAnimation }}}
# Function: AN_beginAnimation {{{
#/*{{{*/***************************************************************
#	
#Function: AN_beginAnimation
#References:
#	-
#Description:
#	Waits until run or step event occurs. 
#Call: 				
#	AN_beginAnimation
#Input parameters:
#	-
#Return value:
#	-
#Examble:
#		AN_beginAnimation
#Fuctionality:
#	waits until global variable runState will be modified.
#Limits: 
#	None
#See also:					
#History:	
#	28.2.2002 Ville Rapa
#	
#***************************************************************/*}}}*/

proc AN_beginAnimation { } {
	global runState eternityLoop 
    update
	if { $eternityLoop } {
		gb_animate_run_pressing
		#event generate $gb(control).run <Motion> -warp 1 -x 10 -y 10
		#AN_delay 
		#event generate $gb(control).run <ButtonPress-1> 
		#after 100 event generate $gb(control).run <ButtonRelease-1> 
	}
	vwait runState

 }

# End of function AN_beginAnimation }}}
# Function: AN_delay {{{
#/*{{{***************************************************************
#  Function: AN_delay
#  Description: wait some time and continues execution.
#  Call: AN_delay
#  Input parameters: --
#  Example: AN_delay
#  Functionality: modify variable a after $gb_speed seconds
#                 Until then execution waits that a will be modified.
#  History: 20.7.2003 Ville Rapa
#***********************************************************/*}}}*/

proc AN_delay {} {
    after [gb_get_speed] "set a 1"
    vwait a    
}

# End of function AN_delay }}}
#--------------------------------------------------------------------
# Commands for animation control buttons. These command are bind to 
# the buttons. If GBI needs to do something when button is pressed 
# then GBI calls must be here!!
#--------------------------------------------------------------------
# Function: AN_stop {{{
#/*{{{*/**************************************************************
#  Function: AN_stop
#  Description:
#  Call:
#  Input parameters:
#  Example:
#  Functionality:
#  History:
#***********************************************************/*}}}*/
proc AN_stop {} {
	global runState
	gb_stop
	vwait runState
}
# End of function AN_stop }}}
# Function: AN_reset {{{
#/*{{{*/**************************************************************
#  Function: AN_reset
#  Description: Reset animation and variabeles. 
#  Call: AN_reset
#  Input parameters: -
#  Example: AN_reset
#  Functionality: 
#  History: Wed Mar  3 13:25:23 EET 2004 Ville Rapa
#***********************************************************/*}}}*/

proc AN_reset {} {

    global textList textIdList markList AN runState examples eternityLoop
    gb_reset
	set textList ""
    set textIdList ""
    set markList ""
    set AN(idCounter) 0
	# Source the rigth example!!!
	set foo [ gb_get_example_state ]
	addExampleToTitle $foo
	eval $foo
}

# End of function AN_reset }}}
# Function: AN_stepStop {{{
#/*{{{*/**************************************************************
#  Function: AN_step
#  Description: AN front-end for step button. Handles step-button related stuff.
#  Call: AN_step
#  Input parameters: -
#  Example: AN_step
#  Functionality: sets variables stepState and runState to 1, and disable 
#				  step-button.
#  History:  Wed Mar  3 13:21:53 EET 2004 Ville Rapa
#***********************************************************/*}}}*/
proc AN_stepStop {} {
    global stepState runState
    set stepState 1
	gb_change_button_state "step" "disabled"
	gb_change_button_state "stop" "normal"
	gb_change_button_state "run" "disabled"
    set runState 1
    #gb_step
}

# End of function AN_step }}}
# Function: AN_run {{{
#/*{{{*/**************************************************************
#  Function: AN_run
#  Description: Sets AN library to the animation state and calls gb_run.
#				This command contains all functionality which must be done
#				when run button is pressed. 
#  Call: AN_run
#  Input parameters: -
#  Example: AN_run
#  Functionality:
#  See also: gb_bind
#  History: Wed Mar  3 13:18:26 EET 2004 Ville Rapa 
#***********************************************************/*}}}*/
proc AN_run {} {
    global runState stepState
    set stepState 0
    gb_run
    set runState 1
}

# End of function AN_run }}} 

#Function: AN_proc{{{
#/*{{{***************************************************************
#  Function: AN_proc
#  Description:
#  Call:
#  Input parameters:
#  Example:
#  Functionality:
#  History:
#***********************************************************/*}}}*/

proc AN_proc { name suorce } {
	
}
#}}}


