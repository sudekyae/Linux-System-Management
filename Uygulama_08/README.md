# Uygulama 08 - Escape from the Red Planet: ARES-1 Mars Base

This is an exercise from my Linux course. It is a big review exercise: it uses almost every topic from the course. I did it first in class on a Proxmox VM, and then again on my own Ubuntu terminal for exam practice.

**Scenario:** It is the year 2087. I am the new system engineer of the ARES-1 Mars base. The old engineer, Dr. Orhan, left the system in a mess. A dust storm is coming and the crew must leave with the return capsule. Dr. Orhan split the launch password into 6 parts and hid them around the base. I need to fix the base, find the parts and launch the capsule.

The tasks follow each other. A folder, file or user from one task is used in the next tasks.

## Files in this folder

- The big files in `ares1/arsiv/` are not uploaded, because they are too big for GitHub. Their sizes are in `izinler.txt`.
- `ares1/` is a copy of `~/ares1`. Git does not save file owners and permissions, so the real permissions are in `izinler.txt`.
- `izinler.txt` is the output of `sudo ls -lR ~/ares1`.

## Tasks

### 1. Connect to the base

```bash
mkdir ~/gorev
cd ~/gorev
nano ares1_kurulum.sh
sed -i 's/\r$//' ares1_kurulum.sh
bash -n ares1_kurulum.sh
chmod +x ares1_kurulum.sh
./ares1_kurulum.sh

cd ~/ares1
pwd
ls -l
mkdir gorev_defteri
```

`sed` removes the Windows line endings (`\r`). `bash -n` checks the script for syntax errors without running it.

### 2. Engineer record

`>` creates the file. `>>` adds to the end of the file and does not delete the old content.

```bash
cd gorev_defteri
whoami > kayit.txt
pwd >> kayit.txt
echo "Name Surname" >> kayit.txt
cat kayit.txt
```

### 3. The hidden message

Files that start with `.` are hidden. `-a` shows them.

```bash
cd ~/ares1
cat BENI_OKU.txt
ls -a
cat .[hidden_file]
echo "PART1" > gorev_defteri/kalkis_sifresi.txt
```

### 4. Oxygen alarm

```bash
wc -l loglar/oksijen.log
awk 'NR==1 || NR==100' loglar/oksijen.log
grep -c "KRITIK" loglar/oksijen.log > gorev_defteri/kritik_sayisi.txt
grep -ci "kritik" loglar/oksijen.log
grep "KRITIK" loglar/oksijen.log | awk '{print $3}' | sort | uniq -c | sort -nr
```

- `wc -l` counts the lines.
- In awk, `NR` is the line number. `||` means "or". Be careful: `awk 'NR==1, NR==100'` with a comma prints lines 1 to 100, not only two lines.
- `-i` makes grep ignore upper and lower case, so it finds more lines (for example "kritik" and "Kritik" too).
- `sort | uniq -c` counts how many times each word is in the list. `uniq` only joins lines that are next to each other, so `sort` must come first. `sort -nr` puts the biggest number at the top.

**Important:** grep needs a file (`grep word file`) or a pipe (`command | grep word`). Without them, it waits for input from the keyboard and the terminal looks stuck. Press `Ctrl+C` to exit.

### 5. The storage is full

The file size is in the 5th column of `ls -l`. `-h` shows sizes like `90M`. With `-h`, 52,000,000 bytes is about 49.6M, because `-h` uses 1024.

```bash
ls depo
ls -lah depo/[subfolder]
mkdir arsiv
mv depo/[subfolder]/[big_file] arsiv/
mv depo/[subfolder]/.[hidden_big_file] arsiv/
ls -lah arsiv
```

A hidden file name starts with a dot. The dot is part of the name, so you must write it.

### 6. Cargo

The folder name `eski sefer` has a space, so it must be in quotes.

```bash
cd ~/ares1/kargo
ls karisik | grep -c '\.numune$'
ls "karisik/eski sefer" | grep -c '\.numune$'

mkdir sera laboratuvar
mv karisik/*.bitki "karisik/eski sefer"/*.bitki sera/
mv karisik/*.numune "karisik/eski sefer"/*.numune laboratuvar/

rm karisik/*.tmp "karisik/eski sefer"/*.tmp
rmdir "karisik/eski sefer" karisik

ls laboratuvar > ~/ares1/gorev_defteri/numune_listesi.txt
```

- grep reads the content of a file. To search in file **names**, give the output of `ls` to grep with a pipe.
- In grep, `.` means "any character", so `\.` is used for a real dot. `$` means "end of the line".
- `*` must be outside the quotes. Inside quotes, it is a normal character, not a wildcard.
- `mv` does not read input from a pipe. The wildcard `*` does the filtering here.
- `rmdir` only deletes empty folders. The inner folder must be deleted first.

### 7. Crew accounts

```bash
sudo adduser luna
sudo adduser atlas
sudo adduser nova

sudo groupadd pilotlar
sudo groupadd bilim

sudo usermod -aG pilotlar luna
sudo usermod -aG pilotlar atlas
sudo usermod -aG bilim nova
sudo usermod -aG bilim luna

grep -E 'pilotlar|bilim' /etc/group

su luna
whoami
exit
```

- `-G` means supplementary groups, `-a` means append. Without `-a`, luna would lose her other group.
- `useradd` does not ask for a password and does not create a home folder. `adduser` does both.

### 8. Safe and capsule permissions

```bash
ls -l ~/ares1/kasa
cat ~/ares1/kasa/[file]
```

The file with the part has `-r--------`: only the owner can read, nobody can write or run it. In numbers: **400**.

```bash
mkdir ~/ares1/kokpit
nano ~/ares1/kokpit/ucus_plani.txt
sudo chown luna:pilotlar ~/ares1/kokpit/ucus_plani.txt
sudo chmod 640 ~/ares1/kokpit/ucus_plani.txt
sudo chown luna:pilotlar ~/ares1/kokpit
sudo chmod 770 ~/ares1/kokpit

ls -l ~/ares1
ls -l ~/ares1/kokpit
sudo ls -l ~/ares1/kokpit
```

**Why can I not list kokpit?** I am not the owner (luna) and not in the group (pilotlar), so I am in "others". With 770, others have no permission (`---`). For a folder, `r` is needed to list it and `x` is needed to enter it. With `sudo`, it works because root can access everything.

**Can nova read ucus_plani.txt?** No. nova is not in pilotlar, so she is in "others", and others have no permission. Also, she cannot enter the kokpit folder.

**Can atlas change ucus_plani.txt?** No. atlas is in pilotlar, but the group can only read (`r--`).

Only root can change the owner of a file, so `chown` always needs `sudo`.

### 9. Broken meteor alarm

```bash
ps aux | grep alarm
echo [PID] > ~/ares1/gorev_defteri/alarm_pid.txt
kill [PID]
ps aux | grep alarm
```

In `ps aux`, the 1st column is the user, the 2nd column is the PID and the last column is the full command line. The 6th part was in the command line.

### 10. Saving energy

```bash
ps aux | grep panel_hesapla
renice -n 15 -p [PID]

cd ~/ares1/araclar
nice -n 10 ./toprak_analizi
```

The terminal is locked now. Press `Ctrl+Z` to stop the program (not `Ctrl+C`, it kills the program).

```bash
jobs
bg
jobs
ps aux | grep toprak
echo [PID] > ~/ares1/gorev_defteri/toprak_pid.txt
```

- `nice` sets the priority when a program starts. `renice` changes the priority of a running process. `nice` needs `-n` before the number, otherwise it thinks the number is a program name.
- `jobs` shows `Stopped` after `Ctrl+Z` and `Running` after `bg`.

**How do I know the two processes have low priority?** In `ps aux`, the `STAT` column has the letter `N`. In `top`, the `NI` column shows 15 and 10.

### 11. Scheduled jobs

```bash
systemctl status cron
crontab -e
```

I added these two lines:

```
* * * * * /home/sude/ares1/araclar/oksijen_kontrol.sh
30 6 * * * /home/sude/ares1/araclar/uyandir.sh
```

```bash
crontab -l
cat ~/ares1/oksijen_raporu.txt
```

- The five fields are: minute, hour, day of month, month, day of week. `*` means "every". Minute comes first, so 06:30 is `30 6`.
- Write the full path, because cron does not run in your current folder.
- Do not use `sudo crontab -e`. It edits the crontab of root.
- I got a "bad hour" error first, because the fields were not separated correctly.

### 12. Launch!

```bash
cat ~/ares1/gorev_defteri/kalkis_sifresi.txt
cd ~/ares1/kapsul
ls -l kalkis.sh
chmod +x kalkis.sh
./kalkis.sh PART1-PART2-PART3-PART4-PART5-PART6
```

`kalkis.sh` had `-rw-r--r--`. There was no `x`, so it could not run. `chmod +x` fixed it.

The parameter is written after the script name with a space. Inside the script, it is `$1`. **Mistake I made:** I gave the path of the password file as the parameter. The script does not open the file, it only compares the text I write.

```bash
cd ~/ares1
cp -r gorev_defteri teslim_OGRENCINO
ls -l teslim_OGRENCINO
```

`-r` is needed to copy a folder with everything in it.

## Launch password

| 1. Part | 2. Part | 3. Part | 4. Part | 5. Part | 6. Part |
|---------|---------|---------|---------|---------|---------|
| KIZIL   | ZETA    | ORION   | 17      | FIRTINA | VEGA    |

## Cleaning up

On my own computer, the cron job runs every minute until I delete it. So after the exercise I cleaned up:

```bash
crontab -r
pkill -f panel_hesapla
pkill -f toprak_analizi
```

I kept the users and groups for exam practice.

## What I learned

- Most of my errors came from paths. `/ares1` starts at the root folder, `ares1/...` starts at the current folder. `~/ares1` works from everywhere.
- grep without a file or a pipe waits for keyboard input.
- `Ctrl+C` kills a program, `Ctrl+Z` stops it.
- `nice` needs `-n`. `renice` needs a PID.
- In cron, minute comes before hour.
- A script parameter is text, not a file.
