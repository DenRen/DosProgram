locals @@
.model tiny
.code

org 100h

;-----------------------------
; Print string
; Entry: DX -> string to print
; Destr: AH
;-----------------------------
putc macro
	xor ah, ah
    inc ah
    shl ah, 3
    inc ah
    int 21h

	endm

Start:
	
	buf_psw db 6 dup (90h)

	call start_prog
	
	call CheckPassw

	call finish_prog

CheckPassw proc
	mov ax, offset buf_psw 
	mov di, ax
	call GetC
	
	cld
	mov cx, size_psw
	
	mov ax, offset orig_psw
	mov si, ax
	mov ax, offset buf_psw
	mov di, ax

	repe cmpsb
	
	jnz @@EndCheck
	call PROG_REAL	
	

@@EndCheck:
	ret
	endp

PROG_REAL:
	
	mov dx, offset psw_correct
	putc
	
	ret

psw_correct db "Password correct!", 13, 10,'$'
orig_psw db "lol__"
size_psw equ $ - offset orig_psw	

GetC proc                 ; GetS Security
    cld
@@NextChar:

    xor ah, ah
    inc ah
    int 21h

    cmp al, 0dh
    je @@EndGetC

    stosb

    jmp short @@NextChar

@@EndGetC:
	
	ret
	endp
	
include mylib.asm
end Start
