.data
v2 dq 06c7967656e657261h
v3 dq 07465646279746573h

.code

InitMainValues MACRO
    mov r10, 0736f6d6570736575h
    xor r10, r8		; r10 = v0 ^ key0
    
    mov r11, 0646f72616e646f6dh
    xor r11, r9		; r11 = v1 ^ key1
    
    xor r8, [v2]	; r8 = key0 ^ v2
    xor r9, [v3]	; r9 = key1 ^ v3
ENDM

SipRound MACRO
	add r10, r11	; v0 += v1
	rol r11, 13		; v1 <<= 13
	xor r11, r10	; v1 ^= v0
	rol r10, 32		; v0 <<= 32
	add r8, r9		; v2 += v3
	rol r9, 16		; v3 <<= 16
	xor r9, r8		; v3 ^= v2

	add r8, r11		; v2 += v1
	rol r11, 17		; v1 <<= 17
	xor r11, r8		; v1 ^= v2
	rol r8, 32		; v2 <<= 32
	add r10, r9		; v0 += v3
	rol r9, 21		; v3 <<= 21
	xor r9, r10		; v3 ^= v0
ENDM

RepeatSipRound MACRO count
    REPT count
        SipRound
    ENDM
ENDM

siphash_2_4 proc
	; RCX message ptr [byte]
	; RDX mess_len qword unsigned
	; R8 key0 qword
	; R9 key1 qword
	

; INITIALIZATION
	InitMainValues
	mov rdi, rdx
	shr rdi, 3
	jz MessageLoadLoopEnd

MessageLoadLoop:
	mov rax, qword ptr [rcx]
	xor r9, rax
	RepeatSipRound 2
	xor r10, rax
	add rcx, 8
	dec rdi
	jnz MessageLoadLoop

MessageLoadLoopEnd:
	xor rax, rax	; rax = 0
	mov rsi, rdx
	and rsi, 7		; rsi = mess_len % 8
	jz LastMessagePartEnd
	add rcx, rsi

LastMessagePart:
	dec rcx
	movzx rdi, byte ptr [rcx]
	shl rax, 8
	or rax, rdi
	dec rsi
	jnz LastMessagePart

LastMessagePartEnd:
	movzx rdi, dl
	shl rdi, 56
	or rax, rdi
	xor r9, rax
	RepeatSipRound 2
	xor r10, rax

; FINALIZATION
	xor r8, 0FFh
	RepeatSipRound 4
	xor r8, r9
	xor r8, r10
	xor r8, r11
	mov rax, r8
	ret
siphash_2_4 endp



siphash_4_8 proc
	; RCX message ptr [byte]
	; RDX mess_len qword unsigned
	; R8 key0 qword
	; R9 key1 qword
	

; INITIALIZATION
	InitMainValues
	mov rdi, rdx
	shl rdi, 3
	jz MessageLoadLoopEnd

MessageLoadLoop:
	mov rax, qword ptr [rcx]
	xor r9, rax
	RepeatSipRound 4
	xor r10, rax
	add rcx, 8
	dec rdi
	jnz MessageLoadLoop

MessageLoadLoopEnd:
	xor rax, rax	; rax = 0
	mov rsi, rdx
	and rsi, 7		; rsi = mess_len % 8
	je LastMessagePartEnd
	add rcx, rsi

LastMessagePart:
	dec rcx
	movzx rdi, byte ptr [rcx]
	shl rax, 8
	or rax, rdi
	dec rsi
	jnz LastMessagePart

LastMessagePartEnd:
	movzx rdi, dl
	shl rdi, 56
	or rax, rdi
	xor r9, rax
	RepeatSipRound 4
	xor r10, rax

; FINALIZATION
	xor r8, 0FFh
	RepeatSipRound 8
	xor r8, r9
	xor r8, r10
	xor r8, r11
	mov rax, r8
	ret
siphash_4_8 endp


end