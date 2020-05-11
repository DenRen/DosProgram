.model tiny
.code

org 100h

Start: 
W equ 80
H equ 25

call start_prog

mov bx, 0b800h
mov es, bx
mov bx, 0

set_font equ mov dl, 219
set_color equ mov dh, 00001011b

mov ah, 26
mov al, 24

mov bh, 36
mov bl, 25

set_font
set_color
call line 

mov ah, 20
mov al, 18

mov bh, 30
mov bl, 23

set_font
set_color
call line

mov ah, 20	; X0 
mov al, 7	; Y0

mov bh, 50	; X1
mov bl, 23	; Y1

set_font
set_color
call line 

mov ah, 20
mov al, 14

mov bh, 21
mov bl, 23

set_font
set_color
call line

mov ah, 20
mov al, 7

mov bh, 21
mov bl, 18

set_font
set_color
call line

call finish_prog


line:
	push cx
	call normal_vector
	
	push dx	

	mov dx, ax
	mov ah, W
	mul ah
	mov ch, dl
	xchg dl, dh
	mov dh, 0
	add ax, dx	
	shl ax, 1; AX == b0

	mov dh, cl
	xchg ax, cx
	mov al,  bl
	inc al
	sub al, ah	; delta y
	mov ah, 0
	inc bh
	sub bh, dl      ; delta x
	div bh		; tg	
	
	shl ah, 1
	cmp ah, bh
	jb not_correct 
	inc al		; Correcting tg
	
	not_correct:
	
	dec bh
	cmp dh, 1
	xchg cx, bx
	pop dx

	je _inc_gamma

_dec_gamma:
    dec ch
	
	mov ah, al
	mov word ptr es:[bx], dx
		
	cmp al, 0	; Проверка на нуль tg
	je _dec_tg_zero
	
	_for_tg_dec:
		add bx, W*2
		dec ah
		
		mov word ptr es:[bx], dx
			
		cmp ah, 0
		jne _for_tg_dec	
			
_dec_tg_zero:
	sub bx, 2
	cmp ch, 0	
	jnz _dec_gamma
	
	jmp short _end_line 
    
	
	
_inc_gamma:		; increment
    dec ch
    
    mov ah, al
    mov word ptr es:[bx], dx
        
    cmp al, 0	; Проверка на нуль tg
    je _inc_tg_zero
    
    _for_tg_inc:
        add bx, W*2
        dec ah
        
        mov word ptr es:[bx], dx
            
        cmp ah, 0
        jne _for_tg_inc	
            
_inc_tg_zero:
    add bx, 2
    cmp ch, 0	
    jnz _inc_gamma
    
    jmp short _end_line 
	                            
_end_line:
    pop cx
    ret

normal_vector:
	cmp bh, ah
	JGE _type1
	
	cmp bl, al
	JGE _antidiag
	xchg ax, bx	 	
	jmp short _diag

	_type1:
		cmp bl, al
		JGE _diag
		xchg ax, bx
		jmp short _antidiag

	_diag:
		mov cx,  1	; gamma ==  1
		ret

	_antidiag:
		mov cx, -1	; gamma == -1
		ret	
	
	



;Рисует точку по координатам 	h l		h	  l
point:			; bx = (X,Y), dx = (BackGround, Symbol)
	inc bh
	mov al, bl
	mov bl, W
	mul bl
	mov bl, 0
	xchg bl, bh
	add bx, ax
	shl BX, 1	; Теперь в AX лежит адрес в видеопамять		
	
	mov word ptr es:[bx], dx
	ret

endl 	equ 13, 10, '$'

start_prog:
	mov ah, 09h
	mov dx, offset str_start_prog
	int 21h	
	mov ax, 0
	mov dx, ax
	ret

finish_prog:
	mov ah, 09h
	mov dx, offset str_finish_prog
	int 21h
	mov ah, 4Ch
	int 21h
	ret

.data

;S SEGMENT STACK
;	DB 128 dup(?)
;S ENDS

str_start_prog:  db 'Program started.', 	endl
str_finish_prog: db 'Program finished.',	endl
end Start
