TITLE Assignment3		(assignment3.asm)

;Author: Wyatt Whiting
;Course / Project ID: Program 3, CS271		Date: 10/15/20
;Description: Takes user input for name. Accepts and accumulates sum of negative numbers
;			  in [-100, -1], along with the total number of numbers entered.
;             Prints sum, total inputs, and average of inputs. 


INCLUDE c:/Irvine/Irvine32.inc

.const

MAX_IN			equ -1
MIN_IN			equ -100
NAME_LEN		equ 30



.data

;strings and variables

header			BYTE		"Assignment 3 - Integer Accumulator - CS271 - Fall 2020 - Wyatt D. Whiting",0
numPrompt		BYTE		"Please enter a number: ",0
greet1			BYTE		"Hello, ",0
greet2			BYTE		". It's a pleasure to meet you!",0
namePrompt		BYTE		"Please enter your name: ",0
instruct1		BYTE		"You will be asked to enter a number in the range [-100, -1], inclusive.",0
instruct2		BYTE		"Once a non-negative number is entered, you will be shown the count ",0
instruct3		BYTE		"and sum of all valid numbers you entered.",0
output1			BYTE		"You entered ",0
output2			BYTE		" valid numbers.",0
output3			BYTE		"The sum of your valid numbers is ",0
output4			BYTE		"The rounded average is ",0
farewell1		BYTE		"Thank you for using the Integer Accumulator. It's been fun, ",0
farewell2		BYTE		".",0
errorMsg		BYTE		"ERORR: No numbers entered.",0
colon			BYTE		": ",0

username		BYTE		NAME_LEN+1 DUP(?)		;max name length + 1 for null terminator
totIn			DWORD		0						;accumulator for argument count
userIn			SDWORD		?						;user input for current step
sum				SDWORD		0						;accumulator for sum
avgIn			SDWORD		?						;variable for average input
lineCount		DWORD		0						;line number variable




.code 
main PROC
		;printing intro
		mov			edx, OFFSET header				;print header
		call		WriteString
		call		CrlF
		mov			edx, OFFSET namePrompt			;print namePrompt
		call		WriteString

		;take and store username
		mov			edx, OFFSET username				
		mov			ecx, NAME_LEN					;ReadString needs max length in ecx
		call		ReadString						;read in string, will add terminating character 
		mov			edx, OFFSET greet1				;print first part of greeting
		call		WriteString
		mov			edx, OFFSET username			;print username
		call		WriteString
		mov			edx, OFFSET greet2				;print second part of greeting
		call		WriteString	
		call		CrlF
		call		CrlF

		;print instructions
		mov			edx, OFFSET instruct1			;print first line of instructions
		call		WriteString
		call		CrlF
		mov			edx, OFFSET instruct2			;print second line of instructions
		call		WriteString
		call		CrlF
		mov			edx, OFFSET instruct3			;print third line of instructions
		call		WriteString
		call		CrlF
		call		CrlF




;beginning of input loop

inputSec:
		;print line number
		inc			lineCount						;increment line counter
		mov			eax, lineCount					
		call		WriteDec						;print line count
		mov			edx, OFFSET colon				;print colon
		call		WriteString

		;get user input
		mov			edx, OFFSET numPrompt			;print input prompt
		call		WriteString
		call		ReadInt							;user input in eax

		;check minimum bound
		cmp			eax, MIN_IN						;SF = 1 iff MSB of (eax + 100) is negative
		jl			inputSec						;jump if SF <> OF

		;check maximum bound
		cmp			eax, MAX_IN						;SF = 1 iff MSB of (eax + 1) is negative
		jg			posIn							;jump if ZF = 0 and SF = OF

		;input is validated
		add			sum, eax						;accumulate validated input to sum
		inc			totIn							;increment total valid input count
		jmp			inputSec						;jump back to input prompt




;program label for post-input loop. Catches if there was no valid inputs

posIn:
		;check for no valid inputs
		mov			eax, totIn
		cmp			eax, 0							;compare total inputs to 0
		je			noInput							;jump if no inputs

		;print total input count and sum
		mov			edx, OFFSET output1				;print first output part
		call		WriteString
		mov			eax, totIn						;load input count to eax
		call		WriteDec						;print number of valid inputs
		mov			edx, OFFSET output2				;print second output part
		call		WriteString
		call		CrlF
		mov			edx, OFFSET output3				;print third output part
		call		WriteString
		mov			eax, sum						;copy accumulated sum to eax
		call		WriteInt						;print as signed number
		call		CrlF

		;calculate rounded average
		cdq											;sign-extend EAX to EDX
		mov			ebx, totIn						;divisor for idiv [ebx] = [divisor]
		idiv		ebx								;[eax, edx] = [quotient, remainder]
		add			edx, edx						;[edx] = [2 * remainder]
		add			edx, ebx						;[edx] = [2 * remainder] + [divisor]

		;adjust quotient if needed
		cmp			edx, 0							;checking negativity with 0
		jge			printAvg						;if non-negative, skip rounding correction
		sub			eax,1							;fix quotient for rounding
		



;program label for printing average

printAvg:
		
		mov			edx, OFFSET output4				;print average text
		call		WriteString
		call		WriteInt						;print average
		call		CrlF
		jmp			endProg							;jump to end of program




;program label for no valid input

noInput:
		;print error message
		mov			edx, OFFSET errorMsg			;error message
		call		WriteString
		call		CrlF
	



;program label for farewell

endProg:
		;print farewell
		call		CrlF
		mov			edx, OFFSET farewell1			;print first part of farewell
		call		WriteString
		mov			edx, OFFSET username			;print username
		call		WriteString
		mov			edx, OFFSET farewell2			;print period
		call		WriteString
		call		CrlF
		exit										;exit with proper code

main ENDP
END main