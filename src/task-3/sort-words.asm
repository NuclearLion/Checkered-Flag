
%include "../include/io.mac"

global get_words
global compare_func
global sort

section .data
	delimiters db ' ,.', 10, 0
	endl db 10, 0
	word_cnt dd 0

section .text
	extern strtok
	extern strlen
	extern strcmp
	extern qsort
	extern printf

compare_func:
    ; save used registers
	push ebp
	mov ebp, esp
	
	push ebx
	push ecx
	push edx

	mov eax, [ebp + 8] ; a
	mov ebx, [ebp + 12] ; b

	mov eax, [eax]
	mov ebx, [ebx]

	push eax
	call strlen
	add esp, 4
	push eax ; save lenA on stack

	push ebx
	call strlen
	add esp, 4
	push eax; save lenB on stack

	pop edx ; lenB
	pop ecx ; lenA

	cmp ecx, edx ; compare lengths
	jg lenA_greater
	jl lenB_greater

	; lenA == lenB, cmp lexicographically
	mov eax, [ebp + 8] ; a
	mov ebx, [ebp + 12] ; b

	mov eax, [eax]
	mov ebx, [ebx]

	push ebx ; b
	push eax ; a
	call strcmp ; strcmp(a, b)
	add esp, 8

	cmp eax, 0 ; ? strcmp(a, b) == 0
	jg lenA_greater ; a > b => return 1
	jl lenB_greater ; a < b => return -1

	; a == b
	mov eax, 0

	jmp end_compare

lenA_greater:
	mov eax, 1
	jmp end_compare

lenB_greater:
	mov eax, -1
	jmp end_compare

end_compare:
	pop edx
	pop ecx
	pop ebx
	leave
	ret



;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0
	pusha

	mov eax, [ebp + 8] ; words
	mov ebx, [ebp + 12] ; number_of_words
	mov ecx, [ebp + 16] ; size
	mov edx, compare_func ; compare_func

	push edx ; compare_func
	push ecx ; size
	push ebx ; number_of_words
	push eax ; words

	call qsort
	add esp, 16

	mov eax, esi

	; PRINTF32 `Sorted words: %s\n\x0`, dword [eax]

	popa
    leave
    ret


;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0
	pusha

	mov edi, [ebp + 8] ; s
	mov esi, [ebp + 12] ; words
	mov ecx, [ebp + 16] ; number_of_words

	mov [word_cnt], ecx

	mov edx, delimiters ; edx = delimiters

	push edx
	push edi
	call strtok ; strtok(s, delimiters)
	add esp, 8

	mov [esi], eax ; words[0] = strtok(s, delimiters)

process_tokens: 
	dec dword [word_cnt] ; word_cnt--
	cmp dword [word_cnt], 0 ; if word_cnt == 0
	je end_process_tokens ; return

	mov edx, delimiters ; edx = delimiters
	push edx ; delimiters
	push 0 ; s = NULL
	call strtok ; strtok(NULL, delimiters)
	add esp, 8

	mov ebx, eax ; save eax in ebx

	add esi, 4
	mov [esi], eax

	mov eax, ebx ; restore eax
	jmp process_tokens ; repeat

end_process_tokens:

	popa
    leave
    ret
