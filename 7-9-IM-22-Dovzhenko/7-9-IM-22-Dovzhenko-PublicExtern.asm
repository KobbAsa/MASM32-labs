.386
.model flat, stdcall
option casemap:none

public DovzhenkoGetDenominator
extern DovzhenkoCurrentA:qword, DovzhenkoCurrentB:qword, DovzhenkoFour:qword, DovzhenkoDenominatorVal:tbyte, DovzhenkoZero:qword

.data
    LogErrorIndicator dq -9999.0
    LogZeroIndicator dq -8888.0
	
.code
DovzhenkoGetDenominator proc
    ; Calculation of (b - a / 4)
    fld DovzhenkoCurrentB
    fld DovzhenkoCurrentA
    fdiv DovzhenkoFour
    fsub

    ; Value under ln check
    fld st(0)
    fcomp qword ptr [DovzhenkoZero]
    fstsw ax
	
    sahf
	
    jb LogNegativeError
    je LogZeroError

    ; ln calculation
    fldln2
    fld st(1)
    fyl2x
    fstp [DovzhenkoDenominatorVal]

    ret

LogNegativeError:
	; return indicator of ln from negative val
    fld qword ptr [LogErrorIndicator]
    fstp [DovzhenkoDenominatorVal]
    ret

LogZeroError:
	; return indicator of ln from zero
    fld qword ptr [LogZeroIndicator]
    fstp [DovzhenkoDenominatorVal]
    ret

DovzhenkoGetDenominator endp
end