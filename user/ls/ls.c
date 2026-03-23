/*
 * LS -- list current directory, one entry per line.
 *
 * Runs as a separate process.  stdout (fd 1) may be the write-end of a
 * pipe when used in a pipeline (e.g.  LS | ROT13).  We must explicitly
 * close fd 1 when done so the reader receives EOF; the entry.S spin-loop
 * keeps this process alive but yields, so the kernel never auto-closes fds.
 */
#include <stdio.h>
#include <syscall.h>

#define BUFSIZE 1024

int main(int argc, char **argv)
{
    char buf[BUFSIZE];
    int  n, i;

    n = sys_ls(buf, sizeof(buf) - 1);
    if (n <= 0) {
        /* nothing to list — close stdout and exit */
        sys_close(1);
        return 0;
    }

    /* sys_ls returns space-separated names; write one per line */
    i = 0;
    while (i < n) {
        int start = i;
        /* find end of this token */
        while (i < n && buf[i] != ' ' && buf[i] != '\0')
            i++;
        /* write the token */
        if (i > start)
            sys_write(1, buf + start, i - start);
        /* newline after each entry */
        sys_write(1, "\n", 1);
        /* skip the space separator */
        while (i < n && (buf[i] == ' ' || buf[i] == '\0'))
            i++;
    }

    /*
     * CRITICAL: close stdout (the pipe write-end) so the next pipeline
     * stage (e.g. ROT13) receives EOF and terminates cleanly.
     */
    sys_close(1);
    return 0;
}
