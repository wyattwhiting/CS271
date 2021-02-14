;Author: Wyatt Whiting
;Date: 2020-11-05
;Description: assignment core algorithms

INCLUDE Irvine32.inc
INCLUDE core_module.inc


.const

MAX_RAN				equ 1024		;maximum random number
MIN_RAN				equ 64			;minimum random number


.code


;______________________________________________________________________________________________________
fillArray PROC
;    Description: fills array with n random values, where n is in [16, 256] and the random values are
;				  in the range [64, 1024]
; Pre-conditions: stack must have desired number of integers, followed by address of array to fill
;				  note - the desired number of integers must be in proper range before calling
;Post-conditions: value and address are removed from the stack. Array at passed address has n random integers
; Registers used: eax, ebx, ecx, esi




		push			ebp							;set up stack frame
		mov				ebp, esp

		;set up for loop

		mov				esi, [ebp + 8]				;array address
		mov				ecx, [ebp + 12]				;loop counter
		mov				ebx, MAX_RAN				;ebx = 1024
		sub				ebx, MIN_RAN				;ebx -= 64
		add				ebx, 1						;ebx += 1 == 961
		
		L1:											;top of loop

			mov			eax, ebx					;copy range backup
			call		RandomRange					;[0, 960] in eax
			add			eax, MIN_RAN				;[64, 1024] in eax
			mov			[esi], eax					;store in array location
			add			esi, 4						;adjust for next element

		loop			L1

		pop				ebp

		ret				8


fillArray ENDP
;______________________________________________________________________________________________________







;______________________________________________________________________________________________________
sortList PROC
;    Description: Sorts array at passed address in largest-first manner. 
; Pre-conditions: stack has list address, followed by number of elements in array
;Post-conditions: array at passed address has been sorted in descending order.
;				  removes arguments from stack
; Registers used: eax, ebx, ecx, esi




		push			ebp							;set up stack frame
		mov				ebp, esp

		L2:

			mov			ecx, [ebp + 8]				;loop counter
			dec			ecx
			mov			esi, [ebp + 12]				;base address for array

			L1:
		
			mov			eax, [esi]					;copy a_n to eax
			mov			ebx, [esi+4]				;copy a_(n + 1) to ebx

			cmp			eax, ebx					;if(eax >= eax)
			jae			noSwap						;	no swap is needed
	

			;if here, elements need to be swapped

			mov			[esi], ebx					;swap part 1
			mov			[esi + 4], eax				;swap part 2

			jmp			L2							;rest loop counter and base address

			noSwap:
			add			esi, 4						;increment element pointer

		loop			L1

funcEnd:

		pop				ebp
		ret				8


sortList ENDP
;______________________________________________________________________________________________________



END