proc BubbleSort {} {
    AN_createProgramLine 1  1  "import java.io.*\;"
	AN_createProgramLine 2  1  "import java.util.*\;"
    AN_createProgramLine 3  1  " "
	AN_createProgramLine 4  1  "public class BubbleSort "
  	AN_createProgramLine 5  1  "\{"
    AN_createProgramLine 6  4  "public static void main(String\[\] args) \{"
	AN_createProgramLine 7  8  "int i, j, k\;" 
	AN_createProgramLine 8  8  "int len = 0\;"
    AN_createProgramLine 9  8  "Scanner scannerr = new Scanner(System.in)\;"
	AN_createProgramLine 10 8  "int inp, temp\;"
    AN_createProgramLine 11 8  "int\[\] source = new int\[0\]\;"
	AN_createProgramLine 12 8  "try \{"
	AN_createProgramLine 13 12 "System.out.println(\"Enter number of values to sort: \")\;"
	AN_createProgramLine 14 12 "len = scannerr.nextInt()\;"
	AN_createProgramLine 15 12 "source = new int\[len\]\;"
	AN_createProgramLine 16 12 "for (i = 0; i < source.length; i++) \{"
    AN_createProgramLine 17 16 "System.out.println(\"Enter value \" + (i + 1) + \": \")\;"
    AN_createProgramLine 18 16 "inp = scannerr.nextInt()\;"
	AN_createProgramLine 19 16 "source\[i\] = inp\;"
    AN_createProgramLine 20 12 "\}"   
	AN_createProgramLine 21	8  "\} catch (NumberFormatException e) \{"
    AN_createProgramLine 22	12 "System.out.println(e.getMessage())\;"
	AN_createProgramLine 23 12 "System.exit(0)\;"
	AN_createProgramLine 24 8  "\}"
    AN_createProgramLine 25 8  "int\[\] target = new int\[len\]\;"
	AN_createProgramLine 26 1  " "
	AN_createProgramLine 27 8  "for (i = 0\; i < len\; i++) \{"
	AN_createProgramLine 28 12 "target\[i\] = source\[i\]\;"
    AN_createProgramLine 29 8  "\}"
    AN_createProgramLine 30 8  "for (k = len\; k > 0\; k--) \{"
    AN_createProgramLine 31 12 "for (j = 1\; j < k\; j++) \{"
    AN_createProgramLine 32 16 "if (target\[j\] > target\[j+1\]) \{"
    AN_createProgramLine 33 20 "temp = target\[j\]\;"
    AN_createProgramLine 34 20 "target\[j\] = target\[j+1\]\;"
    AN_createProgramLine 35 20 "target\[j+1\] = temp\;"
    AN_createProgramLine 36 16 "\}"
	AN_createProgramLine 37 12 "\}"
    AN_createProgramLine 38 8  "\}"
	AN_createProgramLine 39 1  " "
    AN_createProgramLine 40 8  "for (i = 1\; i <= target.length\; i++) \{" 
    AN_createProgramLine 41 12 "System.out.print(target\[i\] + \" \")\;"
	AN_createProgramLine 42 8  "\}"
	AN_createProgramLine 43 1  " "
	AN_createProgramLine 44 4  "\}"
	AN_createProgramLine 45 1  "\}"
	
	AN_beginAnimation
	AN_notice PROGRAM_BEGINS {6 start end}
	
	set iId [AN_createVar i STEP NULL {7 5 5}]
	set jId [AN_createVar j STEP NULL {7 8 8} {400 40}]
	set kId [AN_createVar k STEP NULL {7 11 11} ]
	#set swappedId [AN_createVar swapped STEP null {8 9 15} {400 105} ]
	set lenId [AN_createVar len CONS null {8 5 7} {10 185} ]
	set inpId [AN_createVar inp MRH null {10 5 7} {175 185}] 
	set tempId [AN_createVar temp TEMP null {10 10 13} {400 185}]
	    
    #set sourceId [AN_createVar source CONS NULL {11 7 12} null INT 0]
	AN_notice TRY_BLOCK {12 1 3} 
	AN_writeln "Enter number of values to sort:  " {13 21 51} null "PRINT_REQUEST"
	AN_readData $lenId {14 1 3} READ_DATA _null_ {14 1 3}
		
	set val1 [AN_getAttribute $lenId value]
		if {![string is integer -strict $val1]} {
			AN_notice CATCH_BLOCK {21 3 end} 
			AN_notice CATCH_BLOCK_OUTPUT {22 start end} 
			AN_writeln "Variable 'len' expects an int, not '[AN_getAttribute $lenId value]'"
		} else { 
		    set sourceId [AN_createVar source CONS NULL {15 1 6} NULL INT [AN_getAttribute $lenId value]]
			AN_notice FOR_LOOP_BEGINS {16 1 3} 
			AN_setNewValue $iId 0 {16 6 10}
			AN_setDirection $iId right
			AN_setLim $iId "@<[AN_getAttribute $lenId value]" $lenId  

			while {[AN_compare null FOR "$iId {16 13 29}" ]} {
				AN_writeln "Enter value:  " {17 start end} null "PRINT_REQUEST"
				AN_readData $inpId {18 start end} READ_DATA _null_ {18 start end}
				set val2 [AN_getAttribute $inpId value]
				if {![string is integer -strict $val2]} {
					AN_notice CATCH_BLOCK {21 3 end} 
					AN_notice CATCH_BLOCK_OUTPUT {22 start end} 
					AN_writeln "Variable 'inp' expects an int, not '[AN_getAttribute $inpId value]'"
					AN_notice PROGRAM_ENDS {45 1 end}
	                AN_endAnimation
				} else { 
					set pos [AN_getAttribute $iId value]
					if { $pos != 0 } {
						set pos [expr {$pos + 1}]
						AN_setNewElementValue $sourceId $inpId $pos {19 1 end}
					} else {
						AN_setNewElementValue $sourceId $inpId 1 {19 1 end}
					}
						AN_setExpression $iId "@+1"
						AN_step $iId {16 32 34}
				}
			}
		}
		
	set targetId [AN_createVar "target" ORGA null {25 7 12} null INT [AN_getAttribute $lenId value]]
		
			AN_notice FOR_LOOP_BEGINS {27 1 3} 
			AN_setNewValue $iId 1 {27 6 10}
			AN_setDirection $iId right
			AN_setLim $iId "@<=[AN_getAttribute $lenId value]" $lenId 
			while {[AN_compare null FOR "$iId {27 6 10}" ]} {
				set sourceVal [AN_getElementValue $sourceId [AN_getAttribute $iId value]]
				AN_setNewElementValue $targetId $sourceVal [AN_getAttribute $iId value] {28 1 9}
				AN_step $iId {27 22 24}
			}
		   	
		set tempLen [AN_getAttribute $lenId value]
	    set tempLen [expr {$tempLen - 1}]
	
		AN_notice FOR_LOOP_BEGINS {30 1 3} 
		AN_setNewValue $kId [AN_getAttribute $lenId value] {30 6 12}
		AN_setLim $kId "@>0" null 0 
				
		while {[AN_compare null FOR "$kId {30 15 19}" ]} {
			#AN_change $swappedId false {32 start end} 
			AN_notice FOR_LOOP_BEGINS {31 1 3}
            AN_setDirection $jId right	
            AN_setLim $jId "@<[AN_getAttribute $kId value]" $kId 	
            AN_setExpression $jId "@+1"			
			AN_setNewValue $jId 1 {31 6 10}	
			while {[AN_compare null FOR "$jId {31 13 17}" ]} {
				set index1 [AN_getAttribute $jId value]
                set index2 [expr $index1 + 1]
				AN_notice IF_STATEMENT {32 1 2}
				if { [AN_compareElements $targetId $index1 $index2 "target\[j\]" "target\[j+1\]" {32 5 27} ">" THEN] } {
					AN_swap $targetId [AN_getAttribute $jId value] [expr [AN_getAttribute $jId value] +1] $tempId {33 1 end} {34 1 end} {35 1 end}
					#AN_change $swappedId true {38 start end} 
				}
				AN_step $jId {31 20 22}
			}
			AN_setDirection $kId left
			AN_setExpression $kId "@-1"
			AN_step $kId {30 22 24} 	 
		}
	
		AN_notice FOR_LOOP_BEGINS {40 1 3} 
		AN_setDirection $iId right	
		AN_setNewValue $iId 1 {40 6 10}
		AN_setLim $iId "@<=[AN_getAttribute $lenId value]" $lenId 
		AN_setExpression $iId "@+1"	
		AN_writeln "" 
		while {[AN_compare null FOR "$iId {40 13 30}" ]} {	
			AN_write  "[AN_getElementValue $targetId [AN_getAttribute $iId value]]" { 41 1 end } PRINT_RESULT
			AN_write " "  { 41 1 end } PRINT_RESULT
			AN_step $iId {40 33 35}
		}
	
	AN_notice PROGRAM_ENDS {45 1 end}
	AN_endAnimation
 }