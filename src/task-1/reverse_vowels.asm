; Copyrigth (c) 2023, <Dan-Dominic Staicu>

section .data
	; declare global vars here

section .text
	global reverse_vowels
	extern strlen

;;	void reverse_vowels(char *string)
;	Cauta toate vocalele din string-ul `string` si afiseaza-le
;	in ordine inversa. Consoanele raman nemodificate.
;	Modificare se va face in-place
reverse_vowels:
	push ebp
	; mov ebp, esp
	push esp
	pop ebp
	pusha

	push dword [ebp + 8] ; push string
	call strlen ; get len of the string 
	add esp, 4

	push eax ; push strlen
	pop ecx ; mov ecx, eax

	xor eax, eax
	push dword [ebp + 8] ; push string
	pop eax ; mov eax, string

first_loop_string:
	; check if the current character is a vowel
	cmp byte [eax], 'a'
	je vowel_found_first_loop

	cmp byte [eax], 'e'
	je vowel_found_first_loop

	cmp byte [eax], 'i'
	je vowel_found_first_loop

	cmp byte [eax], 'o'
	je vowel_found_first_loop

	cmp byte [eax], 'u'
	je vowel_found_first_loop

	jmp next_iteration_first_loop

vowel_found_first_loop:
	xor ebx, ebx
	push eax ; save original value of eax onto stack
	push dword [eax] ; push the 4 byte value of [eax] onto stack
	pop ebx ; pop the 4 byte value from stack into ebx
	pop eax ; restore original value of eax
	push ebx ; push the 4 byte value of ebx onto stack

next_iteration_first_loop:
	inc eax ; increment pointer to the next letter
	loop first_loop_string ; loop until ecx is 0

	; next loop starts here

	; now all the vowels are on the stack
	xor eax, eax

	push dword [ebp + 8] ; push string
	call strlen ; get len of the string again
	add esp, 4

	push eax ; push strlen
	pop ecx ; mov ecx, eax ; save strlen in ecx

	xor eax, eax
	push dword [ebp + 8] ; push string
	pop eax ; mov eax, string ; save string in eax again

replaceing_vowels_loop:
	; search again vor vowels
	cmp byte [eax], 'a'
	je vowel_found_second_loop

	cmp byte [eax], 'e'
	je vowel_found_second_loop

	cmp byte [eax], 'i'
	je vowel_found_second_loop

	cmp byte [eax], 'o'
	je vowel_found_second_loop

	cmp byte [eax], 'u'
	je vowel_found_second_loop

	jmp next_iteration_second_loop

vowel_found_second_loop:
	xor ebx, ebx
	pop ebx

	; mov byte [eax], bl equivalent
	push dword [eax] ; push the 4 byte value of [eax] onto stack
	pop edx ; pop the 4 byte value from stack into edx
	xor dl, dl ; clear dl register (last byte of edx)
	push edx ; push the 4 byte value of edx onto stack
	pop dword [eax] ; pop the 4 byte value from stack into [eax]
	
	add byte [eax], bl ; add the last byte of ebx to the current character

next_iteration_second_loop:
	inc eax ; increment pointer to the next letter
	loop replaceing_vowels_loop ; loop until ecx is 0


	popa
	; leave equivalent
	push ebp
	pop esp ; mov esp, ebp
	pop ebp
	ret