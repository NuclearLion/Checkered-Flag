%include "../include/io.mac"

global get_words
global compare_func
global sort

section .data
	delimiters db ' ,.', 10, 0
	endl db 10, 0
	word_cnt dd 0
;;;debug zone;;;
	format db "%s", 0

section .text
	extern strtok
	extern printf
	extern strcat
	extern qsort
	extern strlen
	extern strcmp
;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0
	pusha

	mov eax, [ebp + 8] ; words
	mov ebx, [ebp + 12] ; number_of_words
	mov ecx, [ebp + 16] ; size
	mov edx, compare_func

	push edx
	push ecx
	push ebx
	push eax

	call qsort
	add esp, 16

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

compare_func:
	; push ebp
	; mov ebp, esp
	enter 0, 0
	pusha
	; push edi
	; push esi
	; push edx
	; push ecx
	; push ebx

	xor eax, eax
	; load string pointers
	mov eax, [ebp + 8] ; a
	mov ebx, [ebp + 12] ; b

	; get len of strA
	push eax
	call strlen
	add esp, 4
	mov ecx, eax

	; get len of strB
	push ebx
	call strlen
	add esp, 4
	mov edx, eax

	; compare lenA and lenB
	cmp ecx, edx
	jg lenA_greater
	jl lenB_greater

	; lenA == lenB, cmp lexicographically
	push ebx
	push eax
	call strcmp
	add esp, 8

	; restore stack and return
end_compare:
	; pop ebx
	; pop ecx
	; pop edx
	; pop esi
	; pop edi
	popa
	leave
	ret

lenA_greater:
	mov eax, 1
	jmp end_compare

lenB_greater:
	mov eax, -1
	jmp end_compare

