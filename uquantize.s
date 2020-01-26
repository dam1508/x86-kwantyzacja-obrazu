;*****************************************************************;
;                                                                 ;
;ebx stores helpful info: bl - group length/ bh - group average   ;
;ecx stores the bitmap                                            ;
;esi is a counter of how many bytes is there still to be done     ;
;edi serves as a helping register in calculations                 ;
;                                                                 ;
;*****************************************************************;

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

    mov     ecx, [ebp + 20]         ;load image
    mov     esi, [ecx + 34]         ;number of bytes to change
    add     ecx, [ecx + 10]         ;move to pixels

main_loop:

;------ Byte Change ------

    xor     edx, edx
    movzx   eax, byte[ecx]
    movsx   edi, bl
    div     edi                     ;divide byte by group length
    mul     edi                     ;multiply result by group length
    movsx   edi, bh
    add     eax, edi                ;add grou average
    cmp     eax, 255
    jl      skip
    sub     al, bl

skip:

    mov     byte[ecx],al            ;save byte
    inc     ecx                     ;go to the next byte

    sub     esi, 1                  ;decrement number of bytes to change
    cmp     esi, 0                  ;check if all bytes are done
    jg      main_loop               ;if not change next byte

end:

    mov     esp, ebp
    pop     esi
    pop     edi
    pop     ebx
    pop     ebp
    ret
