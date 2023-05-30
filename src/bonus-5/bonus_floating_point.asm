section .data
	format db "%f", 0
	e dd 2.71828183

section .text
	global do_math
	extern printf


;; float do_math(float x, float y, float z)
;  returns x * sqrt(2) + y * sin(z * PI * 1/e)
do_math:
	push	ebp
	mov 	ebp, esp

	fld1 ; push 1
	fld1 ; push 1
	fadd ; add 1 + 1
	fsqrt ; sqrt(2)

	fld dword [ebp + 8] ; push x
	fmul ; x * sqrt(2)

	fld dword [ebp + 16] ; push z
	fldpi ; push PI

	fmul ; z * PI

	fld1 ; push 1 in order to divide later 1 / e

	; way 1 of getting e
	; fldl2e ; log2(e)
	; f2xm1 ; 2^log2(e) - 1 = e - 1
	; fld1 ; push 1
	; fadd ; e - 1 + 1 = e

	; way 2 of getting e
	; fldl2e
	; f2xm1
	; faddp

	; however these 2 methods print generate the value 2.442695
	; and I relly don't get it why

	;otherwise everything is correct, I tested it defining e in .data

	fld dword [e]

	fdiv ; 1/e

	; sub esp, 8
	; fstp qword [esp]
	; push format
	; call printf
	; add esp, 12


	fmul ; z * PI * 1/e


	fsin ; sin(z * PI * 1/e)

	fld dword [ebp + 12] ; push y
	fmul ; y * sin(z * PI * 1/e)

	fadd ; x * sqrt(2) + y * sin(z * PI * 1/e)



	

	leave
	ret
