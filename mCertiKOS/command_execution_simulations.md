# Shell Command Execution Simulations

This document traces the exact execution flow through the user-space Shell, into the Kernel abstractions, and back out for four distinct command scenarios. By following the File Descriptors (FDs) and `nstages`, the Unix pipeline architecture becomes incredibly clear.

---

## 1. Simulation: `LS`

### Phase 1: Shell Parsing (`user/shell/shell.c`)
- **Command:** `LS`
- **Pipeline Check:** The shell scans for `|`. There is none, so `nstages = 1`.
- **Iteration 0 (`i = 0`):**
  - Because `i == (nstages - 1)`, the shell knows this is the last (and only) command.
  - It does **not** call `sys_pipe()`.
  - Default FDs: `in_fd = -1` (Terminal Keyboard), `out_fd = -1` (Terminal Screen).
  - The shell notices `stage->argc == 1` (no file arguments).
  - The shell calls `spawn_with_fds(elf_id_for_LS, 200, -1, -1)`.

### Phase 2: Kernel Spawn (`kern/trap/TSyscall/TSyscall.c`)
- **`sys_spawn` Execution:**
  - The Kernel creates the `LS` memory footprint.
  - Because both passed FDs are `-1`, it triggers `console_init_fds(new_pid)`.
  - The Kernel allocates `struct file` objects inside the new `LS` process's Thread Control Block (TCB):
    - **Slot 0 (`stdin`)** gets a `FD_CONSOLE_IN` object (Keyboard).
    - **Slot 1 (`stdout`)** gets a `FD_CONSOLE_OUT` object (Monitor).

### Phase 3: Program Execution
- **`LS` Process Runs:** `LS` calls `sys_pwd()`, lists the files, and loops over them, calling `write(1, filename, len)`.
- **Kernel Routing:** The Kernel intercepts `write(1)`, looks at Slot 1, sees `FD_CONSOLE_OUT`, and passes the bytes directly to the video memory/console driver to print on the screen. `LS` safely exits.

---

## 2. Simulation: `CAT` (Waiting for Keyboard Input)

### Phase 1: Shell Parsing
- **Command:** `CAT`
- **Pipeline Check:** `nstages = 1`.
- **Iteration 0:**
  - No pipes created. `in_fd = -1`, `out_fd = -1`.
  - The shell sees `stage->argc == 1`. It does **not** call `open()`.
  - The shell calls `spawn_with_fds(elf_id_for_CAT, 200, -1, -1)`.

### Phase 2: Kernel Spawn
- **`sys_spawn` Execution:**
  - Exactly like `LS`, the Kernel maps Slot 0 to `FD_CONSOLE_IN` and Slot 1 to `FD_CONSOLE_OUT`.

### Phase 3: Program Execution
- **`CAT` Process Runs:** The exact code of `cat.c` does a `while(read(0, buf, size) > 0)`.
- **Kernel Routing:** The Kernel intercepts `read(0)`, looks at Slot 0, sees `FD_CONSOLE_IN`. The Kernel strictly halts the `CAT` process and yields the CPU because the keyboard buffer is empty.
- **User Typing:** You type "Hello", which fills the keyboard buffer. The Kernel wakes `CAT` up and hands it "Hello". `CAT` then calls `write(1)`, which prints "Hello" to the screen.
- **Teardown:** When you press `Ctrl+D`, the Kernel driver intercepts `0x04` and tells `read(0)` to return `0` bytes (End Of File). `CAT` breaks its `while()` loop and exits.

---

## 3. Simulation: `CAT test.txt`

### Phase 1: Shell Parsing
- **Command:** `CAT test.txt`
- **Pipeline Check:** `nstages = 1`.
- **Iteration 0:**
  - No pipes created. `out_fd = -1`.
  - The shell sees `stage->argc == 2` ("test.txt").
  - **The vital difference:** The shell calls `input_fd = open("test.txt", O_RDONLY)`.
  - Let's say the Kernel assigns **FD 3** (pointing to an `FD_INODE` object on the hard drive).
  - The shell calls `spawn_with_fds(elf_id_for_CAT, 200, 3, -1)`.

### Phase 2: Kernel Spawn
- **`sys_spawn` Execution:**
  - The Kernel initializes Slot 1 with `FD_CONSOLE_OUT` because `stdout_fd == -1`.
  - For `stdin`, it sees `stdin_fd == 3`. 
  - The Kernel goes to the Parent Shell's TCB, finds the `struct file` sitting at Index 3 (the Hard Drive file), duplicates the pointer, and forcefully pastes it into **Slot 0** of `CAT`'s TCB!

### Phase 3: Program Execution
- **`CAT` Process Runs:** Just like before, `CAT` blindly runs `while(read(0, buf, size) > 0)`.
- **Kernel Routing:** This time, when the Kernel intercepts `read(0)`, it looks at Slot 0 and sees `FD_INODE`! It completely ignores the keyboard and instead spins up the disk driver to grab bytes from `test.txt`. `CAT` prints the text to the screen and safely exits once the entire file is iterated through.

---

## 4. Simulation: `CAT test.txt | ROT13` (The Pipe Deadlock Danger)

This is the most complex simulation. It shows why File Descriptors are **copied**, and why the Parent Shell **must destroy its own copies** of those File Descriptors to prevent the system from deadlocking.

### Phase 1: Shell Parsing
- **Command:** `CAT test.txt | ROT13`
- **Pipeline Check:** The shell detects the `|`. Therefore, `nstages = 2`.

### Phase 2: Iterations & Kernel Spawning

#### Loop Iteration 0 (`CAT test.txt`):
1. Because `i < 2 - 1`, this is **not** the last command! The Shell needs a pipeline.
2. The Shell calls `sys_pipe(pipefd)`. 
   - The Kernel allocates a hidden 512-byte `FD_PIPE` memory buffer.
   - The Kernel places the **Pipe Read-End** object into the Parent Shell's Slot 4 (`FD 4`).
   - The Kernel places the **Pipe Write-End** object into the Parent Shell's Slot 5 (`FD 5`).
   - *Reference Count for the Write-End is exactly 1 (owned by the Parent Shell).*
3. The Shell opens `test.txt`, placing the `FD_INODE` object into Slot 3 (`FD 3` - Hard Drive).
4. **Spawn:** The Parent Shell calls `spawn_with_fds(elf_id_CAT, 200, input_fd=3, stdout_fd=5)`.
5. **The Duplication Magic:** Inside `sys_spawn()`, the Kernel goes into the Parent Shell's brain, grabs the object sitting in Slot 5 (the Pipe Write-End), and **pastes an exact copy** of it into the new `CAT` process's Slot 1 (`stdout`).
   - Because `CAT` now has a copy, the Kernel increases the Pipe Write-End Reference Count from 1 to 2!
   - Now **BOTH** the Parent Shell and `CAT` have the ability to write to this pipe.
6. **The Deadlock Prevention:** The Parent Shell does **not** intend to write data to this pipe. It only created the pipe to give it to `CAT`. 
   - **Crucially:** The Parent Shell immediately calls `close(5)` on itself. 
   - The Kernel deletes the object from the Parent Shell's Slot 5, dropping the Reference Count from 2 back down to 1. 
   - The pipe is **not destroyed** because `CAT` is still holding its copy in Slot 1! `CAT` is now the **sole absolute owner** of the Write-End of the pipe.

#### Loop Iteration 1 (`ROT13`):
1. Because `i == 1`, this **is** the last command! No new pipe is made. 
2. The Shell sets `out_fd = -1` (Monitor).
3. The Shell's `in_fd` was carried over from the last loop, so `in_fd = 4` (Pipe Read-End).
4. **Spawn:** The Shell calls `spawn_with_fds(elf_id_ROT13, 200, input_fd=4, stdout_fd=-1)`.
5. **The Duplication Magic:** The Kernel copies the object sitting in the Parent Shell's Slot 4 (the Pipe Read-End) into `ROT13`'s Slot 0 (`stdin`). 
   - The Reference Count for the Pipe Read-End jumps from 1 to 2.
6. **The Deadlock Prevention:** The Parent Shell explicitly calls `close(4)` on itself.
   - The Parent Shell throws away its connection, dropping the Reference Count back to 1.
   - `ROT13` is now the **sole absolute owner** of the Read-End of the pipe.
7. The Parent Shell calls `sys_waitpid()` and goes to sleep, waiting for the children to finish.

### Phase 3: Program Execution (Simultaneous Runtime)
Both `CAT` and `ROT13` wake up and are running side-by-side in the CPU scheduler.
1. `CAT` blindly calls `read(0)`. The Kernel fetches data from the Hard Drive (`test.txt`).
2. `CAT` blindly calls `write(1)`. The Kernel pushes that data into the Pipe buffer in memory.
3. Over in `ROT13`'s isolated process, it blindly calls `read(0)`. The Kernel fetches the data that `CAT` just wrote into the Pipe buffer.
4. `ROT13` scrambles the text (e.g., changing 'A' to 'N'), and blindly calls `write(1)`. The Kernel prints the scrambled text onto the physical screen.

#### The Cleanup (Why the `close()` mattered)
5. `CAT` hits the end of `test.txt`. It breaks its loop and hits `sys_exit()`. 
6. The Kernel executes `sys_exit` by permanently destroying `CAT`'s Slot 1.
7. The Pipe Write-End Reference Count drops from 1 to **0**.
8. Because the Reference Count is exactly 0, the Kernel physically seals the Write-End of the pipe.
9. *What if the Parent Shell hadn't called `close(5)` during Iteration 0?* The Reference Count would drop from 2 to 1 (because the Parent Shell would still be holding it). The pipe would stay open!
10. `ROT13` tries to `read(0)` again.
    - If the Reference Count was still 1, the Kernel would say, *"The Parent Shell might write data! Go back to sleep and wait!"* -> **DEADLOCK** (Terminal freezes).
    - But because the Reference Count is 0, the Kernel says, *"No object in the entire computer holds a Write-connection to this pipe. Return `0` bytes (EOF)."*
11. `ROT13` beautifully detects the `EOF`, neatly finishes its loop, and hits `sys_exit()`. Both are `TSTATE_DEAD`; the Shell wakes up and reprints the prompt!

---

## 5. Analyzing the Output Logs (The Exit Sequence)

Let's look at the actual debug trace you provided when running `CAT test.txt | ROT13`:

```text
1. >: CAT test.txt | ROT13
2. [SYS_WAITPID] waiter=2 waiting for pid=511 state=0
3. [SYS_EXIT] pid=511 exiting
4. [SYS_EXIT] pid=511 state=DEAD, switching away
5. [SYS_WAITPID] waiter=2 target=511 now DEAD
6. >: Gur dhvpx oebja sbk whzcf bire gur ynml qbt.
7. ... (ROT13 output continues) ...
8. EBG13 zr naq frr jung unccraf!
9. The quick brown fox jumps over the lazy dog.
10. [SYS_EXIT] pid=512 exiting
11. [SYS_EXIT] pid=512 state=DEAD, switching away
```

Here is exactly what the Kernel processes are doing at each step:

### Step 1: Spawning and Waiting (Line 2)
The shell (which is Process `pid=2`) successfully spawns `CAT` (`pid=511`) and `ROT13` (`pid=512`). 
Because the Parent Shell needs to wait for the command to finish, it calls `sys_waitpid(511)`.
- **`waiter=2`**: The Shell.
- **`target=511`**: The process we are waiting for (`CAT`).
- The Shell literally pauses itself in a loop, saying *"I won't do anything until 511 is marked DEAD."*

### Step 2: `CAT` Finishes (Lines 3-4)
`CAT` reads from the hard drive and writes to the memory pipe perfectly. Eventually, it reaches the end of `test.txt`. `CAT` breaks out of its read-loop and triggers the `sys_exit()` kernel function.

**What happens inside `sys_exit()`?**
1. **Closing FDs**: The Kernel loops through `CAT`'s entire TCB array (Slots 0 to NOFILE) and forces a `file_close()` on everything. This brilliantly deletes `CAT`'s connection to the Pipe Write-End, permanently sealing the pipe.
2. **Marking DEAD**: The Kernel changes `CAT`'s thread state from `TSTATE_RUN` to `TSTATE_DEAD` (`state=DEAD`).
3. **Switching Away**: `CAT` calls the scheduler to give up the CPU (`switching away`) because it's dead and will never run again!

### Step 3: Shell Wakes Up! (Line 5-6)
Because `CAT`'s state just hit `TSTATE_DEAD`, the sleeping Shell (`waiter=2`) suddenly breaks out of its `sys_waitpid()` while-loop. 
The Shell thinks: *"Ah, the pipeline finished!"* and immediately prints the next prompt: `>:` (Line 6).

### Step 4: Wait... `ROT13` is still alive? (Lines 6-11)
You'll notice something funny: the Shell printed the `>:` prompt *before* `ROT13` finished printing its translated text! 
Why? Because `ROT13` runs concurrently in the background as `pid=512`. 

1. Once `CAT` (`pid=511`) died and closed the pipe, `ROT13`'s `read(0)` returned `0` bytes (`EOF`).
2. `ROT13` realizes the data stream is done, finishes translating its final chunk, and prints the scrambled text directly to the screen (overlapping with the shell's `>:` prompt).
3. `ROT13` breaks its loop and hits `sys_exit()`. 
4. The Kernel closes `ROT13`'s FDs, marks `pid=512` as `TSTATE_DEAD`, and switches away safely.

*(Note: In fully mature shells, the Shell actually tracks an array of ALL children in the pipeline and runs `waitpid()` iteratively on every single one of them to ensure `>:` never prints until both `pid=511` and `pid=512` are DEAD!)*

---

### Function Directory Map (Code Locations)
- `strcmp`, `stage->argv` -> Handled in **`user/shell/shell.c`**
- `sys_pipe`, `sys_open` -> **`kern/fs/sysfile.c`**
- `console_init_fds` -> **`kern/fs/file.c`**
- `sys_spawn`, `sys_waitpid`, `sys_exit` -> **`kern/trap/TSyscall/TSyscall.c`**
- `spawn_with_fds` -> **`user/lib/proc.c`**
- `read`, `write` (User Space) -> Maps to `sys_read` and `sys_write` in **`kern/fs/sysfile.c`**
