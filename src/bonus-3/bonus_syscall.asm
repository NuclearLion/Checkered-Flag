%include "../include/io.mac"

section .rodata:
	; taken from fnctl.h
	O_RDONLY	equ 00000
	O_WRONLY	equ 00001
	O_TRUNC		equ 01000
	O_CREAT		equ 00100
	S_IRUSR		equ 00400
	S_IRGRP		equ 00040
	S_IROTH		equ 00004

section .bss
	fd resb 1


section .data
	buffer times 100 db 0
	Marco db "Marco", 0
	Polo db "Polo", 0
	from_len equ 5 ; strlen(Marco)
	to_len equ 4 ; strlen(Polo)
    format db "%s", 0

section .text
	global	replace_marco
	extern printf
	extern strstr
	extern memcpy
	extern strlen
;; void replace_marco(const char *in_file_name, const char *out_file_name)
;  it replaces all occurences of the word "Marco" with the word "Polo",
;  using system calls to open, read, write and close files.

replace_marco:
	push	ebp
	mov 	ebp, esp
	pusha

	mov eax, 5 ; open system call number is 5
	mov ebx, [ebp + 8] ; pointer to filename
	mov ecx, O_RDONLY ; flags - 0 is read mode
	mov edx, 0 ; mode - not used with read mode, can be 0
	int 0x80

	cmp eax, 0
	jl error

	mov ebx, eax ; move file descriptor into ebx for sys_read

	mov eax, 3 ; read system call number is 3
	mov ecx, buffer ; pointer to the buffer
	mov edx, 100 ; nr of bytes to read
	int 0x80

	mov eax, 6
	int 0x80

	; eax now contains the number of bytes read
	mov eax, buffer ; src
	mov edi, Marco ; to replace
	mov esi, Polo ; replace with

	; push buffer
	; push format
	; call printf
	; add esp, 8

replace:
	mov eax, buffer ; src
	mov edi, Marco ; to replace
	mov esi, Polo ; replace with

	push edi
	push eax
	call strstr
	add esp, 8

	test eax, eax
	je done

	mov ebx, eax

	push dword to_len
	push esi
	push eax
	call memcpy
	add esp, 12

	push ebx
	call strlen
	add esp, 4

	lea edi, [ebx + to_len]
	lea esi, [ebx + from_len]
	mov ecx, eax
	rep movsb

	jmp replace

done:
	push buffer
	call strlen
	add esp, 4

	push buffer
	push format
	call printf
	add esp, 8



; open output file
	mov eax, 5 ; open system call number is 2
	mov ebx, [ebp + 12] ; pointer to filename
	mov ecx, 0102o ; O_WRONLY | O_CREAT | O_TRUNC; flags
	mov edx, 0666o
	int 0x80
	mov [fd], eax

	cmp eax, 0
	jl error

	xor esi, esi
	push buffer
	call strlen
	add esp, 4
	mov esi, eax

	; write to file
	mov eax, 4 ; write system call number is 4
	mov ebx, [fd]
	mov ecx, buffer
	mov edx, esi ; maybe strlen of buffer?
	int 0x80

	mov eax, 6 ; syscall number (sys_close)
	mov ebx, [fd]
	int 0x80

	popa
	leave
	ret

error:
	PRINTF32 `in error ffs u dumb shit\n\x0`
	leave
	ret