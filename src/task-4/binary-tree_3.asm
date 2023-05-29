; Copyrigth (c) 2023, <Dan-Dominic Staicu>

struc node
	.value: resd 1 ; reserve 4 bytes for a int
	.left:  resd 1 ; reserve 4 bytes for a pointer
	.right: resd 1 ; reserve 4 bytes for a pointer
endstruc

section .data

section .text
    global inorder_fixing
	extern printf


;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_fixing(struct node *node, struct node *parent)
;       functia va parcurge in inordine arborele binar de cautare, modificand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista.
;
;       Unde este nevoie de modificari se va aplica algoritmul:
;           - daca nodul actual este fiul stang, va primi valoare tatalui - 1,
;                altfel spus: node->value = parent->value - 1;
;           - daca nodul actual este fiul drept, va primi valoare tatalui + 1,
;                altfel spus: node->value = parent->value + 1;

;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;

; ATENTIE: DOAR in frunze pot aparea valori gresite! 
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!

inorder_fixing:
    enter 0, 0
	pusha

	mov eax, [ebp + 8] ; node
	mov ecx, [ebp + 12] ; parent

	cmp eax, 0 ; if node == NULL
	je end

left:
	mov ecx, eax ; the next parent is the current node
	mov eax, [eax + node.left] ; eax = node->left

	push ecx ; push parent
	push eax ; push node->left
	call inorder_fixing ; inorder_fixing(node->left, parent)
	add esp, 8 ; clear stack

check_left:
	mov eax, [ebp + 8] ; node
	mov ecx, [ebp + 12] ; parent

	mov ecx, eax ; the next parent is the current node
	mov eax, [eax + node.left] ; eax = node->left

	cmp eax, 0
	je right

	mov eax, [eax + node.value] ; eax = node->left->value
	mov ecx, [ecx + node.value] ; ecx = parent->value

	cmp eax, ecx ; if node->left->value < parent->value
	jge left_fix


right:
	mov eax, [ebp + 8] ; node
	mov ecx, [ebp + 12] ; parent

	mov ecx, eax
	mov eax, [eax + node.right]

	push ecx ; push parent
	push eax ; push node->right
	call inorder_fixing ; inorder_fixing(node->right, parent)
	add esp, 8 ; clear stack

check_right:
	mov eax, [ebp + 8] ; node
	mov ecx, [ebp + 12] ; parent

	mov ecx, eax
	mov eax, [eax + node.right]

	cmp eax, 0 ; if node->right == NULL
	je end

	mov eax, [eax + node.value] ; eax = node->right->value
	mov ecx, [ecx + node.value] ; ecx = parent->value

	cmp eax, ecx ; if node->right->value > parent->value
	jle right_fix

end:
	popa
    leave
    ret


left_fix:
	mov eax, [ebp + 8] ; node
	mov eax, [eax + node.left] ; node->left


	mov [eax + node.value], ecx ; node->value = parent->value

	dec dword [eax + node.value]

	jmp right

right_fix:
	mov eax, [ebp + 8] ; node
	mov eax, [eax + node.right] ; node->right

	mov [eax + node.value], ecx ; node->value = parent->value

	inc dword [eax + node.value]

	jmp end