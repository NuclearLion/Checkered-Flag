global get_words
global compare_func
global sort

section .text
	extern strtok

section .data
	delimiters db ' ,.',10,0  

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

	mov edi, [ebp + 8] ; edi = s
	mov esi, [ebp + 12] ; esi = words
	mov ecx, [ebp + 16] ; ecx = number_of_words

	; loop s to find words




    leave
    ret
