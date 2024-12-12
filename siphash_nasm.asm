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
	xor rax, rax	; rax = 0
	mov rdx, rsi
	and rdx, 7		; rdx = mess_len % 8
	je LastMessagePartEnd_2_4
	add rdi, rdx

LastMessagePart_2_4:
	dec rdi
	movzx rcx, byte [rdi]
	shl rax, 8
	or rax, rcx
	dec rdx
	jnz LastMessagePart_2_4

LastMessagePartEnd_2_4:
	movzx rcx, sil
	shl rcx, 56
	or rax, rcx
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
	xor rax, rax	; rax = 0
	mov rdx, rsi
	and rdx, 7		; rdx = mess_len % 8
	je LastMessagePartEnd_4_8
	add rdi, rdx

LastMessagePart_4_8:
	dec rdi
	movzx rcx, byte [rdi]
	shl rax, 8
	or rax, rcx
	dec rdx
	jnz LastMessagePart_4_8

LastMessagePartEnd_4_8:
	movzx rcx, sil
	shl rcx, 56
	or rax, rcx
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