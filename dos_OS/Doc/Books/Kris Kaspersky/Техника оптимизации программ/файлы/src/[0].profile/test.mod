;	// �������� ����� ��� ��������� ������� ����������
;	// ��������� �������� ������ (��� � �� �����)
;	// ���������� ����� �������� ���, ����� ����������
;	// ��������  �����  ����������  �����������  RDTSC
;	// ��� ������������  ���  ���������  �  DoCPU.asm,
;	// ������� ��� ����� �� ������������ �� ����

	MOV		ECX,1000					; _ecx = 1000;
										; // ������� �����

@rool:								; do {
	; MUL	EAX							; // ������� ��������� 
										; // �����������������, ���� �� ������
										; // ������ ������� ����� CPU ��������
										; // ����� �� ����������

	REPT	4							; // ������   ������������  ����������
										; // ���������� ��� ������� ����������
		INC	EAX							; // ������� INC EAX
	ENDM								; // ������   ��������������������   �
										; // ���� ������������

	; REPT 4
	; 		FDIV						; // ������� ������������� �������
	; ENDM


DEC	ECX								; _ecx--;
JNZ @rool							; } while(_ecx>0);

;	//
;	// Q: ��� ��������� ����� ���������� ����� �������� �������?
;	// A: ���� ��������� ����������� ����� ����������� ������� ����� �� ���-��
;	// 	  �������� ����� � ����� ����� ������
;	//