Convert_ASCII_to_Int:
    push	ax
    push    dx
    xor     ax, ax
    mov     si, input_buffer
    xor     cx, cx

Convert_ASCII_to_Int_Loop:
    cmp     byte[si], 0
    je      Convert_ASCII_to_Int_Ret

    mov     al, byte[si]
    sub     al, '0'
    imul    cx, 10
    add     cl, al

    inc     si
    jmp     Convert_ASCII_to_Int_Loop

Convert_ASCII_to_Int_Ret:
    pop     dx
    pop     ax
    ret
