
#Copyright (c) 2003 University of Joensuu, Department of Computer Science.

# {{{ source all required files
foreach component [glob ./GBI/GBI.tcl] {
    source $component
}
source "ANFunctions.tcl"
source "ANInterface.tcl"
##}}}
set examplePath [gbSetExamplePath ./Examples]
# {{{ set gp paths and file names
set examples ""
gb_set_exampleNames $examples

#gb_set_path ./
#gb_set_lib_path ./GBI/lib
#gb_set_pic_path /mrapa/src/PlanAni/PlanAni/src/Pics 
#gbSetPiclist "piclist.txt" 
#gbSetPiclistPath ./
#gbSetHotSpotFile "hotspots.txt"
#gbSetHotSpotFilePath ./
#}}}
#set  examples [lsort -ascii $examples]
# Creates GUI and initialize GB library.
gb_init {600 600}
# Switch for role pictures!! 
# 0 = visible and 1 = invisible
set AN(noVarPictures) 0

# Switch for source code. 
# 0 = visible and 1 = invisible.
set AN(noSrc) 0

# If this flag is 1 execution of the animation is automated.
# Inputs are random numbers betweet 0-10.
set eternityLoop 0

set textList ""
set textIdList ""
set markList ""
set AN(idCounter) 0
set AN(debug) 0
# language settings: 1 = finnish, 2 = english
set lan 1

set roles {MRH FIXED FOLL GATH MWH OWF ORGA STEP TEMP OTHE ARRAY}

array set typeTable {
    INT integer
    CHAR char
    BOOL boolean
    REAL real
    CONST constant
	DOUBLE double
	LONG long
    FLOAT float
}
# Function AN_change_lan {{{
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
# End of function AN_change_lan }}}
# Array for localization strings {{{

# Creating messages. See roles at the end of this array list.


set lanTable(1_CREATE_VAR) "Luodaan %s muuttuja '%s', jonka rooli on %s" 
set lanTable(2_CREATE_VAR) "Creating %s variable called '%s' whose role is %s"
set lanTable(1_CREATE_CONST) "Luodaan vakio '%s'" 
set lanTable(2_CREATE_CONST) "Creating constant called '%s'"
set lanTable(1_CREATE_ARRAY) "Luodaan %s taulukko '%s' jonka rooli on %s" 
set lanTable(2_CREATE_ARRAY) "Creating %s table '%s' whose role is %s" 
set lanTable(1_VAR_SET_VALUE) "Vied‰‰n arvo muuttujaan '%s', jonka rooli on %s"
set lanTable(2_VAR_SET_VALUE) "Setting value to '%s' whose role is %s"
set lanTable(1_VAR_UPDATE_VALUE) "P‰ivitet‰‰n muuttujan '%s' arvoa, jonka rooli on %s"
set lanTable(2_VAR_UPDATE_VALUE) "Updating variable '%s' value whose role is %s"
set lanTable(1_PROGRAM_BEGINS) "Varsinainen toiminta alkaa"
set lanTable(2_PROGRAM_BEGINS) "Starting the statement part" 
set lanTable(1_REPEAT_LOOP_BEGINS) "Repeat-silmukka alkaa"
set lanTable(2_REPEAT_LOOP_BEGINS) "Repeat-loop starts" 
set lanTable(1_REPEAT_LOOP_TEST) "Testataan repeat-silmukan loppuminen"
set lanTable(2_REPEAT_LOOP_TEST) "Testing if repeat-loop stops"
set lanTable(1_DO_LOOP_BEGINS) "Do-silmukka alkaa"
set lanTable(2_DO_LOOP_BEGINS) "Do-loop starts" 
set lanTable(1_DO_LOOP_TEST) "Testataan do-silmukan loppuminen"
set lanTable(2_DO_LOOP_TEST) "Testing if do-loop stops"
set lanTable(1_FOR_LOOP_BEGINS) "For-silmukka alkaa"
set lanTable(2_FOR_LOOP_BEGINS) "For-loop starts" 
set lanTable(1_FOR_LOOP_TEST) "Testataan for-silmukan loppuminen"
set lanTable(2_FOR_LOOP_TEST) "Testing if for-loop stops"
set lanTable(1_LOOP_BEGINS) "Silmukka alkaa"
set lanTable(2_LOOP_BEGINS) "Loop starts" 
set lanTable(1_LOOP_TEST) "Testataan loppuuko silmukka"
set lanTable(2_LOOP_TEST) "Testing if loop stops"
set lanTable(1_LOOP_TEST_CONTINUE) "Testataan jatkuuko silmukka"
set lanTable(2_LOOP_TEST_CONTINUE) "Testing if loop continues"
set lanTable(1_LOOP_ENDS) "Silmukka p‰‰ttyy"
set lanTable(2_LOOP_ENDS) "Loop ends" 
set lanTable(1_READ_DATA) "Luetaan arvo"
set lanTable(2_READ_DATA) "Reading a value"
set lanTable(1_PRINT_REQUEST) "Pyydet‰‰n syˆte"
set lanTable(2_PRINT_REQUEST) "Requesting input"
set lanTable(1_WHILE_LOOP_BEGINS) "While-silmukka alkaa"
set lanTable(2_WHILE_LOOP_BEGINS) "While-loop starts"
set lanTable(1_IF_STATEMENT) "Ehtolause alkaa"
set lanTable(2_IF_STATEMENT) "If-statement starts"
set lanTable(1_THEN_ENDS) "Else-osa hyp‰t‰‰n yli"
set lanTable(2_THEN_ENDS) "Skipping else-part"
set lanTable(1_THEN) "Kyll‰... Menn‰‰n then-osaan"
set lanTable(2_THEN) "Yes... Going to then-part"
set lanTable(1_ELSE) "Ei... Siirryt‰‰n else-osaan"
set lanTable(2_ELSE) "No... Going to else-part"
set lanTable(1_THEN_SKIP) "Ei... Ei menn‰ then-osaan"
set lanTable(2_THEN_SKIP) "No... Skipping then-part"
set lanTable(1_ELSE_ENDS) "Else-osa p‰‰ttyy"
set lanTable(2_ELSE_ENDS) "Else-part ends"
set lanTable(1_IF_STATEMENT_TEST) "Testataan If-lausekeen ehto"
set lanTable(2_IF_STATEMENT_TEST) "Testing the condition"
set lanTable(1_IF_ENDS) "Ehtolause p‰‰ttyy"
set lanTable(2_IF_ENDS) "If-statement ends"
set lanTable(1_IF_FALSE) "Ei... Ehtolause p‰‰ttyy"
set lanTable(2_IF_FALSE) "No... If-statement ends"
set lanTable(1_WHILE_LOOP_TEST) "Testataan while-silmukka jatkuminen"
set lanTable(2_WHILE_LOOP_TEST) "Testing if while-loop continues"
set lanTable(1_PROGRAM_ENDS) "Ohjelma p‰‰ttyy"
set lanTable(2_PROGRAM_ENDS) "Program ends"
set lanTable(1_ROLE_CHANGE) "Muuttujan '%s' uusi rooli on %s"
set lanTable(2_ROLE_CHANGE) "Variable '%s' acts now as %s"
set lanTable(1_STEPTONEXT) "P‰ivitet‰‰n muuttujaa '%s'"
set lanTable(2_STEPTONEXT) "Updating variable '%s'"
set lanTable(1_PRINT_RESULT) "Tulostetaan tietoja"
set lanTable(2_PRINT_RESULT) "Printing results"
set lanTable(1_CHANGE_VAR_VALUE) "P‰ivitet‰‰n %s '%s'"
set lanTable(2_CHANGE_VAR_VALUE) "Updating %s '%s'"
set lanTable(1_OWF_UPDATE) "P‰ivitet‰‰n yksisuuntainen lippu '%s'"
set lanTable(2_OWF_UPDATE) "Updating one-way-flag '%s'"
set lanTable(1_OWF_QUERY) "Onko yksisuuntainen lippu '%s' p‰‰ll‰?"
set lanTable(2_OWF_QUERY) "Is one-way-flag '%s' on?"
set lanTable(1_OWF_QUERY_OFF) "Onko yksisuuntainen lippu '%s' pois p‰‰lt‰?"
set lanTable(2_OWF_QUERY_OFF) "Is one-way-flag '%s' off?"
set lanTable(1_OWF_ON) "Ovat... Yksisuuntainen lippu '%s' ei muutu"
set lanTable(2_OWF_ON) "Yes... One-way-flag '%s' does not change"
set lanTable(1_OWF_OFF) "Eiv‰t... Yksisuuntainen lippu '%s' asetetaan pois p‰‰lt‰"
set lanTable(2_OWF_OFF) "No... Setting one-way-flag '%s' off"
set lanTable(1_OWF_OFF_ALREADY) "Eiv‰t... Mutta yksisuuntainen lippu '%s' on jo pois p‰‰lt‰"
set lanTable(2_OWF_OFF_ALREADY) "No... But one-way-flag '%s' is already off"
set lanTable(1_WHILE_AND_TRUE_IN) "Kyll‰... Silmukka jatkuu"
set lanTable(2_WHILE_AND_TRUE_IN) "Yes... Loop continues"
set lanTable(1_WHILE_AND_FALSE_OUT) "Ei... Poistutaan silmukasta"
set lanTable(2_WHILE_AND_FALSE_OUT) "No... Exiting loop"
set lanTable(1_WHILE_AND_TRUE_OUT) "Kyll‰... Poistutaan silmukasta"
set lanTable(2_WHILE_AND_TRUE_OUT) "Yes... Exiting loop"
set lanTable(1_WHILE_AND_FALSE_IN)  "Ei... Silmukka jatkuu"
set lanTable(2_WHILE_AND_FALSE_IN) "No... Loop continues" 

set lanTable(1_VAR_COMP_LESS) "Onko %s '%s'%s pienempi kuin %s?"
set lanTable(2_VAR_COMP_LESS) "Is %s '%s'%s less than %s?"
set lanTable(1_VAR_COMP_GREATER) "Onko %s '%s'%s suurempi kuin %s?"
set lanTable(2_VAR_COMP_GREATER) "Is %s '%s'%s greater than %s?"
set lanTable(1_VAR_COMP_LESS_OR_EQUAL) "Onko %s '%s' pienempi tai yht‰suuri kuin %s?"
set lanTable(2_VAR_COMP_LESS_OR_EQUAL) "Is %s '%s' less than or equal to %s?"
set lanTable(1_VAR_COMP_GREATER_OR_EQUAL) "Onko %s '%s' suurempi tai yht‰suuri kuin %s?"
set lanTable(2_VAR_COMP_GREATER_OR_EQUAL) "Is %s '%s' greater than or equal to %s?"
set lanTable(1_VAR_COMP_NOT_EQUAL) "Onko %s '%s' erisuuri kuin %s?"
set lanTable(2_VAR_COMP_NOT_EQUAL) "Is %s '%s' not equal to %s?"
set lanTable(1_VAR_COMP_EQUAL) "Onko %s '%s' yht‰suuri kuin %s?"
set lanTable(2_VAR_COMP_EQUAL) "Is %s '%s' equal to %s?"

set lanTable(1_VAR_COMP_TWO_LESS) "Onko %s '%s' pienempi kuin %s %s suurempi kuin %s?"
set lanTable(2_VAR_COMP_TWO_LESS) "Is %s '%s' less than %s %s greater than %s?"
set lanTable(1_VAR_COMP_TWO_GREATER) "Onko %s '%s' suurempi kuin %s?"
set lanTable(2_VAR_COMP_TWO_GREATER) "Is %s '%s' greater than %s?"
set lanTable(1_VAR_COMP_TWO_LESS_OR_EQUAL) "Onko %s '%s' pienempi tai yht‰suuri kuin %s?"
set lanTable(2_VAR_COMP_TWO_LESS_OR_EQUAL) "Is %s '%s' less than or equal to %s?"
set lanTable(1_VAR_COMP_TWO_GREATER_OR_EQUAL) "Onko %s '%s' suurempi tai yht‰suuri kuin %s %s pienempi tai yht‰suuri kuin %s?"
set lanTable(2_VAR_COMP_TWO_GREATER_OR_EQUAL) "Is %s '%s' greater than or equal to %s %s less than or equal to %s?"
set lanTable(1_VAR_COMP_TWO_NOT_EQUAL) "Onko %s '%s' erisuuri kuin %s?"
set lanTable(2_VAR_COMP_TWO_NOT_EQUAL) "Is %s '%s' not equal to %s?"

set lanTable(1_STEPPER_CHECK_END_LESS_EQUAL) "Onko askeltaja '%s' pienempi tai yht‰suuri kuin %s?"
set lanTable(2_STEPPER_CHECK_END_LESS_EQUAL) "Is stepper '%s' less than or equal to %s?"
set lanTable(1_STEPPER_CHECK_END_LESS) "Onko askeltaja '%s' pienempi kuin %s?"
set lanTable(2_STEPPER_CHECK_END_LESS) "Is stepper '%s' less than %s?"
set lanTable(1_STEPPER_CHECK_END_GREATER_EQUAL) "Onko askeltaja '%s' suurempi tai yht‰suuri kuin %s?"
set lanTable(2_STEPPER_CHECK_END_GREATER_EQUAL) "Is stepper '%s' greater than or equal to %s?"
set lanTable(1_STEPPER_CHECK_END_GREATER) "Onko askeltaja '%s' suurempi kuin %s?"
set lanTable(2_STEPPER_CHECK_END_GREATER) "Is stepper '%s' greater than %s?"

set lanTable(1_OWF_SET_ON) "Asetetaan yksisuuntainen lippu '%s' p‰‰lle"
set lanTable(2_OWF_SET_ON) "Setting one-way-flag '%s' on"
set lanTable(1_OWF_SET_OFF) "Asetetaan yksisuuntainen lippu '%s' pois p‰‰lt‰"
set lanTable(2_OWF_SET_OFF) "Setting one-way-flag '%s' off"

set lanTable(1_ARRAY_COMPARE_EQUAL) "Ovatko alkion %s arvo sama kuin alkion %s?"
set lanTable(2_ARRAY_COMPARE_EQUAL) "Is value of element %s same than value of element %s?"
set lanTable(1_ARRAY_COMPARE_LESS) "Onko alkioin %s arvo pienempi kuin alkion %s?"
set lanTable(2_ARRAY_COMPARE_LESS) "Is value of cell %s less than value of cell %s?"
set lanTable(1_ARRAY_COMPARE_GREATER) "Onko alkioin %s arvo suurempi kuin alkion %s?"
set lanTable(2_ARRAY_COMPARE_GREATER) "Is value of cell %s greater than value of cell %s?"
set lanTable(1_ARRAY_SET_VALUE) "Vied‰‰n arvo taulukkoon %s kohtaan %s"
set lanTable(2_ARRAY_SET_VALUE) "Setting value to array %s cell %s"
#Onko rooli name pariton?
set lanTable(1_VAR_IS_ODD) "Onko %s '%s' pariton?"
set lanTable(2_VAR_IS_ODD) "Is %s '%s' odd?"
set lanTable(1_VAR_IS_EVEN) "Onko %s '%s' parillinen?"
set lanTable(2_VAR_IS_EVEN) "Is %s '%s' even?"

set lanTable(1_IF_YES) "Kyll‰ se on."
set lanTable(2_IF_YES) "Yes it is."

set lanTable(1_IF_NO) "Ei ole."
set lanTable(2_IF_NO) "No it's not"


set lanTable(1_TEST_TRUE) "Testi onnistui... Silmukka jatkuu"
set lanTable(2_TEST_TRUE) "Test succeeds... Loop continues"

set lanTable(1_TEST_FALSE) "Testi ep‰onnistui... Poistutaan silmukasta"
set lanTable(2_TEST_FALSE) "Test fails... Exiting loop"

set lanTable(1_TEMP_VAR_SET) "Asetetaan tilap‰iss‰ilˆn '%s' arvo muuttujasta '%s'."
set lanTable(2_TEMP_VAR_SET) "Setting value to temporary '%s' from variable '%s'."

set lanTable(1_OR) "tai"
set lanTable(2_OR) "or"

set lanTable(1_AND) "ja"
set lanTable(2_AND) "and"

set lanTable(1_IS) "Onko"
set lanTable(2_IS) "Is"

## Strings for bar comparison!
# See function  cmp_two in ANFunction.tcl 

set lanTable(1_SMALLER) "pienempi kuin"
set lanTable(2_SMALLER) "less than"

set lanTable(1_SMALLER_EQUAL) "pienempi tai yht‰pieni kuin"
set lanTable(2_SMALLER_EQUAL) "less than or equal to"

set lanTable(1_GREATER) "suurempi kuin"
set lanTable(2_GREATER) "greater than"

set lanTable(1_GREATER_EQUAL) "suurempi tai yht‰suuri kuin"
set lanTable(2_GREATER_EQUAL) "greater than or equal to"

set lanTable(1_EQUAL) "yht‰suuri kuin"
set lanTable(2_EQUAL) "equal to"

set lanTable(1_NOT_EQUAL) "erisuuri kuin"
set lanTable(2_NOT_EQUAL) "not equal to"

# Roles 
set lanTable(1_MRH) "tuoreimman s‰ilytt‰j‰"
set lanTable(2_MRH) "most-recent-holder"

set lanTable(1_FIXED) "kiintoarvo"
set lanTable(2_FIXED) "fixed value"

set lanTable(1_FOLL) "seuraaja"
set lanTable(2_FOLL) "follower"

set lanTable(1_CONS) "kiintoarvo"
set lanTable(2_CONS) "fixed value"

set lanTable(1_GATH) "kokooja"
set lanTable(2_GATH) "gatherer"

set lanTable(1_MWH) "sopivimman s‰ilytt‰j‰"
set lanTable(2_MWH) "most-wanted-holder"

set lanTable(1_OWF) "yksisuuntainen lippu"
set lanTable(2_OWF) "one-way-flag"

set lanTable(1_ORGA) "j‰rjestelij‰"
set lanTable(2_ORGA) "organizer"

set lanTable(1_STEP) "askeltaja"
set lanTable(2_STEP) "stepper"

set lanTable(1_TEMP) "tilap‰iss‰ilˆ"
set lanTable(2_TEMP) "temporary"

set lanTable(1_OTHE) "muu"
set lanTable(2_OTHE) "other"

set lanTable(1_ARRAY) "taulukko"
set lanTable(2_ARRAY) "array"

# template
#set lanTable(1_) ""
#set lanTable(2_) ""
# End of sting array }}}
# Function: change_roleTable {{{ 
proc change_roleTable {  } {
    global roleTable lan roles
	unset roleTable
	foreach role $roles { 
		set name [getStr $role]
		set roleTable($role) $name	
	}
}

# End of function change_roleTable }}}
# GB bindings {{{
gb_bind AN_stepStop step
gb_bind AN_reset reset
gb_bind AN_stop stop
gb_bind AN_run run
gb_bind AN_change_lan language
#}}}
#Uncomment next line if u want to have debug option.
AN_change_lan

set runState 0
set stepState 0

start
