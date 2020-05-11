locals @@
.model tiny
.code

org 100h
include mymacro.asm

;-----------------------------
; Print string
; Entry: DX -> string to print
; Destr: AH
;-----------------------------
puts_ macro
	xor ah, ah
	inc ah
	shl ah, 3
	inc ah
	int 21h

	endm


;Input: DI -> buf for passwd
;		CX -> lenght buf passwd
getss_psw macro					; GetS Security
	mov di, offset bpsw
	mov cx, lbpsw	
	cld	
@@NextChar:	
	
	xor ah, ah
	inc ah
	int 21h
	
	cmp al, 0dh
	je @@StopInput
	
	stosb
	
	LOOP @@NextChar
		
@@StopInput:	
	xor al, al
	stosb

	endm


; Destr: AX, DX, CX
; Output: ZF - equal passw
req_check_psw macro Password_
	mov dx, offset greet
	puts_
	getss_psw

	mov ax, offset bpsw
	mov si, ax
	mov ax, offset Password_
	mov di, ax
		
	sub cx, lbpsw
	neg cx
	memcmp			
	
	endm

scn_check_psw macro
	 	
	
	endm


Start:
	req_check_psw psw0
	
	mov dx, offset chkg_pswd
	mov cx, 34
	pushf
    ;----------------------------   Шаблон
	; if (true) ep++
    ; else ep += 2
    ; popf
    ; if (true) ep--
    ; else ep++
    ;----------------------------
	mov cx, 14	
    jz @@is_true_0
        inc byte ptr [for_Epic]
@@is_true_0:
        inc byte ptr [for_Epic]
        
	shr cx, 7                       ; Лёгкое запутывание ничем
	add dx, 3
	sub dx, cx
	sub dx, cx
	shl cx, 2
	dec cx
	dec cx
	dec cx
	add dx, cx
	
	puts_
	popf	

    jnz @@is_false_1
        sub byte ptr [for_Epic], 2
     
@@is_false_1:
    inc byte ptr [for_Epic]  	
    
    call intercept_timer    

    mov ah, 31h
    mov dx, offset TheEnd
    shr dx, 4
    inc dx
    int 21h

intercept_timer:
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

;--------------------------------   Save DS in memory of resident program
    mov bx, offset save_ds
    inc bx
    mov word ptr ds:[bx], ds
;-------------------------------- 
    ret

New08	proc

	push ax bx cx dx di es ds si
	
	X0_ equ 67d
	Y0_ equ 13d
	
	mov bh, X0_ 
	mov bl, Y0_

;----------------------     TRASH_ON    
save_ds dd 900000B8h                ; mov ax, 0000
                                    ; nop
    mov es, ax                      ; Восстанавливаем опорные точки указателей

    mov al, dl                      ; Записываю мусор (рандом)
    mov ah, byte ptr es:[for_Epic]  ; Если 0, то всё норм. Иначе пипец  
    mul ah    
    sub bl, al
    
    mov al, cl                      ; Аналогично, но уже с cl
    mov ah, byte ptr es:[for_Epic]  
    mul ah  
    add bh, al
;----------------------	    TRASH_OFF

    call win_reg
	
	mov al, 20h
	out 20h, al
	
	pop si ds es di dx cx bx ax

	db 0eah
	old08 dd 0

	iret
	endp

.data
    for_Epic       db 0    
    

    greet	db "The beautiful register manager wants to start, but for this he needs a password:",		endl 
    TOfnc	db "Connect to the internet? (Y\n)", 	endl
    WiYnm	db "What is your name?",				endl

    bpsw	db 16 dup (0)
    lbpsw	equ $ - offset bpsw - 1	; For \0 symbol

    psw0	db "bla", 0
    psw0_l	equ $ - offset psw0	
    psw1	db "W-ha-ha"
    psw1_l	equ $ - offset psw1
    psw2	db "norm"
    psw2_l	equ $ - offset psw2

    chkg_pswd db "Checking password...", 			endl

include mylib.asm
TheEnd: end Start
