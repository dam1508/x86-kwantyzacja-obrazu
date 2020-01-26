;*****************************************************************;
;                                                                 ;
;ebx stores helpful info: bl - group length/ bh - group average   ;
;ecx stores the bitmap                                            ;
;esi is a counter of how many bytes is there still to be done     ;
;edx serves as a helping register in calculations                 ;
;                                                                 ;
;*****************************************************************;

section .text

    global uquantize

uquantize:

    push    ebp
    push    ebx
    push    esi
    mov     ebp, esp

    xor     eax, eax
    mov     bl, [ebp + 20]         ;second argument - levels
    mov     al, 255
    div     bl

    mov     dh, 255
    sub     dh, ah                  ;helps in cases where number would go over 255
    mov     bl, al                  ;save group length

    xor     ah, ah
    mov     bh, 2
    div     bh
    mov     bh, al                  ;save group average

    mov     ecx, [ebp + 16]         ;load image
    mov     esi, [ecx + 34]         ;number of bytes to change
    add     ecx, [ecx + 10]         ;move to pixels


main_loop:

;------ Byte Change ------

    xor     eax, eax
    mov     dl, byte[ecx]
    mov     al, dl
    mov     dl, bl
    div     dl                      ;divide byte by group length
    xor     ah, ah
    mul     dl                      ;multiply result by group length

    cmp     al, dh                  ;puts number in the last group
    jne     skip                    ;instead of increasing it over 255
    sub     al, bl

skip:

    add     al, bh                  ;add group average
    mov     byte[ecx], al           ;save byte
    inc     ecx                     ;go to the next byte

    sub     esi, 1                  ;decrement number of bytes to change
    cmp     esi, 0                  ;check if all bytes are done
    jg      main_loop               ;if not change next byte

end:

    mov     esp, ebp
    pop     esi
    pop     ebx
    pop     ebp
    ret
