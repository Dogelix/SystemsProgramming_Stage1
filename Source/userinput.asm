Get_User_Input:
	mov 	si, sector_read_prompt
	call 	Console_Write_16
	call	Read_Single_Key
	mov		si, byte[KEYCHAR]
	call	Console_WriteLine_16
	ret

Read_Single_Key :
	push bp

	; keyboard interrupt
	mov ax,0x00
	int 0x16

	mov byte[KEYCHAR], al
	mov byte[KEYCODE], ah

	; display the entered character
	mov ah,0x0E
	int 0x10

	pop bp
	ret


    

BUFFER: db resb 512
choice: db resb 1
KEYCODE: db resb 1
KEYCHAR: db resb 1