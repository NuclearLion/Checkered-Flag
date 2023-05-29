; Copyrigth (c) 2023, <Dan-Dominic Staicu>

extern array_idx_1      ;; int array_idx_1

struc node
	.value: resd 1 ; reserve 4 bytes for a int
	.left:  resd 1 ; reserve 4 bytes for a pointer
	.right: resd 1 ; reserve 4 bytes for a pointer
endstruc

section .data

section .text
    global inorder_parc	

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_parc(struct node *node, int *array);

;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor in vectorul array.
;    @params:
;        node  -> nodul actual din arborele de cautare;
;        array -> adresa vectorului unde se vor salva valorile din noduri;

; ATENTIE: vectorul array este INDEXAT DE LA 0!
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!
; HINT: folositi variabila importata array_idx_1 pentru a retine pozitia
;       urmatorului element ce va fi salvat in vectorul array.
;       Este garantat ca aceasta variabila va fi setata pe 0 la fiecare
;       test.

inorder_parc:
    enter 0, 0
	pusha

	mov eax, [ebp + 8] ; node
	mov ebx, [ebp + 12] ; array

	cmp eax, 0 ; if node == NULL
	je end

left:
	mov eax, [eax + node.left] ; eax = node.left
	push ebx ; push array
	push eax ; push node.left
	call inorder_parc ; inorder_parc(node.left, array)
	add esp, 8 ; clean stack

save_value:
	mov eax, [ebp + 8] ; current node
	mov ebx, [ebp + 12] ; start of array

	mov edi, [eax + node.value] ; load value in edi

	mov eax, [array_idx_1]
	mov edx, 4
	mul edx ; multiply array_idx_1 by 4

	add ebx, eax ; add result to ebx

	mov [ebx], edi ; array[array_idx_1] = node.value

	inc dword [array_idx_1] ; array_idx_1++

right:
	mov eax, [ebp + 8] ; current node
	mov ebx, [ebp + 12] ; start of array

	mov eax, [eax + node.right] ; eax = node.right
	push ebx ; push array
	push eax ; push node.right
	call inorder_parc ; inorder_parc(node.right, array)
	add esp, 8 ; clean stack

end:
	popa
    leave
    ret
