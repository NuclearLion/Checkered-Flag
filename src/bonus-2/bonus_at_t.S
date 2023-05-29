#include "positions.h"

.macro ADD_MACRO
	xorl %eax, %eax

	addl (%esi), %eax
	addl (%edi), %eax

	movl %eax, (%ebx)
.endm

# newPos = ((oldPos - 1) * newRange / oldRange) + 1
.macro SCALE_POSITION_MACRO position
	movl \position, %eax
	subl $1, %eax
	mull %edx
	movl $9, %ecx
	xorl %edx, %edx
	divl %ecx
	addl $1, %eax
	movl 16(%ebp), %edx # n
.endm


 .macro SUBSTRACT_MACRO value
 	movl 20(%ebp), %ebx
	imull $4, %eax
 	addl %eax, %ebx
 	subl \value, (%ebx)
 .endm


.section .text
.global add_vect

/* 
 * void add_vect(int *v1, int *v2, int n, int *v)
 *
 * add v1 and v2, that have both the length n, and store the result in v3.
 * also, substract from v3 the values provided in positions.S, as described
 * in the task
 */

add_vect:
	pushl	%ebp
	movl 	%esp, %ebp

	pushl %edi
	pushl %esi
	pushl %ebx

	movl 8(%ebp), %esi # v1
	movl 12(%ebp), %edi # v2
	movl 16(%ebp), %edx # n
	movl 20(%ebp), %ebx # v

	xorl %ecx, %ecx

loop_add_arrays:
	ADD_MACRO

	addl $4, %ebx
	addl $4, %esi
	addl $4, %edi
	incl %ecx

	cmpl %edx, %ecx
	jne loop_add_arrays

	SCALE_POSITION_MACRO $FIRST_POSITION # 2
pos1:
	SUBSTRACT_MACRO $FIRST_VALUE # 10

	movl 16(%ebp), %edx # n
	SCALE_POSITION_MACRO $SECOND_POSITION # 4
pos2:
	SUBSTRACT_MACRO $SECOND_VALUE # 127

	movl 16(%ebp), %edx # n
	SCALE_POSITION_MACRO $THIRD_POSITION # 7
pos3:
	movl 16(%ebp), %edx # n
	SUBSTRACT_MACRO $THIRD_VALUE # 21

	popl %edi
	popl %esi
	popl %ebx

	leave
	ret
