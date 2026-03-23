#ifndef _USER_PROC_H_
#define _USER_PROC_H_

#include <types.h>

pid_t spawn(uintptr_t exe, unsigned int quota);pid_t spawn_with_fds(uintptr_t exec, unsigned int quota, int stdin_fd, int stdout_fd);void  yield(void);
void  produce(void);
void  consume(void);

#endif /* !_USER_PROC_H_ */
