DisplaySector:
    push    ax
    push    cx
    push    dx
    xor     dx, dx
    mov     dx, 2
    xchg    bx, bx

    push    dx

    xor     dx, dx
    mov     cx, 16
    xor     ax, ax

DisplaySector_Loop:
    push    cx

    call    Write_Value_Of_DX_Hex
    call    Console_Write_Space
    call    Display16Bytes
    call    DisplayChars
    call    Console_Write_CRLF

    add     dx, 16					; Add 16 to dx to act as the offest counter
    
    mov     bx, SECTOR_SAVE_LOC     ; Janked for it to work (the bx register for some reason wasn't saving it's increments)
    add     bx, dx					; Offset the address in bx by the value in dx

    pop     cx
    loop    DisplaySector_Loop
    mov		si, next_section_msg
	call	Console_WriteLine_16
    mov 	ah, 0
    int     16h

    mov     ax, dx

    pop     dx
    dec     dx
    cmp     dx, 0
    je      DisplaySector_Ret
    push    dx

    mov     dx, ax

    mov     cx, 16
    jmp     DisplaySector_Loop


DisplaySector_Ret:
    pop     dx
    pop     cx
    pop     ax
    ret

DisplayChars:
    push    bx
    push    ax
    push    cx
    mov     bx, SECTOR_SAVE_LOC
    add     bx, dx
    mov     cx, 16
	mov 	ah, 0Eh	; BIOS call to output value in AL to screen	
			
DisplayChars_Loop:
    cmp     byte[bx], 32
    jnae    DisplayChars_Under_32	
    mov		al, [bx]

DisplayChars_Print:
	int 	10h
    inc     bx
    loop    DisplayChars_Loop	
    pop     bx
    pop     ax
    pop     cx
    ret

DisplayChars_Under_32:  
    mov		al, 95
    jmp     DisplayChars_Print

Display16Bytes:
    mov     cx, 16

Display16Bytes_Loop:
    push    cx

    call    DisplayByte

    pop     cx
    inc     bx
    loop    Display16Bytes_Loop
    
    ret

DisplayByte:
    push    dx
    mov     cx, 2
    mov     dl, byte[bx]
    ;xchg    bx, bx

DisplayByte_Loop:
	rol 	dl, 4
    ;xchg    bx, bx
	movzx	si, dl
    ;xchg    bx, bx       
	and		si, 000Fh
	mov		al, byte [si + hex_chars]
    mov 	ah, 0Eh
	int 	10h
	loop 	DisplayByte_Loop

    call    Console_Write_Space          ;add a space char after loop
    pop     dx
    ret