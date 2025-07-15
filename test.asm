	.file	"test.c"
	.intel_syntax noprefix
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC7:
	.string	"fail for vector %d\n"
.LC8:
	.string	"OK"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB39:
	.cfi_startproc
	endbr64
	push	r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	mov	edi, 512
	push	r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	push	rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	push	rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	sub	rsp, 8
	.cfi_def_cfa_offset 48
	call	malloc@PLT
	test	rax, rax
	je	.L4
	mov	rbx, rax
	lea	r12, vectors_sip64[rip]
	xor	r13d, r13d
	xor	ebp, ebp
	jmp	.L12
	.p2align 4,,10
	.p2align 3
.L3:
	mov	rdi, QWORD PTR [rbx]
.L7:
	movabs	rcx, 1084818905618843912
	mov	rsi, r13
	movabs	rdx, 506097522914230528
	call	siphash_2_4@PLT
	movzx	ecx, BYTE PTR 6[r12]
	mov	rdx, rax
	movzx	eax, BYTE PTR 7[r12]
	sal	rcx, 48
	sal	rax, 56
	or	rax, rcx
	movzx	ecx, BYTE PTR [r12]
	or	rax, rcx
	movzx	ecx, BYTE PTR 5[r12]
	sal	rcx, 40
	or	rax, rcx
	movzx	ecx, BYTE PTR 4[r12]
	sal	rcx, 32
	or	rax, rcx
	movzx	ecx, BYTE PTR 3[r12]
	sal	rcx, 24
	or	rax, rcx
	movzx	ecx, BYTE PTR 2[r12]
	sal	rcx, 16
	or	rax, rcx
	movzx	ecx, BYTE PTR 1[r12]
	sal	rcx, 8
	or	rax, rcx
	cmp	rax, rdx
	je	.L11
	mov	edx, r13d
	lea	rsi, .LC7[rip]
	xor	eax, eax
	add	rbp, 1
	mov	edi, 2
	call	__printf_chk@PLT
.L11:
	add	r13, 1
	add	r12, 8
	cmp	r13, 64
	je	.L30
.L12:
	test	r13, r13
	je	.L3
	mov	rdi, r13
	call	malloc@PLT
	mov	QWORD PTR [rbx+r13*8], rax
	mov	rdi, rax
	test	rax, rax
	je	.L4
	lea	eax, -1[r13]
	mov	edx, r13d
	cmp	eax, 14
	jbe	.L14
	movdqa	xmm5, XMMWORD PTR .LC0[rip]
	mov	eax, r13d
	shr	eax, 4
	movups	XMMWORD PTR [rdi], xmm5
	cmp	eax, 1
	je	.L6
	movdqa	xmm6, XMMWORD PTR .LC1[rip]
	movups	XMMWORD PTR 16[rdi], xmm6
	cmp	eax, 3
	jne	.L6
	movdqa	xmm7, XMMWORD PTR .LC2[rip]
	movups	XMMWORD PTR 32[rdi], xmm7
.L6:
	mov	ecx, edx
	and	ecx, -16
	mov	eax, ecx
	test	dl, 15
	je	.L7
.L5:
	sub	edx, ecx
	lea	esi, -1[rdx]
	cmp	esi, 6
	jbe	.L9
	movq	xmm0, QWORD PTR .LC3[rip]
	lea	esi, 1[rax]
	movd	xmm1, eax
	movd	xmm4, esi
	punpckldq	xmm1, xmm4
	paddd	xmm0, xmm1
	movdqa	xmm3, xmm1
	movdqa	xmm2, xmm1
	punpcklwd	xmm3, xmm0
	punpcklwd	xmm2, xmm0
	movq	xmm0, QWORD PTR .LC4[rip]
	pshufd	xmm3, xmm3, 78
	punpcklwd	xmm2, xmm3
	paddd	xmm0, xmm1
	movq	xmm3, QWORD PTR .LC5[rip]
	paddd	xmm1, xmm3
	movdqa	xmm3, xmm0
	punpcklwd	xmm3, xmm1
	punpcklwd	xmm0, xmm1
	movq	xmm1, QWORD PTR .LC6[rip]
	pshufd	xmm3, xmm3, 78
	punpcklwd	xmm0, xmm3
	pand	xmm2, xmm1
	pand	xmm1, xmm0
	packuswb	xmm2, xmm1
	pshufd	xmm2, xmm2, 8
	movq	QWORD PTR [rdi+rcx], xmm2
	mov	ecx, edx
	and	ecx, -8
	add	eax, ecx
	and	edx, 7
	je	.L7
.L9:
	movsx	rdx, eax
	mov	BYTE PTR [rdi+rdx], al
	lea	edx, 1[rax]
	cmp	edx, r13d
	jge	.L7
	movsx	rsi, edx
	mov	BYTE PTR [rdi+rsi], dl
	lea	edx, 2[rax]
	cmp	edx, r13d
	jge	.L7
	movsx	rsi, edx
	mov	BYTE PTR [rdi+rsi], dl
	lea	edx, 3[rax]
	cmp	edx, r13d
	jge	.L7
	movsx	rsi, edx
	mov	BYTE PTR [rdi+rsi], dl
	lea	edx, 4[rax]
	cmp	edx, r13d
	jge	.L7
	movsx	rsi, edx
	mov	BYTE PTR [rdi+rsi], dl
	lea	edx, 5[rax]
	cmp	edx, r13d
	jge	.L7
	movsx	rsi, edx
	add	eax, 6
	mov	BYTE PTR [rdi+rsi], dl
	cmp	eax, r13d
	jge	.L7
	movsx	rdx, eax
	mov	BYTE PTR [rdi+rdx], al
	jmp	.L7
	.p2align 4,,10
	.p2align 3
.L14:
	xor	ecx, ecx
	xor	eax, eax
	jmp	.L5
.L30:
	test	rbp, rbp
	je	.L31
.L13:
	add	rsp, 8
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	xor	eax, eax
	pop	rbx
	.cfi_def_cfa_offset 32
	pop	rbp
	.cfi_def_cfa_offset 24
	pop	r12
	.cfi_def_cfa_offset 16
	pop	r13
	.cfi_def_cfa_offset 8
	ret
.L31:
	.cfi_restore_state
	lea	rdi, .LC8[rip]
	call	puts@PLT
	jmp	.L13
.L4:
	or	edi, -1
	call	exit@PLT
	.cfi_endproc
.LFE39:
	.size	main, .-main
	.globl	vectors_sip64
	.section	.rodata
	.align 32
	.type	vectors_sip64, @object
	.size	vectors_sip64, 512
vectors_sip64:
	.ascii	"1\016\016\335G\333or"
	.ascii	"\375g\334\223\3059\370t"
	.ascii	"ZO\251\331\t\200l\r"
	.ascii	"-~\373\327\226fg\205"
	.ascii	"\267\207q'\340\224'\317"
	.ascii	"\215\246\231\315dUv\030"
	.ascii	"\316\343\376XnF\311\313"
	.string	"7\321\001\213\365"
	.ascii	"\002\253"
	.ascii	"b$\223\232y\365\365\223"
	.string	"\260\344\251\013\337\202"
	.ascii	"\236"
	.ascii	"\363\271\335\224\305\273]z"
	.ascii	"\247\255k\"F/\263\364"
	.ascii	"\373\345\016\206\274\217\036u"
	.ascii	"\220=\204\300'V\352\024"
	.ascii	"\356\362z\216\220\312#\367"
	.ascii	"\345E\276Ia\312)\241"
	.ascii	"\333\233\302W\177\314*?"
	.ascii	"\224G\276,\365\351\232i"
	.ascii	"\234\323\215\226\360\263\301K"
	.ascii	"\275ay\247\035\311m\273"
	.ascii	"\230\356\242\032\362\\\326\276"
	.ascii	"\307g;.\260\313\362\320"
	.ascii	"\210>\243\343\225gS\223"
	.ascii	"\310\316\\\315\214\003\f\250"
	.ascii	"\224\257I\366\306P\255\270"
	.ascii	"\352\270\205\212\336\222\341\274"
	.ascii	"\363\025\273[\2705\330\027"
	.ascii	"\255\317k\007ca./"
	.ascii	"\245\311\035\247\254\252M\336"
	.ascii	"qe\225\207fP\242\246"
	.ascii	"(\357I\\S\243\207\255"
	.ascii	"B\303A\330\372\222\3302"
	.ascii	"\316|\362r/Q'q"
	.ascii	"\343xY\371F#\363\247"
	.ascii	"8\022\005\273\032\260\340\022"
	.ascii	"\256\227\241\017\3244\340\025"
	.ascii	"\264\243\025\b\276\377M1"
	.ascii	"\2019b)\360\220y\002"
	.ascii	"M\f\364\236\345\324\334\312"
	.ascii	"\\s3jv\330\277\232"
	.ascii	"\320\247\004Sk\251>\016"
	.ascii	"\222YX\374\326B\f\255"
	.ascii	"\251\025\302\233\310\006s\030"
	.ascii	"\225+y\363\274\n\246\324"
	.ascii	"\362\035\362\344\035E5\371"
	.ascii	"\207Wu\031\004\217S\251"
	.ascii	"\020\245l\365\337\315\232\333"
	.ascii	"\353u\t\\\315\230l\320"
	.ascii	"Q\251\313\236\313\243\022\346"
	.ascii	"\226\257\255\374,\346f\307"
	.ascii	"r\376R\227ZCd\356"
	.ascii	"Z\026E\262v\325\222\241"
	.ascii	"\262t\313\216\277\207\207\n"
	.ascii	"o\233\264 =\347\263\201"
	.ascii	"\352\354\262\243\013\"\250\177"
	.ascii	"\231$\244<\3011W$"
	.ascii	"\275\203\215:\257\277\215\267"
	.ascii	"\013\032*2e\325\032\352"
	.ascii	"\023Py\243#\034\346`"
	.ascii	"\223+(F\344\327\006f"
	.ascii	"\341\221_\\\261\354\244l"
	.ascii	"\363%\226\\\241mb\237"
	.ascii	"W_\362\216`8\033\345"
	.ascii	"rE\006\353L2\212\225"
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC0:
	.byte	0
	.byte	1
	.byte	2
	.byte	3
	.byte	4
	.byte	5
	.byte	6
	.byte	7
	.byte	8
	.byte	9
	.byte	10
	.byte	11
	.byte	12
	.byte	13
	.byte	14
	.byte	15
	.align 16
.LC1:
	.byte	16
	.byte	17
	.byte	18
	.byte	19
	.byte	20
	.byte	21
	.byte	22
	.byte	23
	.byte	24
	.byte	25
	.byte	26
	.byte	27
	.byte	28
	.byte	29
	.byte	30
	.byte	31
	.align 16
.LC2:
	.byte	32
	.byte	33
	.byte	34
	.byte	35
	.byte	36
	.byte	37
	.byte	38
	.byte	39
	.byte	40
	.byte	41
	.byte	42
	.byte	43
	.byte	44
	.byte	45
	.byte	46
	.byte	47
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC3:
	.long	2
	.long	2
	.align 8
.LC4:
	.long	4
	.long	4
	.align 8
.LC5:
	.long	6
	.long	6
	.align 8
.LC6:
	.value	255
	.value	255
	.value	255
	.value	255
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
