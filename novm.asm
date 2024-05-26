bits 64
default rel
extern ExitProcess
extern printf

segment .data
	; if not in VM, print "0"
	falseMsg db "No VM detected", 0xd, 0xa, 0 
	; if in VM, print "1"
	trueMsg db "VM detected", 0xd, 0xa, 0

segment .text
global main
main:
	push rbp
	mov rbp, rsp
	xor eax, eax
	inc eax ; eax=1 provides processor features and model related info.
	CPUID	;*CPUID* provides processor details
	bt ecx, 0x1f	;feature flag 0x1f(31) = 'CPUID_FEAT_ECX_HYPERVISOR' if true, then VM (yes)
	je yesVm

	; this code gets executed if it's not inside a virtual machine (VM)
	lea ecx, [falseMsg]
	call printf
	jmp end

	yesVm:
		lea ecx, [trueMsg]
		call printf
		jmp end

	end:
		xor eax, eax
		call ExitProcess