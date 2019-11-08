; Stage 2 of the Boot Process
BITS 16

; Tell the assembler that we will be loaded at 7C00 (That's where the BIOS loads boot loader code).
ORG 9000h

Start:
	jmp Boot2MainStart ; Jump past Stage 2 Subroutines

; Have includes here
; Sub Routines
%include "bpb.asm"						; A copy of the BIOS Parameter Block (i.e. information about the disk format)
%include "floppy16.asm"					; Routines to access the floppy disk drive
%include "fat12.asm"					; Routines to handle the FAT12 file system
%include "functions_16.asm"
;%include "userinput.asm"
%include "a20.asm"
%include "messages.asm"

; This is the real mode address where we will initially load the kernel
%define	KERNEL_RMODE_SEG		1000h
%define KERNEL_RMODE_OFFSET		0000h

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

	mov		cx, 1   					; Read 1 Sector
	mov		ax, 1						; Read Sector 1
	mov		bx, 0D000h					; Load Sector Data in to Address
	call 	ReadSectors
	cmp		di, 0						; Check if Sector Read Failed
	je		SectorCannotBeReadErr

	mov		dl, byte[0D000h]

	call	Write_Value_Of_BX_Hex

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
	
val_to_print: 			  db 0

; Pad out the boot stage 2 so that it will be exactly 3584 (7 * 512) bytes
	times 3584 - ($ - $$) db 0


; Example C version of user input
; The am/pm example from class.
; Demonstrates:
;       string input via BIOS
;       basic use of subroutines
;       branches
;
; Algorithm:
;       int main(void)
;       {
;           char prompt[] = "am or pm? ";
;           char am[] = "Good morning!\n";
;           char pm[] = "Good afternoon!\n";
;           char answer[20];
;
;           printf(prompt);
;           scanf("%20s", answer);
;           if (answer[0] == 'a')
;               printf(am);
;           else
;               printf(pm);
;           return 0;
;       }
;
; Assemble as:
;   nasm  -f bin  -o ampm.com  ampmExample.asm
;
; 2005-10-25

