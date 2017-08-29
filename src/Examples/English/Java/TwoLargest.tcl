proc TwoLargest {} {
    AN_createProgramLine 1  1 "import java.io.*;"
    AN_createProgramLine 2  1 " "
    AN_createProgramLine 3  1 "public class TwoLargest "
	AN_createProgramLine 4  1 "\{"
    AN_createProgramLine 5  4 "private int value\;"
    AN_createProgramLine 6  4 "private int largest\;"
    AN_createProgramLine 7  4 "private int second\;"
    AN_createProgramLine 8  1 " "
    AN_createProgramLine 9  4 "public static void main(String args\[\]) \{"
	AN_createProgramLine 10 8 "BufferedReader in = new BufferedReader(new InputStreamReader(System.in))\;"
    AN_createProgramLine 11 8 "largest = -1\;"
    AN_createProgramLine 12 8 "second = -1\;"
    AN_createProgramLine 13 8 "try \{"
	AN_createProgramLine 14 12 "System.out.print(\"Enter value to begin: \")\;"
    AN_createProgramLine 15 12 "value = new Integer(in.readLine()).intValue()\;"
    AN_createProgramLine 16 12 "while (value >= 0) \{"
    AN_createProgramLine 17 16 "if (value > largest) \{"
    AN_createProgramLine 18 20 "second = largest\;"
    AN_createProgramLine 19 20 "largest = value\;"
	AN_createProgramLine 20 16 "\}"
    AN_createProgramLine 21 16 "else if (value > second) \{"
	AN_createProgramLine 22 20 "second = value\;"
	AN_createProgramLine 23 16 "\}"
    AN_createProgramLine 24 16 "System.out.print(\"Enter value (negative to end): \")\;" 
    AN_createProgramLine 25 16 "value = new Integer(in.readLine()).intValue()\;"
    AN_createProgramLine 26 12 "\}"
	AN_createProgramLine 27 12 "if (largest > 0) \{"
	AN_createProgramLine 28 16 "System.out.println(\"Largest was \" + largest)\;"
	AN_createProgramLine 29 12 "\}"
	AN_createProgramLine 30 12 "if (second > 0) \{"
	AN_createProgramLine 31 16 "System.out.println(\"Second largest was \" + second)\;"
	AN_createProgramLine 32 12 "\}"
	AN_createProgramLine 33 8 "\} catch (NumberFormatException e) \{"
	AN_createProgramLine 34 12 "System.out.println(e.getMessage())\;"
	AN_createProgramLine 35 8 "\}"
	AN_createProgramLine 36 4 "\}"
	AN_createProgramLine 37 1 " "
	AN_createProgramLine 38 1 "\}"
 
	AN_beginAnimation
	
	set valueId [AN_createVar value MRH null {5 13 17} null INT]
    set largestId [AN_createVar largest MWH null {6 13 19} null INT]
	set secondId [AN_createVar second MWH null {7 13 18} null INT]
	
	AN_notice PROGRAM_BEGINS {9 start end} 
 
	AN_setNewValue $largestId -1 {11 1 12}
	AN_setNewValue $secondId -1 {12 1 11}
	
	AN_notice TRY_BLOCK {13 1 3} 
	AN_writeln  "Enter value to begin: " {14 start end} null "PRINT_REQUEST"
	AN_readData $valueId {15 start end} READ_DATA _null_ {15 1 5}  
	
	set val [AN_getAttribute $valueId value]
	if {![string is integer -strict $val]} {
		AN_notice CATCH_BLOCK {33 3 end} 
		AN_notice CATCH_BLOCK_OUTPUT {34 start end} 
        AN_writeln "Variable 'value' expects an int, not '[AN_getAttribute $valueId value]'"
    } else {
		AN_notice WHILE_LOOP_BEGINS {16 1 5}
		AN_setLim $valueId "@>0" null 0  
		while {[AN_compare {16 1 5} WHILE "$valueId >= 0 {16 8 17}"]} {
			AN_notice IF_STATEMENT {17 1 2}
			set eka "$valueId > [AN_getAttribute $largestId value] {17 5 19}"
			if { [AN_compare {17 5 19} IF $eka] } {
				AN_setNewValue $secondId $largestId {18 1 16}
				AN_setNewValue $largestId $valueId {19 1 15}		
			} else {    
				AN_notice ELSE {21 1 7}
				set ekax "$valueId > [AN_getAttribute $secondId value] {21 10 23}"
				if { [AN_compare {21 10 23} IF $ekax] } {
					AN_setNewValue $secondId $valueId {22 1 14}
				}
			}	
			AN_writeln  "Enter value (negative to end): " {24 start end} null "PRINT_REQUEST"
			AN_readData $valueId {25 start end} READ_DATA _null_ {25 1 5} 
		}
		AN_notice IF_STATEMENT {27 1 2}
		if { [AN_compare {27 5 15} IF "$largestId > 0 {27 5 15}"] } {
			AN_writeln ""
			AN_write "Largest was " { 28 1 end } PRINT_RESULT
			AN_write [AN_getAttribute $largestId value] 
		}
		if { [AN_compare {30 5 14} IF "$secondId > 0 {30 5 14}"] } {
			AN_writeln "" 
			AN_write "Second largest was " { 31 1 end } PRINT_RESULT
			AN_write [AN_getAttribute $secondId value] 
		}
	}
	
	AN_notice PROGRAM_ENDS {38 1 end}
	AN_endAnimation
 }