bits 64
default rel

segment .data
	; if not in VM, print "0"
	noVm db "No VM detected", 0xd, 0xa, 0 
	; if in VM, print "1"
	yesVm db "VM detected", 0xd, 0xa, 0

segment .text
global main
extern ExitProcess

extern printf

main:
	push rbp
	mov rbp, rsp
	sub rsp, 32

	xor eax, eax
	inc eax ; eax=1 provides processor features and model related info.
	CPUID	;*CPUID* provides processor details
	bt ecx, 0x1f	;feature flag 0x1f(31) = 'CPUID_FEAT_ECX_HYPERVISOR' if true, then VM (yes)
	jne Vmtrue

	lea rcx, [noVm]
	call printf
	jmp end

	Vmtrue:
		lea rcx, [yesVm]
		call printf
		jmp end

	end:
	xor eax, eax
	call ExitProcess