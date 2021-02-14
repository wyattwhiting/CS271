

;______________________________________________________________________________________________________
introAndFarewell PROC C, userString:DWORD																	   
;    Description: prints string from reference on the stack
; Pre-conditions: string offset must on top of stack before procedure call
;Post-conditions: string offset is removed from stack
; Registers used: edx




		push			ebp							;set up stack frame
		mov				ebp, esp

		mov				edx, userString			;print string from passed reference
		call			WriteString

		pop				ebp							;restore ebp
		ret				4							;return to main procedure


introAndFarewell ENDP
;______________________________________________________________________________________________________