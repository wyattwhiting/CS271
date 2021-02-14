;Author: Wyatt Whiting
;Date: 2020-11-05
;Description: I/O procedure definitions

INCLUDE Irvine32.inc
INCLUDELIB c:\Irvine\irvine32.lib
INCLUDE io_module.inc

.const

MAX_IN				equ	256			;maximum user input
MIN_IN				equ 16			;miniumum user input




.code


;______________________________________________________________________________________________________
introAndFarewell PROC																				   
;    Description: prints string from reference on the stack
; Pre-conditions: string offset must on top of stack before procedure call
;Post-conditions: string offset is removed from stack
; Registers used: edx




		push			ebp							;set up stack frame
		mov				ebp, esp

		mov				edx, [ebp + 8]				;print string from passed reference
		call			WriteString

		pop				ebp							;restore ebp
		ret				4							;return to main procedure


introAndFarewell ENDP
;______________________________________________________________________________________________________







;______________________________________________________________________________________________________
getData PROC
;    Description: takes and validates user input to be within acceptable range
; Pre-conditions: error message reference and user request memory reference must be on top of stack
;Post-conditions: both passed values are removed from stack
;				  validated user input is in memory pointed to by topmost stack value
; Registers used: eax, ebx, edx




		push			ebp							;set up stack frame
		mov				ebp, esp

		mov				ebx, [ebp + 8]				;user request address in ebx
		mov				edx, [ebp + 12]				;string offset in edx

funcTop:

		call			ReadDec						;user input in eax

		cmp				eax, MAX_IN					;if(eax > MAX_IN)
		ja				printError					;	goto error
		cmp				eax, MIN_IN					;if(eax < MIN_IN)
		jb				printError					;	goto error

		;if it gets here, user input in eax is within proper range

		mov				[ebx], eax					;input in @intUserReq
		pop				ebp
		ret				8							;return to main procedure

printError:

		call			WriteString					;print error
		jmp				funcTop						;return to prompt


getData ENDP
;______________________________________________________________________________________________________







;______________________________________________________________________________________________________
displayMedian PROC
;    Description: finds and displays the median value in a passed list
; Pre-conditions: stack must have string reference, followed by the list pointer, followed by element count on stack
;Post-conditions: three passed arguments are removed from the stack
; Registers used: eax, ebx, ecx, edx, esi



		
		push			ebp							;set ups stack frame
		mov				ebp, esp

		mov				edx, [esp + 16]				;print passed string
		call			WriteString

		mov				ebx, 2						;for divison by 2 later
		mov				esi, [ebp + 12]				;set up array element pointer
		mov				eax, [ebp + 8]				;number of elements in eax

		cdq		
		div				ebx							;divide by 2
		mov				ecx, eax					;remainder in ecx for loop

		L1:
		
			add			esi, 4						;add necessary offset
		
		loop			L1

		mov				eax, [esi]					;eax has middle value
		cmp				edx, 1						;if(array length is odd)
		je				funcEnd						;	you're done

		;if here, we need to average the middle two elements

		add				eax, [esi - 4]				;add the other middle value
		cdq
		div				ebx							;divide by 2
		cmp				edx, 0						;if(remainder is 0)
		je				funcEnd						;skip the fix

		;if here, we need to add 1 for rounding

		inc				eax							;round						

funcEnd:
		
		call			WriteDec					;print median
		pop				ebp
		ret				12							;return to main procedure


displayMedian ENDP
;______________________________________________________________________________________________________







;______________________________________________________________________________________________________
displayAverage PROC
;    Description: finds and displays the average value of a list
; Pre-conditions: stack must have string pointer, followed by array pointer, followed by element count 
;Post-conditions: all three function arguments removed from stack
; Registers used: eax, ebx, ecx, edx, esi




		push			ebp							;create stack frame
		mov				ebp, esp

		mov				edx, [ebp + 16]				;print string
		call			WriteString

		mov				ecx, [ebp + 8]				;loop counter for all elements in array
		mov				ebx, ecx					;copy for later division
		mov				esi, [ebp + 12]				;array pointer
		mov				eax, 0						;sum accumulator

		L1:
		
			add			eax, [esi]					;accumulate element
			add			esi, 4						;increment pointer
		
		loop			L1

		cdq											;sign-extend
		div				ebx							;divide sum by number of elements

		add				edx, edx					;double remainder
		cmp				ebx, edx					;if(divisor > 2R)
		jb				procEnd						;	skip fixing the remainder
		add				eax, 1						;if here, fix the remainder by adding 1
		

procEnd:

		call			WriteDec					;print print rounded average
		call			CrlF						;formatting
		pop				ebp							;restore ebp
		ret				12							;return to main procedure, nuke stack 


displayAverage ENDP
;______________________________________________________________________________________________________







;______________________________________________________________________________________________________
displayList PROC
;    Description: displays a list of numbers, 5 per line
; Pre-conditions: stack must have array pointer, followed by number of array elements, followed by string offset
;Post-conditions: all arguemnts are removed from stack
; Registers used: eax, ebx, ecx, edx, esi




		push			ebp
		mov				ebp, esp

		mov				edx, [ebp + 8]				;string offset
		call			WriteString					;print

		mov				ecx, [ebp + 12]				;number of elements for loop counter
		mov				esi, [ebp + 16]				;array element address
		mov				ebx, 0						;line count

		L1:
		
			mov			eax, [esi]						
			call		WriteDec					;print array at index pointed by esi

			push		eax							;store eax
			mov			eax, 9						;tab(ascii) = 9
			call		WriteChar					;print tab
			pop			eax							;restore eax

			add			esi, 4						;increment address
			inc			ebx							;increment line counter

			cmp			ebx,5						;if 5 lines have been printed:
			je			newLine						;	print new line
			return:									;return here after new line 

		loop			L1
		jmp				funcEnd						;jump to end of program after loop completes

newLine:
		call			CrlF
		mov				ebx, 0						;reset ebx
		jmp				return						;return to loop

funcEnd:

		pop				ebp							;restore ebp
		ret				12							;return and nuke parameters


displayList ENDP	
;______________________________________________________________________________________________________

END