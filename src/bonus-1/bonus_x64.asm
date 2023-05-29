section .text
	global intertwine
	extern printf
;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	push	rbp
	mov 	rbp, rsp

	; RDI v1
	; RSI n1
	; RDX v2
	; RCX n2
	; R8 v

loop_elements:
	cmp rsi, 0 ; compare n1 with 0
	je check_second_array ; if n1 == 0, jump to check_second_array

	; mov [r8], dword [rdi] ; v[0] = v1[0]
	mov eax, dword [rdi] ; eax = v1[0]
	mov [r8], eax

	add r8, 4 ; v++
	add rdi, 4 ; v1++
	dec rsi ; n1--


check_second_array:
	cmp rcx, 0 ; compare n2 with 0
	jg do_add

	cmp rsi, 0 ; compare n1 with 0
	jg loop_elements ; if n1 > 0, jump to loop_elements
	je end ; if n2 == 0, jump to end

do_add:
	mov eax, dword [rdx] ; eax = v2[0]
	mov [r8], eax ; v[0] = v2[0]

	add r8, 4 ; v++
	add rdx, 4 ; v2++
	dec rcx ; n2--

	jmp loop_elements ; jump to loop_elements

end:
	leave
	ret
