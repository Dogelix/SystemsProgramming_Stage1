boot_2_wait_for_key:		db	'Enter key to continue...', 0

kernel_err:                 db  'Unable to load kernel', 0

sector_failed_to_read:      db  'Unable to Read Sector Error', 0

generic_err:                db  'Error', 0

a20_start_message:		    db	'A20 Checks Start', 0

sector_read_prompt:         db 'What sector would you like to read?: ', 0


; A20 Debug message array 
a20_debug_msgs: 		    dw a20_fail_message, a20_1_message, a20_2_message, a20_3_message, a20_4_message

a20_fail_message:		    db	'A20 ERRO', 0
a20_1_message:			    db	'A20 DFLT', 0
a20_2_message:			    db	'A20 BIOS', 0
a20_3_message:			    db	'A20 KeCn', 0
a20_4_message:			    db	'A20 FA20', 0