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
head      			db "Персональні дані",0
myPersonalData      db "Довженко Антон Андрійович", 13,
						"Дата народження: 15.08.2005", 13, 
						"Група: ІМ-22", 13,
						"Номер студентського: 9094", 0
.code

WinMain proc 
	sub rsp,28h
      invoke MessageBox, NULL, &myPersonalData, &head, MB_OK
      invoke ExitProcess,NULL
WinMain endp

end