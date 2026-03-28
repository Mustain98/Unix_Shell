//
// File descriptors
//

#include <kern/lib/types.h>
#include <kern/lib/debug.h>
#include <kern/lib/spinlock.h>
#include <kern/lib/thread.h>
#include <kern/dev/console.h>
#include <kern/thread/PTCBIntro/export.h>
#include "params.h"
#include "stat.h"
#include "dinode.h"
#include "inode.h"
#include "file.h"

struct {
  spinlock_t lock;
  struct file file[NFILE];
} ftable;

// Pipe cache
#define NPIPE 10
struct {
  spinlock_t lock;
  struct pipe pipe[NPIPE];
} pipe_cache;

void
file_init(void)
{
  spinlock_init(&ftable.lock);
  spinlock_init(&pipe_cache.lock);
}

/**
 * Allocate a file structure.
 */
struct file*
file_alloc(void)
{
  struct file *f;

  spinlock_acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      spinlock_release(&ftable.lock);
      return f;
    }
  }
  spinlock_release(&ftable.lock);
  return 0;
}

/**
 * Increment ref count for file f.
 */
struct file*
file_dup(struct file *f)
{
  spinlock_acquire(&ftable.lock);
  if(f->ref < 1)
    KERN_PANIC("file_dup");
  f->ref++;
  spinlock_release(&ftable.lock);
  return f;
}

/**
 * Close file f.  (Decrement ref count, close when reaches 0.)
 */
void
file_close(struct file *f)
{
  struct file ff;

  spinlock_acquire(&ftable.lock);
  if(f->ref < 1)
    KERN_PANIC("file_close");
  if(--f->ref > 0){
    spinlock_release(&ftable.lock);
    return;
  }
  ff = *f;
  f->ref = 0;
  f->type = FD_NONE;
  spinlock_release(&ftable.lock);
  
  if(ff.type == FD_PIPE){
    pipe_close(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE){
    begin_trans();
    inode_put(ff.ip);
    commit_trans();
  }
}

/**
 * Get metadata about file f.
 */
int
file_stat(struct file *f, struct file_stat *st)
{
  if(f->type == FD_INODE){
    inode_lock(f->ip);
    inode_stat(f->ip, st);
    inode_unlock(f->ip);
    return 0;
  }
  return -1;
}

/**
 * Read from file f.
 */
int
file_read(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
  
  if(f->type == FD_PIPE){
    r = pipe_read(f->pipe, addr, n);
    return r;
  }
  
  if(f->type == FD_CONSOLE_IN){
    r = console_read(addr, n);
    return r;
  }
  
  if(f->type == FD_INODE){
    inode_lock(f->ip);
    if((r = inode_read(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    inode_unlock(f->ip);
    return r;
  }
  
  KERN_PANIC("file_read");
}

/**
 * Write to file f.
 */
int
file_write(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
  
  if(f->type == FD_PIPE){
    r = pipe_write(f->pipe, addr, n);
    return r;
  }
  
  if(f->type == FD_CONSOLE_OUT){
    r = console_write(addr, n);
    return r;
  }
  
  if(f->type == FD_INODE){
    // Write a few blocks at a time to avoid exceeding
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since inode_write()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_trans();
      inode_lock(f->ip);
      if ((r = inode_write(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      inode_unlock(f->ip);
      commit_trans();

      if(r < 0)
        break;
      if(r != n1)
        KERN_PANIC("short file_write");
      i += r;
    }
    return i == n ? n : -1;
  }
  KERN_PANIC("file_write");
}

//
// Pipe implementation
//

int
pipe_alloc(struct file **f0, struct file **f1)
{
  struct pipe *p;
  int i;
  
  p = 0;
  *f0 = *f1 = 0;
  
  // Allocate two file structures
  if((*f0 = file_alloc()) == 0 || (*f1 = file_alloc()) == 0)
    goto bad;
  
  // Allocate pipe structure from cache
  spinlock_acquire(&pipe_cache.lock);
  for(i = 0; i < NPIPE; i++){
    if(pipe_cache.pipe[i].ref == 0){
      p = &pipe_cache.pipe[i];
      p->ref = 2;
      p->readopen = 1;
      p->writeopen = 1;
      p->nwrite = 0;
      p->nread = 0;
      break;
    }
  }
  spinlock_release(&pipe_cache.lock);
  
  if(p == 0)
    goto bad;
  
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  
  return 0;

bad:
  if(*f0)
    file_close(*f0);
  if(*f1)
    file_close(*f1);
  return -1;
}

void
pipe_close(struct pipe *p, int writable)
{
  spinlock_acquire(&pipe_cache.lock);
  if(writable){
    p->writeopen = 0;
    thread_wakeup(&p->nread);
  } else {
    p->readopen = 0;
    thread_wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    p->ref = 0;
  }
  spinlock_release(&pipe_cache.lock);
}

int
pipe_write(struct pipe *p, char *addr, int n)
{
  int i;

  spinlock_acquire(&pipe_cache.lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  // pipe is full
      if(p->readopen == 0){
        spinlock_release(&pipe_cache.lock);
        return -1;
      }
      thread_wakeup(&p->nread);
      thread_sleep(&p->nwrite, &pipe_cache.lock);
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  thread_wakeup(&p->nread);
  spinlock_release(&pipe_cache.lock);
  return n;
}

int
pipe_read(struct pipe *p, char *addr, int n)
{
  int i;

  spinlock_acquire(&pipe_cache.lock);
  while(p->nread == p->nwrite && p->writeopen){  // pipe is empty
    thread_sleep(&p->nread, &pipe_cache.lock);
  }
  for(i = 0; i < n; i++){
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  thread_wakeup(&p->nwrite);
  spinlock_release(&pipe_cache.lock);
  return i;
}

//
// Console implementation
//

int
console_read(char *addr, int n)
{
  int i = 0;
  char c;
  
  while(i < n){
    // Read one character at a time from console
    while((c = cons_getc()) == 0){
      // Enable interrupts while waiting so keyboard strokes can be buffered
      intr_local_enable();
      // Yield CPU while waiting for input
      thread_yield();
    }
    
    // Process Backspace
    if (c == 0x08 || c == 0x7f) {
      if (i > 0) {
        i--;
        cons_putc('\b');
        cons_putc(' ');
        cons_putc('\b');
      }
      continue;
    }

    // Process EOF / Interrupt (Ctrl+D = 0x04, Ctrl+C = 0x03)
    if (c == 0x04) {
      return i; // return bytes read so far. 0 if empty -> EOF.
    }
    if (c == 0x03) {
      cons_putc('^');
      cons_putc('C');
      cons_putc('\n');
      return 0; // Abort line, return EOF.
    }
    
    // Convert carriage return to newline for proper UNIX terminal behavior
    if (c == '\r') {
      c = '\n';
    }

    // Echo the character back to console
    cons_putc(c);
    
    addr[i++] = c;
    
    // Stop at newline (return count includes the newline)
    if(c == '\n')
      return i;
  }
  
  return i;
}

int
console_write(char *addr, int n)
{
  int i;
  
  for(i = 0; i < n; i++){
    cons_putc(addr[i]);
  }
  
  return n;
}

void
console_init_fds(unsigned int pid)
{
  struct file *f_stdin, *f_stdout, *f_stderr;
  
  // Allocate stdin (FD 0)
  f_stdin = file_alloc();
  if(f_stdin){
    f_stdin->type = FD_CONSOLE_IN;
    f_stdin->readable = 1;
    f_stdin->writable = 0;
    f_stdin->ref = 1;
    tcb_set_openfiles(pid, 0, f_stdin);
  }
  
  // Allocate stdout (FD 1)
  f_stdout = file_alloc();
  if(f_stdout){
    f_stdout->type = FD_CONSOLE_OUT;
    f_stdout->readable = 0;
    f_stdout->writable = 1;
    f_stdout->ref = 1;
    tcb_set_openfiles(pid, 1, f_stdout);
  }
  
  // Allocate stderr (FD 2) - also console output
  f_stderr = file_alloc();
  if(f_stderr){
    f_stderr->type = FD_CONSOLE_OUT;
    f_stderr->readable = 0;
    f_stderr->writable = 1;
    f_stderr->ref = 1;
    tcb_set_openfiles(pid, 2, f_stderr);
  }
}

