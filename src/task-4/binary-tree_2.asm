; Copyrigth (c) 2023, <Dan-Dominic Staicu>

extern array_idx_2      ;; int array_idx_2

struc node
	.value: resd 1 ; reserve 4 bytes for a int
	.left:  resd 1 ; reserve 4 bytes for a pointer
	.right: resd 1 ; reserve 4 bytes for a pointer
endstruc

section .data

section .text
    global inorder_intruders

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_intruders(struct node *node, struct node *parent, int *array)
;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista
;
;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;
;        array  -> adresa vectorului unde se vor salva valorile din noduri;

; ATENTIE: DOAR in frunze pot aparea valori gresite!
;          vectorul array este INDEXAT DE LA 0!
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!

; HINT: folositi variabila importata array_idx_2 pentru a retine pozitia
;       urmatorului element ce va fi salvat in vectorul array.
;       Este garantat ca aceasta variabila va fi setata pe 0 la fiecare
;       test al functiei inorder_intruders.      

inorder_intruders:
    enter 0, 0
	pusha 

	mov eax, [ebp + 8] ; node
	mov ecx, [ebp + 12] ; parent
	mov ebx, [ebp + 16] ; array

	cmp eax, 0 ; if node == NULL
	je end

left:
	mov ecx, eax ; the next parent is the current node
	mov eax, [eax + node.left] ; eax = node->left

	push ebx ; push array
	push ecx ; push parent
	push eax ; push node->left
	call inorder_intruders ; inorder_intruders(node->left, parent, array)
	add esp, 12 ; pop 3 params

check_left:
	mov eax, [ebp + 8] ; node
	mov ecx, [ebp + 12] ; parent

	mov ecx, eax ; the next parent is the current node
	mov eax, [eax + node.left] ; eax = node->left

	cmp eax, 0 ; if node->left == NULL
	je right

	mov eax, [eax + node.value] ; eax = node->left->value
	mov ecx, [ecx + node.value] ; ecx = node->value

	cmp eax, ecx
	jge write_in_array_left


right:
	mov eax, [ebp + 8] ; node
	mov ecx, [ebp + 12] ; parent
	mov ebx, [ebp + 16] ; array

	mov ecx, eax ; the next parrent is the current node
	mov eax, [eax + node.right] ; eax = node->right

	push ebx ; push array
	push ecx ; push parent
	push eax ; push node->right
	call inorder_intruders ; inorder_intruders(node->right, parent, array)
	add esp, 12 ; pop 3 params

check_right:
	mov eax, [ebp + 8] ; node
	mov ecx, [ebp + 12] ; parent

	mov ecx, eax ; the next parrent is the current node
	mov eax, [eax + node.right] ; eax = node->right

	cmp eax, 0 ; if node->right == NULL
	je end

	mov eax, [eax + node.value] ; eax = node->right->value
	mov ecx, [ecx + node.value] ; ecx = node->value

	cmp eax, ecx
	jle write_in_array_right

end:
	popa
    leave
    ret


write_in_array_left:
	mov ebx, [ebp + 16] ; array
	mov edi, eax ; edi = node->left->value

	mov eax, [array_idx_2] ; eax = array_idx_2
	mov edx, 4 ; edx = sizeof(int)
	mul edx ; eax = array_idx_2 * sizeof(int)

	add ebx, eax ; ebx = array + array_idx_2 * sizeof(int)

	mov [ebx], edi ; array[array_idx_2] = node->left->value

	inc dword [array_idx_2] ; array_idx_2++

	jmp right


write_in_array_right:
	mov ebx, [ebp + 16] ; array
	mov edi, eax ; edi = node->right->value

	mov eax, [array_idx_2] ; eax = array_idx_2
	mov edx, 4 ; edx = sizeof(int)
	mul edx ; eax = array_idx_2 * sizeof(int)

	add ebx, eax ; ebx = array + array_idx_2 * sizeof(int)

	mov [ebx], edi ; array[array_idx_2] = node->right->value

	inc dword [array_idx_2] ; array_idx_2++

	jmp end