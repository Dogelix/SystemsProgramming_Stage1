; Stage 2 of the Boot Process
BITS 16

; Tell the assembler that we will be loaded at 7C00 (That's where the BIOS loads boot loader code).
ORG 9000h

Start:
	jmp Boot2MainStart ; Jump past Stage 2 Subroutines

; This is the real mode address where we will initially load the kernel
%define	KERNEL_RMODE_SEG		1000h
%define KERNEL_RMODE_OFFSET		0000h
%define SECTOR_SAVE_LOC			0D000h

; Have includes here
; Sub Routines
%include "bpb.asm"						; A copy of the BIOS Parameter Block (i.e. information about the disk format)
%include "floppy16.asm"					; Routines to access the floppy disk drive
%include "functions_16.asm"
%include "display_sector_16.asm"
%include "a20.asm"
%include "messages.asm"
%include "user_input.asm"
%include "conversion_16.asm"

; Kernel name (Must be a 8.3 filename and must be 11 bytes exactly)
ImageName     db "KERNEL  SYS"

; This is where we will store the size of the kernel image in sectors (updated just before jump to kernel to be kernel size in bytes)
KernelSize    dd 0

; Used to store the number of the boot device
boot_device db  0

; Stage 2 Boot Main

Boot2MainStart:
	xor 	ax, ax						; Set stack segment (SS) to 0 and set stack size to top of segment
    mov 	ss, ax
    mov 	sp, 0FFFFh

    mov 	ds, ax						; Set data segment registers (DS and ES) to 0.
	mov		es, ax	
	
	mov		[boot_device], dl			; Boot device number is passed in DL
	
	call 	Enable_A20					; Enables the A20 address line
	cmp		dx, 0
	je		Boot2Cannot

	mov 	si, sector_count_prompt 
	call	Console_WriteLine_16
	call 	Get_Input
	
	call 	Convert_ASCII_to_Int
	mov		bx, cx

	mov 	si, sector_read_prompt
	call	Console_WriteLine_16
	call	Get_Input
	call	Convert_ASCII_to_Int

	mov		ax, cx
	mov		cx, bx
					
	xor		bx, bx						; Zero off the value in bx
	mov		bx, SECTOR_SAVE_LOC			; Load Sector Data in to Address
	call 	ReadSectors

	cmp		di, 0						; Check if Sector Read Failed
	je		SectorCannotBeReadErr
	mov 	bx, SECTOR_SAVE_LOC			; Move the bx back to the start of the loaded sector
	
Boot2DisplaySector:
	call	DisplaySector

	jmp		Switch_To_Protected_Mode

SectorCannotBeReadErr:
	mov		si, sector_failed_to_read
	call 	Console_WriteLine_16
	jmp		WarmBoot

GenericErr:
	mov		si, generic_err
	call 	Console_WriteLine_16
	jmp		WarmBoot

Boot2Cannot:
	mov		si, boot_2_wait_for_key
	call 	Console_WriteLine_16

WarmBoot:
	mov 	ah, 0
	int  	16h							; Wait for Key Press
	int		19h							; Warm boot computer
	hlt

Switch_To_Protected_Mode:
	hlt

; Pad out the boot stage 2 so that it will be exactly 3584 (7 * 512) bytes
	times 3584 - ($ - $$) db 0

