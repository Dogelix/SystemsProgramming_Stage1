DisplaySector:
    xor     cx, cx
    mov     cx, 2
    push    cx
    mov     cx, 16

DisplaySector_Loop:
    push    cx

    call    Display16Bytes

    pop     cx
    loop    DisplaySector_Loop
    push    cx
    
    mov 	ah, 0
    int     16h
    dec     dx
    pop     dx
    cmp     dx, 0
    je      DisplaySector_Ret

    mov     cx, 16
    jmp     DisplaySector_Loop


DisplaySector_Ret:   
    ret

Display16Bytes:
    mov     cx, 16

Display16Bytes_Loop:
    push    cx

    call    DisplayByte

    pop     cx
    inc     bx
    loop    Display16Bytes_Loop
    call    Console_Write_CRLF
    
    ret

DisplayByte:
    mov     cx, 2
    mov     dl, byte[bx]
    xchg    bx, bx

DisplayByte_Loop:
	rol 	dl, 4
    xchg    bx, bx
	movzx	si, dl
    xchg    bx, bx       
	and		si, 000Fh
	mov		al, byte [si + hex_chars]
    mov 	ah, 0Eh
	int 	10h
	loop 	DisplayByte_Loop

    mov		al, 32
    mov 	ah, 0Eh
	int 	10h

    ret