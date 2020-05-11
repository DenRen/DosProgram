end_schr equ '$'

;___________________________ 
;    This macro find for the
; first occurrence of the
; string DS:[SI] in the 
; string ES:[DI].
; SI - "__________________"
; DI - "___"
;--------------------ÚÄÄÄÄÄ¿
; AL, CX, ES, DI     ³Input³
;		     ÀÄÄÄÄÄÙ
;------------------ÚÄÄÄÄÄÄÄ¿
; CX => 0, DI  	   ³Destroy³
; 	  	   ÀÄÄÄÄÄÄÄÙ
;___________________________
strstr macro
	mov al, end_schr
	mov dx, di

	memstrlen
	mov bx, di		; bx - length of DI
	inc bx	
	cld
L_ss:	mov cx, bx
	mov di, dx

	repe cmpsb
	dec di
	scasb 
	
	jne L_ss
	
	sub si, bx
	endm
;___________________________ 
; 
;--------------------ÚÄÄÄÄÄ¿
; AL, CX, ES, DI     ³Input³
;		     ÀÄÄÄÄÄÙ
;------------------ÚÄÄÄÄÄÄÄ¿
; CX => 0, DI  	   ³Destroy³
; 	  	   ÀÄÄÄÄÄÄÄÙ
;___________________________
strcpy macro
	mov al, end_schr
L_scpy: cmp byte ptr ds:[si], al
	movsb
	jne L_scpy
	endm

;___________________________ 
;   This macro searches for
; the position of the AH
; characterint from the end 
; DS:SIof the line line. The 
; position is counted from 
; zero. The result is 
; recorded in BX.
;--------------------ÚÄÄÄÄÄ¿
; AL, CX, ES, DI     ³Input³
;		     ÀÄÄÄÄÄÙ
;------------------ÚÄÄÄÄÄÄÄ¿
; CX => 0, DI  	   ³Destroy³
; 	  	   ÀÄÄÄÄÄÄÄÙ
;___________________________
strrchr macro
	cld
	mov al, end_schr
	xor cx, cx
	dec cx
	repne scasb
	dec di		; DI - end string
	
	xor bx, bx
	dec bx
	sub bx, cx
	mov cx, bx
	
	mov al, ah
	std
	repne scasb
	inc di
	mov bx, di	; Result  	
	
	endm
;___________________________ 
;   This macro searches for
; the position of the AH
; characterint the DS:SI
; line. The position is
; counted from zero. The
; result is recorded in BX.
;--------------------ÚÄÄÄÄÄ¿
; AH, DS, SI	     ³Input³
;		     ÀÄÄÄÄÄÙ
;------------------ÚÄÄÄÄÄÄÄ¿
; AL CX DI BX DX   ³Destroy³
; 	  	   ÀÄÄÄÄÄÄÄÙ
;___________________________

strchr macro
	xor cx, cx
	dec cx
	xor bx, bx
	mov bl, end_schr
	mov dx, di
	cld
L_schr:
	lodsb
	cmp al, ah
	je short fin_schr 
	cmp al, bl
	LOOPNE L_schr
fin_schr:
	xor bx, bx
	dec bx
	sub bx, cx	
	add bx, dx; Result	
	endm
;___________________________ 
; DANGEROUS!
; Result DI
;--------------------ÚÄÄÄÄÄ¿
; ES:DI		     ³Input³
;		     ÀÄÄÄÄÄÙ
;------------------ÚÄÄÄÄÄÄÄ¿
; AX, CX, DI  	   ³Destroy³
; 	  	   ÀÄÄÄÄÄÄÄÙ
;___________________________
memstrlen macro
	cld
	mov al, end_schr
	xor cx, cx
	dec cx
	repnz scasb
	xor di, di
	sub di, cx
	dec di
	dec di
	endm
;___________________________ 
;  This macro compares th
; DS:SI string with the
; ES:DI string. 
;  The result if flagged.
;--------------------ÚÄÄÄÄÄ¿
; CX - quantity symb.³Input³
; DS:SI - 1st	     ÀÄÄÄÄÄÙ
; ES:DI - 2nd
; Result: ZF
;------------------ÚÄÄÄÄÄÄÄ¿
; CX, DI 	   ³Destroy³
; 	  	   ÀÄÄÄÄÄÄÄÙ
;___________________________
memcmp macro
	cld
	repz cmpsb
	endm
;___________________________ 
;  This macro searches for
; the number of the first
; occurrence of the symbol
; AL at the addres ES:DI
; The length of the incoming
; array is in BX.
;  The final address is 
; recorded in the BX,
; relative to the 
; starting ES:DI
;----------------------ÚÄÄÄÄÄ¿
; AL - serched symb.   ³Input³
; CX - length array    ÀÄÄÄÄÄÙ
; ES:DI - pointer to a string
;--------------------ÚÄÄÄÄÄÄÄ¿
; CX, BX, DI  	     ³Destroy³
; 	  	     ÀÄÄÄÄÄÄÄÙ
;___________________________
memchr macro
	cld
	repne scasb
	sub bx, cx
	dec bx
	endm
;___________________________ 
; 
;--------------------ÚÄÄÄÄÄ¿
; DS, DI, ES, SI     ³Input³
;		     ÀÄÄÄÄÄÙ
;------------------ÚÄÄÄÄÄÄÄ¿
; CX => 0, DI  	   ³Destroy³
; 	  	   ÀÄÄÄÄÄÄÄÙ
;___________________________
memcpy macro
	cld
	rep movsb
	endm


;___________________________ 
; 
;--------------------ÚÄÄÄÄÄ¿
; AL, CX, ES, DI     ³Input³
;		     ÀÄÄÄÄÄÙ
;------------------ÚÄÄÄÄÄÄÄ¿
; CX => 0, DI  	   ³Destroy³
; 	  	   ÀÄÄÄÄÄÄÄÙ
;___________________________

memset macro
	cld
	rep stosb
	endm


