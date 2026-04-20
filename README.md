# mCertikOS Unix Shell — Project Report & Setup Guide

> **Course:** CSE 4502
> **Base Project Authors:** Bo Song, Haoliang Zhang (2015)  
> **Platform:** mCertikOS (a formally verified x86 microkernel OS)

---

## Table of Contents

1. [Base Project Description](#1-base-project-description)
2. [Added Modules & Features](#2-added-modules--features)
3. [System Architecture](#3-system-architecture)
4. [Technologies Used](#4-technologies-used)
5. [Problems Encountered & Solutions](#5-problems-encountered--solutions)
6. [Setup & Execution Guide (macOS)](#6-setup--execution-guide-macos)

---

## 1. Base Project Description

The **mCertikOS** project is a formally verified, x86 teaching operating system originally developed at Yale. The base code includes:

- A **bootloader** (`boot0`, `boot1`) that loads the kernel off a disk image
- A **microkernel** (`kern/`) with memory management (paging, containers), interrupt handling, a cooperative thread scheduler, and an IDE disk driver
- A **file system** (`kern/fs/`) implementing a simple Unix-like inode/directory structure
- A collection of **user-space processes** (`user/`): shell, ping/pong (IPC demo), ls, cat, rot13, echo, fstest
- A **basic shell** (`user/shell/shell.c`) that provided only a handful of hardcoded built-in commands in a read-eval-print loop (REPL), with no process isolation, no pipe support, and no signal handling

The provided shell was essentially a **monolithic interpreter**: every command (even `cat`) ran inside the shell process itself. A crash in any command would take down the entire shell.

---

## 2. Added Modules & Features

### 2.1 Dynamic Process Execution via `spawn` (External Process Isolation)

**What was added:**  
The shell was refactored to detect uppercase process commands (`LS`, `CAT`, `ROT13`) and launch them as fully isolated child processes using the `spawn_with_fds()` kernel interface, instead of executing them as C functions inside the shell.

**Files modified:**
- `user/shell/shell.c` — `elf_id_for_process()`, `is_process_cmd()`, `launch_process_stage()`
- `kern/trap/TSyscall/TSyscall.c` — `sys_spawn()`

**How it enhances the project:**  
If `LS` panics, only its child process dies. The parent shell survives and re-prints the `>:` prompt cleanly. This mirrors how real Unix shells use `fork()`/`exec()`.

```c
// Shell maps a command name to its compiled ELF binary ID
static int elf_id_for_process(const char *name) {
    if (strcmp(name, "CAT")   == 0) return 6;
    if (strcmp(name, "ROT13") == 0) return 7;
    if (strcmp(name, "LS")    == 0) return 9;
    return -1;
}
```

---

### 2.2 File Descriptor Inheritance & `spawn_with_fds`

**What was added:**  
`sys_spawn` was given two extra parameters — `stdin_fd` and `stdout_fd`. When spawning a child:
- If the fd is `-1`, the kernel assigns a console handle (`FD_CONSOLE_IN` / `FD_CONSOLE_OUT`).
- If the fd is a valid file descriptor, the kernel **duplicates** the parent's `struct file *` pointer into the child's Thread Control Block (TCB), incrementing the reference count.

**Files modified:**
- `kern/trap/TSyscall/TSyscall.c` — `sys_spawn()`
- `user/lib/proc.c` — `spawn_with_fds()`

**How it enhances the project:**  
Child processes are completely I/O-agnostic. `CAT` reads from `FD 0` without knowing whether that's a keyboard, a file on disk, or a pipe. This is the fundamental abstraction that makes Unix pipelines possible.

```c
// Inside sys_spawn — duplicate parent's FD into child's slot 0
if (stdin_fd >= 0 && parent_fds[stdin_fd] != 0) {
    f = file_dup(parent_fds[stdin_fd]);
    tcb_set_openfiles(new_pid, 0, f);
}
```

---

### 2.3 Pipeline Support (`|` operator)

**What was added:**  
A full Unix-style pipeline parser and runner:
- `parse_pipeline()` — splits the command line on `|` into ordered stages
- `run_pipeline()` — creates kernel pipes between stages, spawns each process with the correct FDs, then closes the parent's copies of pipe ends
- `launch_process_stage()` — prepares and calls `spawn_with_fds` for each stage

**Files modified:**
- `user/shell/shell.c`
- `kern/trap/TSyscall/TSyscall.c` — `sys_pipe()`

**How it enhances the project:**  
Commands can now be chained. `CAT test.txt | ROT13` streams the file through the cipher without either process knowing about the other. The crucial deadlock prevention — the parent shell **must** close its own copy of each pipe end after spawning — is correctly implemented.

```c
// Parent creates pipe, uses write-end for stage i, then closes it immediately
sys_pipe(pipefd);
out_fd = pipefd[1];
pids[i] = launch_process_stage(&stages[i], in_fd, out_fd);
close(pipefd[1]);   // <-- critical: drop parent's write reference
in_fd = pipefd[0];  // pass read-end to next stage
```

---

### 2.4 Process Synchronization (`sys_waitpid` & `sys_exit`)

**What was added:**  
- `sys_exit()` — properly closes all open file descriptors (preventing pipe deadlocks), marks the process `TSTATE_DEAD`, removes it from the scheduler queue, and refunds its resource quota to the parent container
- `sys_waitpid()` — spin-yields until the target process reaches `TSTATE_DEAD`

**Files modified:**
- `kern/trap/TSyscall/TSyscall.c`

**How it enhances the project:**  
The shell correctly pauses after spawning a pipeline and only re-prints the `>:` prompt when all children have exited. Without this, prompt output would interleave with process output.

```c
// Shell blocks until each child is DEAD
for (i = 0; i < nstages; i++) {
    if (pids[i] >= 0)
        sys_waitpid(pids[i]);
}
```

---

### 2.5 CWD Inheritance for Spawned Processes

**What was added:**  
`sys_spawn` now copies the parent shell's current working directory inode into the child's TCB so that relative paths resolve identically in every spawned process.

**Files modified:**
- `kern/trap/TSyscall/TSyscall.c`

```c
tcb_set_cwd(new_pid, inode_dup((struct inode*)tcb_get_cwd(curid)));
```

---

### 2.6 Signal Handling (`kill`, `trap`, `sigaction`)

**What was added:**
- `shell_kill()` — sends a signal to any running process by PID (`kill -9 <pid>`)
- `shell_trap()` — registers a custom signal handler for the shell itself via `sigaction`
- `sys_kill()` in the kernel — handles `SIGKILL` (immediate termination) and queues other signals as pending
- `sys_sigaction()` — stores per-process signal handlers in the TCB
- `sys_sigreturn()` — restores saved register context after returning from a user-space signal handler

**Files modified:**
- `user/shell/shell.c`
- `kern/trap/TSyscall/TSyscall.c`

**How it enhances the project:**  
Processes can now be cleanly terminated or interrupted. `SIGKILL` is unblockable and immediately sets the process to `TSTATE_DEAD`. Other signals are delivered asynchronously the next time the process enters kernel mode.

---

### 2.7 Expanded Built-in Commands

The following built-in commands were added or hardened with correctness fixes:

| Command | Description |
|---------|------------|
| `write <str> <file>` | Write a string directly into a file (overwrite) |
| `append <str> <file>` | Append a string to an existing file |
| `kill -<sig> <pid>` | Send a signal to a process |
| `trap <signum>` | Register shell's own signal handler |
| `spawn <elf_id>` | Manually spawn a predefined user process |
| `help` | List all available commands |

Bug fixes applied to existing built-ins:
- `cd` — fixed crash from passing a `char` as a pointer
- `rm` — fixed inverted bounds check (`pathIdx > argc + 1` → `pathIdx >= argc`)
- `cat` — fixed single-read truncation (now reads in a loop until EOF)
- `is_dir()` — fixed use of uninitialized fd when `is_file_exist()` returns 0
- `shell_touch()` / `shell_kill()` — fixed `return;` in `int`-returning functions

---

## 3. System Architecture

```
+-------------------------------------------------------+
|               User Space (Ring 3)                     |
|                                                       |
|   shell.c  ←→  ls  ←→  cat  ←→  rot13  ←→  echo    |
|      |              File Descriptors (FD 0/1)         |
|   spawn_with_fds()  →  sys_spawn syscall              |
+-------------------------------------------------------+
              ↕  Trap / Syscall Gate (int 0x30)
+-------------------------------------------------------+
|               Kernel Space (Ring 0)                   |
|                                                       |
|  TSyscall.c                                           |
|    sys_spawn   → proc_create, file_dup, tcb_set_cwd   |
|    sys_pipe    → pipe_alloc, file_dup                 |
|    sys_waitpid → spin-yield on TSTATE_DEAD            |
|    sys_exit    → file_close * NOFILE, thread_exit     |
|    sys_kill    → tcb_add_pending_signal               |
|    sys_sigaction → tcb_set_sigaction                  |
|                                                       |
|  Thread Scheduler (PTQueue / PThread)                 |
|  File System   (inode / dir / path / sysfile)         |
|  Memory Mgr    (MContainer / MPTOp)                   |
|  Device Drivers (IDE disk, keyboard, console, LAPIC)  |
+-------------------------------------------------------+
               ↕  Hardware (x86 i386)
```

### Pipeline Data Flow: `CAT test.txt | ROT13`

```
Shell Process (pid=2)
  │
  ├── sys_pipe()  →  pipefd[0]=read, pipefd[1]=write
  │
  ├── spawn CAT (pid=511)
  │     FD 0 → test.txt (inode on disk)
  │     FD 1 → pipefd[1] (write-end of pipe)
  │
  ├── close(pipefd[1])  ← CRITICAL: drop parent's write ref
  │
  ├── spawn ROT13 (pid=512)
  │     FD 0 → pipefd[0] (read-end of pipe)
  │     FD 1 → console (terminal screen)
  │
  ├── close(pipefd[0])  ← drop parent's read ref
  │
  ├── sys_waitpid(511)  ← waits for CAT
  └── sys_waitpid(512)  ← waits for ROT13
```

---

## 4. Technologies Used

| Component | Technology |
|-----------|-----------|
| OS Kernel | mCertikOS (x86 i386, formally verified C) |
| Compiler | `i686-elf-gcc` (cross-compiler for bare-metal) |
| Linker | `i686-elf-ld` |
| Emulator | QEMU (`qemu-system-x86_64`) |
| Build System | GNU Make + Python (`make_image.py`) |
| Language | C (GNU89 standard) |
| Disk Image | Raw x86 disk image with custom MBR |
| Shell Source | `user/shell/shell.c` |
| Kernel Syscalls | `kern/trap/TSyscall/TSyscall.c` |

---

## 5. Problems Encountered & Solutions

### Problem 1: Shell prompt appeared before process output finished
**Root cause:** Shell was printing `>:` immediately after spawning child processes without waiting for them.  
**Solution:** Implemented `sys_waitpid()` which spin-yields in the kernel until `tcb_get_state(target_pid) == TSTATE_DEAD`. The shell now calls this for every spawned PID before reprinting the prompt.

---

### Problem 2: Pipe deadlock — ROT13 never terminated
**Root cause:** After spawning `CAT` and `ROT13`, the parent shell still held an open write-end reference to the pipe. When `CAT` exited, the pipe's write reference count dropped from 2 to 1 (not 0), so `ROT13`'s `read()` kept blocking waiting for more data.  
**Solution:** The parent shell `close(pipefd[1])` immediately after spawning each stage. This drops the reference count to 1 (owned only by the child), so when the child exits the count hits 0 and the read-end gets a proper EOF.

---

### Problem 3: `sys_exit` did not close file descriptors
**Root cause:** The original `sys_exit` just marked the process dead and called `thread_exit()`, leaving pipe file structures with dangling open references.  
**Solution:** Added a loop in `sys_exit` that iterates all `NOFILE` slots in the exiting process's TCB and calls `file_close()` on each open file before terminating.

---

### Problem 4: Spawned processes had wrong working directory
**Root cause:** `sys_spawn` created a new process with a NULL CWD inode, so spawned `LS` or `CAT` couldn't resolve relative paths.  
**Solution:** Added `tcb_set_cwd(new_pid, inode_dup(...tcb_get_cwd(curid)...))` in `sys_spawn` to duplicate the parent shell's CWD inode into the child.

---

### Problem 5: `cd` crashed the shell
**Root cause:** The original code passed a char literal `'\0'` (integer 0) as a pointer to `strcpy`, causing a null-pointer dereference.  
**Solution:** Changed to properly initialize `path[0] = '\0'` and pass the array pointer.

---

### Problem 6: `cat` only read the first 99 bytes of a file
**Root cause:** The original `_shell_cat` called `read()` once with a 99-byte buffer and stopped.  
**Solution:** Changed `_shell_cat` to loop with `while ((n = read(fd, buf, sizeof(buf)-1)) > 0)` until EOF.

---

## 6. Setup & Execution Guide (macOS)

### Prerequisites

Install all required tools using [Homebrew](https://brew.sh/):

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install QEMU (x86 emulator)
brew install qemu

# Install the i386-elf cross-compiler toolchain
brew tap nativeos/i386-elf-toolchain
brew install i386-elf-binutils i386-elf-gcc
```

Verify the tools are available:

```bash
qemu-system-x86_64 --version   # Should print QEMU version
i686-elf-gcc --version          # Should print GCC cross-compiler version
```

> **Note:** Python 3 is also required for the disk image build script. It is typically pre-installed on macOS. Check with `python3 --version`.

---

### Step 1: Clone the Repository

```bash
git clone <your-repo-url> mcertikos
cd mcertikos
```

---

### Step 2: Build the Project

```bash
make
```

A successful build ends with:

```
All targets of boot loader are done.
All targets of kernel are compiled.
All targets of user are done.
Building Certikos Image...
All done.
All targets are done.
```

This produces `certikos.img` (bootable disk image) and `certikos_disk.img` (file system disk).

---

### Step 3: Run the OS in QEMU

**Option A — With output in your terminal (no-X mode, recommended):**

```bash
make qemu-nox
```

**Option B — With a separate QEMU window:**

```bash
make qemu
```

> To exit QEMU at any time, press **`Ctrl-a`** then **`x`**.

---

### Step 4: Verify the Shell is Running

After boot you will see:

```
********Welcome to left-mid-right shell*********
********This is the final project for CPSC 422/522 Operating Systems in Yale********
********Author: Bo Song, Haoliang Zhang********
********Date: 12/18/2015 ********
>:
```

The `>:` prompt means the shell is ready to accept commands.

---

### Step 5: Test Commands

#### Built-in file system commands (lowercase)

```bash
>: ls               # List files in current directory
>: pwd              # Print working directory
>: mkdir mydir      # Create a directory
>: cd mydir         # Change into that directory
>: touch hello.txt  # Create an empty file
>: write "hello world" hello.txt   # Write text to the file
>: cat hello.txt    # Print the file contents  →  hello world
>: append " again" hello.txt
>: cat hello.txt    # →  hello world again
>: rm hello.txt     # Remove the file
>: cd ..            # Go back up
>: rm -r mydir      # Remove directory recursively
```

#### External process commands (uppercase, run as isolated child processes)

```bash
>: LS               # Spawns ls as a child process
>: CAT test.txt     # Spawns cat to read test.txt
```

#### Pipeline test

```bash
>: CAT test.txt | ROT13
```

Expected output: Contents of `test.txt` cipher-shifted (A→N, B→O, etc.)

```
>: CAT test.txt | ROT13
Gur dhvpx oebja sbk whzcf bire gur ynml qbt.
>:
```

#### Signal / process management

```bash
>: spawn 1          # Spawn the ping process (elf_id=1)
>: spawn 2          # Spawn the pong process (elf_id=2)
>: kill -9 3        # Send SIGKILL to process PID 3
>: trap 2           # Register shell's SIGINT handler
>: help             # Print all available commands
```

---

### Troubleshooting

| Issue | Fix |
|-------|-----|
| `i686-elf-gcc: command not found` | Run `brew install i386-elf-gcc` |
| `qemu-system-x86_64: command not found` | Run `brew install qemu` |
| `make: python3: No such file` | Run `brew install python3` |
| QEMU freezes at boot | Try `make clean && make` then retry |
| Black screen in QEMU window | Use `make qemu-nox` instead |
| `certikos_disk.img` not found | Run `make mkfs` to regenerate the filesystem disk |

---

### Clean & Rebuild

```bash
make clean    # Remove all compiled objects and disk image
make          # Rebuild from scratch
```

---

### File Reference Map

| File | Purpose |
|------|---------|
| `user/shell/shell.c` | Shell REPL, built-in commands, pipeline runner |
| `kern/trap/TSyscall/TSyscall.c` | Kernel syscall implementations (spawn, exit, waitpid, pipe, kill, sigaction) |
| `kern/fs/sysfile.c` | File system syscalls (open, read, write, pipe) |
| `kern/fs/file.c` | File struct management (`file_dup`, `file_close`, `console_init_fds`) |
| `user/lib/proc.c` | `spawn_with_fds()` user-library wrapper |
| `user/cat/cat.c` | Standalone CAT process binary |
| `user/ls/ls.c` | Standalone LS process binary |
| `user/rot13/rot13.c` | Standalone ROT13 process binary |
| `Makefile` | Top-level build orchestration |
| `make_image.py` | Assembles bootable disk image |