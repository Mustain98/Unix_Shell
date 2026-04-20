# Project Report: mCertiKOS Unix Shell Development

**Course:** CSE 4502 (Operating Systems Lab)

---

## 1. Base (Provided) Project Description

The base project utilizes **mCertiKOS**, a formally verified, x86 teaching operating system microkernel originally developed at Yale. The initial codebase provided a foundational operating system structure, including:

*   **Bootloader & Microkernel:** A bootloader (`boot0`, `boot1`) coupled with a kernel (`kern/`) handling basic memory management, cooperative thread scheduling, hardware interrupts, and an IDE disk driver.
*   **Simple File System:** A primitive Unix-like file system (`kern/fs/`) structured with inodes and directory entries.
*   **User Space Programs:** A collection of small executable binaries such as `ping/pong`, `ls`, `cat`, `rot13`, and `echo`.
*   **Monolithic Base Shell:** A read-eval-print loop (REPL) shell (`user/shell/shell.c`) that lacked isolation. It functioned as a monolithic interpreter where commands ran as internal C functions directly within the shell process. Consequently, the shell lacked pipeline chaining capabilities, signal handling, and robust crash resistance (any command panic would crash the entire shell).

---

## 2. Added Modules and Features

The core of our efforts centered around transitioning three major commands—`CAT`, `ROT13`, and `LS`—from being internal shell built-ins to fully isolated, executable binaries. By focusing predominantly on these three commands, we drove the development of our entire process execution and pipeline architectures. This provided an interactive POSIX-style environment. The key features implemented include:

### 2.1 Primary Focus: Dynamic Execution of `CAT`, `ROT13`, and `LS`
*   **Implementation:** The shell was heavily refactored to parse these uppercase commands (`LS`, `CAT`, `ROT13`) and launch them as isolated child processes using the `spawn_with_fds()` kernel abstraction, instead of executing them as C functions inside the shell.
*   **Enhancement:** Focusing on these commands established true process isolation mirroring Unix `fork()/exec()`. If `LS` panics, or if `CAT` encounters an error, only that child process dies. The parent shell survives and re-prints the prompt safely.

### 2.2 File Descriptor Abstraction & Inheritance
*   **Implementation:** Expanded `sys_spawn` and the kernel `struct file` implementation to pass dual file descriptors (`stdin_fd` and `stdout_fd`). The kernel safely duplicates these references (be it `FD_CONSOLE`, `FD_INODE`, or `FD_PIPE`) into slots 0 and 1 of the new process’s Thread Control Block (TCB).
*   **Enhancement:** Allows complete I/O-agnostic programming for user processes, essential for how `CAT` can seamlessly read from either a keyboard or a file. Executables blindly interact with standard `read(0)` and `write(1)` irrespective of what device or stream those descriptors represent.

### 2.3 Unix Pipeline Architecture (`|`)
*   **Implementation:** Built the `parse_pipeline` and `run_pipeline` modules, heavily tested using `CAT` and `ROT13`. The shell scans for pipelines, instantiates memory-backed `sys_pipe()` buffers, and iteratively binds process outputs to succeeding process inputs.
*   **Enhancement:** Processes can be seamlessly chained (e.g., `CAT test.txt | ROT13`). Memory pipelines transfer data autonomously, bypassing disk I/O, forming standard Unix compositional logic.

### 2.4 Process Synchronization (`sys_waitpid` & `sys_exit`)
*   **Implementation:** Built system calls forcing parent processes to block/yield while assessing when a target PID state transitions to `TSTATE_DEAD`. Strengthened `sys_exit()` to iterate through a closing process's TCB and cleanly trigger `file_close()` for every open file descriptor.
*   **Enhancement:** Prevents console racing phenomena where the parent re-prints a Shell `>:` prompt before the background child has finished printing. Assures absolute teardown of kernel resources upon execution termination.

### 2.5 CWD (Current Working Directory) Inheritance
*   **Implementation:** Modified `sys_spawn` to clone and carry over the parent shell's current working directory inode.
*   **Enhancement:** Ensures context preservation allowing spawned processes to cleanly resolve relative file system paths smoothly.

### 2.6 Signal Handling (`kill`, `trap`, `sigaction`)
*   **Implementation:** Provided full signal control APIs spanning `sys_kill` (queueing pending signals to the TCB), `sys_sigaction` to declare callbacks, and custom console utilities `kill -9` and `trap`.
*   **Enhancement:** Delivered programmatic ways to forcibly term (SIGKILL) rogue programs or register custom event interception handlers, providing modern system oversight.

### 2.7 Internal Built-in File Utilities
*   **Implementation:** Created or fortified robust internal shell operations involving extensive directory or file manipulations: `cd`, `ls`, `pwd`, `cp -r` (recursive copy via DFS), `mv`, `rm -r`, `mkdir`, `touch`, `write`, `append`, and `cat`.
*   **Enhancement:** Provides users full power to manipulate virtual disk files interactively without spawning heavyweight processes.

---

## 3. Technologies, Frameworks, and Libraries Used

*   **Platform System:** mCertiKOS (x86 microkernel OS, strictly developed inside a formally verified framework).
*   **Primary Language:** C (GNU89 Standard) for kernel modules and user processes.
*   **Development Toolchain:** Cross-compilation performed using `i686-elf-gcc` and `i686-elf-ld`.
*   **Virtualization/Emulator:** QEMU (`qemu-system-x86_64`) executing raw x86 disk image instances.
*   **Build Pipeline:** GNU Make integrated with Python utility scripts (`make_image.py`) executing MBR image constructions.

---

## 4. System Architecture

The project splits horizontally across hardware privilege rings connecting User-Space implementations to Kernel abstractions:

1.  **User Space (Ring 3):** 
    *   The monolithic `shell.c` operates purely as a choreographer handling prompt interaction, string parsing (`nstages`), and requesting process configurations.
    *   Isolated binaries (`ls`, `cat`, `rot13`) sit agnostic executing standard `read/write` loops blindly outputting to memory.
2.  **Hardware Traps (Interrupt `0x30`):** 
    *   Acts as the secure boundary bridging API interfaces to privileged functionality.
3.  **Kernel Space (Ring 0 / `TSyscall.c`):**
    *   **Unified File Structures:** Everything (IDE Disk, Console monitor, Memory Pipe) boils down to a generic `struct file` referenced by integer indices.
    *   **Delegated Streams:** The core router (`kern/fs/file.c`) intercepts kernel-called reads and splits logic via the struct's intrinsic `type` tag—interacting directly with kernel device drivers (VGA memory, keyboard matrix) or file chunks seamlessly.

---

## 5. Problems Encountered and Resolved

### Problem 1: Pipe Deadlocks and Permanent Hanging
*   **Problem:** Formulating a pipeline `CAT | ROT13` triggered deadlocks causing `ROT13` to hang eternally awaiting more stream data.
*   **Resolution:** Discovered that the parent shell process was retaining copies of the duplicated `Pipe` write-ends, preventing the reference count from hitting 0 upon the first child's death. Addressed this by enforcing immediate `close()` invocations on the duplicated parent pipes immediately following `spawn_with_fds`. 

### Problem 2: Resource and Context Leakage
*   **Problem:** Orphaned file descriptor handles persisted when commands crashed ungracefully. Also, child programs executed without awareness of context, rendering relative folders inaccessible.
*   **Resolution:** Re-wrote `sys_exit` to proactively iterate over maximum user file tables (`NOFILE`) and force kernel `file_close()` invocations before dropping Thread state. Appended `inode_dup` routines inside `sys_spawn` allocating the inherited CWD.

### Problem 3: Out-of-sync Console Input/Output
*   **Problem:** The `>:` interactive prompt manifested mid-way through `cat` or `rot13` prints.
*   **Resolution:** Programmed the system synchronous call `sys_waitpid()` utilizing a kernel spin-yield routine that aggressively halts the parent Thread Scheduler until the queried target acquires a `TSTATE_DEAD` flag. 

### Problem 4: Hardcoded Built-in Crashes
*   **Problem:** Base implementations of directory interactions contained faulty memory management (such as passing char array elements dynamically instead of pointers in `cd`) or limited read buffers (the original `cat` command truncated files past 99 bytes).
*   **Resolution:** Fixed type-casting pointer boundaries and re-formulated loops for chunk-based iteration buffering reads continuously up until EOF. Resolved `-r` flag bounds mappings within recursion algorithms.

---

## 6. Setup and Execution Guide

### Required Software & Dependencies
The following tools are necessary on macOS to build the cross-compiled base OS and run the virtualization:
- **Homebrew** (Package manager)
- **QEMU** (x86 Emulator)
- **i386-elf-toolchain** (Bare-metal GCC Cross-Compiler)
- **Python 3** (Used for disk image generation)
- **GNU Make**

Install them via your terminal:
```bash
# Install QEMU monitor
brew install qemu

# Install cross-compiler
brew tap nativeos/i386-elf-toolchain
brew install i386-elf-binutils i386-elf-gcc
```

### Step-by-step Build Instructions
1. Navigate to the root directory `mCertiKOS/`.
2. Clean out any previous binary objects:
   ```bash
   make clean
   ```
3. Compile the Kernel, Bootloader, and User processes:
   ```bash
   make
   ```
   *A successful build outputs `All targets are done.` and produces `certikos.img` / `certikos_disk.img`.*

### Running the OS on Local Machine
1. To start the operating system in the **terminal window (No-X Mode)**:
   ```bash
   make qemu-nox
   ```
   *(To exit QEMU safely at any time, press `Ctrl-a`, then `x`.)*

### Verification & Testing 
Once QEMU boots, you will see a banner and the `>:` prompt, signaling the shell is running correctly.

**Test Case 1: Dynamic Execution & File Manipulation**
```bash
>: touch hello.txt
>: write "operating systems" hello.txt
>: CAT hello.txt
```
*Expected Output:*
```text
operating systems
>:
```

**Test Case 2: Unix Pipeline (`|`) Architecture**
Test the seamless memory piping between isolated external executables:
```bash
>: CAT hello.txt | ROT13
```
*Expected Output (Cipher-shifted by 13 positions):*
```text
bcrengvat flfgrzf
>:
```

**Test Case 3: Process Isolation & Fault Tolerance**
```bash
>: LS
```
*Expected Output:*
```text
(Lists all current directory files cleanly in uppercase binary footprint, then repaints the prompt without crashing).
```
