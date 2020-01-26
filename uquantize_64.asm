;*****************************************************************;
;                                                                 ;
;r9d - group length / r10d - group average                        ;
;rdi stores the bitmap                                            ;
;ecx is a counter of how many bytes is there still to be done     ;
;r8d serves as a helping register in calculations                 ;
;                                                                 ;
;*****************************************************************;

section .text

    global uquantize

uquantize:

    push    rbp
    mov     rbp, rsp

    xor     edx, edx
    mov     eax, 255
    div     esi
    mov     r9d, eax                  ;save group length

    xor     edx, edx
    mov     ecx, 2
    div     ecx
    mov     r10d, eax                  ;save group average

    mov     ecx, [rdi + 34]         ;number of bytes to change
    xor     edx, edx
    mov     edx, [rdi + 10]         ;move to pixels
    add     rdi, rdx

main_loop:

;------ Byte Change ------

    xor     edx, edx
    movzx   eax, byte[rdi]
    mov     r8d, r9d
    div     r8d                     ;divide byte by group length
    mul     r8d                     ;multiply result by group length
    mov     r8d, r10d
    add     eax, r8d                ;add group average

    cmp     eax, 255                ;last numbers go to the last group
    jl      skip                    ;(remainder overflow)
    sub     eax, r9d

skip:

    mov     byte[rdi], al           ;save byte
    inc     rdi                     ;go to the next byte

    sub     ecx, 1                  ;decrement number of bytes to change
    cmp     ecx, 0                  ;check if all bytes are done
    jg      main_loop               ;if not change next byte

end:

    mov     rsp, rbp
    pop     rbp
    ret
