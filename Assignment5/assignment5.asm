TITLE Assignment5		(assignment5.asm)

;Author: Wyatt Whiting
;Course / Project ID: Program 4, CS271		Date: 11/04/20
;Description: Takes user input in range n \in [16, 256]. It then generates  
;			  n random numbers in range [64, 1024] and displays in array. 
;			  Then sorts in descending order and calculates the median and 
;			  average values. 

INCLUDE Irvine32.inc
INCLUDE core_module.inc
INCLUDE io_module.inc

.const

MAX_IN				equ	256			;maximum user input
MIN_IN				equ 16			;miniumum user input

MAX_RAN				equ 1024		;maximum random number
MIN_RAN				equ 64			;minimum random number




.data

;strings

strHeader			BYTE			"Assignment 5 - Arrays and Randoms - CS271 - Fall 2020 - Wyatt D. Whiting", 10, 13, 10, 13
					BYTE			"Please enter the number of integers you would like to generate.",10,13
					BYTE			"I will accept integers in the set [16, 256]: ", 0
strErrorRange		BYTE			"ERROR: The number you entered is outside the acceptable range. Please try again: ", 0
strArrUnsort		BYTE			10, 13, "---=== Unsorted Array ===---", 10, 13, 0
strArrSort			BYTE			10, 13, "---===  Sorted Array  ===---", 10, 13, 0
strBye				BYTE			10, 13, 10, 13, "Thanks for grading my program, Mahon!", 10, 13, 0
strMedian			BYTE			10, 13, 10, 13, "Median value: ", 0
strAverage			BYTE			10, 13, 10, 13, "Average value: ", 0


;array and request

intArray			DWORD			256 DUP (0)		;start array with all 0s, which will represent non-entry
intUserReq			DWORD			?				;variable for user input




.code

main PROC 
;    Description: main function to run the program. Calls all other procedures in proper order
; Pre-conditions: none
;Post-conditions: none
; Registers used: none explicitely, each procedure has their own documentation 




		call			Randomize					;seed PRNG, recommended to be in main by supplemenetary lecture 20


		push			OFFSET strHeader			; introAndFarewell(&header)
		call			introAndFarewell			;


		push			OFFSET strErrorRange		;
		push			OFFSET intUserReq			; getData(&errorMessage, &request)
		call			getData						;


		push			intUserReq					;
		push			OFFSET intArray				; fillArray(request, &list)
		call			fillArray					;


		push			OFFSET intArray				;
		push			intUserReq					; displayList(&list, request, &string)
		push			OFFSET strArrUnsort			;
		call			displayList					;


		push			OFFSET intArray				;
		push			intUserReq					; sortList(&list, request)
		call			sortList					;

		
		push			OFFSET strMedian			;
		push			OFFSET intArray				; displayMedian(&string, &list, request)	
		push			intUserReq					;
		call			displayMedian				;

		push			OFFSET strAverage			;
		push			OFFSET intArray				; displayAverage(&string, &list, request)
		push			intUserReq					;
		call			displayAverage				;

		push			OFFSET intArray				;
		push			intUserReq					; displayList(&list, request, &string)
		push			OFFSET strArrSort			;
		call			displayList					;
		

		push			OFFSET strBye				; introAndFarewell(&strBye)
		call			introAndFarewell			;

		exit


main ENDP

END main