TITLE Assignment7		(assignment7.asm)

;Author: Wyatt Whiting
;Course / Project ID: Program 7, CS271		Date: 12/03/20
;Description: Generates random combinatorial problems, asking users to 
;			  find (n choose r). Calcualates correct answer using a recursive factorial procedure
;			  and checks whether user input is correct or not. At the end of a problem, the user
;			  is asked if they would like to do another problem, and the program loops accordingly.

INCLUDE C:/Irvine/Irvine32.inc



.data


;strings that will be unchanged

strHeader			BYTE			"Assignment 7 - Recursive Combinatorics - CS271 - Fall 2020 - Wyatt D. Whiting", 10, 13, 10, 13
					BYTE			"I will generate a combinatorics problem, then take and validate your answer.", 0
					BYTE			"The program will loop until you choose to exit.", 10, 13, 0
strProb				BYTE			10, 13, 10, 13, "Problem: ", 10, 13, 0
strSet				BYTE			"Elements in the set: ", 0
strChoose			BYTE			"Elements to choose: ", 0
strAns				BYTE			"How many combinations are there? ", 0
strCorrect1			BYTE			"There are ", 0
strCorrect2			BYTE			" combinations of ", 0
strCorrect3			BYTE			" items from a set of ", 0
strRight			BYTE			"Correct! ", 0
strWrong			BYTE			"Incorrect! ", 0
strAnother			BYTE			"Would you like to try another problem? (y = yes, anything else = no): ", 0
strBye				BYTE			"Goodbye. ", 10, 13, 0
strError			BYTE			"ERROR: You entered non-digit characters. Please try again. ", 10, 13, 0


;input buffers and such

strBuffer			BYTE			10 DUP(0)
intAnswer			DWORD			0
intResult			DWORD			0
intFacRes			DWORD			1
intN				DWORD			0
intR				DWORD			0






.code


main PROC
;    Description: main procedure. Mostly pushing and calling functions.
; Pre-conditions: none
;Post-conditions: none
; Registers used: eax, edx


		call				Randomize					;seed RNG

		push				OFFSET strHeader			;intro
		call				intro

		progTop:

		push				OFFSET strProb				;generate and show problem
		push				OFFSET strSet
		push				OFFSET strChoose
		push				OFFSET intN
		push				OFFSET intR
		call				showProblem

		push				OFFSET strError				;get and convert user input
		push				OFFSET strAns
		push				OFFSET strBuffer
		push				OFFSET intAnswer
		call				getData

		push				OFFSET intFacRes			;find correct answer
		push				OFFSET intResult
		push				intN
		push				intR
		call				combinations

		push				intN						;show correct answer
		push				intR
		push				intAnswer
		push				intResult
		call				showResults

		mov					eax, 0						
		mov					edx, OFFSET strAnother		;get user choice for looping
		call				WriteString
		call				ReadChar

		cmp					al, 121						;check if input is 'y'
		je					progTop

		exit											;terminate program

main ENDP






intro PROC
;    Description: prints the program introduction
; Pre-conditions: none
;Post-conditions: introduction printed to screen
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






showProblem PROC
;    Description: generates and displays a combinatorics problem for the user
; Pre-conditions: stack has address of n and r
;Post-conditions: n and r variables are populated with values
; Registers used: eax, ebx, edx, esi


		push				ebp
		mov					ebp, esp					;set up stack frame

		push				eax							;push used registers
		push				ebx
		push				edx
		push				edi

		mov					esi, [ebp + 12]

		mov					eax, 10
		call				RandomRange					;eax in [0, 9]
		add					eax, 3						;eax in [3, 12]
		mov					[esi], eax					;store

		call				RandomRange					;eax in [0, n - 1]
		add					eax, 1						;eax in [1, n]
		mov					esi, [ebp + 8]
		mov					[esi], eax					;store

		mov					edx, [ebp + 24]				;print problem header
		call				WriteString

		mov					edx, [ebp + 20]				;print set size
		call				WriteString
		mov					esi, [ebp + 12]
		mov					eax, [esi]
		call				WriteDec
		call				CrlF

		mov					edx, [ebp + 16]				;print number of elements to choose
		call				WriteString
		mov					esi, [ebp + 8]
		mov					eax, [esi]
		call				WriteDec
		call				CrlF
		
		pop					esi							;restore used registers
		pop					edx
		pop					ebx
		pop					eax

		pop					ebp							;clean stack and return
		ret					20

showProblem ENDP






getData PROC
;    Description: takes user input as string and validates, then converts to int and saves
; Pre-conditions: stack needs to have the address of the input buffer and location to store the data
;Post-conditions: pointer to data is popualted with integer converted from user input string
; Registers used: eax, ebx, ecx, edx, esi

		
		push				ebp
		mov					ebp, esp					;stack frame

		push				eax							;store used registers
		push				ebx
		push				ecx
		push				edx
		push				esi

		inPrompt:

		mov					edx, [ebp + 16]				;prompt for answer
		call				WriteString

		mov					edx, [ebp + 12]				;input buffer address
		mov					ecx, 10						;max input characters
		call				ReadString					;get user input

		call				CrlF

		;string now in input buffer, number of characters in eax

		mov					esi, [ebp + 12]				;esi points to current character
		mov					ecx, eax					;number of characters to check
		L1:

			mov				bl, [esi]					;current character in bl
			
			cmp				bl, 48						;too low?
			jb				notInt

			cmp				bl, 57						;too high?
			ja				notInt

			;if here, current character is integer

			add				esi, 1						;point to next character
			jmp				OK							;skip error if input is ok

			notInt:										;if character isn't an integer

			mov				edx, [ebp + 20]	
			call			WriteString
			jmp				inPrompt

			OK:				

		loop				L1

		;once here, input contains only digits

		mov					ecx, eax					;length in ecx
		mov					edx, [ebp + 12]				;buffer offset in edx
		call				ParseDecimal32				;convert to binary, in eax

		mov					edi, [ebp + 8]
		mov					[edi], eax			;store binary value

		pop					esi					;restore used registers
		pop					edx
		pop					ecx
		pop					ebx
		pop					eax

		pop					ebp
		ret					16
getDATA ENDP






combinations PROC
;    Description: calculates the nCr from previously generated input
; Pre-conditions: stack needs n and r along with address for factorial result and combination result
;Post-conditions: combination result is stored at combo result pointer
; Registers used: eax, ebx, ecx, edi

		
		push				ebp
		mov					ebp, esp					;set up stack frame

		push				eax							;store used registers
		push				ebx
		push				ecx
		push				edi
		
		push				[ebp + 20]					;push fac result address
		push				[ebp + 12]					;push n
		call				factorial

		mov					edi, [ebp + 20]				;edi has result address
		mov					eax, [edi]					;eax has n!

		push				[ebp + 20]					;push fac result address
		push				[ebp + 8]					;push r
		call				factorial					

		mov					ebx, [edi]					;ebx has r!
		cdq					
		div					ebx							;eax has n! / r!

		mov					ecx, [ebp + 12]				;ecx has n
		sub					ecx, [ebp + 8]				;ecx has n - r
		cmp					ecx, 0
		je					skipDiv						;if (n - r) == 0 skip division 

		push				[ebp + 20]					;push result address
		push				ecx							;push (n - r)
		call				factorial					

		mov					ebx, [edi]					;ebx now has (n - r)!
		cdq
		div					ebx							;eax now has (n! / r!) / (n - r)!

		skipDiv:

		mov					edi, [ebp + 16]				;address of final result in edi
		mov					[edi], eax					;store result

		pop					edi							;restore used registers
		pop					ecx
		pop					ebx
		pop					eax

		pop					ebp
		ret					16							;clean stack

combinations ENDP







factorial PROC
;    Description: calculates factorial of integer in a recursive manner
; Pre-conditions: stack needs output address and number to find factorial of
;Post-conditions: output address stores result of n * (n - 1)
; Registers used: eax, ebx, ecx, edx


		push				ebp
		mov					ebp, esp					;set up stack frame

		push				eax							;push all used registers
		push				ebx
		push				ecx
		push				edx

		mov					edx, 0						;zero edx
		mov					ecx, [ebp + 8]				;value
		mov					ebx, [ebp + 12]				;address of result

		cmp					ecx, 1						;checking for base case
		je					baseCase

		;if here, it's not the base case. 

		dec					ecx							;decrease value
		push				ebx							;push address to recursive call
		push				ecx							;push reduced value to recursive call
		call				factorial					;call recursive case
		inc					ecx							;restore value

		;result address has result from recursive call

		mov					eax, [ebx]					;get ready to multiply
		cdq
		mul					ecx							;multiply by value
		mov					ecx, eax					;push into value storage

		baseCase:										;label to skip recursion

		mov					[ebx], ecx					;move into result address

		pop					edx							;restore all the registers
		pop					ecx
		pop					ebx
		pop					eax

		pop					ebp					
		ret					8							;clean the stack
factorial ENDP







showResults PROC
;    Description: displays results and correctness of user response
; Pre-conditions: stack needs result, user answer, r, and n
;Post-conditions: correct answer and validity of user answer is printed to screen
; Registers used: eax, edx

		
		push				ebp						
		mov					ebp, esp					;set up stack frame

		push				eax							;push used registers
		push				edx

		mov					edx, OFFSET strCorrect1		;first part
		call				WriteString

		mov					eax, [ebp + 8]				;correct result
		call				WriteDec

		mov					edx, OFFSET strCorrect2		;second part
		call				WriteString

		mov					eax, [ebp + 16]				;elements
		call				WriteDec

		mov					edx, OFFSET strCorrect3		;third part
		call				WriteString

		mov					eax, [ebp + 20]				;set size
		call				WriteDec
		call				CrlF

		mov					eax, [ebp + 8]				;compare for correct answer
		mov					ebx, [ebp + 12]
		cmp					eax, ebx
		je					correctAns

		mov					edx, OFFSET strWrong		;wrong answer
		call				WriteString
		jmp					showResEnd

		correctAns:

		mov					edx, OFFSET strRight		;right answer
		call				WriteString

		showResEnd:

		call				CrlF						;formatting

		pop					edx							;restore used registers
		pop					eax

		pop					ebp							;clean stack
		ret					16
showResults ENDP


END main