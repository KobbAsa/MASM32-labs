.386
.model flat, stdcall
option casemap :none

include \masm32\include\masm32rt.inc
include \masm32\include\dialogs.inc

.data
    DovzhenkoEncryptedPassword db "7*5(-1%.6audj", 0
    DovzhenkoKey db "sECRETKEY1479", 0

    DovzhenkoErrorTitle db "Error", 0
    DovzhenkoFillTheField db "Please fill the password field", 0

    DovzhenkoPasswordIncorrectCase db "Password is incorrect", 0
    DovzhenkoPasswordCorrectCase db "Success. You can have my personal info:", 0

    DovzhenkoPersonalDataName db "Dovzhenko Anton", 0
    DovzhenkoPersonalDataBirth db "Date of birth: 15.08.2005", 0
    DovzhenkoPersonalDataGroup db "Group: IM-22", 0
    DovzhenkoPersonalDataID db "Student ID number: 9094", 0

.data?
    DovzhenkoInstM dd ?
    DovzhenkoPasswordBuf db 256 dup (?)
    EncryptedDovzhenkoPasswordBuf db 256 dup (?)

.code
    DovzhenkoPassPr PROTO :DWORD,:DWORD,:DWORD,:DWORD
    PasswordWindowDovzhenko PROTO :DWORD,:DWORD

start:

DovzhenkoDisplayMessageMc macro message, title, style
    ; Info output macros (macros 1)
    invoke MessageBox, NULL, addr message, addr title, style
    ;; some hidden comment
endm

DovzhenkoEncryptMc macro src, dest, key, length
    ; Encrypting macros (macros 2)
    LOCAL EncryptLoop, EncryptEnd
    lea esi, src
    lea edi, dest
    lea ebx, key
    mov ecx, length
    ;; another hidden comment
    EncryptLoop:
        mov al, [esi]
        test al, al
        jz EncryptEnd
        xor al, [ebx]
        stosb
        inc esi
        inc ebx
        cmp byte ptr [ebx], 0
        jnz EncryptLoop
        lea ebx, key
        jmp EncryptLoop
    EncryptEnd:
        mov byte ptr [edi], 0
endm

DovzhenkoCompareHashMc macro inputBuf, encryptedPassword, errorMessage
	; Comparing with hash macros (macros 3)
    LOCAL DovzhenkoLMark1, DovzhenkoLMark2 ; Local marks
    invoke lstrcmp, addr inputBuf, addr encryptedPassword

    .IF ZERO?
        jmp DovzhenkoLMark1
    .ELSE
        jmp DovzhenkoLMark2
    .ENDIF

    DovzhenkoLMark1: ; local mark DovzhenkoLMark1
        DovzhenkoDisplayMessageMc DovzhenkoPersonalDataName, DovzhenkoPasswordCorrectCase, MB_OK
        DovzhenkoDisplayMessageMc DovzhenkoPersonalDataBirth, DovzhenkoPasswordCorrectCase, MB_OK
        DovzhenkoDisplayMessageMc DovzhenkoPersonalDataGroup, DovzhenkoPasswordCorrectCase, MB_OK
        DovzhenkoDisplayMessageMc DovzhenkoPersonalDataID, DovzhenkoPasswordCorrectCase, MB_OK
        jmp EndMacro

    DovzhenkoLMark2: ; local mark DovzhenkoLMark2
        DovzhenkoDisplayMessageMc errorMessage, DovzhenkoErrorTitle, MB_ICONERROR

    EndMacro:
    ;; one more hidden comment
endm

PasswordWindowDovzhenko proc DovzhenkoResF :DWORD, DovzhenkoDaR :DWORD
    LOCAL DovzhenkoArr1[4]:DWORD
    LOCAL DovzhenkoVK :DWORD

    lea eax, DovzhenkoArr1
    mov DovzhenkoVK, eax

    mov ecx, DovzhenkoResF
    mov [eax], ecx

    mov ecx, DovzhenkoDaR
    mov [eax+4], ecx

    Dialog "Lab 4 by Dovzhenko Anton", \
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

DovzhenkoPassPr PROC DovzhenkoWinHandler :DWORD, DovzhenkoEntrPass :DWORD, DovzhenkoWSI :DWORD, DovzhenkoAddWInf :DWORD
    LOCAL DovzhenkoPasswordLength :DWORD

    .IF DovzhenkoEntrPass == WM_COMMAND
        .IF DovzhenkoWSI == IDOK

            invoke GetDlgItemText, DovzhenkoWinHandler, 301, addr DovzhenkoPasswordBuf, sizeof DovzhenkoPasswordBuf
            invoke lstrlen, addr DovzhenkoPasswordBuf

            mov DovzhenkoPasswordLength, eax

            .IF DovzhenkoPasswordLength == 0
                DovzhenkoDisplayMessageMc DovzhenkoFillTheField, DovzhenkoErrorTitle, MB_ICONERROR
            .ELSE
                DovzhenkoEncryptMc DovzhenkoPasswordBuf, EncryptedDovzhenkoPasswordBuf, DovzhenkoKey, DovzhenkoPasswordLength
                DovzhenkoCompareHashMc EncryptedDovzhenkoPasswordBuf, DovzhenkoEncryptedPassword, DovzhenkoPasswordIncorrectCase
            .ENDIF

            invoke EndDialog, DovzhenkoWinHandler, 0

        .ENDIF

        .IF DovzhenkoWSI == IDCANCEL
            invoke EndDialog, DovzhenkoWinHandler, 0
        .ENDIF

    .ENDIF

    xor eax, eax
    ret
DovzhenkoPassPr ENDP

end start