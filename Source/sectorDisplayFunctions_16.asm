DisplaySector:
    mov     cx, 2
    mov     dl, byte[bx]
    xchg    bx, bx

Write_Sector_BX_Loop:
	rol 	dl, 4
    xchg    bx, bx
	movzx	si, dl
    xchg    bx, bx       
	and		si, 000Fh
	mov		al, byte [si + hex_chars]
    xchg    bx, bx 
    mov 	ah, 0Eh
	int 	10h
	loop 	Write_Sector_BX_Loop
    ret
