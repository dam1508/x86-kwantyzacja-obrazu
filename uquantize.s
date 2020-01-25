section .text


    global uquantize

uquantize:

    push    ebp
    push    ebx
    push    edi
    push    esi
    mov     ebp, esp

    xor     edx, edx
    mov     ebx, [ebp + 24]         ;second argument - levels
    mov     eax, 255
    div     ebx
    mov     bl, al                  ;save group length

    xor     edx, edx
    mov     ecx, 2
    div     ecx
    mov     bh, al                  ;save group average

    mov     ecx, [ebp + 20]
    mov     esi, [ecx + 34]
    add     ecx, [ecx + 10]         ;move to pixels

main_loop:



;-------- B ----------

    xor     edx, edx
    movzx   eax, byte[ecx]
    movsx   edi, bl
    div     edi
    mul     edi
    movsx   edi, bh
    add     eax, edi
    mov     byte[ecx],al
    inc     ecx

;-------- G ----------

    xor     edx, edx
    movzx   eax, byte[ecx]
    movsx   edi, bl
    div     edi
    mul     edi
    movsx   edi, bh
    add     eax, edi
    mov     byte[ecx],al
    inc     ecx

;-------- R ----------

    xor     edx, edx
    movzx   eax, byte[ecx]
    movsx   edi, bl
    div     edi
    mul     edi
    movsx   edi, bh
    add     eax, edi
    mov     byte[ecx],al
    inc     ecx

    sub     esi, 3
    cmp     esi, 2
    jg      main_loop

end:

    mov     esp, ebp
    pop     esi
    pop     edi
    pop     ebx
    pop     ebp
    ret
