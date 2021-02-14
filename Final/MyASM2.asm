TITLE MyASM					(MyASM.asm)
;CS271 Final Project - Calling Win32 from ASM to print message box
;5 Dec 2020 - Wyatt D. Whiting


INCLUDE c:\Irvine\irvine32.inc



;prototype for Win32 MessageBoxA function - From pg452 in textbook

MessageBoxA PROTO,
	hWnd:DWORD,
	lpText:PTR BYTE,
	lpCaption:PTR BYTE,
	uType:DWORD


.data								;strings for the box

strHeader			BYTE			"This is the box title.",0
strMessage			BYTE			"This is the first line of text in the box,", 10, 13
					BYTE			"And this is the second. Made by Wyatt Whiting :)", 0


.code 
main PROC 
		
		;invoke MessageBoxA - Inspired by page 454/455 of textbook

		invoke			MessageBoxA, 
							NULL, 
							ADDR strMessage,
							ADDR strHeader, 
							MB_CANCELTRYCONTINUE + MB_ICONEXCLAMATION
						
		;program gets here after user has selected option for window

		exit							;exit program
main ENDP

END