/*
 * CDDL HEADER START
 *
 * The contents of this file are subject to the terms of the
 * Common Development and Distribution License, Version 1.0 only
 * (the "License").  You may not use this file except in compliance
 * with the License.
 *
 * You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
 * or http://www.opensolaris.org/os/licensing.
 * See the License for the specific language governing permissions
 * and limitations under the License.
 *
 * When distributing Covered Code, include this CDDL HEADER in each
 * file and include the License file at usr/src/OPENSOLARIS.LICENSE.
 * If applicable, add the following below this CDDL HEADER, with the
 * fields enclosed by brackets "[]" replaced with your own identifying
 * information: Portions Copyright [yyyy] [name of copyright owner]
 *
 * CDDL HEADER END
 */
/*
 * Copyright 2004 Sun Microsystems, Inc.  All rights reserved.
 * Use is subject to license terms.
 */

#ifndef _MACH_I386_SDT_ISA_H
#define	_MACH_I386_SDT_ISA_H

/*
 * Only define when testing.  This makes the calls into actual calls to
 * test functions.
 */
/* #define DTRACE_CALL_TEST */

#define DTRACE_STRINGIFY(s) #s
#define DTRACE_TOSTRING(s) DTRACE_STRINGIFY(s)
#if defined(KERNEL)
/*
 * For the kernel, set an explicit global label so the symbol can be located
 */
#ifdef __x86_64__
#define DTRACE_LAB(p, n)		\
   "__dtrace_probeDOLLAR" DTRACE_TOSTRING(__LINE__) DTRACE_STRINGIFY(_##p##___##n)

#define DTRACE_LABEL(p, n)		\
      ".section __DATA, __data\n\t"	\
      ".globl " DTRACE_LAB(p, n) "\n\t"	\
       DTRACE_LAB(p, n) ":" ".quad 1f""\n\t"	\
       ".text" "\n\t"			\
	"1:"
#else
#define DTRACE_LAB(p, n)		\
   "__dtrace_probe$" DTRACE_TOSTRING(__LINE__) DTRACE_STRINGIFY(_##p##___##n)

#define DTRACE_LABEL(p, n)		\
      ".section __DATA, __data\n\t"	\
      ".globl " DTRACE_LAB(p, n) "\n\t"	\
       DTRACE_LAB(p, n) ":" ".long 1f""\n\t"	\
       ".text" "\n\t"			\
	"1:"
#endif
#else	/* !KERNEL */
#define DTRACE_LABEL(p, n)									\
	"__dtrace_probe$" DTRACE_TOSTRING(__LINE__) DTRACE_STRINGIFY(_##p##___##n) ":"	"\n\t"
#endif	/* !KERNEL */

#ifdef DTRACE_CALL_TEST

#define DTRACE_CALL(p,n)	\
	DTRACE_LABEL(p,n)	\
	DTRACE_CALL_INSN(p,n)

#else

#define DTRACE_CALL(p,n)	\
	DTRACE_LABEL(p,n)	\
	DTRACE_NOPS

#endif

#ifdef __x86_64__

#define DTRACE_NOPS			\
	"nop"			"\n\t"	\
	"nop"			"\n\t"	\
	"nop"			"\n\t"	

#define DTRACE_CALL_INSN(p,n)						\
	"call _dtracetest" DTRACE_STRINGIFY(_##p##_##n)	"\n\t"

#define ARG1_EXTENT	1
#define ARGS2_EXTENT	2
#define ARGS3_EXTENT	3
#define ARGS4_EXTENT	4
#define ARGS5_EXTENT	5
#define ARGS6_EXTENT	6
#define ARGS7_EXTENT	7
#define ARGS8_EXTENT	8
#define ARGS9_EXTENT	10	
#define ARGS10_EXTENT	10	

#define DTRACE_CALL0ARGS(provider, name)							\

#define DTRACE_CALL1ARG(provider, name)								\

#define DTRACE_CALL2ARGS(provider, name)							\

#define DTRACE_CALL3ARGS(provider, name)							\

#define DTRACE_CALL4ARGS(provider, name)							\

#define DTRACE_CALL5ARGS(provider, name)							\

#define DTRACE_CALL6ARGS(provider, name)							\

#define DTRACE_CALL7ARGS(provider, name)							\

#endif // __x86_64__

#ifdef __i386__

#define DTRACE_NOPS			\
	"nop"			"\n\t"	\
	"mov r0, r0" "\n\t" \

#define DTRACE_CALL_INSN(p,n)						\
	"blx _dtracetest" DTRACE_STRINGIFY(_##p##_##n)	"\n\t"

#define ARG1_EXTENT	1
#define ARGS2_EXTENT	2
#define ARGS3_EXTENT	4
#define ARGS4_EXTENT	4
#define ARGS5_EXTENT	8
#define ARGS6_EXTENT	8
#define ARGS7_EXTENT	8
#define ARGS8_EXTENT	8
#define ARGS9_EXTENT	12	
#define ARGS10_EXTENT	12	

/*
 * Because this code is used in the kernel, we must not touch any floating point
 * or specialized registers. This leaves the following registers:
 *
 * eax ; volatile, safe to use
 * ebx ; PIC register, gcc error when used
 * ecx ; volatile, safe to use
 * edx ; volatile, safe to use
 * esi ; non-volatile, otherwise safe to use
 * edi ; non-volatile, otherwise safe to use
 *
 * Using any of the non volatile register causes a spill to stack which is almost
 * certainly a net performance loss. Also, note that the array ref (__dtrace_args)
 * consumes one free register. If all three of the volatile regs are used for load/store,
 * the compiler will spill a register to hold the array ref.
 *
 * The end result is that we only pipeline two loads/stores at a time. Blech.
 */

#define DTRACE_CALL0ARGS(provider, name)							\

#define DTRACE_CALL1ARG(provider, name)								\

#define DTRACE_CALL2ARGS(provider, name)							\

#define DTRACE_CALL3ARGS(provider, name)							\

#define DTRACE_CALL4ARGS(provider, name)							\

#define DTRACE_CALL5ARGS(provider, name)							\

#define DTRACE_CALL6ARGS(provider, name)							\

#define DTRACE_CALL7ARGS(provider, name)							\

#define DTRACE_CALL8ARGS(provider, name)							\

#define DTRACE_CALL9ARGS(provider, name)							\

#define DTRACE_CALL10ARGS(provider, name)							\

#endif // __i386__

#endif	/* _MACH_I386_SDT_ISA_H */
