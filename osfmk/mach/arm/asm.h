/*
 * Copyright (c) 2007 Apple Inc. All rights reserved.
 */
/*
 * @OSF_COPYRIGHT@
 */
/* 
 * Mach Operating System
 * Copyright (c) 1991,1990,1989 Carnegie Mellon University
 * All Rights Reserved.
 * 
 * Permission to use, copy, modify and distribute this software and its
 * documentation is hereby granted, provided that both the copyright
 * notice and this permission notice appear in all copies of the
 * software, derivative works or modified versions, and any portions
 * thereof, and that both notices appear in supporting documentation.
 * 
 * CARNEGIE MELLON ALLOWS FREE USE OF THIS SOFTWARE IN ITS "AS IS"
 * CONDITION.  CARNEGIE MELLON DISCLAIMS ANY LIABILITY OF ANY KIND FOR
 * ANY DAMAGES WHATSOEVER RESULTING FROM THE USE OF THIS SOFTWARE.
 * 
 * Carnegie Mellon requests users of this software to return to
 * 
 *  Software Distribution Coordinator  or  Software.Distribution@CS.CMU.EDU
 *  School of Computer Science
 *  Carnegie Mellon University
 *  Pittsburgh PA 15213-3890
 * 
 * any improvements or extensions that they make and grant Carnegie Mellon
 * the rights to redistribute these changes.
 */

#ifndef	_ARM_ASM_H_
#define	_ARM_ASM_H_

#include <arm/arch.h>

#ifdef _KERNEL
#include <gprof.h>
#endif	/* _KERNEL */

#ifdef MACH_KERNEL
#include <mach_kdb.h>
#else	/* !MACH_KERNEL */
#define	MACH_KDB 0
#endif	/* !MACH_KERNEL */


#if	defined(MACH_KERNEL) || defined(_KERNEL)
#include <gprof.h>
#endif	/* MACH_KERNEL || _KERNEL */


#define FRAME	pushl %ebp; movl %esp, %ebp
#define EMARF	leave


/* There is another definition of ALIGN for .c sources */
#ifdef ASSEMBLER
#define ALIGN 4
#endif /* ASSEMBLER */

#ifndef FALIGN
#define FALIGN ALIGN
#endif

#define LB(x,n) n
#if	__STDC__
#ifndef __NO_UNDERSCORES__
#define	LCL(x)	L ## x
#define EXT(x) _ ## x
#define LEXT(x) _ ## x ## :
#else
#define	LCL(x)	.L ## x
#define EXT(x) x
#define LEXT(x) x ## :
#endif
#define LBc(x,n) n ## :
#define LBb(x,n) n ## b
#define LBf(x,n) n ## f
#else /* __STDC__ */
#ifndef __NO_UNDERSCORES__
#define LCL(x) L/**/x
#define EXT(x) _/**/x
#define LEXT(x) _/**/x/**/:
#else /* __NO_UNDERSCORES__ */
#define	LCL(x)	.L/**/x
#define EXT(x) x
#define LEXT(x) x/**/:
#endif /* __NO_UNDERSCORES__ */
#define LBc(x,n) n/**/:
#define LBb(x,n) n/**/b
#define LBf(x,n) n/**/f
#endif /* __STDC__ */

#define String	.asciz
#define Value	.word
#define Times(a,b) (a*b)
#define Divide(a,b) (a/b)

#if 0 /* TOTOJK */
#ifdef __ELF__
#define ELF_FUNC(x)	.type x,@function
#define ELF_DATA(x)	.type x,@object
#define ELF_SIZE(x,s)	.size x,s
#else
#define ELF_FUNC(x)
#define ELF_DATA(x)
#define ELF_SIZE(x,s)
#endif
#else
#define ELF_FUNC(x)
#define ELF_DATA(x)
#define ELF_SIZE(x,s)
#endif /* TODOJK */

#define	Entry(x)	.globl EXT(x); ELF_FUNC(EXT(x)); .align FALIGN; LEXT(x)
#define	ENTRY(x)	Entry(x) MCOUNT
#define	ENTRY2(x,y)	.globl EXT(x); .globl EXT(y); \
			ELF_FUNC(EXT(x)); ELF_FUNC(EXT(y)); \
			.align FALIGN; LEXT(x); LEXT(y) \
			MCOUNT
#if __STDC__
#define	ASENTRY(x) 	.globl x; .align FALIGN; x ## : ELF_FUNC(x) MCOUNT
#else
#define	ASENTRY(x) 	.globl x; .align FALIGN; x: ELF_FUNC(x) MCOUNT
#endif /* __STDC__ */

#define	DATA(x)		.globl EXT(x); ELF_DATA(EXT(x)); .align ALIGN; LEXT(x)

#define End(x)		ELF_SIZE(x,.-x)
#define END(x)		End(EXT(x))
#define ENDDATA(x)	END(x)
#define Enddata(x)	End(x)

#ifdef ASSEMBLER
#if	MACH_KDB
#include <ddb/stab.h>
/*
 * This pseudo-assembler line is added so that there will be at least
 *	one N_SO entry in the symbol stable to define the current file name.
 */
#endif	/* MACH_KDB */

#define MCOUNT

#else /* NOT ASSEMBLER */

/* These defines are here for .c files that wish to reference global symbols
 * within __asm__ statements. 
 */
#ifndef __NO_UNDERSCORES__
#define CC_SYM_PREFIX "_"
#else
#define CC_SYM_PREFIX ""
#endif /* __NO_UNDERSCORES__ */
#endif /* ASSEMBLER */

#ifdef ASSEMBLER

#if defined (_ARM_ARCH_4T)
# define RET    bx      lr
# define RETeq  bxeq    lr
# define RETne  bxne    lr
# ifdef __STDC__
#  define RETc(c) bx##c lr
# else
#  define RETc(c) bx/**/c       lr
# endif
#else
# define RET    mov     pc, lr
# define RETeq  moveq   pc, lr
# define RETne  movne   pc, lr
# ifdef __STDC__
#  define RETc(c) mov##c        pc, lr
# else
#  define RETc(c) mov/**/c      pc, lr
# endif
#endif

#if defined (__thumb__)
# define BRANCH_EXTERN(x)	ldr	pc, [pc, #-4] ;	\
				.long	EXT(x)
#else
# define BRANCH_EXTERN(x)	b	EXT(x)
#endif

#endif /* ASSEMBLER */

#endif /* _ARM_ASM_H_ */
