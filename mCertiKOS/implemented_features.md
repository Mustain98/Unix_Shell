# Unix Shell Implementation State

This document outlines everything we have implemented so far for this UNIX Shell, including paths, features, and functionalities within the `mCertikOS` codebase.

## 1. Shell Core (`user/shell/shell.c`)
- **Path:** `/user/shell/shell.c`
- **Functionality:** 
  The core of our shell handles the read-eval-print loop (REPL). It manages prompt display, input parsing, and command execution.

### Built-in Commands Handled Internally
The shell has intrinsic implementations for standard file, directory, and process management operations:

* **`ls` (`shell_ls`)**: Lists all files and directories. Uses `sys_ls` and `sys_chdir`. Supports `ls <path>` by temporarily changing directory and then reverting.
* **`pwd` (`shell_pwd`)**: Prints the working directory. Relies on the `sys_pwd` system call.
* **`cd` (`shell_cd`)**: Changes directory. Uses `sys_chdir`. Allows `cd` to navigate back to the root if passed without arguments.
* **`cp` (`shell_cp`)**: Copies a file or a directory structure. Provides recursive copying via the `-r` flag. Relies on DFS traversal to duplicate trees recursively.
* **`mv` (`shell_mv`)**: Moves a file or directory. Internally calls `_shell_cp` and then `_shell_rm`.
* **`rm` (`shell_rm`)**: Removes files. With the `-r` flag, recursively removes subdirectories doing a post-order traversal using `sys_unlink`.
* **`mkdir` (`shell_mkdir`)**: Creates a new directory using `sys_mkdir`.
* **`cat` (`shell_cat`)**: Prints the content of files by reading via the `open` and `read` system calls and printing it via `printf`. 
* **`touch` (`shell_touch`)**: Creates a new empty file. Opens a file with `O_CREATE` and immediately closes it.
* **`write` (`shell_write`)**: Writes a specific string directly into a file. 
* **`append` (`shell_append`)**: Appends a given string to an existing file by copying the previous content, then creating the file again with both the old content and the new content.
* **`help` (`shell_help`)**: Displays a help message outlining available commands and usage.

### Process & Signal Management
* **`kill` (`shell_kill`)**: Sends signals to specific processes using `kill(pid, sig)`. Validates signal numbers (1-31) and PID ranges. 
* **`trap` (`shell_trap`)**: Registers signal handlers for the shell using `sigaction`.
* **`spawn` (`shell_spawn`)**: Spawns predefined user processes (e.g., ping, pong) using their respective `elf_id`.

## 2. Pipeline and Executable Parsing
- **Functionality:** 
  In addition to built-ins, the shell can parse and execute pipelines of external process executables (`LS`, `CAT`, `ROT13`).

* **`parse_pipeline()`**: Specifically looks for the pipe character (`|`), separates the input into command stages, and builds a dependency array.
* **`run_pipeline()`**: Spawns multiple child processes attached to pipe file descriptors (`sys_pipe`), then blocks (`sys_waitpid()`) until all child processes have reached the dead/exited state. 
* **`launch_process_stage()`**: Prepares the `stdin` and `stdout` descriptors and invokes `spawn_with_fds` to launch externally compiled ELF binaries on the virtual filesystem.

## 3. Underlying System Interface Support
- **Functionality**:
  The shell depends on a robust set of underlying kernel system calls implemented inside the mCertikOS framework, essentially mocking full POSIX behaviors:
* **File System Operations**: `sys_open`, `sys_read`, `sys_write`, `sys_unlink`, `sys_mkdir`, `sys_ls`, `sys_pwd`, `sys_chdir`, `sys_is_dir`
* **Process Flow Control**: `spawn`, `sys_waitpid`, `yield`
* **Signals/IPC**: `kill`, `sigaction`, `sys_pipe`, `pause`

---
*Note: This snapshot represents the shell at the application layer (`user/shell`). The corresponding implementation of process execution, scheduling, traps and synchronization are handled in `kern/proc`, `kern/thread`, and `kern/trap`.*
