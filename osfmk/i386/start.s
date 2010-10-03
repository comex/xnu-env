/*
 * Copyright (c) 2000 Apple Computer, Inc. All rights reserved.
 *
 * @APPLE_OSREFERENCE_LICENSE_HEADER_START@
 * 
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. The rights granted to you under the License
 * may not be used to create, or enable the creation or redistribution of,
 * unlawful or unlicensed copies of an Apple operating system, or to
 * circumvent, violate, or enable the circumvention or violation of, any
 * terms of an Apple operating system software license agreement.
 * 
 * Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this file.
 * 
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 * 
 * @APPLE_OSREFERENCE_LICENSE_HEADER_END@
 */
/*
 * @OSF_COPYRIGHT@
 */
/* 
 * Mach Operating System
 * Copyright (c) 1991,1990 Carnegie Mellon University
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
/*
 */

#include <platforms.h>

#include <i386/asm.h>
#include <i386/proc_reg.h>
#include <i386/postcode.h>
#include <assym.s>

#define	CX(addr,reg)	addr(,reg,4)

#include <i386/lapic.h>
#include <i386/acpi.h>
#include <i386/cpuid.h>

/*
 * Interrupt and bootup stack for initial processor.
 */

/* in the __HIB section since the hibernate restore code uses this stack. */
	.section __HIB, __data
	.align	12

	.globl	EXT(low_intstack)
EXT(low_intstack):
	.globl  EXT(gIOHibernateRestoreStack)
EXT(gIOHibernateRestoreStack):

	.set	., .+INTSTACK_SIZE

	.globl	EXT(low_eintstack)
EXT(low_eintstack:)
	.globl  EXT(gIOHibernateRestoreStackEnd)
EXT(gIOHibernateRestoreStackEnd):

/*
 * Pointers to GDT and IDT.  These contain linear addresses.
 */
	.align	ALIGN
	.globl	EXT(gdtptr)
	/* align below properly */
	.word	0 
LEXT(gdtptr)
	.word	Times(8,GDTSZ)-1
	.long	EXT(master_gdt)

	/* back to the regular __DATA section. */

	.section __DATA, __data

/*
 * Stack for last-gasp double-fault handler.
 */
	.align	12
	.globl	EXT(df_task_stack)
EXT(df_task_stack):
	.set	., .+INTSTACK_SIZE
	.globl	EXT(df_task_stack_end)
EXT(df_task_stack_end):


/*
 * Stack for machine-check handler.
 */
	.align	12
	.globl	EXT(mc_task_stack)
EXT(mc_task_stack):
	.set	., .+INTSTACK_SIZE
	.globl	EXT(mc_task_stack_end)
EXT(mc_task_stack_end):

#if	MACH_KDB
/*
 * Kernel debugger stack for each processor.
 */
	.align	12
	.globl	EXT(db_stack_store)
EXT(db_stack_store):
	.set	., .+(INTSTACK_SIZE*MAX_CPUS)

/*
 * Stack for last-ditch debugger task for each processor.
 */
	.align	12
	.globl	EXT(db_task_stack_store)
EXT(db_task_stack_store):
	.set	., .+(INTSTACK_SIZE*MAX_CPUS)

/*
 * per-processor kernel debugger stacks
 */
        .align  ALIGN
        .globl  EXT(kgdb_stack_store)
EXT(kgdb_stack_store):
        .set    ., .+(INTSTACK_SIZE*MAX_CPUS)
#endif	/* MACH_KDB */


	
/*
 * BSP CPU start here.
 *	eax points to kernbootstruct
 *
 * Environment:
 *	protected mode, no paging, flat 32-bit address space.
 *	(Code/data/stack segments have base == 0, limit == 4G)
 */
	.text
	.align	ALIGN
	.globl	EXT(_start)
LEXT(_start)
