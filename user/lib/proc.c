#include <proc.h>
#include <syscall.h>
#include <types.h>

pid_t
spawn(uintptr_t exec, unsigned int quota)
{
	// Default: inherit console stdin/stdout
	return sys_spawn(exec, quota, -1, -1);
}

pid_t
spawn_with_fds(uintptr_t exec, unsigned int quota, int stdin_fd, int stdout_fd)
{
	return sys_spawn(exec, quota, stdin_fd, stdout_fd);
}

void
yield(void)
{
	sys_yield();
}

void
produce(void)
{
	sys_produce();
}

void
consume(void)
{
	sys_consume();
}

