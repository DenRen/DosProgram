;==========================================================
;
; BUF_OVF.ASM (c) Ded, 2010
; Demonstates buffer overflow problem.
;
; NB: File code page is 866.
;
;==========================================================
;$                                ; A very important dollar

locals @@

.model tiny
.code
org 100h

;--------------------------------------------

Start:		
		nop
		nop
		nop
		mov dx, offset __bss ; Just for fun
		call PutS
		
		call Main
		
		mov dx, offset CrLfMsg
		call PutS

		call Exit
		nop
		nop
		nop
;--------------------------------------------

PromptMsg 	db  0dh, 0ah, 'Enter Admin password:  $'
CheckingMsg 	db  0dh, 0ah, 'Checking the password: $'
CheckFailedMsg 	db  0dh, 0ah, 'Password check failed! $'
AdminRightsMsg  db  0dh, 0ah, 'You got Admin rights.  $'
CrLfMsg		db  0dh, 0ah, '$'

AdminPwd	db 'GOD'
AdminPwdLen	equ $ - AdminPwd

;--------------------------------------------

Main		proc

		mov dx, offset PromptMsg
		call PutS

                mov di, offset Password
                push di
		call GetS
		pop di               ; We ignore password length (very bad!)

		mov dx, offset CheckingMsg
		call PutS
                mov dx, di
		call PutS
		mov dx, offset CrLfMsg
		call PutS

		mov si, offset AdminPwd
		mov cx, AdminPwdLen
		cld                  ; si++ and di++ (see below)
		repe cmpsb           ; while (cx-- && ds:[si++] == es:[di++]) ;
                jmp @@Check

;               ³
;               ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;-----                                                                      ³
Password        db 10 dup ('$')      ; Placing buffer here is dangerous!    ³
                                     ; But we've decided to do so...        ³
;-----                                                                      ³
;               ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
;               ³ 
;               ³ This code starts IMMEDIATELY after buffer end:
;               V
                                                                            
@@Check:        je @@PasswordOK      ; 75h ('u') --> jne
		                     ; So, '1234567890u' will crack us.

		mov dx, offset CheckFailedMsg
		call PutS
		ret

@@PasswordOK:	mov dx, offset AdminRightsMsg
		call PutS
		ret

		endp

		db '$'

;--------------------------------------------
; Exit to OS
; Entry: none
; Destr: n/a
;--------------------------------------------

Exit		proc
		mov ax, 4c00h
		int 21h
		ret
		endp

;--------------------------------------------
; Print a string
; Entry: DX -> string to print
; Destr: AH
;--------------------------------------------

PutS		proc
		mov ah, 09h
		int 21h
		ret
		endp

;--------------------------------------------
; Get a string
; Entry: DI --  string addr
; Exit:  DI --> end of string 
; Destr: AX DI
;--------------------------------------------

GetS		proc

		push dx
		cld                  ; inc di (see below)

@@NextChar:	mov ah, 01h
		int 21h

		cmp al, 0dh
		je @@StopInput

		stosb                ; { es:[di] = al; inc di; }
		jmp @@NextChar

@@StopInput:	pop dx

		ret
		endp

;--------------------------------------------

                db 0dh, 0ah          ; Just to visually divide binary code
                                     ; from ASM text appended.

__bss:          db '!$'              ; copy/b BUF_OVF.COM + BUF.OVF.ASM
                                     ; and change these bytes to 0dh, 0ah, for example
                                     
end		Start		

