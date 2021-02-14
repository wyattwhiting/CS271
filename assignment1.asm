TITLE Assignment 1		(assignment1.asm)

;Author: Wyatt Whiting
;Course / Project ID: Project 1, CS271		Date: 10/02/20
;Description: displays title and instructions. Takes user input. Does some arithemetic and displays terminating message.

INCLUDE c:/Irvine/Irvine32.inc



.data

;numeric data. 
;using DWORD becuase ReadInt interprets input as 32-bit value
;and we don't need to worry about negative values
usrInput1		DWORD ?			;first user input
usrInput2		DWORD ?			;second user input
sum				DWORD ?			;sum of numbers
diff			DWORD ?			;difference of numbers
prod			DWORD ?			;product of numbers
quot			DWORD ?			;quotient of numbers
remainder		DWORD ?			;remainder of numbers
str1 \
BYTE "This string is quite long!",0


;strings and output literals
intro			BYTE "Assignment 1 - CS271 - Fall 2020 - Wyatt D. Whiting", 0
instruct		BYTE "Enter two integers when prompted. Note, your second input must neither exceed the first or be 0. ",0
prompt1			BYTE "Please enter your first integer: ",0
prompt2			BYTE "Please enter your second integer: ",0
farewell		BYTE "Thank you for grading my program. I hope I earn a good score!",0
errorMsgZero	BYTE "ERROR: the second value you entered is zero, which will cause a division by zero error. Please try again.",0
errorMsgVals	BYTE "ERROR: the second value you entered is greater than the first. Please try again.",0
repeatQues		BYTE "Would you like to run the program again? Enter 1 for yes, anything else for no: ",0
challenges		BYTE "I have implemented challenges 1 and 2",0


;math symbols, etc...
plus			BYTE " + ",0
minus			BYTE " - ",0
times			BYTE " * ",0
divide			BYTE " / ",0
remain			BYTE ", remainder ",0
equals			BYTE " = ",0



.code
main PROC
;start with printing program introduction
		
		;print assignment information and such
		mov		edx, OFFSET intro		;load intro's OFFSET into edx register
		call	WriteString				;print string
		call	CrlF					;carriage return 

		mov		edx, OFFSET challenges	;load challenge's OFFSET into edx
		call	WriteString				;print string
		call	CrlF					;carriage return

		mov		edx, OFFSET instruct	;load instruct's OFFSET into edx
		call	WriteString				;print string
		call	CrlF					;carriage return 


;prompt input from user and store data into declared variables
;this routine will also check the data is acceptable for the rest
;of the program logic
getUserInput: 

		call	CrlF						;carriage return for formatting

		;clear registers
		;probably not necessary but w/e
		mov		eax, 0						;reset eax
		mov		ebx, 0						;reset ebx

		;print prompt for first user input
		mov		edx, OFFSET prompt1			;load prompt1's OFFSET into edx register
		call	WriteString					;print string

		;take and store first user input
		call	ReadInt						;stores 32-bit value in eax
		mov		usrInput1, eax				;copy eax to usrInput1

		;print prompt for second user input
		mov		edx, OFFSET prompt2			;load prompt2's OFFSET into edx register
		call	WriteString					;print string

		;take and store second user input
		call	ReadInt						;stores 32-bit value in eax
		mov		usrInput2, eax				;copy eax to usrInput2

		call	CrlF						;carriage return for formatting



		;check the sizes of inputs are acceptable
		;start by checking usrInput2 != 0
		cmp		usrInput2, 0				;compare usrInput2 to 0
		je		errorZero					;jump to errorZero section if they are equal
		
		;checking if usrInput1 < usrInput2
		mov		eax, usrInput1				;copy usrInput1 into eax
		mov		ebx, usrInput2				;copy usrInput2 into ebx
		cmp		eax, ebx					;compare inputs
		jl		errorVals					;jump if usrInput1 < usrInput2

		jmp		math						;if no errors are found, go ahead with calculations



;program label for errors
errorZero:
		mov		edx, OFFSET errorMsgZero	;copy errorMsgVals's OFFSET to edx
		call	WriteString					;print the message
		call	CrlF						;carriage return
		jmp		getUserInput				;jump back to user input prompting

errorVals:
		mov		eax, 0						;reset eax
		mov		ebx, 0						;reset ebx
		mov		edx, OFFSET errorMsgVals	;copy errorMsgVals's OFFSET to edx
		call	WriteString					;print the message
		call	CrlF						;carriage return
		jmp		getUserInput				;jump back to user input prompting



;control flow label for math calculations
;usrInputs must be verified before jump
math:

		;addition
		mov		eax, usrInput1				;load first input into eax
		add		eax, usrInput2				;add usrInput2 to eax
		mov		sum, eax					;store in sum
		
		;subtraction
		mov		eax, usrInput1				;load first input into eax
		sub		eax, usrInput2				;now eax = usrInput1 - usrInput2
		mov		diff, eax					;store difference

		;multiplication
		mov		eax, usrInput1				;load first input into eax
		mov		ebx, usrInput2				;load second input into ebx
		mul		ebx							;multiply by usrInput2
		mov		prod, eax					;store product

		;division
		mov		eax, usrInput1				;load first input into eax
		mov		ebx, usrInput2				;load second user input into ebx
		div		ebx							;perform divsion 
		mov		quot, eax					;store quotient
		mov		remainder, edx				;store remainder



		;print all the equations

		;show sum equation
		mov		eax, usrInput1				;a
		call	WriteDec
		mov		edx, OFFSET plus			;+
		call	WriteString
		mov		eax, usrInput2				;b
		call	WriteDec
		mov		edx, OFFSET equals			;=
		call	WriteString
		mov		eax, sum					;c
		call	WriteDec
		call	CrlF

		;show difference equation
		mov		eax, usrInput1				;a
		call	WriteDec
		mov		edx, OFFSET minus			;-
		call	WriteString
		mov		eax, usrInput2				;b
		call	WriteDec
		mov		edx, OFFSET equals			;=
		call	WriteString
		mov		eax, diff					;c
		call	WriteDec
		call	CrlF

		;show product equation
		mov		eax, usrInput1				;a
		call	WriteDec
		mov		edx, OFFSET times			;*
		call	WriteString
		mov		eax, usrInput2				;b
		call	WriteDec
		mov		edx, OFFSET equals			;=
		call	WriteString
		mov		eax, prod					;c
		call	WriteDec
		call	CrlF

		;show division equation
		mov		eax, usrInput1				;a
		call	WriteDec
		mov		edx, OFFSET divide			;/
		call	WriteString
		mov		eax, usrInput2				;b
		call	WriteDec
		mov		edx, OFFSET equals			;=
		call	WriteString
		mov		eax, quot					;c
		call	WriteDec
		mov		edx, OFFSET remain			;remainder
		call	WriteString
		mov		eax, remainder				;r
		call	WriteDec
		call	CrlF						;carriage return
		call	CrlF

		;ask if use wants to repeat the process, take input
		mov		edx, OFFSET repeatQues		;load repeatQues' OFFSET into edx
		call	WriteString					;print the string
		call	ReadInt						;stores 32-bit value in eax
		cmp		eax, 1						;compare stored input to decimal 1
		je		getUserInput				;if 1 was entered, return to user input



		;print farewell
		call	CrlF						;carriage return
		mov		edx, OFFSET farewell		;load farewell's OFFSET to edx
		call	WriteString					;print string
		call	CrlF						;carriage return


	exit
main ENDP

END main