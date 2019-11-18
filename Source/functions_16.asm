; Various sub-routines that will be useful to the boot loader code	
;http://createyourownos.blogspot.com/p/an-x86.html
; Output Carriage-Return/Line-Feed (CRLF) sequence to screen using BIOS

Console_Write_CRLF:
	mov 	ah, 0Eh						; Output CR
    mov 	al, 0Dh
    int 	10h
    mov 	al, 0Ah						; Output LF
    int 	10h
    ret

Console_Write_Space:
	mov		al, 32
    mov 	ah, 0Eh
	int 	10h
	ret

; Write to the console using BIOS.
; 
; Input: SI points to a null-terminated string

Console_Write_16:
	mov 	ah, 0Eh						; BIOS call to output value in AL to screen

Console_Write_16_Repeat:
    mov		al, [si]
	inc     si
    test 	al, al						; If the byte is 0, we are done
	je 		Console_Write_16_Done
	int 	10h							; Output character to screen
	jmp 	Console_Write_16_Repeat

Console_Write_16_Done:
    ret

; Write string to the console using BIOS followed by CRLF
; 
; Input: SI points to a null-terminated string

Console_WriteLine_16:
	call 	Console_Write_16
	call 	Console_Write_CRLF
	ret

hex_chars	db '0123456789ABCDEF'

Write_Value_Of_DX_Hex:
	mov		cx, 4
	mov 	ah, 0Eh

Write_Value_Of_DX_Hex_Loop:
	rol 	dx, 4
	mov		si, dx
	and		si, 000Fh
	mov		al, byte [si + hex_chars]
	int 	10h
	loop 	Write_Value_Of_DX_Hex_Loop
	;mov		si, spacer
	;call	Console_Write_16
	ret

Write_Value_Of_BX_Int:
	mov 	si, buffer  ; Load the buffer in to memory 
	mov 	ax, bx		; Move the value of bx to ax

Write_Value_Of_BX_Int_Loop:
	xor		dx, dx
	mov 	cx, 10
	div		cx

	add		dl, 48	  	; Convert to an ascii character
	mov		[si], dl
	dec		si
	cmp		ax, 0 	  	; If ax != 0 then continue to read the value
	jne 	Write_Value_Of_BX_Int_Loop
	inc 	si
	call 	Console_WriteLine_16

Write_Value_Of_BX_Int_Done:
	ret

buffer 	db '     ', 0 ; 5 space characters to allow for a 16 bit number

bx_val_hex_msg:             db 'BX Hex Value: ', 0
bx_val_msg:                 db 'BX Value: ', 0