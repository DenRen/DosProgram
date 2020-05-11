.model tiny
.code

org 100h

Start:

call start_prog

; Intercept the timer

xor ax, ax
mov es, ax
mov bx, 8 * 4

cli
mov ax, word ptr es:[bx]
mov word ptr [old08], ax
mov ax, word ptr es:[bx + 2]
mov word ptr [old08 + 2], ax

mov ax, cs
mov word ptr es:[bx], offset New08
mov word ptr es:[bx + 2], ax
sti

mov ah, 31h
mov dx, offset TheEnd
shr dx, 4
inc dx
int 21h


New08	proc
	push ax

	mov ax, word ptr [int_time_new08]
	cmp ah, al  
	;jae no_pres_reg_scan_			; !!! Error. 
	xor al, al
	mov byte ptr [int_time_new08], al
	push bx cx dx di es ds si
	
	X0_ equ 67d
	Y0_ equ 15d
	
	mov bh, X0_
	mov bl, Y0_
	call win_reg
	
	mov al, 20h
	out 20h, al
	
	pop si ds es di dx cx bx
	
	jmp short no_pp
	
	iret
	endp
	
no_pres_reg_scan_:
	inc al
	mov byte ptr [int_time_new08], al		
no_pp:
	pop ax

	db 0eah
	old08 dd 0

	iret
	endp

int_time_new08 db 0, 0

include mylib.asm
TheEnd: end Start
