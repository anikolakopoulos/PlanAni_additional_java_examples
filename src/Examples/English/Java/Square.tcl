proc Square {} {
    AN_createProgramLine 1  1 "import java.io.*;"
    AN_createProgramLine 2  1 " "
    AN_createProgramLine 3  1 "public class Square \{"
    AN_createProgramLine 4  4 "public static void main(String argv\[\]) \{"
    AN_createProgramLine 5  8 "final int maxSide = 78\;"
    AN_createProgramLine 6  8 "char c\;"
    AN_createProgramLine 7  8 "int side\;"
    AN_createProgramLine 8  8 "int i, j;"
	AN_createProgramLine 9  8 "BufferedReader in = new BufferedReader(new InputStreamReader(System.in))\;"
    AN_createProgramLine 10 8 "System.out.print(\"Enter character for drawing: \")\;"
    AN_createProgramLine 11 8 "try \{"
    AN_createProgramLine 12 12 "c = in.readLine().charAt(0)\;"
    AN_createProgramLine 13 12 "System.out.print(\"Enter side length: \")\;"
    AN_createProgramLine 14 12 "side = new Integer(in.readLine()).intValue()\;"
    AN_createProgramLine 15 12 "while (side < 0 || side > maxSide) \{"
    AN_createProgramLine 16 16 "System.out.print(\"Length incorrect. Re-enter: \")\;"
    AN_createProgramLine 17 16 "side = new Integer(in.readLine()).intValue()\;"
    AN_createProgramLine 18 12 "\}"
	AN_createProgramLine 19 12 "System.out.println()\;"
    AN_createProgramLine 20 12 "for (i = 1\; i <= side\; i++) \{"
    AN_createProgramLine 21 16 "for (j = 1\; j <= side\; j++)" 
    AN_createProgramLine 22 20 "System.out.print(c + \" \")\;"
    AN_createProgramLine 23 16 "System.out.println()\;"
	AN_createProgramLine 24 12 "\}"
	AN_createProgramLine 25 8 "\} catch (NumberFormatException e) \{"
	AN_createProgramLine 26 12 "System.out.println(e.getMessage())\;"
	AN_createProgramLine 27 8 "\}"
	AN_createProgramLine 28 4 "\}"
	AN_createProgramLine 29 1 " "
	AN_createProgramLine 30 1 "\}"
 
	AN_beginAnimation
	AN_notice PROGRAM_BEGINS {4 start end} 
 
	set maxSideId [AN_createVar "maxSide" FIXED 78 {5 11 22} NULL CONST]
    set cId [AN_createVar "c" FIXED NULL {6 6 6} ]
	set sideId [AN_createVar "side" FIXED null {7 5 8} ]
	set iId [AN_createVar "i" STEP null {8 5 5} null INT]
	set jId [AN_createVar "j" STEP null {8 8 8} null INT]
	AN_writeln  "Enter character for drawing: " {10 start end} null "PRINT_REQUEST"
	AN_notice TRY_BLOCK {11 1 3} 
	AN_readData $cId {12 start end} READ_DATA _null_ {12 1 1}	 
	AN_writeln  "Enter side length: " {13 start end} null "PRINT_REQUEST"
	AN_readData $sideId {14 start end} READ_DATA _null_ {14 1 4}
	
	set val [AN_getAttribute $sideId value]
	
	if {![string is integer -strict $val]} {
		AN_notice CATCH_BLOCK {25 3 end} 
		AN_notice CATCH_BLOCK_OUTPUT {26 start end} 
        AN_writeln "Variable 'side' expects an int, not '[AN_getAttribute $sideId value]'"
    } else {
		AN_notice WHILE_LOOP_BEGINS {15 1 5} 
		while {[AN_compare {15 8 33} WHILE_AND_TRUE_IN "$sideId < > 0 [AN_getAttribute $maxSideId value] {15 8 33} OR"]} {  
			AN_writeln  "Length incorrect. Re-enter: " {16 1 end} 
			AN_readData $sideId {17 start end} READ_DATA _null_ {17 1 4}      
		} 
		AN_notice FOR_LOOP_BEGINS {20 1 3} 
		AN_setNewValue $iId 1 {20 6 10}
		AN_setDirection $iId right
		AN_setLim $iId "@<=[AN_getAttribute $sideId value]" $sideId 

		while {[AN_compare null FOR "$iId {20 13 21}" ]} {
			AN_notice FOR_LOOP_BEGINS {21 1 3}	
			AN_setNewValue $jId 1 {21 6 10}	
			AN_setDirection $jId right
			AN_setExpression $jId "@+1"
			AN_setLim $jId "@<=[AN_getAttribute $sideId value]" $sideId 
			AN_writeln "" 
			while {[AN_compare null FOR "$jId {21 13 21}" ]} {
				AN_write  [AN_getAttribute $cId value] { 22 1 end } PRINT_RESULT
				AN_write  " " { 23 1 end } PRINT_RESULT
				AN_step $jId {21 24 26}
			}
			AN_setDirection $iId right
			AN_setExpression $iId "@+1"
			AN_step $iId {20 24 26} 
		}
	}
	AN_notice PROGRAM_ENDS {30 1 end}
	AN_endAnimation
 }