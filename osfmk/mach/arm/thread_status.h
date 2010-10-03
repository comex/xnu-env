#ifndef	_MACH_ARM_THREAD_STATUS_H_
#define _MACH_ARM_THREAD_STATUS_H_

#define ARM_THREAD_STATE        1
#define THREAD_STATE_NONE       2

typedef struct arm_thread_state {
	unsigned int r[12];
	unsigned int ip;
	unsigned int sp;
	unsigned int lr;
	unsigned int pc;
	unsigned int cpsr;
} arm_thread_state_t;

#define ARM_THREAD_STATE_COUNT \
   (sizeof(struct arm_thread_state) / sizeof(int))

#endif /* _MACH_ARM_THREAD_STATUS_H_ */
