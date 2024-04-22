.386
.model flat, stdcall
option casemap :none

include \masm32\include\masm32rt.inc

.data
    DovzhenkoBasicTitle db "Lab 5 by Dovzhenko Anton - Example %d", 0
    DovzhenkoDivByZeroErrorMsg db "Error! You can't divide by 0!", 0
    DovzhenkoResultsWin db "The formula is (21 - a * c / 4) / (1 + c / a + b)", 13,
                       "a = %d, b = %d, c = %d", 13,
                       "So the example is (21 - %d * %d / 4) / (1 + %d / %d + %d)", 13,
                       "Result before modifying: %d", 13,
                       "Final result: %d", 0
    DovzhenkoFourKm dd 4

.data
    DovzhenkoA dd 2, -4, 3, 7, 4
    DovzhenkoB dd 2, -10, -14, -12, -3
    DovzhenkoC dd 10, 24, 48, 28, 8

.code
start:

main proc
    LOCAL DovzhenkoLpIndx: DWORD
	
    LOCAL DovzhenkoTitle[100]: BYTE
    LOCAL DovzhenkoError[100]: BYTE
    LOCAL DovzhenkoResultStr[256]: BYTE
	
    LOCAL DovzhenkoIntrmdRes: DWORD
    LOCAL DovzhenkoFinalRes: DWORD
	
    LOCAL DovzhenkoPAVal: DWORD, DovzhenkoPBVal: DWORD, DovzhenkoPCVal: DWORD
    LOCAL DovzhenkoNumZm: DWORD, DovzhenkoDenumZN: DWORD

    mov DovzhenkoLpIndx, 0

DovzhenkoCalcLoop:
    mov eax, DovzhenkoLpIndx
    inc eax  ; Increment index
	
    invoke wsprintf, addr DovzhenkoTitle, addr DovzhenkoBasicTitle , eax  ; Format the window title
    invoke wsprintf, addr DovzhenkoError, addr DovzhenkoDivByZeroErrorMsg  ; Format the error message

    mov eax, DovzhenkoLpIndx
    shl eax, 2
    lea ebx, [DovzhenkoA]
    add ebx, eax
    mov ecx, [ebx]
    mov DovzhenkoPAVal, ecx

    lea ebx, [DovzhenkoB]
    add ebx, eax
    mov ecx, [ebx]
    mov DovzhenkoPBVal, ecx

    lea ebx, [DovzhenkoC]
    add ebx, eax
    mov ecx, [ebx]
    mov DovzhenkoPCVal, ecx

    ; Multiplication
    mov eax, DovzhenkoPAVal
    imul eax, DovzhenkoPCVal
    mov ecx, [DovzhenkoFourKm]
    or ecx, ecx
    jz DovzhenkoDivByZeroErr
    cdq
    idiv ecx
    mov ecx, 21
    sub ecx, eax
    mov DovzhenkoNumZm, ecx

    ; Division calculation and zero-check
    mov eax, DovzhenkoPCVal
    or eax, eax
    jz DovzhenkoDivByZeroErr
    cdq
    mov ecx, DovzhenkoPAVal
    idiv ecx
    add eax, DovzhenkoPBVal
    inc eax
    or eax, eax
    jz DovzhenkoDivByZeroErr
    mov DovzhenkoDenumZN, eax
    mov eax, DovzhenkoNumZm
    or eax, eax
    jz DovzhenkoDivByZeroErr
    cdq
    idiv DovzhenkoDenumZN
    mov DovzhenkoIntrmdRes, eax

    ; Check if the result is even or odd
    mov eax, DovzhenkoIntrmdRes
    test eax, 1
    jz DovzhenkoEvenIntResult
    imul eax, 5
    jmp DovzhenkoSetFinalRes

DovzhenkoEvenIntResult:
    sar eax, 1

DovzhenkoSetFinalRes:
    mov DovzhenkoFinalRes, eax
	
    invoke wsprintf, addr DovzhenkoResultStr, addr DovzhenkoResultsWin, DovzhenkoPAVal, DovzhenkoPBVal, DovzhenkoPCVal, DovzhenkoPAVal, DovzhenkoPCVal, DovzhenkoPCVal, DovzhenkoPAVal, DovzhenkoPBVal, DovzhenkoIntrmdRes, DovzhenkoFinalRes
    invoke MessageBox, NULL, addr DovzhenkoResultStr, addr DovzhenkoTitle, MB_OK

    add DovzhenkoLpIndx, 1
    cmp DovzhenkoLpIndx, 5
	
    jl DovzhenkoCalcLoop
    jmp DovzhenkoExitProcessLbl

DovzhenkoDivByZeroErr:
    invoke MessageBox, NULL, addr DovzhenkoError, addr DovzhenkoTitle, MB_ICONERROR or MB_OK
    jmp DovzhenkoExitProcessLbl

DovzhenkoExitProcessLbl:
    invoke ExitProcess, 0
main endp

end start