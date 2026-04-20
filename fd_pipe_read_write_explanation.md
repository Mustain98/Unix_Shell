 # How Files, Pipes, and Terminals Actually Work

This document walks through the actual Kernel C code to show you the "Magic Trick" of Unix: how a program doesn't need to know if it's talking to a hard drive or a pipe, and how the Shell sets this all up.

---

## 1. The Ultimate Abstraction: `struct file`
In the Kernel, every single open "thing" (a file on the disk, a pipe in memory, or the console keyboard) is represented by one unified structure: the `struct file`.

**From `kern/fs/file.h`:**
```c
struct file {
  // What exactly is this file?
  enum { FD_NONE, FD_PIPE, FD_INODE, FD_CONSOLE_IN, FD_CONSOLE_OUT } type;
  
  int ref;          // How many processes are using this file right now?
  int8_t readable;  // Are we allowed to read from it?
  int8_t writable;  // Are we allowed to write to it?
  
  // Depending on "type", ONE of these pointers will be used:
  struct pipe *pipe;   // Used if type == FD_PIPE
  struct inode *ip;    // Used if type == FD_INODE (a real file on disk)
  
  uint32_t off;        // Current read/write offset (position in the file)
};
```

Whenever you have a File Descriptor (like `FD 0` or `FD 1`), it is literally just an index number. The Kernel uses that index number to look up the exact `struct file` pointer belonging to your process.

---

## 2. Breaking Down `file_read` and `file_write`
So, when a program like `CAT` says, _"Hey Kernel, I want to `read(0, buffer, 100)`"_, the Kernel finds the `struct file` sitting at Index 0 and passes it to the `file_read` function.

Look at how beautifully simple `file_read` is. It just checks the `type` tag and delegates the work!

**From `kern/fs/file.c`:**
```c
int file_read(struct file *f, char *addr, int n)
{
  if(f->readable == 0) return -1; // Panic if we don't have permission
  
  // 1. Is it a Pipe?
  if(f->type == FD_PIPE) {
    return pipe_read(f->pipe, addr, n); // Read from temporary memory buffer
  }
  
  // 2. Is it the Keyboard?
  if(f->type == FD_CONSOLE_IN) {
    return console_read(addr, n); // Wait for user to press keys
  }
  
  // 3. Is it a real file on the Hard Drive?
  if(f->type == FD_INODE) {
    inode_lock(f->ip);
    int r = inode_read(f->ip, addr, f->off, n); // Ask the hard drive for bytes
    f->off += r; // Move the position forward
    inode_unlock(f->ip);
    return r;
  }
}
```

This exact same logic applies to writing data. When `LS` wants to `write(1, buffer, 50)`, the Kernel looks at the `struct file` at Index 1 and runs `file_write`:

```c
int file_write(struct file *f, char *addr, int n)
{
  if(f->writable == 0) return -1;
  
  if(f->type == FD_PIPE)        return pipe_write(f->pipe, addr, n);
  if(f->type == FD_CONSOLE_OUT) return console_write(addr, n);
  if(f->type == FD_INODE)       // ... Complex logic to write to Hard Drive ...
}
```
**This is the core of Unix:** The executing program (`LS`, `CAT`) only calls `read` and `write`. The Kernel figures out the rest based on the `struct file`'s `type`!

---

## 3. How the Shell Wires the FDs (The Pipeline)
But how do the correct FDs get put into the correct slots? Let's walk through how the Shell parses a pipeline command like `LS | CAT | ROT13` inside `run_pipeline()`.

The Shell tracks two variables: `in_fd` and `out_fd`.
- If `in_fd = -1`, it defaults to the Keyboard.
- If `out_fd = -1`, it defaults to the Monitor.

**From `user/shell/shell.c` (Simplified):**
```c
    int in_fd = -1; // The very first command reads from the Keyboard
    
    // We loop through our 3 commands: LS (i=0), CAT (i=1), ROT13 (i=2)
    for (i = 0; i < nstages; i++) {
        
        if (i < nstages - 1) { // We are NOT on the last command
            sys_pipe(pipefd);  // Create a new Pipe: pipefd[0] is Read, pipefd[1] is Write
            out_fd = pipefd[1]; // This command should output into the pipe!
        } else {
            out_fd = -1; // The last command outputs to the Terminal Monitor
        }

        // We launch the process (e.g., spawn_with_fds)
        pids[i] = launch_process_stage(&stages[i], in_fd, out_fd);

        // -- THE WIRING MAGIC HAPPENS HERE --
        
        if (in_fd >= 0) close(in_fd); // Close the pipe Read-end the PREVIOUS command used
        
        if (i < nstages - 1) {
            close(pipefd[1]);   // Parent shell closes its copy of the Write-end
            in_fd = pipefd[0];  // Set the NEXT command's input to be the current pipe's Read-end!
        }
    }
```

### The Walkthrough of `LS | CAT | ROT13`:

**Iteration 0 (`LS`):**
1. `in_fd` is `-1` (Keyboard).
2. Not the last stage! Shell creates `Pipe A` (`pipefd[0]`, `pipefd[1]`).
3. Sets `out_fd = Pipe A Write-End`.
4. Spawns `LS` with Input=`-1`, Output=`Pipe A Write-End`.
5. Updates `in_fd` = `Pipe A Read-End` for the next loop.

**Iteration 1 (`CAT`):**
1. `in_fd` is `Pipe A Read-End`.
2. Not the last stage! Shell creates `Pipe B` (`pipefd[0]`, `pipefd[1]`).
3. Sets `out_fd = Pipe B Write-End`.
4. Spawns `CAT` with Input=`Pipe A Read-End`, Output=`Pipe B Write-End`.
5. Updates `in_fd` = `Pipe B Read-End` for the next loop.

**Iteration 2 (`ROT13`):**
1. `in_fd` is `Pipe B Read-End`.
2. IT IS the last stage! No new pipe is made. `out_fd = -1` (Terminal screen).
3. Spawns `ROT13` with Input=`Pipe B Read-End`, Output=`-1`.

**The result?** All three independent processes are seamlessly chained together, reading and writing to memory buffers governed by `struct pipe` without any of the three programs knowing it!

---

## 5. How a `struct file` is Created and Assigned an FD Number

It's helpful to understand the lifecycle of a file object: how it is born, how it gets its "FD number", and how that number is used to route `read` and `write` requests.

### 1. Creation (`file_alloc`)
Whenever you open a file, create a pipe, or initialize the console, the Kernel needs a new `struct file`. It gets one by calling `file_alloc()`.

The Kernel has a massive global array table of file objects (`ftable.file[NFILE]`). It simply loops through this table, finds the first object that isn't being used (`f->ref == 0`), claims it (`f->ref = 1`), and hands it back.

**From `kern/fs/file.c`:**
```c
struct file* file_alloc(void)
{
  struct file *f;
  spinlock_acquire(&ftable.lock);
  
  // Look through the global file table for an empty struct
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){ // Found an unused file struct!
      f->ref = 1;    // Claim it
      spinlock_release(&ftable.lock);
      return f;
    }
  }
  
  spinlock_release(&ftable.lock);
  return 0; // Return error if the OS ran out of files
}
```
After allocating the file, the caller sets the `type` tag. For example, if you called `sys_pipe`, the caller sets `f->type = FD_PIPE`. If you called `open("test.txt")`, `sys_open` sets `f->type = FD_INODE`.

### 2. Assignment (`fdalloc`)
Now we have our `struct file` in Kernel memory, but the user program (`CAT` or `LS`) can't see Kernel memory. The user program needs an integer number (the **File Descriptor**).

To assign this number, the Kernel calls `fdalloc(struct file *f)`.
1. It grabs the current process's private array of open files (`tcb_get_openfiles()`).
2. It loops from `0` up to the max open files limit (`NOFILE`).
3. It finds the first empty slot (`fds[idx] == 0`).
4. It forcefully inserts the `struct file` pointer into that slot.
5. **It returns the index number (`idx`) as the File Descriptor!**

**From `kern/fs/sysfile.c`:**
```c
static int fdalloc(struct file *f)
{
  int idx;
  int curid = get_curid(); // Get current Process ID
  
  // Get this specific worker's private FD Array (the "Slots")
  struct file ** fds = tcb_get_openfiles(curid);  
  
  // Look for the lowest empty slot number
  for(idx = 0; idx < NOFILE; idx++){ 
    if(fds[idx] == 0){ // Slot is empty!
    
      // Glue the struct file pointer into the slot
      tcb_set_openfiles(curid, idx, f); 
      
      return idx; // This index (e.g., 3, 4, 5) IS the File Descriptor!
    }
  }
  return -1; // Process opened too many files
}
```

### 3. Usage & Checking the Type (`read` / `write`)
Later, when the user program wants to read data, it says: `read(3, buffer, 10)`.

1. The Kernel looks up Index `3` in the process's array and extracts the `struct file` pointer.
2. It passes that pointer to `file_read(struct file *f, char *addr, int n)`.
3. `file_read` checks the **`f->type`** field (which was permanently set back during Step 1) and routes the request to the correct hardware or memory buffer.

**Summary Pipeline Flow:**
> `open()` -> Calls `file_alloc()` (Creates `struct file`) -> Sets `type = FD_INODE` -> Calls `fdalloc()` (Finds Slot 3) -> Returns `3` to User.
> User calls `read(3)` -> Kernel checks Slot 3 -> Extracts struct -> Checks `type == FD_INODE` -> Reads from Hard Drive!

---

## 4. Answering Your Questions: What is `nstages` and Command Simulations

### What is `nstages`?
`nstages` is **not** the number of arguments. It is the number of **Pipeline Stages** (the number of separate commands chained together with the `|` character).
- If you run `CAT test.txt`, `nstages` is **1**.
- If you run `LS -l /home`, `nstages` is **1** (even though there are 3 arguments).
- If you run `LS | CAT | ROT13`, `nstages` is **3**.

The number of arguments for a specific command is stored inside `stage->argc` (e.g., for `CAT test.txt`, `stage->argc` is 2).

### Simulation 1: `CAT test.txt`
1. **Parsing:** The shell sees no `|`. `nstages` = 1.
2. **Loop Iteration 0 (`CAT`):**
   - Because `i = 0` and `nstages - 1 = 0`, the shell knows this is the **last (and only)** stage. It does **not** call `sys_pipe()`.
   - `in_fd` defaults to `-1` (Keyboard/Console).
   - `out_fd` defaults to `-1` (Monitor/Console).
   - *Wait!* The shell notices `stage->argc == 2` (the user typed `test.txt`).
   - The shell calls `open("test.txt")` and gets an FD (let's say `FD 3`) pointing to the hard drive (`FD_INODE`).
   - The shell spawns `CAT`, passing `input_fd = 3` and `stdout_fd = -1`.
3. **Execution:** `CAT` blindly calls `read(0)`. The Kernel looks at Slot 0, sees `FD_INODE`, and fetches bytes from the hard drive (`test.txt`). `CAT` prints it out to the screen.

### Simulation 2: `CAT` (Waiting for Keyboard Input)
1. **Parsing:** `nstages` = 1.
2. **Loop Iteration 0 (`CAT`):**
   - Again, no pipes are created.
   - `in_fd` = `-1` (Keyboard).
   - `out_fd` = `-1` (Monitor).
   - The shell notices `stage->argc == 1` (no file provided).
   - The shell does **not** call `open()`. 
   - The shell spawns `CAT`, passing `input_fd = -1` and `stdout_fd = -1`.
   - The Kernel intercepts `-1` and puts a `FD_CONSOLE_IN` object into Slot 0, and a `FD_CONSOLE_OUT` object into Slot 1.
3. **Execution:** `CAT` calls `read(0)`. The Kernel sees `FD_CONSOLE_IN` and pauses `CAT`, waiting for you to physically press keys. You type words, `CAT` repeats them to the screen. When you press `Ctrl+D`, the Kernel translates that to an `EOF` (End of File) signal (specifically, returning `0` bytes read), and `CAT` gracefully exits!

### Simulation 3: `CAT test.txt | ROT13`
1. **Parsing:** The shell sees the `|`. `nstages` = 2.
2. **Loop Iteration 0 (`CAT test.txt`):**
   - Not the last stage! The shell creates `Pipe A` (`pipefd[0]` and `pipefd[1]`). 
   - `out_fd` = `Pipe A Write-End`.
   - The shell opens `test.txt` because `argc == 2`, getting `FD 3` (`FD_INODE`).
   - The shell spawns `CAT`, passing `input_fd = 3` (hard drive) and `stdout_fd = Pipe A Write-End`.
   - Parent shell closes its copy of `Pipe A Write-End` and prepares `in_fd = Pipe A Read-End` for the next loop.
3. **Loop Iteration 1 (`ROT13`):**
   - This IS the last stage (`i = 1`). No new pipe is made. `out_fd = -1` (Monitor/Console).
   - `in_fd` = `Pipe A Read-End`.
   - The shell spawns `ROT13`, passing `input_fd = Pipe A Read-End` and `stdout_fd = -1` (Monitor).
4. **Execution:** `CAT` reads from the hard drive and writes to the memory buffer (`FD_PIPE`). `ROT13` reads from that exact same memory buffer, scrambles the letters, and writes them to the screen (`FD_CONSOLE_OUT`).

---

### Function Directory Map (Code Locations)
- `struct file`, `file_alloc`, `file_read`, `file_write` -> **`kern/fs/file.c`** / **`file.h`**
- `console_read`, `console_write`, `pipe_read`, `pipe_write` -> **`kern/fs/file.c`**
- `inode_read` -> **`kern/fs/inode.c`**
- `run_pipeline`, `launch_process_stage` -> **`user/shell/shell.c`**
- `sys_pipe` -> **`kern/fs/sysfile.c`**
- `fdalloc` -> **`kern/fs/sysfile.c`**
- `close` (User Space) -> Maps to `sys_close` in **`kern/fs/sysfile.c`**
elf 