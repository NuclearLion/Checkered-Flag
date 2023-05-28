; Copyrigth (c) 2023, <Dan-Dominic Staicu>

section .data
	back db "..", 0
	curr db ".", 0
	slash db "/", 0
	; declare global vars here
	cnt_out dd 0

section .text
	global pwd
	extern strcat
	extern strlen
	extern strcmp

;;	void pwd(char **directories, int n, char *output)
;	Adauga in parametrul output path-ul rezultat din
;	parcurgerea celor n foldere din directories
pwd:
	enter 0, 0
	pusha

	mov edi, [ebp + 8] ; edi = directories
	mov ecx, [ebp + 12] ; ecx = n
	mov esi, [ebp + 16] ; esi = output

	

loop_words:
	push ecx
check_back: ; check if the word is ".."
	xor edx, edx
	mov edx, back
	push dword [edi] ; directory
	push edx
	call strcmp ; strcmp(edi, "..")
	add esp, 8

	cmp eax, 0 ; check if edi is ".."
	jne check_curr ; if it is not, check if it is "."
	cmp dword [cnt_out], 0 ; check if it has what folder to remove
	jle next_word
	; if it is, remove the last folder from the path

	mov ebx, esi ; ebx = esi = output

find_slash: ; find the last character in the string
	inc ebx ; move to the next char
	cmp byte [ebx], 0 ; check if it is the end of the string
	jne find_slash ; if it is not, loop

overwrite_slash: ; go back until it finds the last slash
	dec ebx ; move back in the string
	cmp byte [ebx], '/' ; check if it is a slash
	jne overwrite_slash ; if it is not, loop
	mov byte [ebx], 0 ; overwrite the slash with 0

	dec dword [cnt_out] ; decrement the count of folders in the output

	jmp next_word ; go to the next word in the matrix
check_curr:
	xor edx, edx
	mov edx, curr
	push dword [edi]
	push edx
	call strcmp ; strcmp(edi, ".")
	add esp, 8

	cmp eax, 0 ; check if edi is "."
	jne add_word ; if not, add it to the output

	jmp next_word ; if it is, do nothing and go to the next word
add_word:
	; concatenate slash in the output
	xor edx, edx
	mov edx, slash
	push edx ; src
	push esi ; dest
	call strcat ; strcat(esi, "/")
	add esp, 8

	; inc count of folders in the output
	inc dword [cnt_out]

	; concatenate the word in the output
	push dword [edi] ; src
	push esi ; dest
	call strcat ; strcat(esi, edi)
	add esp, 8

next_word:
	xor eax, eax

	push edi
	call strlen ; get the length of the word
	add esp, 4

	add edi, 4 ; move to the next word

	pop ecx ; get the count of words in given matrix
	dec ecx ; decrement the count of words
	jnz loop_words ; if there are more words, loop

	; place the last slash
	xor edx, edx
	mov edx, slash
	push edx ; src
	push esi ; dest
	call strcat ; strcat(esi, "/")
	add esp, 8

	popa
	leave
	ret
