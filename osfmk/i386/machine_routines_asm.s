/*
 * Copyright (c) 2000-2010 Apple Inc. All rights reserved.
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
 
#include <i386/asm.h>
#include <i386/rtclock.h>
#include <i386/proc_reg.h>
#include <i386/eflags.h>
       
#include <i386/postcode.h>
#include <i386/apic.h>
#include <assym.s>

/*
**      ml_get_timebase()
**
**      Entry   - %esp contains pointer to 64 bit structure.
**
**      Exit    - 64 bit structure filled in.
**
*/
ENTRY(ml_get_timebase)

			.globl	EXT(tmrCvt)
			.align FALIGN

LEXT(tmrCvt)
			.globl	EXT(_rtc_nanotime_store)
			.align	FALIGN

LEXT(_rtc_nanotime_store)


/* void  _rtc_nanotime_adjust(	
		uint64_t         tsc_base_delta,
	        rtc_nanotime_t  *dst);
*/
	.globl	EXT(_rtc_nanotime_adjust)
	.align	FALIGN

LEXT(_rtc_nanotime_adjust)
	mov	12(%esp),%edx			/* ptr to rtc_nanotime_info */
	
	movl	RNT_GENERATION(%edx),%ecx	/* get current generation */
	movl	$0,RNT_GENERATION(%edx)		/* flag data as being updated */

	movl	4(%esp),%eax			/* get lower 32-bits of delta */
	addl	%eax,RNT_TSC_BASE(%edx)
	adcl	$0,RNT_TSC_BASE+4(%edx)		/* propagate carry */

	incl	%ecx				/* next generation */
	jnz	1f
	incl	%ecx				/* skip 0, which is a flag */
1:	movl	%ecx,RNT_GENERATION(%edx)	/* update generation and make usable */

	ret


/* unint64_t _rtc_nanotime_read( rtc_nanotime_t *rntp, int slow );
 *
 * This is the same as the commpage nanotime routine, except that it uses the
 * kernel internal "rtc_nanotime_info" data instead of the commpage data.  The two copies
 * of data (one in the kernel and one in user space) are kept in sync by rtc_clock_napped().
 *
 * Warning!  There is another copy of this code in osfmk/i386/locore.s.  The
 * two versions must be kept in sync with each other!
 *
 * There are actually two versions of the algorithm, one each for "slow" and "fast"
 * processors.  The more common "fast" algorithm is:
 *
 *	nanoseconds = (((rdtsc - rnt_tsc_base) * rnt_tsc_scale) / 2**32) - rnt_ns_base;
 *
 * Of course, the divide by 2**32 is a nop.  rnt_tsc_scale is a constant computed during initialization:
 *
 *	rnt_tsc_scale = (10e9 * 2**32) / tscFreq;
 *
 * The "slow" algorithm uses long division:
 *
 *	nanoseconds = (((rdtsc - rnt_tsc_base) * 10e9) / tscFreq) - rnt_ns_base;
 *
 * Since this routine is not synchronized and can be called in any context, 
 * we use a generation count to guard against seeing partially updated data.  In addition,
 * the _rtc_nanotime_store() routine -- just above -- zeroes the generation before
 * updating the data, and stores the nonzero generation only after all other data has been
 * stored.  Because IA32 guarantees that stores by one processor must be seen in order
 * by another, we can avoid using a lock.  We spin while the generation is zero.
 *
 * In accordance with the ABI, we return the 64-bit nanotime in %edx:%eax.
 */
 
		.globl	EXT(_rtc_nanotime_read)
		.align	FALIGN
LEXT(_rtc_nanotime_read)
