/*
 * Copyright (c) 2000-2006 Apple Computer, Inc. All rights reserved.
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
 * ---------------------------------------------------------------------------
 * Copyright (c) 2002, Dr Brian Gladman, Worcester, UK.   All rights reserved.
 *
 * LICENSE TERMS
 *
 * The free distribution and use of this software in both source and binary
 * form is allowed (with or without changes) provided that:
 *
 *   1. distributions of this source code include the above copyright
 *      notice, this list of conditions and the following disclaimer;
 *
 *   2. distributions in binary form include the above copyright
 *      notice, this list of conditions and the following disclaimer
 *      in the documentation and/or other associated materials;
 *
 *   3. the copyright holder's name is not used to endorse products
 *      built using this software without specific written permission.
 *
 * ALTERNATIVELY, provided that this notice is retained in full, this product
 * may be distributed under the terms of the GNU General Public License (GPL),
 * in which case the provisions of the GPL apply INSTEAD OF those given above.
 *
 * DISCLAIMER
 *
 * This software is provided 'as is' with no explicit or implied warranties
 * in respect of its properties, including, but not limited to, correctness
 * and/or fitness for purpose.
 * ---------------------------------------------------------------------------
 * Issue 31/01/2006
 *
 * This code requires either ASM_X86_V2 or ASM_X86_V2C to be set in aesopt.h 
 * and the same define to be set here as well. If AES_V2C is set this file 
 * requires the C files aeskey.c and aestab.c for support.
 *
 * This is a full assembler implementation covering encryption, decryption and
 * key scheduling. It uses 2k bytes of tables but its encryption and decryption
 * performance is very close to that obtained using large tables.  Key schedule
 * expansion is slower for both encryption and decryption but this is likely to
 * be offset by the much smaller load that this version places on the processor
 * cache. I acknowledge the contribution made by Daniel Bernstein to aspects of
 * the design of the AES round function used here.
 *
 * This code provides the standard AES block size (128 bits, 16 bytes) and the
 * three standard AES key sizes (128, 192 and 256 bits). It has the same call
 * interface as my C implementation. The ebx, esi, edi and ebp registers are
 * preserved across calls but eax, ecx and edx and the artihmetic status flags
 * are not.
 */

#include <mach/i386/asm.h>

Entry(aes_encrypt)
Entry(aes_encrypt_key128)
Entry(aes_encrypt_key192)
Entry(aes_encrypt_key256)
Entry(aes_encrypt_key)
Entry(aes_decrypt)
Entry(aes_decrypt_key128)
Entry(aes_decrypt_key192)
Entry(aes_decrypt_key256)
Entry(aes_decrypt_key)
