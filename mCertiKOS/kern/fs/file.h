// On-disk file system format. 

// Block 0 is unused.
// Block 1 is super block.
// Blocks 2 through sb.ninodes/IPB hold inodes.
// Then free bitmap blocks holding sb.size bits.
// Then sb.nblocks data blocks.
// Then sb.nlog log blocks.

#ifndef _KERN_FS_FILE_H_
#define _KERN_FS_FILE_H_

#include "stat.h"
#include "inode.h"

// Pipe buffer size
#define PIPESIZE 512

// Pipe structure for inter-process communication
struct pipe {
  int ref;                  // reference count
  char data[PIPESIZE];      // data buffer
  uint32_t nread;           // number of bytes read
  uint32_t nwrite;          // number of bytes written
  int readopen;             // read fd is still open
  int writeopen;            // write fd is still open
};

struct file {
  enum { FD_NONE, FD_PIPE, FD_INODE, FD_CONSOLE_IN, FD_CONSOLE_OUT } type;
  int ref; // reference count
  int8_t readable;
  int8_t writable;
  struct pipe *pipe;
  struct inode *ip;
  uint32_t off;
};

void file_init(void);

// Allocate a file structure.
struct file* file_alloc(void);

// Increment ref count for file f.
struct file* file_dup(struct file *f);

// Close file f.  (Decrement ref count, close when reaches 0.)
void file_close(struct file *f);

// Get metadata about file f.
int file_stat(struct file *f, struct file_stat *st);

// Read from file f.
int file_read(struct file *f, char *addr, int n);

// Write to file f.
int file_write(struct file *f, char *addr, int n);

// Pipe operations
int pipe_alloc(struct file **f0, struct file **f1);
void pipe_close(struct pipe *p, int writable);
int pipe_write(struct pipe *p, char *addr, int n);
int pipe_read(struct pipe *p, char *addr, int n);

// Console operations
int console_read(char *addr, int n);
int console_write(char *addr, int n);

// Initialize console file descriptors for a process
void console_init_fds(unsigned int pid);

#define CONSOLE 1

#endif /* !_KERN_FS_FILE_H_ */
