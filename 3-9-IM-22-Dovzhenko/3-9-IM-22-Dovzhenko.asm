.386
.model flat, stdcall
option casemap :none

include \masm32\include\masm32rt.inc
include \masm32\include\dialogs.inc

.data
    DovzhenkoPassword db "DovzhenkoPASS", 0
	
	DovzhenkoErrorTitle db "Error", 0
	DovzhenkoFillTheField db "Please fill the password field", 0
	
	DovzhenkoPasswordIncorrectCase db "Password is incorrect", 0
	DovzhenkoPasswordCorrectCase db "Success. You can have my personal info:", 0
	
    DovzhenkoPersonalData db "Dovzhenko Anton", 13,
    "Date of birth: 15.08.2005", 13, 
    "Group: IM-22", 13,
    "Student ID number: 9094", 0

.data?
    DovzhenkoInstM dd ?
	DovzhenkoPasswordBuf db 256 dup (?)
	
.code
	DovzhenkoPassPr PROTO :DWORD,:DWORD,:DWORD,:DWORD
	PasswordWindowDovzhenko PROTO :DWORD,:DWORD

start:

PasswordWindowDovzhenko proc DovzhenkoResF :DWORD, DovzhenkoDaR :DWORD
    LOCAL DovzhenkoArr1[4]:DWORD
    LOCAL DovzhenkoVK :DWORD

    lea eax, DovzhenkoArr1
    mov DovzhenkoVK, eax

    mov ecx, DovzhenkoResF
    mov [eax], ecx
	
    mov ecx, DovzhenkoDaR
    mov [eax+4], ecx

    Dialog "Lab 3 by Dovzhenko Anton", \
           "Times New Roman Bold", 10, \
            WS_OVERLAPPED or \
            WS_SYSMENU or DS_CENTER, \
            5, \
            55, 55, 300, 90, \
            2048

    DlgGroup  0, 30, 10, 230, 30, 300
	
	; Text field and caption
	DlgStatic "Enter the password:", SS_CENTER, 94, 8, 100, 10, 400
    DlgEdit   ES_LEFT or WS_TABSTOP, 38, 22, 212, 11, 301
	
	; Buttons
    DlgButton "Submit", WS_TABSTOP, 20, 52, 50, 13, IDOK
    DlgButton "Cancel", WS_TABSTOP, 222, 52, 50, 13, IDCANCEL

    CallModalDialog DovzhenkoInstM, 0, DovzhenkoPassPr, DovzhenkoVK

    ret
PasswordWindowDovzhenko endp

DovzhenkoPassPr proc DovzhenkoWinHandler :DWORD, DovzhenkoEntrPass :DWORD, DovzhenkoWSI :DWORD, DovzhenkoAddWInf :DWORD
    LOCAL DovzhenkoPasswordLength :DWORD

    switch DovzhenkoEntrPass
	
        case WM_INITDIALOG
            xor eax, eax
            ret

        case WM_COMMAND
            switch DovzhenkoWSI
			
                case IDOK
                    mov DovzhenkoPasswordLength, rv( GetWindowTextLength, rv(GetDlgItem, DovzhenkoWinHandler, 301) )
					
                    .IF DovzhenkoPasswordLength == 0
                        fn MessageBox, 0, addr DovzhenkoFillTheField, addr DovzhenkoErrorTitle, MB_ICONERROR
						
                    .ELSE
                        inc DovzhenkoPasswordLength
						
                        invoke GetDlgItem, DovzhenkoWinHandler, 301
                        invoke GetWindowText, eax, addr DovzhenkoPasswordBuf, DovzhenkoPasswordLength
                        invoke lstrcmp, addr DovzhenkoPasswordBuf, addr DovzhenkoPassword
						
                        .IF ZERO?
                            fn MessageBox, 0, addr DovzhenkoPersonalData, addr DovzhenkoPasswordCorrectCase, MB_OK
                        .ELSE
                            fn MessageBox, 0, addr DovzhenkoPasswordIncorrectCase, addr DovzhenkoErrorTitle, MB_ICONERROR
                        .ENDIF
						
                        invoke EndDialog, DovzhenkoWinHandler, 0
						
                    .ENDIF
					
                case IDCANCEL
                    invoke EndDialog, DovzhenkoWinHandler, 0
					
            endsw
			
        case WM_CLOSE
            invoke EndDialog, DovzhenkoWinHandler, 0
			
    endsw

    xor eax, eax
    ret
	
DovzhenkoPassPr endp

end start