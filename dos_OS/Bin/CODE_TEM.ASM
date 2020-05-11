.model tiny
.code

org 100h

include mymacro.asm

Start:

x equ 40
y equ 15 

Symb equ 'Y'

call start_prog

X0 equ 20d
Y0 equ 5d
X1 equ 60d
Y1 equ 15d

COMMENT^
mov bx, (X0 shl 8) or Y0
mov dx, (X1 shl 8) or Y1


call draw_window

mov di, offset str2
mov al, 'o'
mov bx, 10
memchr

mov al, '#'
xor cx, cx
inc cx
mov di, offset str2
add di, bx
memset

mov si, offset str2
mov di, offset str3

mov cx, 14d
memcmp

ja K

mov ah, 09h
mov dx, offset str2
int 21h
K:

mov al, 'i'
mov di, offset str2
strchr

mov ah, '-'
mov di, offset str1
strrchr

mov si, offset str2
mov di, offset str1
strcpy
^
mov si, offset str1
mov di, offset str4
strstr

mov ah, 09h
mov dx, SI
int 21h

call finish_prog

include mylib.asm

.data

str1 db "Meow-meow. I am a ",	endl
str2 db "Second string3",	endl
str3 db "Second string2", 	endl
str4 db "meow", 		end_schr

TheEnd:	end Start