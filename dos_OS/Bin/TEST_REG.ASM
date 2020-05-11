.model tiny
.code

org 100h

Start:

call start_prog

X0_ equ 30d
Y0_ equ 9d
 
mov bh, X0_
mov bl, Y0_
call scan_reg

mov bh, X0_
mov bl, Y0_ + 6
call scan_reg

comment @
; Intercept the keyboard

cli
xor ax, ax
mov es, ax
mov bx, 9 * 4

mov ax,	word ptr es:[bx]
mov word ptr [old09], ax
mov ax, word ptr es:[bx + 2]
mov word ptr [old09 + 2], ax

mov ax, cs

mov word ptr es:[bx], offset New09
mov word ptr es:[bx + 2], ax
sti

; Intercept the timer
cli
mov bx, 8 * 4

mov ax, word ptr es:[bx]
mov word ptr [old08], ax
mov ax, word ptr es:[bx + 2]
mov word ptr [old08 + 2], ax

mov ax, cs

mov word ptr es:[bx], offset New08
mov word ptr es:[bx + 2], ax
sti

;call finish_prog

;call resident_finish_prog

mov ah, 31h
mov dx, offset TheEnd
shr dx, 4
inc dx
int 21h
@
call finish_prog

; size: 11x6
quant_regs equ (offset sc_quant_reg_end - offset sc_quant_reg_begin) / 2
scan_reg:
	push dx cx bx ax ; Save for watching value of registers
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
breg_name db "AX", "BX", "CX", "DX"
sc_quant_reg_end   db ?

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

; Draw in ES:[DI]
; Input: BL
; Destr: AX, BX
draw_BYTE_:
	call myB2H
	
	mov al, bh
	stosw
	mov al, bl
	stosw
		
	ret

; Input: bl
; Destroy: bx
; Return:  (H, L) -> (BH, BL)
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

; Input al: 0000NUMBb
; Destr: AL

myBh2H:			; Byte helf to HEX
	add bl, '0'

	cmp bl, 10d + '0'
	jb myBh2H_end	
	add bl, 'A' - '0' - 10d

myBh2H_end:
	ret

New08	proc
	push ax di es

	mov di, 0b800h 	
	mov es, di
	mov di, (10 * 80 + 41) * 2
	
	;mov al, 'A'
	;mov ah, 4eh
	
	mov al, dl
	mov ah, 4fh
			
	stosw
	
	mov al, 20h
	out 20h, al
	
	pop es di ax
	
	iret
	endp
	
;	db 0eah
	old08 dd 0
	
;	iret
;	endp

New09 	proc
	push ax di es
	;pushf

	mov di, 0b800h
	mov es, di
	mov di, (10 * 80 + 39) * 2
	
	in al, 60h
	mov ah, 4eh
	
	stosw
	
	in al, 61h
	mov ah, al
	or al, 80h	; 1000 0000b
	out 61h, al
	xchg ah, al
	out 61h, al
	
	mov al, 20h
	out 20h, al
	
	;popf
	pop es di ax

      	db 0eah
	old09 dd 0
	      
	iret
	endp

include mylib.asm
TheEnd: end Start