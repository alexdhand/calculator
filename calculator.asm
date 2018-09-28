%include "/usr/local/share/csc314/asm_io.inc"


segment .data
    equals  db  "=",10,0

segment .bss


segment .text
    global  asm_main
    extern  printf

asm_main:
    push    ebp
    mov     ebp, esp
    ; ********** CODE STARTS HERE **********
    ; EAX EBX ECX EDX ESI EDI

    ;read an int, a char, and an int
    call    read_int
    mov     ebx, eax        ; store first int in ebx
    call    read_char       ; clear /n
    xor     ecx, ecx        ; clear out ECX
    xor     edx, edx        ; clear out EDX

    call    read_char       ; clear /n
    mov     cl, al          ; store the operation in ecx
    call    read_char

    call    read_int
    mov     esi, eax        ; store the next int in esi
    call    read_char       ; get rid of new line

    push    equals          ; print the equals sign to the screen
    pop     eax
    call    print_string
    xor     eax, eax        ; clear out eax
; compare cl with the hex codes for what operand we want
; + = 0x2B  - = 0x2D  * = 0x2A  % = 0x25  ^ = 0x5E  / = 0x2F
    cmp     ecx, 0x2B
    je      plus

    cmp     ecx, 0x2D
    je      minus

    cmp     ecx, 0x2A
    je      multiply

    cmp     ecx, 0x2F
    je      divide

    cmp     ecx, 0x25
    je      modulo

    cmp     ecx, 0x5E
    je      exponential
; this section holds the labels for each operand, and the corresponding math code
    plus:
        add     ebx, esi
        mov     eax, ebx
        call    print_int
        call    print_nl
        jmp     end
    minus:
        sub     ebx, esi
        mov     eax, ebx
        call    print_int
        call    print_nl
        jmp     end
    multiply:
        mov     eax, ebx
        imul    esi
        call    print_int
        call    print_nl
        jmp     end
    divide:
        mov     eax, ebx
        idiv    esi
        call    print_int
        call    print_nl
        jmp     end
    modulo:
        mov     eax, ebx
        idiv    esi
        mov     eax, edx        ;EDX is the remainder (what we are after in modulo)
        call    print_int
        call    print_nl
        jmp     end
    exponential:        ; loop through EDX, each loop multiply EBX * EBX
        mov     eax, ebx
        cmp     esi, 0
        jg      while
        jl      exp0
        exp0:               ;if a^0, the answer is 0
            mov eax, 0
            call    print_int
            sub     esi, 1
            call    print_nl
            jmp     end
        while:
            sub     esi, 1
            cmp     esi, 0
            je      endwhile
            mul     ebx
            jmp     while
        endwhile:
            call    print_int
            call    print_nl
    end:

    ; *********** CODE ENDS HERE ***********
    mov     eax, 0
    mov     esp, ebp
    pop     ebp
    ret

