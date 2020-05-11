video_com equ 0b800h

W equ 80d
H equ 25d

CR 	equ 13
LF	equ 10
CRLF 	equ CR, LF
endl 	equ CRLF, '$'

;___________________________ 
; Draws a rectangular window
; along the coordinates of
; diagonal vertices.
;--------------------ÚÄÄÄÄÄ¿
; BX = (X0, Y0)	     ³Input³
; DX = (X1, Y1)      ÀÄÄÄÄÄÙ
;------------------ÚÄÄÄÄÄÄÄ¿
; AX BX CX DX	   ³Destroy³
; ES DI	  	   ÀÄÄÄÄÄÄÄÙ
;___________________________
draw_window:
	BackGround 	equ 00001100b
	Horiz		equ 'Í'
	Vertical	equ 'º'
	Upp_Right	equ '»'
	Upp_Left	equ 'É'
	Low_Left	equ 'È'
	Low_Right	equ '¼'
	Empty_BG	equ ' '
	
	mov ax, video_com
	mov es, ax	
	
	xor ah, ah
	mov al, W
	mul bl
	xor cx, cx
	mov cl, bh
	add ax, cx
	shl ax, 1	
	mov di, ax	; The DI is the begining of the window
	
	cld
	
	xor ch, ch
	mov cl, dh
	xor ax, ax
	mov al, bh
	sub cx, ax	
	dec cx		; CX = delta x
	
	mov bh, dl
	sub bh, bl 
	shr bx, 8	
	dec bl		; BL = delta y
	mov bh, cl	; BH = delta x

	; Draw upper line
	mov ax, (BackGround shl 8) or Upp_Left
	stosw
	
	xor cx, cx
	mov cl, bh	
	mov ax, (BackGround shl 8) or Horiz
	rep stosw	
	
	mov ax, (BackGround shl 8) or Upp_Right
	stosw
	
	; Draw the middle lines (CX == 0)
	xor dx,dx

	mov dl, bl	; DL = delta y
L:	add di, W*2
	mov cl, bh
	shl cx, 1
	sub di, cx
	sub di, 4

	mov ax, (BackGround shl 8) or Vertical
	stosw
	mov ax, (BackGround shl 8) or Empty_BG
	mov cl, bh 
	rep stosw
	mov ax, (BackGround shl 8) or Vertical
	stosw
	
	dec dl
	jnz L
	
	add di, W*2
	mov cl, bh
	shl cx, 1
	sub di, cx
	sub di, 4
	
; Draw bottom line
	mov ax, (BackGround shl 8) or Low_Left
	stosw
	
	xor cx, cx
	mov cl, bh	
	mov ax, (BackGround shl 8) or Horiz
	rep stosw	
	
	mov ax, (BackGround shl 8) or Low_Right
	stosw    
    	
	ret

start_prog:
	mov ah, 09h
	mov dx, offset msg_start_prog
	int 21h
	ret

finish_prog:
	mov ah, 09h
	mov dx, offset msg_finish_prog
	int 21h
	
	mov ax, 4C00h
	int 21h 
	ret

comment ^
resident_finish_prog:
	mov ah, 31h
	mov dx, offset TheEnd
	shr dx, 4
	inc dx
	int 21h

	ret
^

msg_start_prog 	db 'Program started...', 	endl 
msg_finish_prog db 'Program finished.', 	endl

;___________________________
;   This function takes a 
; location upper left corner
; in BX -> (X0, Y0) and 
; draws a window of reg. and
; their values.
;   The size of the window
; depends on the number of
; entered registers in the
; function itself. There are
; tags with the name 
; "SAVE_REG". 
;   If you want to enable
; colon blinking, then 
; uncomment "Enable colob
; blinking".
;___________________________ 
; 
;--------------------ÚÄÄÄÄÄ¿
; BX 		     ³Input³
;		     ÀÄÄÄÄÄÙ
;-------------------ÚÄÄÄÄÄÄ¿
; ES:[DI]	    ³Output³
;   	    	    ÀÄÄÄÄÄÄÙ
;------------------ÚÄÄÄÄÄÄÄ¿
; AL BX DX CX      ³Destroy³
; ES DI	DS SI 	   ÀÄÄÄÄÄÄÄÙ
;___________________________
quant_regs equ (offset sc_quant_reg_end - offset sc_quant_reg_begin) / 2
win_reg:
	push si dx cx bx ax ; {SAVE_REG (1/2)} 
			 ; Save for watching value of registers
	push bx	 	 ; Save (X0, Y0)

	mov dh, bh
	add dh, 12
	mov dl, bl
	add dl, quant_regs + 1
	
	call draw_window ; (es == 0b800h)
	
	mov cx, quant_regs
	
	pop bx		 ; Begin location
	xor ax, ax
	mov al, bl
	inc al
	mov ah, 80d
	mul ah

	mov bl, bh
	xor bh, bh
	add ax, bx	
	inc ax
	inc ax
	shl ax, 1	
	mov di, ax	 ; DI = ((Y0 + 1) * 80 + X0 + 2) * 2
	
	push ax		 ; Save DI

;----------------------------------------
; Draw names of registers
;----------------------------------------	
	mov ax, cs
	mov ds, ax
	mov si, offset breg_name
	
	mov ah, 00001111b
	mov bl, ':'
sc_reg_L:
	;mov ah, 00001111b	; Enable colob blinking (1/2)
	lodsb
	stosw
	lodsb
	stosw
	
	;mov ah, 10001111b	; Enable colob blinking (2/2)
	mov al, bl		; AL = ':'	 
	stosw
	add di, 77 * 2
	
	LOOP sc_reg_L

;----------------------------------------
; Draw value registrs
;----------------------------------------
	mov cx, quant_regs
		
	pop bx		; Load from stack begin location
	add bx, 4 * 2	; Correcting value
	mov di, bx
		
	mov ah, 00001111b
	
sc_reg_R:		
	pop dx
		
	call draw_REG_		
	add di, (80 - 5) * 2
	
	LOOP sc_reg_R	

	ret

sc_quant_reg_begin db ?
breg_name db "AX", "BX", "CX", "DX", "SI"	; {SAVE_REG (2/2)}
sc_quant_reg_end   db ?

;___________________________ 
;   This function takes a 
; double byte in DX. It 
; value printed in ES:[DI]
; in HEX format
; Their backgrounds 
; defined AH
;--------------------ÚÄÄÄÄÄ¿
; DX, AH, ES, DI     ³Input³
;		     ÀÄÄÄÄÄÙ
;-------------------ÚÄÄÄÄÄÄ¿
; word in ES:[DI]   ³Output³
; 	  	    ÀÄÄÄÄÄÄÙ
;------------------ÚÄÄÄÄÄÄÄ¿
; AL, BX	   ³Destroy³
; 	  	   ÀÄÄÄÄÄÄÄÙ
;___________________________
; Input 	DX
; Destroy	AL, BX
draw_REG_:
	mov bl, dh
	call draw_BYTE_
	mov al, ' '
	stosw
	mov bl, dl
	call draw_BYTE_
	ret
;___________________________ 
;   This function takes a
; byte in BL and writes in
; HEX form in ES:[DI]
; It background defined AH
;--------------------ÚÄÄÄÄÄ¿
; BL, AH, ES, DI     ³Input³
;		     ÀÄÄÄÄÄÙ
;-------------------ÚÄÄÄÄÄÄ¿
; byte in ES:[DI]   ³Output³
; 	  	    ÀÄÄÄÄÄÄÙ
;------------------ÚÄÄÄÄÄÄÄ¿
; AX BX		   ³Destroy³
; 	  	   ÀÄÄÄÄÄÄÄÙ
;___________________________
draw_BYTE_:
	call myB2H
	
	mov al, bh
	stosw
	mov al, bl
	stosw
		
	ret
;___________________________ 
;   This function takes a
; byte in BL and converting
; his in HEX format in BX.
; 
;    BL:          BX:
; (BLH, BLL) -> (BH, BL) 
;
; Example:
; 	mov bl, 4Ah;
; 	call myB2H
;
; 	BX == ('4', 'A')
;--------------------ÚÄÄÄÄÄ¿
; BL		     ³Input³
;		     ÀÄÄÄÄÄÙ
;-------------------ÚÄÄÄÄÄÄ¿
; BX 		    ³Output³
; 	  	    ÀÄÄÄÄÄÄÙ
;------------------ÚÄÄÄÄÄÄÄ¿
; BX 		   ³Destroy³
; 	  	   ÀÄÄÄÄÄÄÄÙ
;___________________________
myB2H:
	mov bh, bl
	
	shl bl, 4
	shr bl, 4
	
	shr bh, 4

	call myBh2H
	xchg bl, bh	; BH - L
 	
	call myBh2H	; BL - H
		
	xchg bl, bh	; Norm	
	ret

;___________________________ 
;   This function takes a
; number from 0 to 15 in AL
;
; Fromat:   al: 0000NUMBb
;
; Returned in HEX format
; this number in ax (ASCII) 
;--------------------ÚÄÄÄÄÄ¿
; BL		     ³Input³
;		     ÀÄÄÄÄÄÙ
;-------------------ÚÄÄÄÄÄÄ¿
; BL 		    ³Output³
; 	  	    ÀÄÄÄÄÄÄÙ
;------------------ÚÄÄÄÄÄÄÄ¿
; BL 		   ³Destroy³
; 	  	   ÀÄÄÄÄÄÄÄÙ
;___________________________
; Input al: 0000NUMBb


myBh2H:			            ; Byte helf to HEX
	add bl, '0'

	cmp bl, 10d + '0'
	jb myBh2H_end	
	add bl, 'A' - '0' - 10d

myBh2H_end:
	ret