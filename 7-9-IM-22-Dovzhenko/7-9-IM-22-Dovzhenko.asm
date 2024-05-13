.386
.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc

public DovzhenkoCurrentA, DovzhenkoCurrentB, DovzhenkoFour, DovzhenkoDenominatorVal, DovzhenkoZero
extern DovzhenkoGetDenominator:proto

.data
    DovzhenkoA dq 3.4, 10.6, 11.3, 10.4, 88.8, 16.2, 12.4
    DovzhenkoB dq 9.3, 3.5, 19.7, 3.6, 22.6, 3.9, 3.1
    DovzhenkoC dq 12.6, 2.7, 1.3, 2.8, 2.6, 6.4, 19.1
    DovzhenkoD dq 18.1, 1.5, 71.2, 4.6, 213.3, 17.3, 169.6

    DovzhenkoZero dq 0.0
    DovzhenkoTwo dq 2.0
    DovzhenkoFour dq 4.0
    DovzhenkoTwentyThree dq 23.0

    DovzhenkoNumeratorPart1 dq 0.0
    DovzhenkoNumeratorPart2 dq 0.0
	
    DovzhenkoNumeratorVal dt 0.0
    DovzhenkoDenominatorVal dt 0.0

    DovzhenkoResultrVal dq 0.0

    LogErrorIndicator dq -9999.0
    LogZeroIndicator dq -8888.0

    DovzhenkoCurrentA dq 0.0
    DovzhenkoCurrentB dq 0.0

    DovzhenkoTitleTemplate db "Lab 7 by Dovzhenko Anton - Example %d", 0
    DovzhenkoExampleTitle db 64 dup(0)

    DovzhenkoResultsWin db "The formula is (2 * c - d / 23) / ln(b - a / 4)", 13,
                         "a = %s, b = %s, c = %s, d = %s", 13,
                         "So the example is (2 * %s - %s / 23) / ln(%s - %s / 4)", 13,
                         "Final result: %s", 0

    DovzhenkoErrorExample db "The formula is (2 * c - d / 23) / ln(b - a / 4)", 13,
                           "a = %s, b = %s, c = %s, d = %s", 13,
                           "So the example is (2 * %s - %s / 23) / ln(%s - %s / 4)", 13,
                           "But there is an error: %s", 0

    DovzhenkoZeroDenomErrorMsg db "You can't divide by 0!", 0
    DovzhenkoNegLogErrorMsg db "Logarithm from negative value!", 0
    DovzhenkoLogZeroErrorMsg db "Logarithm of zero is undefined!", 0

    DovzhenkoAStr db 64 dup(0)
    DovzhenkoBStr db 64 dup(0)
    DovzhenkoCStr db 64 dup(0)
    DovzhenkoDStr db 64 dup(0)

    DovzhenkoResultString db 64 dup(0)
    DovzhenkoDisplayBuff db 256 dup(0)

.code

; (2 * c - d / 23)

; First part (2 * c) with parameter passing through eax
CalcTwoC proc
    fld qword ptr [eax]
    fmul qword ptr [ebx]
    ret
CalcTwoC endp

; Second part (- d / 23), through the stack
CalcNegDiv proc
	pop ebx
	pop ecx
	
    fld qword ptr [ecx]
	pop ecx
	
    fdiv qword ptr [ecx]
    fchs
	
	push ebx
	ret
CalcNegDiv endp

main proc
    mov edi, 0

DovzhenkoCalculateLoop:
    cmp edi, 7
    je DovzhenkoEndProgram

    mov eax, edi
    inc eax

    invoke wsprintf, addr DovzhenkoExampleTitle, addr DovzhenkoTitleTemplate, eax

    finit

    ; (2 * c)
    lea eax, [DovzhenkoC + edi * 8]
	lea ebx, [DovzhenkoTwo]
    call CalcTwoC
	
	fstp qword ptr [DovzhenkoNumeratorPart1]
    
    ; (- d / 23)
	push offset DovzhenkoTwentyThree ; Load 23 through the stack
	lea ecx, [DovzhenkoD + edi * 8]  ; Load d through the stack
	push ecx

	call CalcNegDiv
	
	fstp qword ptr [DovzhenkoNumeratorPart2]

    fld [DovzhenkoNumeratorPart1]
    fadd [DovzhenkoNumeratorPart2]
    fstp [DovzhenkoNumeratorVal]

    fld [DovzhenkoA + edi * 8]
    fstp DovzhenkoCurrentA
    fld [DovzhenkoB + edi * 8]
    fstp DovzhenkoCurrentB

    invoke FloatToStr, [DovzhenkoA + edi * 8], addr DovzhenkoAStr
    invoke FloatToStr, [DovzhenkoB + edi * 8], addr DovzhenkoBStr
    invoke FloatToStr, [DovzhenkoC + edi * 8], addr DovzhenkoCStr
    invoke FloatToStr, [DovzhenkoD + edi * 8], addr DovzhenkoDStr

    call DovzhenkoGetDenominator

    fld [DovzhenkoDenominatorVal]
    fcomp qword ptr [LogErrorIndicator]
    fstsw ax
    sahf
    je DovzhenkoNegLogError

    fld [DovzhenkoDenominatorVal]
    fcomp qword ptr [LogZeroIndicator]
    fstsw ax
    sahf
    je DovzhenkoLogZeroError

    fld [DovzhenkoDenominatorVal]
    fcomp qword ptr [DovzhenkoZero]
    fstsw ax
    sahf
    je DovzhenkoZeroDivideError

    fld [DovzhenkoNumeratorVal]
    fld [DovzhenkoDenominatorVal]
    fdiv
    fstp [DovzhenkoResultrVal]

    invoke FloatToStr, [DovzhenkoResultrVal], addr DovzhenkoResultString

    invoke wsprintf, addr DovzhenkoDisplayBuff, addr DovzhenkoResultsWin,
           addr DovzhenkoAStr, addr DovzhenkoBStr, addr DovzhenkoCStr, addr DovzhenkoDStr,
           addr DovzhenkoCStr, addr DovzhenkoDStr, addr DovzhenkoBStr, addr DovzhenkoAStr,
           addr DovzhenkoResultString

    invoke MessageBox, NULL, addr DovzhenkoDisplayBuff, addr DovzhenkoExampleTitle, MB_OK

    inc edi
    jmp DovzhenkoCalculateLoop

DovzhenkoNegLogError:
    invoke wsprintf, addr DovzhenkoDisplayBuff, addr DovzhenkoErrorExample,
           addr DovzhenkoAStr, addr DovzhenkoBStr, addr DovzhenkoCStr, addr DovzhenkoDStr,
           addr DovzhenkoCStr, addr DovzhenkoDStr, addr DovzhenkoBStr, addr DovzhenkoAStr,
           addr DovzhenkoNegLogErrorMsg

    invoke MessageBox, NULL, addr DovzhenkoDisplayBuff, addr DovzhenkoExampleTitle, MB_ICONERROR or MB_OK
    jmp DovzhenkoNextExample

DovzhenkoLogZeroError:
    invoke wsprintf, addr DovzhenkoDisplayBuff, addr DovzhenkoErrorExample,
           addr DovzhenkoAStr, addr DovzhenkoBStr, addr DovzhenkoCStr, addr DovzhenkoDStr,
           addr DovzhenkoCStr, addr DovzhenkoDStr, addr DovzhenkoBStr, addr DovzhenkoAStr,
           addr DovzhenkoLogZeroErrorMsg

    invoke MessageBox, NULL, addr DovzhenkoDisplayBuff, addr DovzhenkoExampleTitle, MB_ICONERROR or MB_OK
    jmp DovzhenkoNextExample

DovzhenkoZeroDivideError:
    invoke wsprintf, addr DovzhenkoDisplayBuff, addr DovzhenkoErrorExample,
           addr DovzhenkoAStr, addr DovzhenkoBStr, addr DovzhenkoCStr, addr DovzhenkoDStr,
           addr DovzhenkoCStr, addr DovzhenkoDStr, addr DovzhenkoBStr, addr DovzhenkoAStr,
           addr DovzhenkoZeroDenomErrorMsg

    invoke MessageBox, NULL, addr DovzhenkoDisplayBuff, addr DovzhenkoExampleTitle, MB_ICONERROR or MB_OK
    jmp DovzhenkoNextExample

DovzhenkoNextExample:
    inc edi
    jmp DovzhenkoCalculateLoop

DovzhenkoEndProgram:
    invoke ExitProcess, 0

main endp
end main