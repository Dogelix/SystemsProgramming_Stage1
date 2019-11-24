Get_Input:
    push    cx
    mov     di, input_buffer   ; di store the keyboard buffer
    xor     cl, cl

Get_Input_Loop:
    mov 	ah, 0h
	int  	16h	

    cmp     al, 08h             ; Check if backspace
    je      Backspace_Entered

    cmp     al, 0Dh             ; Check if enter key
    je      Get_Input_Ret

    cmp     cl, 5              ; If 63 Chars entered loop to only allow Enter or Backspace
    je      Get_Input_Loop

    mov     ah,  0Eh            ; Print Char to screen
    int     10h

    stosb                       ; Put Character in to the buffer (di)
    inc     cl
    jmp     Get_Input_Loop

Backspace_Entered:
    cmp     cl, 0               ; Jmp back to loop in cl == 0 (Start of buffer)
    je      Get_Input_Loop

    dec     di                  
    mov     byte[di], 0         ; Del character in buffer
    dec     cl                  ; Dec counter

    mov     ah, 0Eh             ; Backspace to screen
    mov     al, 08h
    int     10h

    mov     al, 20h             ; Blank char to screen
    int     10h
    
    mov     al, 08h             ; Output backspace again
    int     10h
    jmp     Get_Input_Loop

Get_Input_Ret:
    mov     al, 0
    stosb

    mov     ah, 0Eh             ; CRLF to screen
    mov     al, 0Dh
    int     10h
    mov     al, 0Ah
    int     10h		

    pop     cx
    ret

input_buffer times 6 db 0
