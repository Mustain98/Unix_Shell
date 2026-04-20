/*
 * ROT13 -- apply ROT13 cipher to stdin, write result to stdout.
 *
 * Runs as a separate process.  fd 0 is the read-end of a pipe (or console),
 * fd 1 is the write-end of a pipe (or console).  We close both when done
 * so adjacent pipeline stages receive their EOF signals cleanly.
 *
 * ROT13 is its own inverse: applying it twice restores the original text.
 * Non-alphabetic characters (digits, spaces, punctuation) pass through
 * unchanged.
 */
#include <stdio.h>
#include <syscall.h>

#define BUFSIZE 512

/* Rotate a single character by 13 positions within its case band. */
static char rot13_char(char c)
{
    if (c >= 'a' && c <= 'z')
        return 'a' + ((c - 'a' + 13) % 26);
    if (c >= 'A' && c <= 'Z')
        return 'A' + ((c - 'A' + 13) % 26);
    return c;   /* non-alpha: pass through */
}

int main(int argc, char **argv)
{
    char buf[BUFSIZE];
    int  n, i;

    /* Read from stdin, apply ROT13 in-place, write to stdout. */
    while ((n = sys_read(0, buf, sizeof(buf))) > 0) {
        for (i = 0; i < n; i++)
            buf[i] = rot13_char(buf[i]);
        sys_write(1, buf, n);
    }

    /*
     * CRITICAL: close both ends so upstream writers and downstream readers
     * in a multi-stage pipeline (e.g.  LS | CAT | ROT13) all get EOF.
     */
    sys_close(1);
    sys_close(0);
    return 0;
}
