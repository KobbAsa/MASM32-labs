.386
.model flat, stdcall

extern MessageBoxA@16:near
includelib \masm32\lib\user32.lib

.data
    head db "���������� ���", 0
    myPersonalData db "�������� ����� ���������", 13,
    "���� ����������: 15.08.2005", 13, 
    "�����: ��-22", 13,
    "����� �������������: 9094", 0

.code
start: 
    push 0
    push offset head
    push offset myPersonalData
    push 0
    
    call MessageBoxA@16

    ret
end start