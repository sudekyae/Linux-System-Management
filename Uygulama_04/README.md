# Uygulama 04 - User and Group Management (Extra Practice)

This is an extra exercise to practice the commands from Uygulama 03. A small game studio is making a mobile game. Every team should only access its own files. I created the users and groups, made a project folder and set the owners and permissions of the files and folders.

The task list is in `Uygulama_04_Gorevler.md` (in Turkish).

## Users

| User   | Role               |
|--------|--------------------|
| mert   | Project manager    |
| zeynep | Graphic designer   |
| can    | Graphic designer   |
| elif   | Sound designer     |
| deniz  | Game tester        |

## Groups

| Group        | Members              |
|--------------|----------------------|
| tasarimcilar | mert, zeynep, can    |
| sesciler     | mert, elif           |
| testerlar    | mert, deniz, zeynep  |

## Steps

### 1. Create the users

```bash
sudo adduser mert
sudo adduser zeynep
sudo adduser can
sudo adduser elif
sudo adduser deniz
```

### 2. Create the groups and add the users

Mert and Zeynep are in more than one group, so I used `-aG`. Without `-a`, the user loses the other groups.

```bash
sudo groupadd tasarimcilar
sudo groupadd sesciler
sudo groupadd testerlar

sudo usermod -aG tasarimcilar mert
sudo usermod -aG tasarimcilar zeynep
sudo usermod -aG tasarimcilar can
sudo usermod -aG sesciler mert
sudo usermod -aG sesciler elif
sudo usermod -aG testerlar mert
sudo usermod -aG testerlar deniz
sudo usermod -aG testerlar zeynep
```

### 3. Check the groups

Group information is in the `/etc/group` file. `-E` lets me use `|` to search for more than one word.

```bash
grep -E 'tasarimcilar|sesciler|testerlar' /etc/group
groups mert
```

The difference: `groups user` shows the groups of a user. `grep group /etc/group` shows the members of a group.

### 4. Create the project folder

```bash
sudo mkdir /home/mert/oyun_projesi
sudo chown mert /home/mert/oyun_projesi
```

### 5. Create the subfolders and set permissions

```bash
sudo mkdir /home/mert/oyun_projesi/grafik
sudo mkdir /home/mert/oyun_projesi/sesler
sudo mkdir /home/mert/oyun_projesi/testler
```

**grafik** - the group can write:

```bash
sudo chown :tasarimcilar /home/mert/oyun_projesi/grafik
sudo chmod g+w /home/mert/oyun_projesi/grafik
```

**sesler** - the group can read and write:

```bash
sudo chown :sesciler /home/mert/oyun_projesi/sesler
sudo chmod g+rw /home/mert/oyun_projesi/sesler
```

**testler** - the group can only read:

```bash
sudo chown :testerlar /home/mert/oyun_projesi/testler
sudo chmod g+r /home/mert/oyun_projesi/testler
```

### 6. karakter_tasarimi.txt

I used `sudo nano` to create the file and write in it. `sudo echo "text" > file` does not work, because the `>` part runs as my own user, not as root.

Owner: zeynep, group: tasarimcilar. The owner can read and write, the group can only read, others have no permission (640).

```bash
sudo nano /home/mert/oyun_projesi/grafik/karakter_tasarimi.txt
sudo chown zeynep:tasarimcilar /home/mert/oyun_projesi/grafik/karakter_tasarimi.txt
sudo chmod 640 /home/mert/oyun_projesi/grafik/karakter_tasarimi.txt
```

### 7. muzik_listesi.txt

Owner: elif, group: sesciler. The owner and the group can read and write, others can only read (664).

```bash
sudo nano /home/mert/oyun_projesi/sesler/muzik_listesi.txt
sudo chown elif:sesciler /home/mert/oyun_projesi/sesler/muzik_listesi.txt
sudo chmod 664 /home/mert/oyun_projesi/sesler/muzik_listesi.txt
```

### 8. hata_raporu.txt

Owner: deniz, group: testerlar. The owner can read, write and execute, the group can read and write, others have no permission (760).

```bash
sudo nano /home/mert/oyun_projesi/testler/hata_raporu.txt
sudo chown deniz:testerlar /home/mert/oyun_projesi/testler/hata_raporu.txt
sudo chmod 760 /home/mert/oyun_projesi/testler/hata_raporu.txt
```

### 9. butce.txt

Only mert can read and write this file (600).

```bash
sudo nano /home/mert/oyun_projesi/butce.txt
sudo chown mert /home/mert/oyun_projesi/butce.txt
sudo chmod 600 /home/mert/oyun_projesi/butce.txt
```

### 10. Check the permissions

```bash
sudo ls -lR /home/mert/oyun_projesi
```

## Questions and answers

**Can Can read karakter_tasarimi.txt? Can he change it?**
Can is in the tasarimcilar group. The group has only read permission (r--), so he can read the file but he cannot change it.

**Can Deniz read muzik_listesi.txt?**
Yes. Deniz is not the owner and not in the sesciler group, so he is in "others". Others have read permission (r--).

**Can Elif read hata_raporu.txt? Why?**
No. Elif is not in the testerlar group, so she is in "others". Others have no permission (---).

**Can Zeynep change hata_raporu.txt? Why?**
Yes. Zeynep is in the testerlar group and the group has read and write permission (rw-).

**Who can access butce.txt other than mert?**
Only root. Root can read and write every file, so users with `sudo` can also open it.

## A note about the home folder

The answers above are based on the file permissions. But in practice, `/home/mert` has `750` permission. The other users are not in the mert group, so they cannot enter `/home/mert`. Because of this, they cannot open their files, even if the file permissions are correct. You can test it like this:

```bash
sudo -u can cat /home/mert/oyun_projesi/grafik/karakter_tasarimi.txt
```

To use a file, a user needs `x` permission on every folder in the path.

## Files in this folder

- `oyun_projesi/` is a copy of `/home/mert/oyun_projesi`. Git does not save file owners and permissions, so the real permissions are in `izinler.txt`.
- `izinler.txt` is the output of `sudo ls -lR /home/mert/oyun_projesi`.
- `Uygulama_04_Gorevler.md` is the task list.
