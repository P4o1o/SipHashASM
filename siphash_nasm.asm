section .note.GNU-stack note
	align 4
    dd 1, 0, 0
    db "GNU",0
    align 4

bits 64

section .data

align 8
JumpTable_2_4:
	dq Last0_2_4
	dq Last1_2_4
	dq Last2_2_4
	dq Last3_2_4
	dq Last4_2_4
	dq Last5_2_4
	dq Last6_2_4
	dq Last7_2_4

align 8
JumpTable_4_8:
	dq Last0_4_8
	dq Last1_4_8
	dq Last2_4_8
	dq Last3_4_8
	dq Last4_4_8
	dq Last5_4_8
	dq Last6_4_8
	dq Last7_4_8

section .text
global siphash_2_4
global siphash_4_8

%macro InitMainValues 0
    mov r10, 0x0736f6d6570736575   ; r10 = v0
    xor r10, rdx                     ; r10 = v0 ^ key0
    mov r11, 0x0646f72616e646f6d   ; r11 = v1
    xor r11, rcx                     ; r11 = v1 ^ key1
    mov r8, 0x06c7967656e657261		; r8 = v2
    xor r8, rdx                     ; r8 = key0 ^ v2
	mov r9, 0x07465646279746573		; r9 = v3
    xor r9, rcx                    ; r9 = key1 ^ v3
%endmacro

%macro SipRound 0
    add r10, r11                    ; v0 += v1
    rol r11, 13                      ; v1 <<= 13
    xor r11, r10                     ; v1 ^= v0
    rol r10, 32                      ; v0 <<= 32
    add r8, r9                       ; v2 += v3
    rol r9, 16                       ; v3 <<= 16
    xor r9, r8                       ; v3 ^= v2

    add r8, r11                      ; v2 += v1
    rol r11, 17                      ; v1 <<= 17
    xor r11, r8                      ; v1 ^= v2
    rol r8, 32                       ; v2 <<= 32
    add r10, r9                      ; v0 += v3
    rol r9, 21                       ; v3 <<= 21
    xor r9, r10                      ; v3 ^= v0
%endmacro

siphash_2_4:
	; RDI message ptr [byte]
	; RSI mess_len qword unsigned
	; RDX key0 qword
	; RCX key1 qword
	
; INITIALIZATION
	InitMainValues
	mov rcx, rsi
	shr rcx, 3
	jz MessageLoadLoopEnd_2_4
MessageLoadLoop_2_4:
	mov rax, qword [rdi]
	xor r9, rax
	SipRound
	SipRound
	xor r10, rax
	add rdi, 8
	dec rcx
	jnz MessageLoadLoop_2_4

MessageLoadLoopEnd_2_4:
	mov rax, rsi
	shl rax, 56
	and rsi, 7		; rsi = mess_len % 8
	lea rdx, [rel JumpTable_2_4]
	jmp qword [rdx + rsi*8]
Last7_2_4:
	movzx rcx, byte [rdi + 6]
	shl rcx, 48
	or rax, rcx
Last6_2_4:
	movzx rcx, byte [rdi + 5]
	shl rcx, 40
	or rax, rcx
Last5_2_4:
	movzx rcx, byte [rdi + 4]
	shl rcx, 32
	or rax, rcx
Last4_2_4:
	movzx rcx, byte [rdi + 3]
	shl rcx, 24
	or rax, rcx
Last3_2_4:
	movzx rcx, byte [rdi + 2]
	shl rcx, 16
	or rax, rcx
Last2_2_4:
	movzx rcx, byte [rdi + 1]
	shl rcx, 8
	or rax, rcx
Last1_2_4:
	movzx rcx, byte [rdi]
	or rax, rcx
Last0_2_4:
	xor r9, rax
	SipRound
	SipRound
	xor r10, rax
; FINALIZATION
	xor r8, 0FFh
	SipRound
	SipRound
	SipRound
	SipRound
	xor r8, r9
	xor r8, r10
	xor r8, r11
	mov rax, r8
	ret

siphash_4_8:
	; RDI message ptr [byte]
	; RSI mess_len qword unsigned
	; R8 RDX key0 qword
	; R9 RCX key1 qword

; INITIALIZATION
	InitMainValues
	mov rcx, rsi
	shr rcx, 3
	jz MessageLoadLoopEnd_4_8
MessageLoadLoop_4_8:
	mov rax, qword [rdi]
	xor r9, rax
	SipRound
	SipRound
	SipRound
	SipRound
	xor r10, rax
	add rdi, 8
	dec rcx
	jnz MessageLoadLoop_4_8

MessageLoadLoopEnd_4_8:
	mov rax, rsi
	shl rax, 56
	and rsi, 7		; rsi = mess_len % 8
	lea rdx, [rel JumpTable_4_8]
	jmp qword [rdx + rsi*8]
Last7_4_8:
	movzx rcx, byte [rdi + 6]
	shl rcx, 48
	or rax, rcx
Last6_4_8:
	movzx rcx, byte [rdi + 5]
	shl rcx, 40
	or rax, rcx
Last5_4_8:
	movzx rcx, byte [rdi + 4]
	shl rcx, 32
	or rax, rcx
Last4_4_8:
	movzx rcx, byte [rdi + 3]
	shl rcx, 24
	or rax, rcx
Last3_4_8:
	movzx rcx, byte [rdi + 2]
	shl rcx, 16
	or rax, rcx
Last2_4_8:
	movzx rcx, byte [rdi + 1]
	shl rcx, 8
	or rax, rcx
Last1_4_8:
	movzx rcx, byte [rdi]
	or rax, rcx
Last0_4_8:
	xor r9, rax
	SipRound
	SipRound
	SipRound
	SipRound
	xor r10, rax

; FINALIZATION
	xor r8, 0FFh
	SipRound
	SipRound
	SipRound
	SipRound
	SipRound
	SipRound
	SipRound
	SipRound
	xor r8, r9
	xor r8, r10
	xor r8, r11
	mov rax, r8
	ret