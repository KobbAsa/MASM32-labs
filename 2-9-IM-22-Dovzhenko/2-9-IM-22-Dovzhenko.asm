.386
.model flat, stdcall
option casemap :none

include \masm32\include\masm32rt.inc

.data
	head db "Lab 2 by Dovzhenko Anton, IM-22", 0
	
	DovzhenkoString db "15082005", 0
	
	; Byte
	DovzhenkoPositiveNumberA db 15
	DovzhenkoNegativeNumberA db -15
	
	; Word A and -A
	DovzhenkoPositiveWordA dw 15
	DovzhenkoNegativeWordA dw -15
	
	; Word B and -B
	DovzhenkoPositiveWordB dw 1508
	DovzhenkoNegativeWordB dw -1508
	
	; ShortInt A and -A
	DovzhenkoPositiveShortIntA dd 15
	DovzhenkoNegativeShortIntA dd -15
	
	; ShortInt B and -B
	DovzhenkoPositiveShortIntB dd 1508
	DovzhenkoNegativeShortIntB dd -1508
	
	; ShortInt C and -C
	DovzhenkoPositiveShortIntC dd 15082005
	DovzhenkoNegativeShortIntC dd -15082005
	
	; LongInt A and -A
	DovzhenkoPositiveLongIntA dq 15
	DovzhenkoNegativeLongIntA dq -15
	
	; LongInt B and -B
	DovzhenkoPositiveLongIntB dq 1508
	DovzhenkoNegativeLongIntB dq -1508
	
	; LongInt C and -C
	DovzhenkoPositiveLongIntC dq 15082005
	DovzhenkoNegativeLongIntC dq -15082005
	
	; D, E, F and -D, -E, -F Double (double)
	DovzhenkoPositiveDoubleD dq 0.002
	DovzhenkoNegativeDoubleD dq -0.002
	
	DovzhenkoPositiveDoubleE dq 0.166
	DovzhenkoNegativeDoubleE dq -0.166
	
	DovzhenkoPositiveDoubleF dq 1658.457
	DovzhenkoNegativeDoubleF dq -1658.457
	
	; D and -D Single (float)
	DovzhenkoPositiveSingleD dd 0.002
	DovzhenkoNegativeSingleD dd -0.002
	
	; F and -F Extended (long double)
	DovzhenkoPositiveExtendedF dt 1658.457
	DovzhenkoNegativeExtendedF dt -1658.457
	
	; Forms
	formForString db "ddmmyyyy = %s", 10, 10, 0
	
    formForA db "A and -A (dd):", 10, "A = %d", 10, "-A = %d", 10, 10, 0
    formForB db "B and -B (ddmm):", 10, "B = %d", 10, "-B = %d", 10, 10, 0
	formForC db "C and -C (ddmmyyyy):", 10, "C = %d", 10, "-C = %d", 10, 10, 0
	formForD db "D and -D (A/N):", 10, "D = %s", 10, "-D = %s", 10, 10, 0
	formForE db "E and -E (B/N):", 10, "E = %s", 10, "-E = %s", 10, 10, 0
	formForF db "F and -F (C/N):", 10, "F = %s", 10, "-F = %s", 10, 10, 0
	
.data?
	buffForString db 128 dup(?)

    buffA db 64 dup(?)
    buffB db 64 dup(?)
	buffC db 64 dup(?)
	
	buffPD db 32 dup(?)
	buffND db 32 dup(?)
	buffD db 64 dup(?)	
	
	buffPE db 32 dup(?)
	buffNE db 32 dup(?)
	buffE db 64 dup(?)
	
	buffPF db 32 dup(?)
	buffNF db 32 dup(?)
	buffF db 64 dup(?)

	bigBuff db 1024 dup(?)
	
.code
start:

	invoke FloatToStr2, DovzhenkoPositiveDoubleD, addr buffPD
	invoke FloatToStr2, DovzhenkoNegativeDoubleD, addr buffND
	
	invoke FloatToStr2, DovzhenkoPositiveDoubleE, addr buffPE
	invoke FloatToStr2, DovzhenkoNegativeDoubleE, addr buffNE
	
	invoke FloatToStr, DovzhenkoPositiveDoubleF, addr buffPF
	invoke FloatToStr, DovzhenkoNegativeDoubleF, addr buffNF
	
	invoke wsprintf, addr buffForString, addr formForString, addr DovzhenkoString

    invoke wsprintf, addr buffA, addr formForA, DovzhenkoPositiveShortIntA, DovzhenkoNegativeShortIntA
    invoke wsprintf, addr buffB, addr formForB, DovzhenkoPositiveShortIntB, DovzhenkoNegativeShortIntB
    invoke wsprintf, addr buffC, addr formForC, DovzhenkoPositiveShortIntC, DovzhenkoNegativeShortIntC
	
    invoke wsprintf, addr buffD, addr formForD, addr buffPD, addr buffND
    invoke wsprintf, addr buffE, addr formForE, addr buffPE, addr buffNE
    invoke wsprintf, addr buffF, addr formForF, addr buffPF, addr buffNF	
	
	invoke lstrcpy, addr bigBuff, addr buffForString
    invoke lstrcat, addr bigBuff, addr buffA
    invoke lstrcat, addr bigBuff, addr buffB
	invoke lstrcat, addr bigBuff, addr buffC
	invoke lstrcat, addr bigBuff, addr buffD
	invoke lstrcat, addr bigBuff, addr buffE
	invoke lstrcat, addr bigBuff, addr buffF

    invoke MessageBox, NULL, addr bigBuff, addr head, 0
    
    invoke ExitProcess, 0

end start