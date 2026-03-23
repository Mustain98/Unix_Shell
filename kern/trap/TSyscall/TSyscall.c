#include <lib/string.h>
#include <lib/trap.h>
#include <lib/syscall.h>
#include <lib/debug.h>
#include <lib/x86.h>
#include <lib/thread.h>
#include <dev/intr.h>
#include <pcpu/PCPUIntro/export.h>
#include <vmm/MPTOp/export.h>
#include <thread/PThread/export.h>
#include <thread/PTQueueInit/export.h>
#include <lib/signal.h>
#include <thread/PTCBIntro/export.h>
#include <thread/PCurID/export.h>
#include <kern/fs/file.h>
#include <kern/fs/inode.h>
#include <kern/fs/dir.h>
#include <kern/fs/stat.h>
#include <kern/fs/path.h>
#include <kern/fs/params.h>
#include <lib/ipc.h>
#include <lib/monitor.h>

#include "import.h"

extern struct MsgBlock msgBlock[NUM_IDS];
extern spinlock_t msg_lock;

// recv_id, user_buffer_addr, length
void sys_sync_send(tf_t *tf){
   unsigned int cur_pid;
   unsigned int recv_pid, user_addr, length;
//   spinlock_acquire(&msg_lock);
   recv_pid = syscall_get_arg2(tf);
   user_addr = syscall_get_arg3(tf);
   length = syscall_get_arg4(tf);
   cur_pid = get_curid();
   msgBlock[cur_pid].recv_pid = recv_pid;
   msgBlock[cur_pid].buffer_addr = user_addr;
   msgBlock[cur_pid].length = length;
   msg_enqueue(cur_pid);
   thread_wakeup(&msgBlock[cur_pid].send_cv);
   // cur_pid has not been read, block and wait for it
   while(msg_getBlockBySendID(cur_pid) != NUM_IDS){
      thread_sleep(&msgBlock[cur_pid].recv_cv, &msg_lock);
   }
   syscall_set_errno(tf, E_SUCC);
//   spinlock_release(&msg_lock);
   return ;
}

void sys_sync_recv(tf_t *tf){
   unsigned int cur_pid;
   unsigned int send_pid, user_recv_addr, recv_length, send_length, copy_length, user_send_addr;
//   spinlock_acquire(&msg_lock);

   send_pid = syscall_get_arg2(tf);
   user_recv_addr = syscall_get_arg3(tf);
   recv_length = syscall_get_arg4(tf);
   cur_pid = get_curid();

   // loop if current pid has no received message or received message is not sent from target process
   while(msg_getBlockBySendID(send_pid) == NUM_IDS || msgBlock[send_pid].recv_pid != cur_pid){
      thread_sleep(&msgBlock[send_pid].send_cv, &msg_lock);
   }
   // message received
   user_send_addr = msgBlock[send_pid].buffer_addr;
   send_length = msgBlock[send_pid].length;

   // find the min of send_length and recv_length, then copy data from source process addressing space to dest process addressing space
   copy_length = send_length < recv_length? send_length: recv_length;
   ipc_copy(cur_pid, user_recv_addr, send_pid, user_send_addr, copy_length);
   msg_remove(send_pid);
   thread_wakeup(&msgBlock[send_pid].recv_cv);
   syscall_set_errno(tf, E_SUCC);
   syscall_set_retval1(tf, copy_length);
//   spinlock_release(&msg_lock);
   return ;
}

char sys_buf[NUM_IDS][PAGESIZE];

extern uint8_t _binary___obj_user_pingpong_ping_start[];
extern uint8_t _binary___obj_user_pingpong_pong_start[];
extern uint8_t _binary___obj_user_pingpong_ding_start[];
extern uint8_t _binary___obj_user_fstest_fstest_start[];
extern uint8_t _binary___obj_user_shell_shell_start[];
extern uint8_t _binary___obj_user_cat_cat_start[];
extern uint8_t _binary___obj_user_rot13_rot13_start[];
extern uint8_t _binary___obj_user_echo_echo_start[];
extern uint8_t _binary___obj_user_ls_ls_start[];
/**
 * Spawns a new child process.
 * The user level library function sys_spawn (defined in user/include/syscall.h)
 * takes four arguments: [elf_id], [quota], [stdin_fd], and [stdout_fd].
 * Returns the new child process id or NUM_IDS (as failure), with appropriate error number.
 * 
 * Parameters:
 *   elf_id: The identifier of the ELF image
 *     1=ping, 2=pong, 3=ding, 4=fstest, 5=shell, 6=cat, 7=rot13, 8=echo, 9=ls
 *   quota: Resource quota for the new process
 *   stdin_fd: File descriptor to use as stdin (FD 0) in child, or -1 to inherit console
 *   stdout_fd: File descriptor to use as stdout (FD 1) in child, or -1 to inherit console
 */
void sys_spawn(tf_t *tf)
{
  unsigned int new_pid;
  unsigned int elf_id, quota;
  int stdin_fd, stdout_fd;
  void *elf_addr;
  unsigned int qok, nc, curid;
  struct file **parent_fds, *f;

  elf_id = syscall_get_arg2(tf);
  quota = syscall_get_arg3(tf);
  stdin_fd = (int)syscall_get_arg4(tf);
  stdout_fd = (int)syscall_get_arg5(tf);

  curid = get_curid();
  qok = container_can_consume(curid, quota);
  nc = container_get_nchildren(curid);
  if (qok == 0) {
    syscall_set_errno(tf, E_EXCEEDS_QUOTA);
    syscall_set_retval1(tf, NUM_IDS);
    return;
  }
  else if (NUM_IDS < curid * MAX_CHILDREN + 1 + MAX_CHILDREN) {
    syscall_set_errno(tf, E_MAX_NUM_CHILDEN_REACHED);
    syscall_set_retval1(tf, NUM_IDS);
    return;
  }
  else if (nc == MAX_CHILDREN) {
    syscall_set_errno(tf, E_INVAL_CHILD_ID);
    syscall_set_retval1(tf, NUM_IDS);
    return;
  }

  if (elf_id == 1) {
    elf_addr = _binary___obj_user_pingpong_ping_start;
  } else if (elf_id == 2) {
    elf_addr = _binary___obj_user_pingpong_pong_start;
  } else if (elf_id == 3) {
    elf_addr = _binary___obj_user_pingpong_ding_start;
  } else if (elf_id == 4) {
    elf_addr = _binary___obj_user_fstest_fstest_start;
  } else if (elf_id == 5) {
    elf_addr = _binary___obj_user_shell_shell_start;
  } else if (elf_id == 6) {
    elf_addr = _binary___obj_user_cat_cat_start;
  } else if (elf_id == 7) {
    elf_addr = _binary___obj_user_rot13_rot13_start;
  } else if (elf_id == 8) {
    elf_addr = _binary___obj_user_echo_echo_start;
  } else if (elf_id == 9) {
    elf_addr = _binary___obj_user_ls_ls_start;
  } else {
    syscall_set_errno(tf, E_INVAL_PID);
    syscall_set_retval1(tf, NUM_IDS);
    return;
  }

  new_pid = proc_create(elf_addr, quota);

  if (new_pid == NUM_IDS) {
    syscall_set_errno(tf, E_INVAL_PID);
    syscall_set_retval1(tf, NUM_IDS);
    return;
  }
  
  // Inherit current working directory from parent so spawned commands behave like shell commands.
  if (tcb_get_cwd(curid) == NULL) {
    tcb_set_cwd(curid, inode_get(ROOTDEV, ROOTINO));
  }
  tcb_set_cwd(new_pid, inode_dup((struct inode*)tcb_get_cwd(curid)));


  // Set up file descriptors for the new process
  parent_fds = tcb_get_openfiles(curid);
  
  // Handle FD initialization based on parameters
  if (stdin_fd == -1 && stdout_fd == -1) {
    // Both default to console - initialize all console FDs
    console_init_fds(new_pid);
  } else {
    // Set up stdin (FD 0)
    if (stdin_fd >= 0 && stdin_fd < NOFILE && parent_fds[stdin_fd] != 0) {
      f = file_dup(parent_fds[stdin_fd]);
      tcb_set_openfiles(new_pid, 0, f);
    } else if (stdin_fd == -1) {
      // Use console input
      f = file_alloc();
      if(f){
        f->type = FD_CONSOLE_IN;
        f->readable = 1;
        f->writable = 0;
        f->ref = 1;
        tcb_set_openfiles(new_pid, 0, f);
      }
    }
    
    // Set up stdout (FD 1)
    if (stdout_fd >= 0 && stdout_fd < NOFILE && parent_fds[stdout_fd] != 0) {
      f = file_dup(parent_fds[stdout_fd]);
      tcb_set_openfiles(new_pid, 1, f);
    } else if (stdout_fd == -1) {
      // Use console output
      f = file_alloc();
      if(f){
        f->type = FD_CONSOLE_OUT;
        f->readable = 0;
        f->writable = 1;
        f->ref = 1;
        tcb_set_openfiles(new_pid, 1, f);
      }
    }
  }
  
  syscall_set_errno(tf, E_SUCC);
  syscall_set_retval1(tf, new_pid);
}

/**
 * Yields to another thread/process.
 * The user level library function sys_yield (defined in user/include/syscall.h)
 * does not take any argument and does not have any return values.
 * Do not forget to set the error number as E_SUCC.
 */
void sys_yield(tf_t *tf)
{
  thread_yield();
  syscall_set_errno(tf, E_SUCC);
}
void sys_is_dir(tf_t * tf){
  int fd, type, isDir;
  struct file * fp;
  fd = syscall_get_arg2(tf);
  fp = tcb_get_openfiles(get_curid())[fd];
  if(fp == 0 || fp->ip == 0){
    KERN_INFO("kern/trap/TSyscall/TSyscall:sys_is_dir: fp illegal\n");
    syscall_set_retval1(tf, -1);
    syscall_set_errno(tf, E_BADF);
    return ;
  }
  type = fp->ip->type;
  isDir = (type == T_DIR);
  syscall_set_errno(tf, E_SUCC);
  syscall_set_retval1(tf, isDir);
}

void sys_ls(tf_t *tf)
{
  uint32_t off, inum;
  struct dirent de;
  uint32_t de_size;
  struct inode * p_inode;
  int user_buf_addr = syscall_get_arg2(tf);
  int buf_len = syscall_get_arg3(tf);
  int cur_pid = get_curid();
  int len;
  char * buf_p = sys_buf[cur_pid];
  struct inode* dp = (struct inode*)tcb_get_cwd(cur_pid);

  // Lazily initialize cwd to root if not set
  if (dp == NULL) {
    dp = inode_get(ROOTDEV, ROOTINO);
    tcb_set_cwd(cur_pid, dp);
  }

  // Lock the inode to ensure it's valid
  inode_lock(dp);

  de_size = sizeof(de);
  for(off = 0; off < dp->size; off += de_size){
    if(inode_read(dp, (char *)&de, off, de_size)!= de_size){
        // size is not legal
        inode_unlock(dp);
        KERN_PANIC("wrong in dir_lookup");
    }
    if(de.inum == 0){
        // free entry
        continue;
    }
    // TODO index may out of bound
    strncpy(buf_p, de.name, strnlen(de.name, PAGESIZE));
    buf_p += strnlen(de.name, PAGESIZE);
    *(buf_p++) = ' ';
    //dprintf("%s ", de.name);
  }

  inode_unlock(dp);

  *(buf_p - 1) = '\0';
  //dprintf("\n");
  len = buf_p - sys_buf[cur_pid] < buf_len? buf_p - sys_buf[cur_pid]: buf_len;
  pt_copyout(sys_buf[cur_pid], cur_pid, user_buf_addr, len);
  syscall_set_errno(tf, E_SUCC);
  syscall_set_retval1(tf, len);
}
void sys_pwd(tf_t *tf)
{
    char arr[100][100];
    int len = 0;
    unsigned int poff;
    struct inode* curi = (struct inode*)tcb_get_cwd(get_curid());
    struct inode* parent;
    struct dirent de;
    unsigned int off;
    unsigned int de_size = sizeof(struct dirent);
    char* p = arr[len];

    // Lazily initialize cwd to root if not set
    if (curi == NULL) {
        curi = inode_get(ROOTDEV, ROOTINO);
        tcb_set_cwd(get_curid(), curi);
    }

    parent = dir_lookup(curi, "..", &poff);

    while (parent->inum != curi->inum) {
        for (off = 0; off < parent->size; off += de_size) {
            if (inode_read(parent, (char *)&de, off, de_size) != de_size)
                break;
            if (de.inum == curi->inum) {
                strncpy(arr[len], de.name, DIRSIZ);
                arr[len][DIRSIZ] = 0;
                len++;
                break;
            }
        }
        curi = parent;
        parent = dir_lookup(curi, "..", &poff);
    }

    int i;
    for (i = len - 1; i >= 0; i--) {
        p += strnlen(arr[i], sizeof(arr[i]));
        *p++ = '/';
    }
    *p = '\0';

    pt_copyout(arr[0], get_curid(), syscall_get_arg1(tf), p - arr[0] + 1);
}


void sys_mv(tf_t *tf)
{
}

void sys_cat(tf_t *tf)
{
}

void sys_rm(tf_t *tf)
{
  int isRecursive;
  int user_addr_path;
  int length;
  int cur_pid;
  user_addr_path = syscall_get_arg2(tf);
  length = syscall_get_arg3(tf);
  isRecursive = syscall_get_arg4(tf);
  cur_pid = get_curid();
  length = length < PAGESIZE - 1? length: PAGESIZE - 1;
  pt_copyin(cur_pid, user_addr_path, sys_buf[cur_pid], length);
  sys_buf[cur_pid][length] = '\0'; // path
  // TODO unfinished

}

void sys_cp(tf_t *tf)
{
}

void sys_touch(tf_t *tf)
{
}

void sys_sigaction(tf_t *tf)
{
    int signum = syscall_get_arg2(tf);
    struct sigaction *user_act = (struct sigaction *)syscall_get_arg3(tf);
    struct sigaction *user_oldact = (struct sigaction *)syscall_get_arg4(tf);
    unsigned int cur_pid = get_curid();
    struct sigaction kern_act;

    // Validate signal number
    if (signum < 1 || signum >= NSIG) {
        syscall_set_errno(tf, E_INVAL_SIGNUM);
        return;
    }

    // Save old handler if requested
    if (user_oldact != NULL) {
        struct sigaction *cur_act = tcb_get_sigaction(cur_pid, signum);
        if (cur_act != NULL) {
            // Copy from kernel to user space
            pt_copyout((void*)cur_act, cur_pid, (uintptr_t)user_oldact, sizeof(struct sigaction));
        }
    }

    // Set new handler if provided
    if (user_act != NULL) {
        // Copy from user space to kernel
        pt_copyin(cur_pid, (uintptr_t)user_act, (void*)&kern_act, sizeof(struct sigaction));
        KERN_INFO("[SIGACTION] Setting handler for sig %d: handler=%x\n", signum, (unsigned int)kern_act.sa_handler);
        tcb_set_sigaction(cur_pid, signum, &kern_act);
    }

    syscall_set_errno(tf, E_SUCC);
}

void sys_kill(tf_t *tf)
{
    int pid = syscall_get_arg2(tf);
    int signum = syscall_get_arg3(tf);

    // Validate signal number
    if (signum < 1 || signum >= NSIG) {
        syscall_set_errno(tf, E_INVAL_SIGNUM);
        return;
    }

    // Validate target process
    if (pid < 0 || pid >= NUM_IDS || tcb_get_state(pid) == TSTATE_DEAD) {
        syscall_set_errno(tf, E_INVAL_PID);
        return;
    }

    // SIGKILL is special - terminate immediately, cannot be caught
    if (signum == SIGKILL) {
        KERN_INFO("[SIGNAL] SIGKILL sent to process %d - terminating immediately\n", pid);

        // Set state to DEAD
        tcb_set_state(pid, TSTATE_DEAD);

        // Remove from ready queue
        tqueue_remove(NUM_IDS, pid);

        // Clear any pending signals
        tcb_set_pending_signals(pid, 0);

        // FREE QUOTA: refund the usage back to the parent container
        unsigned int parent = container_get_parent(pid);
        unsigned int quota = container_get_quota(pid);
        container_refund_usage(parent, quota);

        KERN_INFO("[SIGNAL] Process %d terminated by SIGKILL\n", pid);
        syscall_set_errno(tf, E_SUCC);
        return;
    }

    // Set signal as pending
    tcb_add_pending_signal(pid, signum);

    // Wake up process if it's sleeping
    if (tcb_is_sleeping(pid)) {
        void *chan = tcb_get_channel(pid);
        if (chan != NULL) {
            thread_wakeup(chan);
        }
    }

    syscall_set_errno(tf, E_SUCC);
}

void sys_pause(tf_t *tf)
{
    unsigned int cur_pid = get_curid();

    // Check if any signals are pending
    if (tcb_get_pending_signals(cur_pid) != 0) {
        syscall_set_errno(tf, E_SUCC);
        return;
    }

    // No signals pending, go to sleep
    tcb_set_state(cur_pid, TSTATE_SLEEP);
    thread_yield();
    syscall_set_errno(tf, E_SUCC);
}

void sys_sigreturn(tf_t *tf)
{
    unsigned int cur_pid = get_curid();
    uint32_t saved_esp_addr, saved_eip_addr;
    uint32_t saved_esp, saved_eip;

    KERN_INFO("[SIGRETURN] Called by process %d\n", cur_pid);

    // Get the saved context addresses from TCB
    tcb_get_signal_context(cur_pid, &saved_esp_addr, &saved_eip_addr);

    KERN_INFO("[SIGRETURN] saved_esp_addr=%x saved_eip_addr=%x\n", saved_esp_addr, saved_eip_addr);

    if (saved_esp_addr == 0 || saved_eip_addr == 0) {
        KERN_INFO("[SIGRETURN] No signal context to restore\n");
        syscall_set_errno(tf, E_INVAL_ADDR);
        return;
    }

    // Read saved ESP from user stack
    if (pt_copyin(cur_pid, saved_esp_addr, &saved_esp, sizeof(uint32_t)) != sizeof(uint32_t)) {
        KERN_INFO("[SIGRETURN] Failed to read saved_esp from %x\n", saved_esp_addr);
        syscall_set_errno(tf, E_MEM);
        return;
    }

    // Read saved EIP from user stack
    if (pt_copyin(cur_pid, saved_eip_addr, &saved_eip, sizeof(uint32_t)) != sizeof(uint32_t)) {
        KERN_INFO("[SIGRETURN] Failed to read saved_eip from %x\n", saved_eip_addr);
        syscall_set_errno(tf, E_MEM);
        return;
    }

    KERN_INFO("[SIGRETURN] Restoring context: esp=%x eip=%x\n", saved_esp, saved_eip);

    // Clear the signal context in TCB
    tcb_clear_signal_context(cur_pid);

    // Restore the original trapframe
    tf->esp = saved_esp;
    tf->eip = saved_eip;

    syscall_set_errno(tf, E_SUCC);
}
