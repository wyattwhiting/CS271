TITLE Assignment4		(assignment4.asm)

;Author: Wyatt Whiting
;Course / Project ID: Program 4, CS271		Date: 10/25/20
;Description: Takes user input n \in [1, 400], and prints out sequence
;		      (c_1, c_2, c_3, ... , c_n) where c_i denotes the i'th composite number.
;		      Results are displayed 8 per row, with 4 spaces between terms. 


INCLUDE c:/Irvine/Irvine32.inc

.const

MAX_IN				equ	400			;maximum user input
MIN_IN				equ 1			;miniumum user input



.data

;strings and variables

header				BYTE			"Assignment 4 - Procedures - CS271 - Fall 2020 - Wyatt D. Whiting", 10, 13, 10, 13
					BYTE			"Hello! Please enter the number of composite numbers you would like printed.",10,13
					BYTE			"I will accept integers in the set [1, 400]", 10, 13, 0
prompt				BYTE			"Enter a number in the range specified above: ",0
rangeErr			BYTE			"ERROR. That number is outside the acceptable range. Please try again",10, 13, 0
goodbye 			BYTE			10,13,"Programmed by Wyatt Whiting. Please have mercy on my soul.",0
space				BYTE			"    ",0


userIn				DWORD			?
currCheck			DWORD			?
compFlag			DWORD			?
isValid				DWORD			?
compCount			DWORD			0





.code 




;---------------------------------------------------------
main PROC
;
; Pre-conds: none	
;Post-conds: number of desired composites have been printed to screen
;  Requires: user to input data
;      Desc: main procedure for the program. Only calls sub-procedures
;
;---------------------------------------------------------

		call		introduction
		call		getUserData
		call		showComposites
		call		farewell
		exit
main ENDP




;---------------------------------------------------------
introduction PROC
;
; Pre-conds: none	
;Post-conds: introduction has been printed to screen
;			 registers are unchanged
;  Requires: none
;      Desc: prints introduction string to screen
;
;---------------------------------------------------------


		pushad										;push all registers

		mov			edx, OFFSET header				;print header
		call		WriteString
			
		popad										;pop all registers
		ret											;return to main procedure


introduction ENDP






;---------------------------------------------------------
getUserData PROC
;
; Pre-conds: introduction must have been ran already
;Post-conds: userIn stores a number in the range [1, 400]
;			 registers remain unchanged
;  Requires: introduction must have been printed
;      Desc: prompts for input until user enters integer in acceptable range
;
;---------------------------------------------------------


		pushad										;push all registers

getInput:
		mov			edx, OFFSET prompt				;print prompt
		call		WriteString
		call		ReadDec							;input in eax
		mov			userIn, eax						;store in global variable


		call		validate						;isValid indicates if userInput is acceptable
			
		cmp			isValid, 0						;if user input is not valid
		je			getInput						;loop back to prompt

		;otherwise, the input is valid and the program may continue

		popad										;pop all registers
		ret											;return to main procedure


getUserData ENDP






;---------------------------------------------------------
validate PROC
;
; Pre-conds: userIn must have user input
;Post-conds: isValid set to 1 if userIn is in range [1, 400]
;			 registers stay unchanged
;  Requires: userIn be initialized
;      Desc: checks validity of user input
;
;---------------------------------------------------------


		pushad										;push all registers

		mov			eax, userIn						;check input doesn't exceed maximum
		cmp			eax, MAX_IN
		ja			outOfRange

		cmp			eax, MIN_IN						;check input not less than minimum
		jb			outOfRange

		;if it gets here, it's within range

		mov			isValid, 1						;indicates the input is within range
		jmp			return							;jump straight to the return instruction

outOfRange:
		mov			isValid, 0						;indicate the input is out of range
		mov			edx, OFFSET rangeErr			;print error message
		call		WriteString

return:
		popad										;pop all registers
		ret											;return to getUserData procedure


validate ENDP






;---------------------------------------------------------
showComposites PROC
;
; Pre-conds: userIn has been validated and is in range [1, 400]
;Post-conds: composites have been printed to screen
;  Requires: userIn be validated
;      Desc: prints composites up to the userIn'th composite
;
;---------------------------------------------------------


		pushad										;push all registers

		;copy user input to check variable

		mov					ecx, userIn				;number of composites to find
		mov					ebx, 0					;use as line counter
		mov					currCheck, 3			;start here since 4 is the first composite

		L1:											;loopback point
			inc				currCheck
			call			isComposite				;check if currCheck is composite
			cmp				compFlag, 0				;if not composite
			je				L1						;increment until one is found

			;if it gets here, currCheck has a composite number

			inc				ebx						;increment line count

			mov				eax, currCheck				
			call			WriteDec				;print out composite

			mov				edx, OFFSET space		;print a space
			call			WriteString

			cmp				ebx, 8					;check if 8 numbers have been printed
			jne				skipNewLine				;if not, don't print a new line

			call			CrlF					;newline
			mov				ebx, 0					;reset line count

			skipNewLine:

		loop			L1							;loop back to L1, decrement ecx


		popad										;restore registers
		ret											;return to main function


showComposites ENDP






;---------------------------------------------------------
isComposite PROC
;
; Pre-conds: currCheck is value to check compositeness of
;Post-conds: compFlag set based on compositeness of currCheck
;  Requires: none, all registers remain unchnaged
;      Desc: checks if currCheck is composite or not
;
;---------------------------------------------------------


		pushad										;push all registers

		;find currCheck/2 for starting point of check loop

		mov				eax, currCheck				;move value to check into eax
		mov				ebx, 2						;dividing by 2
		cdq											;sign extend eax into edx
		div				ebx							;quotient now in eax, remainder in edx

		;try to divide currCheck by (currCheck/2), subtrating one each time until 2 is reached

		mov				ebx, eax
		
		L1:

			cmp			ebx, 1						;if we get to dividing by 1, don't bother since it must be prime
			je			notComp

			mov			eax, currCheck				;want to divide eax
			cdq										;sign extend
			div			ebx							;divide by [ebx] = currCheck / 2, remainder in edx

			cmp			edx, 0						;if there is no remainder found
			je			isComp						;factor has been found

			;if program gets here, the current divisor is not a factor. Decrement and try again

			dec			ebx							;decrement ebx
		
		jmp				L1
			



;label for if number is composite

isComp:
		mov				compFlag, 1					;number is composite
		jmp				endProc						;end the process




;label for if number is not composite

notComp:
		mov				compFlag, 0					;number is not composite




;label to allow skipping

endProc:

		popad										;pop all registers
		ret											;return to main procedure
isComposite ENDP





;---------------------------------------------------------
farewell PROC
;
; Pre-conds: program has printed out composites
;Post-conds: program none
;  Requires: none, registers remain unchanged
;      Desc: prints farewell to user
;
;---------------------------------------------------------


		pushad										;push all registers

		mov			edx, OFFSET goodbye				;print goodbye message
		call		WriteString		

		popad										;pop all registers
		ret											;return to main procedure


farewell ENDP

END main