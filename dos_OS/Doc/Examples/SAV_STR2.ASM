;*************************************************
; SAV_STR2.ASM     Version 2.0    12/19/90 10:53pm (c) Ded
;*************************************************
my_program segment                      ; ������� �ᯮ��塞��� ���� �ணࠬ��
assume cs: my_program, ds: my_program   ; CS, DS 㪠�뢠�� �� my_program
org 100h                                ; ��砫� �ᯮ��塞��� ���� � CS:100h
;-------------------------------------------------
	backsp    equ 8     		; ASCII ��� ���⭮�� ������
	end_line  equ 13                ; ASCII ��� ������ ���⪨
	KING_SIZE equ 20                ; ��� ࠧ���...
	BUF_SIZE  equ KING_SIZE         ; ������ ����
;=================================================
start:	                                ; ��砫� �ணࠬ��
	mov ah, 09h                     ; ���⠥� �ਣ��襭��
	lea dx, start_mess              ;
	int 21h                         ;
	lea bx, buffer                  ; � BX - ��砫� ����

next:	mov ah, 0                       ; ���뢠��� 16, �㭪�� 0 - �������
	int 16h                         ; ����⨥ ������ � ������ ��� � AL
	cmp al, backsp                  ; �����?
	je back                         ; �� - ��ࠡ��뢠��
	cmp al, end_line                ; ���; ������ ���⪨?
	je done                         ; �� - ��ࠡ��뢠��
					; ���; �����, ���� ᨬ���. 
	cmp bx, offset buffer + BUF_SIZE; �ॢ�襭� �� ����� ����?                            
					;
	jae beep                        ; �� - ��९�������. �室�� �� ���
	mov [bx], al                    ; ���; ��堥� ᨬ��� � ����
	inc bx                          ; �����稢��� ���������� ����� ����
	mov ah, 02h                     ; �뤠�� ᨬ��� �� ��࠭
	mov dl, al                      ;
	int 21h                         ;
	jmp next                        ; � ��稭��� ���� ᭮��.

back:                                   ; ����� ���⭠� ������!!!
	cmp bx, offset buffer           ; � �� ��室���� �� �� � ��砫� ����?
	je next                         ; �� - ��࠭�� ����������
	mov ah, 09h                     ; ��� - �뤠�� �� ��࠭ �������
	lea dx, clear                   ; ��᫥����⥫쭮���
	int 21h                         ;
	dec bx                          ; �����蠥� �����. ����� ����
	mov byte ptr [bx], '$'          ; �������� �㪢� � ����
	jmp next                        ; �� ᫥������ �㪢�

beep:	mov ah, 02h                     ; ��騬 � ������� ����
	mov dl, 7                       ;
	int 21h                         ;
	jmp next                        ; �� ᫥������ �㪢� 

done:                                   ; ����� ������ ���⪨.
	cmp bx, offset buffer           ; ���� �� ��-����� � ����?
	je noth                         ; ��� - �ᮡ� ��砩
	mov ah, 09h                     ; ���� �� ����: �뢮��� ᮮ�饭��,
	lea dx, message                 ;
	int 21h                         ;
	lea dx, buffer                  ; ���⠥� ᮤ�ন��� ����.
	int 21h                         ;
	jmp exit                        ; �����稢��� ࠡ���

noth:	mov ah, 09h                     ; ����� ��ப�. �뢮��� ᮮ⢥�-                             
					; ����饥 ᮮ�饭�� � ��騬 1 ᥪ.
	lea dx, mess_noth               ; ���� ��ப� ��� �뢮��                             
	int 21h                         ; ��ᨬ ��� �뢥�� ��ப�                             

exit:	mov ax, 4c00h             ; ��室�� �� �ணࠬ�� � ����� ��室� 0
	int 21h                   ; ��室��...

	buffer  db BUF_SIZE dup ('$'), '$'            ; ���� ��� �����.
	message db 13,10, 'You have typed:',13,10,'$' ; ����饭�� ��� �뢮��
						      ; �� ��࠭ ('$' - �ਧ���
	start_mess db 'Copyright (c) Ded, 1990. '     ; ���� (��...) ��ப�
		   db 'Welcome to MY input!', 13,10
		   db 'Type some letters and press ENTER.'
		   db 13,10, '$'
	mess_noth  db 'You typed nothing!', '$'
	clear      db 8, ' ', 8, '$'                  ; 
;==================================================
my_program ends                   ; ����� (��...) ᥣ����
;**************************************************
end start                         ; �ᯮ��塞� ��� ��稭����� � ��⪨ start