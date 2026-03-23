/*
 * CAT -- concatenate and print files (or stdin).
 *
 * Runs as a separate process.  fd 0 is either the console, a file opened
 * by the shell, or the read-end of a pipe.  fd 1 may be the write-end of
 * a pipe.  We close fd 1 when done so the next pipeline stage gets EOF.
 *
 * Usage (via shell pipeline infrastructure):
 *   CAT          -- copy stdin to stdout
 *   CAT filename -- shell opens file and passes it as stdin_fd to spawn
 */
#include <stdio.h>
#include <syscall.h>
#include <file.h>
#include <string.h>

#define BUFSIZE 512

int main(int argc, char **argv)
{
    char buf[BUFSIZE];
    int  fd, n, i;

    if (argc <= 1) {
        /*
         * No filename argument: read from stdin (fd 0).
         * In a pipeline the shell has already pointed fd 0 at the
         * pipe read-end or at an opened file via spawn_with_fds().
         */
        while ((n = sys_read(0, buf, sizeof(buf))) > 0)
            sys_write(1, buf, n);
    } else {
        /* File arguments: open each one and copy to stdout. */
        for (i = 1; i < argc; i++) {
            fd = sys_open(argv[i], O_RDONLY);
            if (fd < 0) {
                printf("CAT: cannot open %s\n", argv[i]);
                continue;
            }
            while ((n = sys_read(fd, buf, sizeof(buf))) > 0)
                sys_write(1, buf, n);
            sys_close(fd);
        }
    }

    /*
     * CRITICAL: close stdout (the pipe write-end) so the next pipeline
     * stage receives EOF and terminates cleanly.
     */
    sys_close(1);
    return 0;
}
