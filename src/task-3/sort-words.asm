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
	extern printf
	extern strcat
	extern qsort
;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0
    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0
	pusha

	xor edi, edi
	xor esi, esi
	xor ecx, ecx

	mov edi, [ebp + 8] ; s
	mov esi, [ebp + 12] ; words
	mov ecx, [ebp + 16] ; number_of_words

	mov [word_cnt], ecx

	mov edx, delimiters ; edx = delimiters

	push edx
	push edi
	call strtok ; strtok(s, delimiters)
	add esp, 8


	; mov esi, eax ; words[0] = strtok(s, delimiters)
	push eax
	push dword [esi]
	call strcat
	add esp, 8

	; PRINTF32 `before printf of pula\n\x0`
	; PRINTF32 `value of esi: %s\x0\n`, esi
	; PRINTF32 `after printf of pula\n\x0`

	mov edx, endl

	push edx ; src
	push dword [esi] ; dest
	call strcat
	add esp, 8

	PRINTF32 `before printf of pula\n\x0`
	PRINTF32 `%s\x0`, [esi]
	PRINTF32 `after printf of pula\n\x0`

process_tokens:
	; cmp eax, 0 ; check if strtok returned NULL
	dec dword [word_cnt]
	cmp dword [word_cnt], 0
	je end_process_tokens

	mov edx, delimiters
	push edx
	push 0
	call strtok ; strtok(NULL, delimiters)
	add esp, 8

	; PRINTF32 `%s\x0`, eax
	mov ebx, eax

	; push eax
	; push dword [esi]
	; call strcat ; strcat(words[i], token)
	; add esp, 8
	push eax
	push dword [esi]
	call strcat
	add esp, 8

	; PRINTF32 `before printf of pula\n\x0`
	; PRINTF32 `value of esi: %s\x0\n`, [esi]
	; PRINTF32 `after printf of pula\n\x0`

	mov edx, endl

	push edx ; src
	push dword [esi] ; dest
	call strcat
	add esp, 8
	PRINTF32 `before printf of pula\n\x0`
	PRINTF32 `value of esi: %s\x0\n`, [esi]
	PRINTF32 `after printf of pula\n\x0`

	; PRINTF32 `edi value:%s\n\x0`, edi

	mov eax, ebx
	jmp process_tokens


end_process_tokens:

	popa
    leave
    ret
