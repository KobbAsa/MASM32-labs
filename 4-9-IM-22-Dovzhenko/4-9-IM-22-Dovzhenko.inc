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