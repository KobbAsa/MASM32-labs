OPTION DOTNAME
	
option casemap:none
include \masm64\include\temphls.inc
include \masm64\include\win64.inc
include \masm64\include\kernel32.inc
includelib \masm64\lib\kernel32.lib
include \masm64\include\user32.inc
includelib \masm64\lib\user32.lib
OPTION PROLOGUE:rbpFramePrologue
OPTION EPILOGUE:none

.data
head      			db "���������� ���",0
myPersonalData      db "�������� ����� ���������", 13,
						"���� ����������: 15.08.2005", 13, 
						"�����: ��-22", 13,
						"����� �������������: 9094", 0
.code

WinMain proc 
	sub rsp,28h
      invoke MessageBox, NULL, &myPersonalData, &head, MB_OK
      invoke ExitProcess,NULL
WinMain endp

end