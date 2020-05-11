/*----------------------------------------------------------------------------
 * @
 *				������� ��� ������������ �������������
 *			���������		������		��������	�������
 *			===============================================
 * 
 * Build 0x001 06.07.2002
--------------------------------------------------------------------------- */

// ������������
#define BLOCK_SIZE	(1*M)					// ������ ��������������� �����


#include <DoCPU.h>

main()
{
	int a, x = 0;
	int   *p_dw;
	float d = 0;
	char  *p_b, *buf;	

	// TITLE
	PRINT("= = = ������������ ������������� ��������� ������� ���� = = =\n");
	PRINT_TITLE;

	// �������� ������
	buf		= (char *) _malloc32(8);
	p_b		= (char *) _malloc32(BLOCK_SIZE);
	p_dw	= (int *) _malloc32(BLOCK_SIZE);
	
	
	/*------------------------------------------------------------------------
	 *
	 *						��������� ������ �������
	 *								(������)
	 *
	----------------------------------------------------------------------- */
	VVV;
	A_BEGIN(0)
		for(a = 0; a < BLOCK_SIZE; a++)
			x+=p_b[a];
	A_END(0)

	/*------------------------------------------------------------------------
	 *
	 *					��������� ������ �������� �������
	 *								(������)
	 *
	----------------------------------------------------------------------- */
	VVV;
	A_BEGIN(1)
		for(a = 0; a < BLOCK_SIZE; a += sizeof(int))
			x+=*(int*)((char *)p_dw + a);
	A_END(1)

	/*------------------------------------------------------------------------
	 *
	 *					��������� ������ ���������� �������
	 *								(������)
	 *
	----------------------------------------------------------------------- */
	VVV;
	A_BEGIN(2)
		for(a = 0; a< BLOCK_SIZE; a += 8)
			_mmx_cpy(buf, (char *)((char *)p_dw+a));
	A_END(2)
	RM;	/* ����������������� ����� MMX */



	/*------------------------------------------------------------------------
	 *
	 *						��������� ������ �������
	 *								(������)
	 *
	----------------------------------------------------------------------- */
	VVV;
	A_BEGIN(3)
		for(a = 0; a < BLOCK_SIZE; a++)
			p_b[a]=x;
	A_END(3)


	/*------------------------------------------------------------------------
	 *
	 *						��������� ������ �������� �������
	 *								(������)
	 *
	----------------------------------------------------------------------- */
	VVV;
	A_BEGIN(4)
		for(a = 0; a < BLOCK_SIZE; a += sizeof(int))
			*(int*)((char *)p_dw + a)=x;
	A_END(4)


	/*------------------------------------------------------------------------
	 *
	 *						��������� ������ ����������� �������
	 *								(������)
	 *
	----------------------------------------------------------------------- */
	VVV;
	A_BEGIN(5)
		for(a = 0; a < BLOCK_SIZE; a += 8)
			_mmx_cpy((char *)((char *)p_dw+a), buf);
	A_END(5)
	RM;	/* ����������������� ����� MMX */

	// ����� �����������
	Lx_OUT("byte vs dword READ ",Ax_GET(0),Ax_GET(1));
	Lx_OUT("byte vs qword READ ",Ax_GET(0),Ax_GET(2));

	Lx_OUT("byte vs dword WRITE",Ax_GET(3),Ax_GET(4));
	Lx_OUT("byte vs qword WRITE",Ax_GET(3),Ax_GET(5));

	return x+d;
}


_P_S()
{
/*
	��������������   ������,   �   ��������-������������   ��������.   ������,
	����������,  ����  �����  ���  ���������.  ���, ���� � ������� ������ ����
	��������.  ���,  ��������,  ����  ����  ��������  - �������������� ������,
	������  ��������  ��  �������,  ��  �����  ���  �������  �� �������� � ���
	�������� � ������ ��� ����� ��� ������ �������?
*/
}
