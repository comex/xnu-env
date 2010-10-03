/*
 * Copyright (c) 2006 Apple Computer, Inc. All rights reserved.
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

#include <platforms.h>
#include <mach_kdb.h>

#include <i386/asm.h>
#include <i386/asm64.h>
#include <i386/proc_reg.h>
#include <i386/postcode.h>
#include <assym.s>

	.data
	.align 3
	.globl EXT(gdtptr64)
	/* align below right */
	.word	0
LEXT(gdtptr64)
	.word	Times(8,GDTSZ)-1
	/* XXX really want .quad here */
	.long	EXT(master_gdt)
	.long	KERNEL_UBER_BASE_HI32  /* must be in uber-space */

	.align 3
	.globl EXT(idtptr64)
	/* align below right */
	.word	0
LEXT(idtptr64)
	.word	Times(16,IDTSZ)-1
	/* XXX really want .quad here */
	.long	EXT(master_idt64)
	.long	KERNEL_UBER_BASE_HI32  /* must be in uber-space */

	.text

Entry(ml_load_desc64)

Entry(ml_64bit_lldt)
Entry(set_64bit_debug_regs)
Entry(flush_tlb64)
Entry(set64_cr3)
Entry(get64_cr3)

/* FXSAVE and FXRSTOR operate in a mode dependent fashion, hence these variants.
 * Must be called with interrupts disabled.
 */

Entry(fxsave64)
Entry(fxrstor64)

Entry(cpuid64)
