; Copyrigth (c) 2023, <Dan-Dominic Staicu>
%include "../include/io.mac"

section .data
	back db "..", 0
	curr db ".", 0
	slash db "/", 0
	; declare global vars here
	cnt_out dd 0

section .text
	global pwd
	extern strcat
	extern printf
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
	; check if the word is ".."
	; PRINTF32 `edi at start of each loop: %s\n\x0`, [edi]
	push ecx
check_back:
	xor edx, edx
	mov edx, back
	push dword [edi]
	push edx
	call strcmp
	add esp, 8

	cmp eax, 0
	jne check_curr
	cmp dword [cnt_out], 0 ; check if it has what folder to remove
	jle next_word
	; if it is, remove the last folder from the path

	; TODO: remove the last folder from the path and last slash
	mov ebx, esi

find_slash:
	inc ebx ; move to the next char
	cmp byte [ebx], 0 ; check if it is the end of the string
	jne find_slash

overwrite_slash:
	dec ebx ; move back in the string
	cmp byte [ebx], '/' ; check if it is a slash
	jne overwrite_slash
	mov byte [ebx], 0 ; overwrite the slash with 0

	dec dword [cnt_out] ; decrement the count of folders in the output

	jmp next_word
check_curr:
	xor edx, edx
	mov edx, curr
	push dword [edi]
	push edx
	call strcmp
	add esp, 8

	cmp eax, 0
	jne add_word

	; if it is, do nothing
	jmp next_word
add_word:
	; concatenate slash in the output
	xor edx, edx
	mov edx, slash
	push edx
	push esi ; dest
	call strcat
	add esp, 8

	; PRINTF32 `esi in add_word: %s\n\x0`, esi
	; PRINTF32 `edi in add_word: %s\n\x0`, [edi]

	; inc count of folders in the output
	inc dword [cnt_out]

	; concatenate the word in the output
	push dword [edi] ; src
	push esi ; dest
	call strcat
	add esp, 8

	; PRINTF32 `esi after add: %s\n\x0`, [esi]

next_word:
	xor eax, eax

	push edi
	call strlen ; get the length of the word
	add esp, 4

	add edi, 4 ; move to the next word
	; PRINTF32 `edi: %s\n\x0`, edi

	pop ecx ; get the count of words in given matrix
	; PRINTF32 `ecx %d\n\x0`, ecx
	dec ecx ; decrement the count of words
	jnz loop_words ; if there are more words, loop

	; PRINTF32 `esi at end: %s\n\x0`, esi
	; place the last slash
	xor edx, edx
	mov edx, slash
	push edx
	push esi ; dest
	call strcat
	add esp, 8

	popa
	leave
	ret
