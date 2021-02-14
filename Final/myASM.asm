TITLE myASM					(myASM.asm)
;demonstration of calling standard C functions from Assembly

.686p
.model flat, stdcall
.stack 4096


printf PROTO C, :VARARG


.data

myString		BYTE		"Hello, world! Wyatt W. F2020 CS271  ", 0

.code

main PROC C

		push			OFFSET myString						;push string pointer to stack
		call			printf								;call the C printf() function
		add				esp, 4								;fix the stack
				
		invoke			printf, OFFSET myString				;no need to fix stack for this one

		mov				eax, 0								;0 eax
		ret													;return to exit program

main ENDP
END 