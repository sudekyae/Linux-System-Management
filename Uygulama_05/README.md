# Uygulama 05 - Process Management Escape Game

This is an exercise from my Linux course (Uygulama 4 in the course, Uygulama_05 in this repo). The topic is process management.

In the game, you are stuck in a server. You have 30 minutes to escape. The script starts some processes in the background, shows the message "Server'da kapali kaldiniz" every 5 seconds and after 1 minute starts a process that uses a lot of CPU. To escape, you need to find this process, watch the system resources and cancel the scheduled job that ends the game.

I did this exercise on my own Ubuntu terminal.

## Before starting

I created the `escape` folder and wrote the `escape_game.sh` script in it. The script was copied from Windows, so I removed the Windows line endings and checked the syntax:

```bash
sed -i 's/\r$//' escape_game.sh
bash -n escape_game.sh
```

The script uses the `at` command. It was not installed on my system, so I installed it first. Without it, the scheduled job is not created.

```bash
sudo apt install at
systemctl status atd
```

## Steps

### 1. Make the script executable

```bash
chmod +x escape_game.sh
```

### 2. Run the script

```bash
./escape_game.sh
```

### 3. List all processes

```bash
ps aux
```

To find only the game processes:

```bash
ps aux | grep escape
```

### 4. Watch the CPU usage

```bash
top
```

`htop` can also be used. Press `q` to exit.

### 5. Change the priority of the CPU process

19 is the lowest priority.

```bash
renice 19 [process_id]
```

Output: `old priority 0, new priority 19`

**Note:** After `renice`, the CPU usage was still 100%. This is normal. The nice value does not limit the CPU. It only decides who goes first when other processes also want the CPU. If no other process needs the CPU, a process with nice 19 can still use all of it. In `top`, the `NI` column shows the new value.

### 6. List the scheduled jobs

```bash
atq
```

### 7. Cancel the scheduled job

```bash
atrm [job_id]
```

### 8. Stop the CPU process

```bash
kill [process_id]
```

### 9. Stop all processes that run the same command

`-f` checks the full command line, not only the process name.

```bash
pkill -f "CPU daha da zorlaniyor"
```

### 10. Stop all processes of the game

Answer from the course:

```bash
killall bash
kill -9 escape_game.sh
```

**Note:** Be careful with these commands.

- `killall bash` stops all bash processes of the user, not only the game. On a real system this can stop other important work.
- `kill -9 escape_game.sh` does not work, because `kill` needs a PID (a number), not a file name. `-9` means "stop the process by force".

A safer way that only stops the game processes:

```bash
pkill -f escape_game.sh
```

or

```bash
killall escape_game.sh
```

## Final check

```bash
ps aux | grep escape
atq
top
```

Only the `grep` line is left, there is no scheduled job and the CPU usage is normal. I escaped from the server.

## Commands in this exercise

| Command  | What it does                                      |
|----------|---------------------------------------------------|
| `ps aux` | Lists all processes                               |
| `top`    | Shows processes and CPU usage live                |
| `renice` | Changes the priority of a running process         |
| `atq`    | Lists the jobs scheduled with `at`                |
| `atrm`   | Deletes a job scheduled with `at`                 |
| `kill`   | Stops a process with its PID                      |
| `pkill`  | Stops processes by name (`-f` for full command)   |
| `killall`| Stops all processes with the same name            |

## What I learned

- `nice` and `renice` change the priority, not the CPU limit.
- If a program is not installed when a script runs, that part of the script fails, but the rest of the script can continue. I had to install `at` and run the game again.
- `pkill -f` is useful when many processes come from the same script.
- `kill` works with PIDs, `pkill` and `killall` work with names.
