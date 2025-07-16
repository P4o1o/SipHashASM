.data
v2 dq 06c7967656e657261h
v3 dq 07465646279746573h
align 8
JumpTable_2_4 dq offset Last0_2_4
              dq offset Last1_2_4
              dq offset Last2_2_4
              dq offset Last3_2_4
              dq offset Last4_2_4
              dq offset Last5_2_4
              dq offset Last6_2_4
              dq offset Last7_2_4
align 8
JumpTable_4_8 dq offset Last0_4_8
              dq offset Last1_4_8
              dq offset Last2_4_8
              dq offset Last3_4_8
              dq offset Last4_4_8
              dq offset Last5_4_8
              dq offset Last6_4_8
              dq offset Last7_4_8
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
	mov rax, rdx
	shl rax, 56
	and rdx, 7
	jmp qword ptr [JumpTable_2_4 + rdx*8]
Last7_2_4:
	movzx rdi, byte ptr [rcx + 6]
	shl rdi, 48
	or rax, rdi
Last6_2_4:
	movzx rdi, byte ptr [rcx + 5]
	shl rdi, 40
	or rax, rdi
Last5_2_4:
	movzx rdi, byte ptr [rcx + 4]
	shl rdi, 32
	or rax, rdi
Last4_2_4:
	movzx rdi, byte ptr [rcx + 3]
	shl rdi, 24
	or rax, rdi
Last3_2_4:
	movzx rdi, byte ptr [rcx + 2]
	shl rdi, 16
	or rax, rdi
Last2_2_4:
	movzx rdi, byte ptr [rcx + 1]
	shl rdi, 8
	or rax, rdi
Last1_2_4:
	movzx rdi, byte ptr [rcx]
	or rax, rdi
Last0_2_4:
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
	mov rax, rdx
	shl rax, 56
	and rdx, 7
	jmp qword ptr [JumpTable_4_8 + rdx*8]
Last7_4_8:
	movzx rdi, byte ptr [rcx + 6]
	shl rdi, 48
	or rax, rdi
Last6_4_8:
	movzx rdi, byte ptr [rcx + 5]
	shl rdi, 40
	or rax, rdi
Last5_4_8:
	movzx rdi, byte ptr [rcx + 4]
	shl rdi, 32
	or rax, rdi
Last4_4_8:
	movzx rdi, byte ptr [rcx + 3]
	shl rdi, 24
	or rax, rdi
Last3_4_8:
	movzx rdi, byte ptr [rcx + 2]
	shl rdi, 16
	or rax, rdi
Last2_4_8:
	movzx rdi, byte ptr [rcx + 1]
	shl rdi, 8
	or rax, rdi
Last1_4_8:
	movzx rdi, byte ptr [rcx]
	or rax, rdi
Last0_4_8:
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