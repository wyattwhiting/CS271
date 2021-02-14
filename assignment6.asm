TITLE Assignment6		(assignment6.asm)

;Author: Wyatt Whiting
;Course / Project ID: Program 6, CS271		Date: 11/21/20
;Description: Takes 8 unsigned integers from user and stores as string. 
;			  The inputs are validated as being integers and stores the input
;			  in an array. The integers are then displayed, along with their sum
;			  and average. 

INCLUDE C:/Irvine/Irvine32.inc


.const

MAXINTS				EQU				8
MAXSTRLEN			EQU				10





.data


;strings that will be unchanged

strHeader			BYTE			"Assignment 6 - Macros - CS271 - Fall 2020 - Wyatt D. Whiting", 10, 13, 10, 13
					BYTE			"You will be prompted to enter 8 unsigned 32-bit integers.", 10, 13
					BYTE			"I will then show you your entries, along with their sum and average.", 10, 13, 10, 13, 0
strPrompt			BYTE			"Please enter an unsigned integer: ", 0
strError			BYTE			"ERROR: Your input was non-numeric or greater than 32 bits. Please try again.", 10, 13, 0
strEntered			BYTE			10, 13, "You entered the following numbers:", 10, 13, 10, 13, 0
strSum				BYTE			10, 13, 10, 13, "The sum of all your numbers is: ", 0
strAvg				BYTE			10, 13, 10, 13, "The average of all your numbers is: ", 0
strFarewell			BYTE			10, 13, "Thanks for playing!", 10, 13, 0

;arrays, buffers, and numerics

strBuffer			BYTE			MAXSTRLEN DUP(0)				;set aside 10 bytes for the ReadString procedure
intInArr			DWORD			MAXINTS DUP(0)					;array for storing user inputs
intLenArr			DWORD			MAXINTS DUP(0)					;length of each integer
intInLen			BYTE			?								;size of input







.code


getString MACRO promptAddr, inBufferAddr, inLenAddr
;    Description: displays input prompt, takes input as string, stores into memory specified by inBufferAddr
; Pre-conditions: strAddr must point to valid null-terminated string
;Post-conditions: string at strAddr has been printed to screen
; Registers Used: eax, ecx, edx

		push			eax											;store all registers
		push			ecx
		push			edx

		mov				edx, promptAddr								;print prompt
		call			WriteString

		mov				ecx, 8										;maximum input size
		mov				edx, inBufferAddr							;address to store input
		call			ReadString									;read user input as string
		mov				[inLenAddr], eax							;store length of input

		pop				edx											;restore all registers
		pop				ecx
		pop				eax
		
ENDM








displayString MACRO	strAddr
;    Description: displays the string located at address strAddr
; Pre-conditions: strAddr must point to valid null-terminated string
;Post-conditions: string at strAddr has been printed to screen
; Registers used: edx
		
		push				edx							;store edx

		mov					edx, strAddr				;print the string
		call				WriteString	

		pop					edx							;restore edx

ENDM








printStrVal	MACRO integer
;    Description: finds order of magnitude of integer in passed register and calls writeVal to print to screen
; Pre-conditions: 'integer' is register holding value to be printed
;Post-conditions: value at 'integer' has been converted to string and printed
; Registers used: eax, ebx, ecx, edx, edi

		LOCAL				L1, endLoop					;local loop labels		

		push				eax							;store all used registers
		push				ebx
		push				ecx
		push				edx
		push				edi

		mov					edi, integer				;copy the input into edi
		mov					eax, 10						;comparing to 10 at start
		mov					ebx, 10						;to multiply by 10 each loop
		mov					ecx, 1						;number of digits
		mov					edx, 0						;zeroed for multiplication

		L1:
			
			cmp				edi, eax					;test if input > 10^n
			jb				endLoop						;if so, we know number of digits

			mul				ebx							;otherwise, test next power of ten
			inc				ecx							;increment digit count

		jmp					L1							;loop back 

		endLoop:										;for once length has been determined

		;ecx now nas number of digits

		push				OFFSET strBuffer			;buffer offset
		push				edi							;numeric value to print
		push				ecx							;magnitude of numeric value
		call				writeVal					;call the procedure

		pop					edi							;restore all used registers
		pop					edx
		pop					ecx
		pop					ebx
		pop					eax
		
ENDM







main PROC
;    Description: main procedure for function
; Pre-conditions: none
;Post-conditions: none
; Registers used: eax, ebx, ecx, edx, edi, esi, 

		push				OFFSET strHeader
		call				intro

		push				OFFSET intLenArr
		push				OFFSET strError
		push				OFFSET intInLen
		push				OFFSET strBuffer
		push				OFFSET strPrompt
		push				OFFSET intInArr		
		call				readVals

		;array now has integers entered by the user
		
		mov					edx, OFFSET strEntered		;print output message
		call				WriteString

		mov					ecx, 8						;loop counter
		mov					edi, OFFSET intInArr
		mov					esi, OFFSET intLenArr
		mov					eax, 0						;accumulator

		L1:

			add				eax, [edi]

			push			OFFSET strBuffer
			push			[edi]
			push			[esi]	
			call			writeVal

			push			eax							;store accumulator

			mov				eax, 32						;ascii space
			call			WriteChar					
			call			WriteChar					;print twice

			pop				eax							;restore accumulator


			add				edi, 4
			add				esi, 4

		loop				L1
				
		;time to display sum

		displayString		OFFSET strSum				;sum string
		printStrVal			eax							;print string of value in eax

		;time to display average

		displayString		OFFSET strAvg				;print string

		mov					ecx, 8						;divisor

		mov					edx, 0						;prepare to divide eax by ebx
		cdq
		div					ecx							;quotient in EAX, remainder in EDX

		add					edx, edx					;double remainder
		cmp					ebx, edx					;checking if rounding needs to happen
		jbe					noRound						;skip rounding if divisor <= 2 * remainder

		;if here, add 1 to quotient for rounding

		add					eax, 1						;fix rounding

		noRound:

		printStrVal			eax							;convert average to string and print
		call				CrlF						;formatting

		displayString		OFFSET strFarewell			;print farewell message

		exit											;terminate program

main ENDP







intro PROC
;    Description: prints introduction
; Pre-conditions: stack has offset of introduction string
;Post-conditions: message is printed to screen
; Registers used: edx

		push				ebp							;set up stack frame
		mov					ebp, esp
		
		push				edx							;save edx on stack

		mov					edx, [ebp + 8]				;load offset to edx
		call				WriteString

		pop					edx							;restore edx
		pop					ebp							;restore ebp

		ret					4							;clean stack
				
intro ENDP







readVals PROC
;    Description: takes and validates user inputs in form of string, then stores int representation in array
; Pre-conditions: stack has input length pointer, string buffer pointer, prompt string offset, and integer array pointer
;Post-conditions: integer array and integer length array have been populated with user input 
; Registers used: eax, ebx, ecx, edx, edi, esi
	
		push				ebp							;set up stack frame
		mov					ebp, esp

		push				eax							;push all used registers
		push				ebx
		push				ecx
		push				edx
		push				edi
		push				esi

		mov					edi, [ebp + 8]				;pointer to start of storage array
		mov					edx, [ebp + 28]				;pointer to array of integer lengths

		mov					ebx, 0

		readInput:

		;calling getString macro
		getString			[ebp + 12], [ebp + 16], [ebp + 20]

		;input now at address [ebp + 16], length at [ebp + 20]

		mov					esi, [ebp + 16]				;pointer to current character to check
		mov					ecx, [ebp + 20]				;loop counter
		mov					eax, 0

		;testing to see if inputted string is integer

		L1:

			mov				al, [esi]					;current character in al

			cmp				al, 48						;compare to lower bound for ascii numeric
			jb				err
			cmp				al, 57						;compare to upper bound for ascii numeric
			ja				err

			;if here, current character is numeric

			add				esi, 1
			jmp				OK
				
			err:										;current digit is non-numeric

			push			edx							;store edx

			mov				edx, [ebp + 24]				;print error message
			call			WriteString
				
			pop				edx							;restore edx

			jmp				readInput					;get input again

			OK:

		loop				L1

		;once here, string in buffer is valid integer

		push				edx

		mov					edx, [ebp + 16]				;validated string offput in edx
		mov					ecx, [ebp + 20]				;string length in ecx
		call				ParseInteger32				;int binary now in eax

		pop					edx

		mov					[edi], eax					;store int in array
		mov					[edx], ecx					;store int length in parallel array

		inc					ebx							;increment counter
		add					edi, 4						;point to next element in array
		add					edx, 4

		cmp					ebx, 8						;see if we have enough elements yet
		je					endProc						;if so, jump to the end

		jmp					readInput					;otherwise, go get more input
		
		endProc:

		pop					esi							;restore all the registers
		pop					edi
		pop					edx
		pop					ecx
		pop					ebx
		pop					eax
		pop					ebp

		ret					24							;clean stack

readVals ENDP







writeVal PROC
;    Description: 
; Pre-conditions: stack has string buffer pointer, integer to print, and length of the integer
;Post-conditions: integer is converted to string and printed to screen
; Registers used: eax, ebx, ecx, edx
		
		push				ebp							;set up stack frame
		mov					ebp, esp

		push				eax							;store all used registers
		push				ebx
		push				ecx
		push				edx

		mov					eax, [ebp + 12]				;number to print
		mov					ebx, [ebp + 16]				;buffer address pointer
		mov					ecx, [ebp + 8]				;loop counter, length of digit

		add					ebx, ecx					;point to where null terminator should be

		push				eax
		mov					eax, 0
		mov					[ebx], eax					;add null terminator
		pop					eax

		L1:

			cmp				eax, 0						;loop until all digits have been processed
			je				loopBreak

			dec				ebx							;point to previous buffer byte

			mov				edx, 0						;prepare for division
			cdq

			push			ebx							;
			mov				ebx, 10						;temporarily use ebx to divide by 10
			div				ebx							;push and pop ebx to maintain its value
			pop				ebx							;

			add				edx, 48						;adjust remainder to be ascii value

			mov				[ebx], dl					;store byte in pointer location

		jmp					L1							;jump to start of loop

		loopBreak:

		displayString		ebx							;call printing macro
			
		pop					edx							;restore all registers
		pop					ecx
		pop					ebx
		pop					eax
		pop					ebp							;restore ebp

		ret					12							;clean stack

writeVal ENDP






END main