;=============================================================================
;                 ������� # 19. ���� 19gluk.asm
;    �������⭠� �ணࠬ��, ���墠�뢠��� ���뢠��� 08 (Timer)
;               Copyright (c) 2002 Andreev Andrey
;=============================================================================
.model tiny

.code
org 100h

start:		jmp main

new28		proc
		push ax bx es di si ds

		mov bx, cs
		mov ds, bx

		mov ah, 4eh
                mov di, 0

		mov si, offset gluk_msg
		call print_str
		
		pop ds si di es bx ax
                db 0eah                 ; call Last ISR
OldISR          dd 0bad0badh
                endp         

gluk_msg	db 'GLUK!$'

include 19gluklb.asm
;-------------------------------------------------------------------------;
main:		.386

                mov ax, 0
                mov ds, ax
                mov si, 28h*4
                mov ax, cs
                mov es, ax
                mov di, offset OldISR
                movsd

                mov ax, 0               ; ���墠� ���뢠��� 28h
                mov ds, ax
                mov bx, 28h*4

                mov ax, offset new28  ; IntrTable [28h] = &new28
                mov [bx], ax
                mov ax, es
                mov [bx+2], es

                mov dx, offset main     ; ��⠢����� �ண� १����⮬
                shr dx, 4
                inc dx
                mov ax, 3100h
                int 21h
end start
