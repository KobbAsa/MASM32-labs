.386 
.model flat,stdcall 
option casemap:none 

include \masm32\include\masm32rt.inc

.data 
    DovzhenkoA dq 3.4, 10.6, 11.3, 10.4, 88.8
    DovzhenkoB dq 9.3, 3.5, 19.7, 3.6, 22.6
    DovzhenkoC dq 12.6, 2.7, 1.3, 2.8, 2.6
    DovzhenkoD dq 18.1, 1.5, 71.2, 4.6, 213.3

    DovzhenkoZero dq 0.0
    DovzhenkoTwo dq 2.0
    DovzhenkoFour dq 4.0
    DovzhenkoTwentyThree dq 23.0

    DovzhenkoNumeratorVal dt 0.0
    DovzhenkoDenominatorVal dt 0.0
	
    DovzhenkoResultrVal dq 0.0

    DovzhenkoTitleTemplate db "Lab 6 by Dovzhenko Anton - Example %d", 0
    DovzhenkoExampleTitle db 64 dup(0)
	
    DovzhenkoErrorExample db "The formula is (2 * c - d / 23) / ln(b - a / 4)", 13,
                           "a = %s, b = %s, c = %s, d = %s", 13,
                           "So the example is (2 * %s - %s / 23) / ln(%s - %s / 4)", 13,
                           "But there is an error: %s", 0
	
    DovzhenkoZeroDenomErrorMsg db "You can't divide by 0!", 0							 
    DovzhenkoNegLogErrorMsg db "Logarithm from negative value!", 0	
    DovzhenkoLogZeroErrorMsg db "Logarithm of zero is undefined!", 0

    DovzhenkoResultsWin db "The formula is (2 * c - d / 23) / ln(b - a / 4)", 13,
                           "a = %s, b = %s, c = %s, d = %s", 13,
                           "So the example is (2 * %s - %s / 23) / ln(%s - %s / 4)", 13,
                           "Final result: %s", 0

    DovzhenkoAStr db 64 dup(0)
    DovzhenkoBStr db 64 dup(0)
    DovzhenkoCStr db 64 dup(0)
    DovzhenkoDStr db 64 dup(0)
	
    DovzhenkoResultString db 64 dup(0)
    DovzhenkoDisplayBuff db 256 dup(0)

.code 
main proc
    mov edi, 0
	
DovzhenkoCalculateLoop:
    cmp edi, 5
    je DovzhenkoEndProgram
	
    ; Format the output and display
    mov eax, edi
    inc eax
	
    invoke wsprintf, addr DovzhenkoExampleTitle, addr DovzhenkoTitleTemplate, eax
	
    finit

    ; Compute numerator (2 * c - d / 23)
    fld [DovzhenkoC + edi * 8]
    fmul [DovzhenkoTwo]
    fld [DovzhenkoD + edi * 8]
    fdiv [DovzhenkoTwentyThree]
    fsub
    fstp [DovzhenkoNumeratorVal]

    ; Compute (b - a/4)
    fld [DovzhenkoB + edi * 8]
    fld [DovzhenkoA + edi * 8]
    fdiv [DovzhenkoFour]
    fsub
    fstp [DovzhenkoDenominatorVal]

    ; Update variables for display
    invoke FloatToStr, [DovzhenkoA + edi * 8], addr DovzhenkoAStr
    invoke FloatToStr, [DovzhenkoB + edi * 8], addr DovzhenkoBStr
    invoke FloatToStr, [DovzhenkoC + edi * 8], addr DovzhenkoCStr
    invoke FloatToStr, [DovzhenkoD + edi * 8], addr DovzhenkoDStr

    ; Check if value under logarithm is negative
    fld [DovzhenkoDenominatorVal]
    fcomp DovzhenkoZero
    fstsw ax
    sahf
    jb DovzhenkoNegativeLogError
    
    ; Check if value under logarithm is zero
    fld [DovzhenkoDenominatorVal]
    fcomp DovzhenkoZero
    fstsw ax
    sahf
    je DovzhenkoLogOfZeroError

    ; Continue with computation if valid
    fld [DovzhenkoDenominatorVal]
    fldln2
    fld st(1)
    fyl2x
    fstp [DovzhenkoDenominatorVal]

    ; Check if denominator is zero
    fld [DovzhenkoDenominatorVal]
    fcom DovzhenkoZero
    fstsw ax
    sahf
    je DovzhenkoZeroDivideError

    ; Divide numerator by denominator
    fld [DovzhenkoNumeratorVal]
    fld [DovzhenkoDenominatorVal]
    fdiv
    fstp [DovzhenkoResultrVal]

    ; Converting
    fld [DovzhenkoResultrVal]
    fstp [DovzhenkoResultrVal]

    invoke FloatToStr, [DovzhenkoResultrVal], addr DovzhenkoResultString

    invoke wsprintf, addr DovzhenkoDisplayBuff, addr DovzhenkoResultsWin, 
           addr DovzhenkoAStr, addr DovzhenkoBStr, addr DovzhenkoCStr, addr DovzhenkoDStr,
           addr DovzhenkoCStr, addr DovzhenkoDStr, addr DovzhenkoBStr, addr DovzhenkoAStr,
           addr DovzhenkoResultString

    ; Display the results
    invoke MessageBox, NULL, addr DovzhenkoDisplayBuff, addr DovzhenkoExampleTitle, MB_OK

    inc edi
    jmp DovzhenkoCalculateLoop

	; Error Handlers
DovzhenkoNegativeLogError:
    invoke wsprintf, addr DovzhenkoDisplayBuff, addr DovzhenkoErrorExample,
           addr DovzhenkoAStr, addr DovzhenkoBStr, addr DovzhenkoCStr, addr DovzhenkoDStr,
           addr DovzhenkoCStr, addr DovzhenkoDStr, addr DovzhenkoBStr, addr DovzhenkoAStr,
		   addr DovzhenkoNegLogErrorMsg
    
	invoke MessageBox, NULL, addr DovzhenkoDisplayBuff, addr DovzhenkoExampleTitle, MB_ICONERROR or MB_OK
    jmp DovzhenkoNextExample

DovzhenkoLogOfZeroError:
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

	; Other handlers
DovzhenkoNextExample:
    inc edi
    jmp DovzhenkoCalculateLoop

DovzhenkoEndProgram:
    invoke ExitProcess, 0 

main endp 
end main