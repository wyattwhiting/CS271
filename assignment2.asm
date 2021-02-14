TITLE Assignment 2		(assignment2.asm)

;Author: Wyatt Whiting
;Course / Project ID: Project 2, CS271		Date: 10/10/20
;Description: takes user input for name and desired nth fibonacci number, displays 
;             all fibbonacci numbers up to and include the nth number. Says farewell
;			  to use after running. 


INCLUDE c:/Irvine/Irvine32.inc

;constant definitions, like max and min input

MIN_IN				equ 1
MAX_IN				equ 46
NAME_LEN			equ 30


.data

;variables for messages which will be printed to the screen

intro			BYTE	"Assignment 2 - CS271 - Fall 2020 - Wyatt D. Whiting",0
instruct1		BYTE   	"This program takes input n and shows Fibonacci numbers up to fib(n),",0
instruct2		BYTE    "where fib(1) = fib(2) = 1. Subsequent terms are given by the formula",0
instruct3		BYTE	"fib(n + 1) = fib(n) + fib(n - 1).",0
numPrompt		BYTE	"Please enter an integer in the range [1,46]: ",0
nameprompt		BYTE	"Please enter your name: ",0
greeting1		BYTE	"Hello, ",0
greeting2		BYTE	". Are you feeling fulfilled in your life?",0
tooLow			BYTE	"ERROR: value is less than 1. ",0
tooHigh			BYTE	"ERROR: value is greater than 46.",0
farewell1		BYTE	"Thank you for using the program, ",0
farewell2		BYTE    ". Goodbye!",0
space			BYTE	"    ",0

;other variable declarations

username		BYTE	NAME_LEN+1 DUP(?)		;max name length + 1 for null terminator
userIn			DWORD	?						;will hold user input. signed for possibility of neg
lineCount		DWORD   1						;count of numbers on line, starts at 1 to avoid 5 numbers on first line




.code
main PROC

;print program introduction and header

		;print intro
		mov			edx, OFFSET intro				;move intro's offset to edx
		call		WriteString						;print string
		call		CrlF							;newline
		call		CrlF

		;print instructions
		mov			edx, OFFSET instruct1			;first line of instructions
		call		WriteString						
		call		CrlF	
		mov			edx, OFFSET instruct2			;second line of instructions
		call		WriteString						
		call		CrlF
		mov			edx, OFFSET instruct3			;third line of instructions
		call		WriteString						
		call		CrlF
		call		CrlF							;for formatting		

		;print out name prompt
		mov			edx, OFFSET namePrompt			;move namePrompt's offset to edx
		call		WriteString						;print string

		;get and store username into string variable
		mov			edx, OFFSET username				
		mov			ecx, NAME_LEN					;ReadString needs max length in ecx
		call		ReadString						;read in string, will add terminating character 

		;greeting 
		mov			edx, OFFSET greeting1			;first part of greeting
		call		WriteString
		mov			edx, OFFSET username			;followed by name
		call		WriteString
		mov			edx, OFFSET greeting2			;followed by second part of greeting
		call		WriteString
		call		CrlF




;label for taking user input

inputSec:
		mov			edx, OFFSET numPrompt			;prompt input
		call		WriteString

		call		ReadInt							;input now in eax
		mov			userIn, eax						;store for later use

		;check that MIN_IN < eax = userIn < MAX_IN
		cmp			eax, MAX_IN						;check against maximum input
		jg			errorHigh						;jump if input > MAX_IN
		cmp			eax, MIN_IN						;check against minimum input
		jl			errorLow						;jump if input < MIN_IN

		jmp			noError							;if passed check, skip error printing and go to rest of program




;label for printing too-low error

errorLow:
		mov			edx, OFFSET tooLow				;print error
		call		WriteString
		call		CrlF
		jmp			inputSec						;loop back to user input prompt




;label for print too-high error

errorHigh:
		mov			edx, OFFSET tooHigh				;print error
		call		WriteString
		call		CrlF
		jmp			inputSec						;loop back to user input prompt
		



;label for when input has been validated

noError:
		call		CrlF							;ease of reading
					
		mov			edx, OFFSET space				;for easy access
		mov			ecx, userIn						;number of iterations for LOOP instruction

		cmp			ecx, 1							;test for special case userIn == 1
		je			print1							;jump to avoid integer overflow later

		sub			ecx, 1							;subract two from ecx to account for special case

		mov			eax, 1							;initilize first term
		mov			ebx, 1							;initialize second term

		call		WriteDec						;print first term
		call		WriteString						;print space




;label for loop to print fibb values to screen

loopStart:
		call		WriteDec						;print fibonacci term and space
		call		WriteString

		inc			lineCount						;increment count of lines
		cmp			lineCount, 4					;compare to 4
		je			newLine							;jump to print new line

		return:										;label for newLine to return to

		xadd		eax, ebx						;[eax, ebx = n, m] -> [eax, ebx = m, n + m]
		loop		loopStart

		call		CrlF							;formatting
		jmp			progEnd							;after loop ends, jump to end of program
		



;label for printing just one fibonacci number

print1:
		mov			eax, 1							;1 in eax
		call		WriteDec						;print
		jmp			progEnd							;jump to end of program
		



;label for printing new line

newLine:
		call		CrlF							;print new line
		mov			lineCount, 0					;reset line counter
		jmp			return							;return to loop




;label for end of program

progEnd:
		call		CrlF							;formatting
		mov			edx, OFFSET farewell1			;first part of farewell
		call		WriteString
		mov			edx, OFFSET username			;user's name
		call		WriteString
		mov			edx, OFFSET farewell2			;second part of farewell
		call		WriteString
		call		CrlF							;formatting
		
		exit										;exit function to avoid runtime errors




main ENDP
END main

