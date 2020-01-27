;*****************************************************************;
;                                                                 ;
;r8b - group length / r9b - group average                         ;
;rdi stores the bitmap                                            ;
;ecx is a counter of how many bytes is there still to be done     ;
;edx serves as a helping register in calculations                 ;
;                                                                 ;
;*****************************************************************;

section .text

    global uquantize

uquantize:

    push    rbp
    mov     rbp, rsp

    xor     eax, eax
    mov     al, 255
    div     sil                     ;divide 255 by number of levels

    mov     dh, 255
    sub     dh, ah                  ;helps in cases where number would go over 255
    mov     r8b, al                 ;save group length

    xor     ah, ah
    mov     r9b, 2
    div     r9b
    mov     r9b, al                 ;save group average

    mov     ecx, [rdi + 34]         ;number of bytes to change
    xor     eax, eax
    mov     eax, [rdi + 10]         ;move to pixels
    add     rdi, rax


main_loop:

;------ Byte Change ------

    xor     eax, eax
    mov     dl, byte[rdi]
    mov     al, dl
    mov     dl, r8b
    div     dl                      ;divide byte by group length
    xor     ah, ah
    mul     dl                      ;multiply result by group length

    cmp     al, dh                  ;puts number in the last group
    jne     skip                    ;instead of increasing it over 255
    sub     al, r8b

skip:

    add     al, r9b                 ;add group average
    mov     byte[rdi], al           ;save byte
    inc     rdi                     ;go to the next byte

    sub     ecx, 1                  ;decrement number of bytes to change
    cmp     ecx, 0                  ;check if all bytes are done
    jg      main_loop               ;if not change next byte

end:

    mov     rsp, rbp
    pop     rbp
    ret
