%include "../include/io.mac"

global get_words
global compare_func
global sort

section .data
	delimiters db ' ,.', 10, 0
	endl db 10, 0
	word_cnt dd 0
	sep_zero db 0

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

	mov esi, [ebp + 12] ; words
	mov ecx, [ebp + 16] ; number_of_words

clear_array:
	mov edi, [esi]
	mov byte [edi], 0
	add esi, 4
	loop clear_array

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

	mov edx, endl ; edx = \n

	push edx ; src
	push dword [esi] ; dest
	call strcat ; strcat(words[0], \n)
	add esp, 8

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

	push eax ; src
	push dword [esi] ; dest
	call strcat ; concatenate last word from string in the words array
	add esp, 8 

	mov edx, endl ; edx = \n

	push edx ; src
	push dword [esi] ; dest
	call strcat ; strcat(words[i], \n)
	add esp, 8

	mov eax, ebx ; restore eax
	jmp process_tokens ; repeat

end_process_tokens:

	popa
    leave
    ret
