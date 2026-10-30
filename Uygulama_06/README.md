# Uygulama 06 - Process Management (Extra Practice)

This is an extra exercise to practice the commands from Uygulama 05. A data center is too hot and I have 20 minutes to save the system. The script shows a warning message every 7 seconds. After 1 minute it starts two processes that use a lot of CPU. There is also a scheduled job that ends the game after 20 minutes.

The task list is in `Uygulama_06_Gorevler.md` (in Turkish). The game script is `veri_merkezi/kurtarma_oyunu.sh`.

## Before starting

```bash
mkdir veri_merkezi
cd veri_merkezi
sed -i 's/\r$//' kurtarma_oyunu.sh
bash -n kurtarma_oyunu.sh
systemctl status atd
```

## Steps

### 1. Make the script executable

```bash
chmod +x kurtarma_oyunu.sh
ls -l kurtarma_oyunu.sh
```

### 2. Run the script

```bash
./kurtarma_oyunu.sh
```

### 3. List the processes

```bash
ps aux
ps aux | grep kurtarma
```

### 4. Watch the CPU usage

```bash
top
```

Two `bash` processes used 100% CPU. In `top`, the `NI` column was 0. Press `c` in `top` to see the full command line.

### 5. Lower the priority of both processes

`renice` can take more than one PID.

```bash
renice 19 -p [pid1] [pid2]
```

Output: `old priority 0, new priority 19` for each process.

After this, the `NI` column was 19, but the CPU usage was still 100%. In `ps aux`, the `STAT` column showed `RN`. `N` means the process has low priority.

### 6. List the scheduled job

```bash
atq
```

### 7. Cancel the scheduled job

```bash
atrm [job_id]
atq
```

### 8. Stop the first CPU process with its PID

```bash
kill [pid1]
```

### 9. Stop the second CPU process with its name

The terminal was too small, so the command line was cut. When the output goes to a pipe, `ps` shows the full line:

```bash
ps aux | grep [pid2]
```

The name was after `#` in the command line. Then I stopped the process with this name:

```bash
pkill -f fan_arizasi
```

### 10. Stop all processes of the game

I did not use `killall bash`, because it can stop other bash processes too. This command only stops the processes of this script:

```bash
pkill -f kurtarma_oyunu.sh
```

### 11. Final check

```bash
ps aux | grep kurtarma
atq
top
```

## Questions and answers

**What is the difference between `kill` and `pkill`?**
`kill` stops a process with its PID (a number). `pkill` stops processes with their name. With `-f`, `pkill` checks the full command line.

**What is the difference between `kill PID` and `kill -9 PID`?**
`kill` asks the process to stop (SIGTERM). The process can clean up before it stops, and sometimes it can ignore the request. `kill -9` stops the process by force (SIGKILL). The process cannot ignore it.

**What is the difference between `nice` and `renice`?**
`nice` sets the priority when a program starts. `renice` changes the priority of a process that is already running.

**Why can a process with nice 19 still use 100% CPU?**
The nice value only decides who goes first. If a new process wants the CPU, it gets priority. But when no other process is active, the low priority process can use all of the free CPU.

## Commands in this exercise

| Command   | What it does                                   |
|-----------|------------------------------------------------|
| `ps aux`  | Lists all processes                            |
| `top`     | Shows processes and CPU usage live             |
| `renice`  | Changes the priority of a running process      |
| `atq`     | Lists the jobs scheduled with `at`             |
| `atrm`    | Deletes a job scheduled with `at`              |
| `kill`    | Stops a process with its PID                   |
| `pkill`   | Stops processes by name (`-f` for full command)|

## What I learned

- In `top`, press `c` to see the full command. In `ps aux`, use a pipe to see the full line.
- `STAT` shows the state of a process: `R` is running, `S` is sleeping, `N` is low priority.
- `kill` uses numbers, `pkill` uses names.
- `killall bash` is not a good idea, because it stops more than the game.
