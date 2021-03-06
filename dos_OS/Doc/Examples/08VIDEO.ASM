;-----------------------------------------------------------------------------
;                  ������� # 8. ���� 08video.asm
;        ����� ����� ���⮩ �஡����� ��אַ㣮�쮩 ���
;                (c) 2001 Copyleft  Andreev Andrey
;-----------------------------------------------------------------------------

.model tiny

;-----------------------------------------------------------------------------
; ���ᠭ�� ����⠭�

videoseg        = 0b800h
probel          = 0e00h         ; ᨬ���, ����� ���������� ��אַ㣮�쭨�
string_color    = 0eh

left_up         = 0ec9h         ; �             ᨬ���� ࠬ��          -->
hor_line        = 0ecdh         ; �
right_up        = 0ebbh         ; �
ver_line        = 0ebah         ; �
right_down      = 0ebch         ; �
left_down       = 0ec8h         ; �             ᨬ���� ࠬ��          <--

x1              = 10            ; ࠧ���� ��אַ㣮�쭨�� -->
x2              = 70
y1              = 5
y2              = 10            ; ࠧ���� ��אַ㣮�쭨�� <--

;-----------------------------------------------------------------------------
.code
org 100h

start:

; �����⮢�� � ������� ��אַ㣮�쭨�� �஡���묨 ᨬ������

                mov ax, videoseg
                mov es, ax
                mov ax, probel
                mov di, (y1 * 80 + x1) * 2
                mov cx, x2 - x1         ; Window width
                mov si, 0000h           ; si -> bx. if si = bx, exit
                mov bx, y2 - y1         ; Window height

;������� ��אַ㣮�쭨�� �஡����� (��� 横��)

x1_to_x2:       stosw                   ; mov es:[di], ax  /  inc di
                loop x1_to_x2

y1_to_y2:       add di, (80d - (x2 - x1)) * 2
                inc si
                mov cx, x2 - x1
                cmp si, bx
                jne x1_to_x2

; ��ᮢ���� ࠬ�� ����� ࠭�� ���ᮢ������ ��אַ㣮�쭨��

                mov di, (y1 * 80 + x1 - 81) * 2
                mov ax, left_up
                stosw                   ; ��⠢�� ���孥�� ������ 㣫� ࠬ��

                mov ax, hor_line        ; �ᮢ���� ���孥� ����� ࠬ��
                mov cx, x2 - x1
                rep stosw

                mov ax, right_up
                stosw                   ; �ᮢ���� ���孥�� �ࠢ��� 㣫� ࠬ��

                                        ; �ᮢ���� ���⨪����� ����� ࠬ��
                mov di, (y1 * 80 + x1 - 1) * 2
                mov ax, ver_line
                mov si, 1d              ; ���稪 �� ����

right_ver:      mov cx, y2 - y1            ; <-------------+
                                           ;               |
vertical:       stosw                      ; <--+          |
                add di, 79d * 2            ;    | 横� 1   |
                loop vertical              ; <--+          |
                                           ;               | 横� 2
                mov di, (y1 * 80 + x2) * 2 ;               |
                add si, 1d                 ;               |
                cmp si, 2d                 ;               |
                je  right_ver              ; <-------------+

                mov ax, left_down       ; �ᮢ���� ������� ������ 㣫� ࠬ��
                mov di, (y2 * 80 + x1 - 1) * 2
                stosw

                mov ax, hor_line        ; �ᮢ���� ������ ��ਧ��⠫쭮� ࠬ��
                mov cx, x2 - x1
                rep stosw
                                        ; � ��᫥����!
                mov ax, right_down      ; �ᮢ���� ������� �ࠢ��� 㣫� ࠬ��
                stosw

; �뢮� ������

                mov di, (y1 * 80 + x1 + 2) * 2
                mov si, offset msg
                mov ah, string_color
again:          lodsb
                cmp al, '$'
                je done
                stosw
                jmp again

; ��室 �� �ணࠬ��

done:           mov ax, 4c00h
                int 21h

.data
msg             db '(c) 2001 Copyleft Andreev Andrey.$'

end start

;----------------------------------------------------------------------------
;                               �����...
;----------------------------------------------------------------------------