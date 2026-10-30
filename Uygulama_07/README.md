# Uygulama 07 - Package Management: Setting Up a New Server

This is an exercise from my Linux course (Uygulama 5 in the course, Uygulama_07 in this repo). The main topic is package management, but the exercise also repeats many commands from the earlier exercises: folders and files, `grep`, `sed`, users, groups, permissions and processes.

**Scenario:** I have a new Ubuntu server for a web project. I need to set up the project folders, manage users and install software.

I did this exercise on my own Ubuntu terminal. I created the `web_proje` folder inside this folder (`Uygulama_07`), not in `/`, because creating a folder in `/` needs `sudo`.

## Steps

### 1. Where am I? What is in this folder?

```bash
pwd
ls
```

### 2. Learn how to use a command

`man` opens the manual page of a command. Press `q` to exit.

```bash
man ls
```

### 3. Create the project folders

```bash
mkdir web_proje
mkdir web_proje/html
mkdir web_proje/logs
```

### 4. Create index.html and show it

`>` creates the file and writes the text in it.

```bash
echo "Merhaba Dünya!" > web_proje/html/index.html
cat web_proje/html/index.html
```

### 5. Create access.log and add a date

My teacher gave us a sample log file, so I put its content in `access.log`. Then I added the date and time with `>>`, so the old content was not deleted.

```bash
date >> web_proje/logs/access.log
```

**Note:** The date was added to the end of the last line, not to a new line. The reason: the last line of the file did not end with a newline character (`\n`). `>>` adds the text to the very end of the file. I fixed it with `nano`. To avoid this, you can add an empty line first:

```bash
echo >> web_proje/logs/access.log
```

### 6. Find the lines with "hata"

```bash
grep "hata" web_proje/logs/access.log
```

### 7. Fix a misspelled word

In the log file, "yanlış" was written as "yanlis". `sed` changes the word in all lines. `g` at the end means "every match in the line". `-i` saves the change in the file.

```bash
sed -i 's/yanlis/yanlış/g' web_proje/logs/access.log
```

### 8. Create the user ahmet

```bash
sudo adduser ahmet
```

### 9. Create and delete the user mehmet

`--remove-home` also deletes the home directory of the user.

```bash
sudo adduser mehmet
sudo deluser --remove-home mehmet
```

The same thing with the basic command:

```bash
sudo userdel -r mehmet
```

To check:

```bash
ls /home
grep mehmet /etc/passwd
```

**Note:** In the PDF, `--remove-home` looks like one long dash (`–`). This is because of Word. In the terminal, you must write two normal dashes (`--`).

### 10. Give ahmet write permission on the project folder

I made ahmet the owner of the folder and gave the owner write permission. Only root can change the owner of a file, so `chown` needs `sudo`, even if I am the owner.

```bash
sudo chown ahmet web_proje
sudo chmod u+w web_proje
```

ahmet is a normal user, so he can only write in his home directory and in the folders where he has permission.

### 11. Create the group web_gelistiriciler and add ahmet

```bash
sudo groupadd web_gelistiriciler
sudo usermod -aG web_gelistiriciler ahmet
```

### 12. Only the owner can read and write the log files

```bash
chmod 600 web_proje/logs/*
ls -l web_proje/logs
```

### 13. Find the process that uses the most CPU

```bash
ps aux
top
```

### 14. Install and remove software

```bash
sudo apt install apache2
sudo apt remove apache2
```

### 15. Are wget and curl installed?

```bash
dpkg -l wget
dpkg -l curl
```

`ii` at the start of the line means the package is installed. Other ways:

```bash
apt list --installed | grep wget
which curl
```

**Note:** `apt show wget` shows information about the package, but it does not clearly say if the package is installed.

### 16. Update the package lists

```bash
sudo apt update
```

`apt update` only updates the list of packages. It does not install new versions. To install the new versions, `apt upgrade` is used.

### 17. Install wget and curl

```bash
sudo apt install wget curl
```

### 18. Download a file

```bash
wget https://github.com/cirosantilli/linux-cheat/raw/master/linux-cheat.pdf
```

### 19. Download the file with a new name

`-O` saves the file with the given name.

```bash
wget -O linux_komutlari.pdf https://github.com/cirosantilli/linux-cheat/raw/master/linux-cheat.pdf
```

**Note:** For both commands I got `ERROR 404: Not Found`. The commands are correct, but the file is not at this link anymore (the exercise is from 2024). `-O` creates an empty file even when the download fails, so I deleted it.

## Commands in this exercise

| Command          | What it does                                  |
|------------------|-----------------------------------------------|
| `pwd`            | Shows the current folder                      |
| `man`            | Shows the manual of a command                 |
| `sed -i 's/a/b/g'` | Changes text in a file                      |
| `deluser --remove-home` | Deletes a user and the home directory  |
| `userdel -r`     | Same as above (basic command)                 |
| `apt install`    | Installs a package                            |
| `apt remove`     | Removes a package                             |
| `apt update`     | Updates the package lists                     |
| `apt upgrade`    | Installs the new versions of packages         |
| `dpkg -l`        | Shows if a package is installed               |
| `wget`           | Downloads a file from the internet            |
| `wget -O`        | Downloads a file with a new name              |

## Command pairs

| Action      | Basic command | Ubuntu version |
|-------------|---------------|----------------|
| Add user    | `useradd`     | `adduser`      |
| Delete user | `userdel`     | `deluser`      |
| Add group   | `groupadd`    | `addgroup`     |
| Delete group| `groupdel`    | `delgroup`     |

Easy way to remember: if the verb is first (**add**user), it is the Ubuntu version. If the verb is last (user**add**), it is the basic command.

## What I learned

- Only root can change the owner of a file. The owner can change the permissions with `chmod`, but not the owner with `chown`.
- `>>` adds text to the end of the file. If the last line has no newline, the new text joins that line.
- Short options use one dash (`-r`), long options use two dashes (`--remove-home`).
- `apt update` and `apt upgrade` are different.
- A 404 error means the server is reachable, but the file is not there.
