# Uygulama 03 - User and Group Management

In this exercise I practiced user and group management on Linux. A company needs different users and groups for software development and documentation work. I created the users and groups, made a project folder and set the file and folder permissions.

I did this exercise on my own Ubuntu terminal.

## Users

| User    | Role                  |
|---------|-----------------------|
| alice   | Project manager       |
| bob     | Developer             |
| charlie | Developer             |
| dave    | Test engineer         |
| eve     | Documentation expert  |

## Groups

| Group              | Members              |
|--------------------|----------------------|
| gelistiriciler     | alice, bob, charlie  |
| testciler          | alice, dave          |
| belgelestiriciler  | alice, eve           |

## Steps

### 1. Create the users

`adduser` creates the user, the home directory and asks for a password.

```bash
sudo adduser alice
sudo adduser bob
sudo adduser charlie
sudo adduser dave
sudo adduser eve
```

### 2. Create the groups and add the users

I used `-aG` with `usermod`. `-a` means "append". Without it, the user loses the groups they already have. This is important for alice, because she is in all three groups.

```bash
sudo groupadd gelistiriciler
sudo groupadd testciler
sudo groupadd belgelestiriciler

sudo usermod -aG gelistiriciler alice
sudo usermod -aG gelistiriciler bob
sudo usermod -aG gelistiriciler charlie
sudo usermod -aG testciler alice
sudo usermod -aG testciler dave
sudo usermod -aG belgelestiriciler alice
sudo usermod -aG belgelestiriciler eve
```

To check the groups:

```bash
groups alice
grep -E 'gelistiriciler|testciler|belgelestiriciler' /etc/group
```

### 3. Create the project folder

The folder is inside alice's home directory, so I needed `sudo`. After that I made alice the owner.

```bash
sudo mkdir /home/alice/proje_klasoru
sudo chown alice /home/alice/proje_klasoru
```

### 4. Create the subfolders and set permissions

```bash
sudo mkdir /home/alice/proje_klasoru/src
sudo mkdir /home/alice/proje_klasoru/tests
sudo mkdir /home/alice/proje_klasoru/docs
```

**src** - for developers, they can write here:

```bash
sudo chown :gelistiriciler /home/alice/proje_klasoru/src
sudo chmod g+w /home/alice/proje_klasoru/src
```

**tests** - for test engineers, they can read:

```bash
sudo chown :testciler /home/alice/proje_klasoru/tests
sudo chmod g+r /home/alice/proje_klasoru/tests
```

**docs** - for documentation, the group can read and write:

```bash
sudo chown :belgelestiriciler /home/alice/proje_klasoru/docs
sudo chmod g+rw /home/alice/proje_klasoru/docs
```

`chown :group` only changes the group of the folder. The owner stays the same.

### 5. Create ana_kod.py in src

Only the owner and the group can read and write this file (660).

```bash
sudo touch /home/alice/proje_klasoru/src/ana_kod.py
sudo chmod 660 /home/alice/proje_klasoru/src/ana_kod.py
```

### 6. Create proje_belgeleri.txt in docs

The owner can read, write and execute. The group can only write (720).

```bash
sudo touch /home/alice/proje_klasoru/docs/proje_belgeleri.txt
sudo chmod 720 /home/alice/proje_klasoru/docs/proje_belgeleri.txt
```

### 7. Check the permissions

```bash
sudo ls -l /home/alice/proje_klasoru/
```

You can also test the access of a user with `sudo -u`:

```bash
sudo -u bob ls /home/alice/proje_klasoru/src
```

### 8. Create gizli_dosya.txt in docs

Only the owner can read and write this file (600). Nobody else has access.

```bash
sudo touch /home/alice/proje_klasoru/docs/gizli_dosya.txt
sudo chmod 600 /home/alice/proje_klasoru/docs/gizli_dosya.txt
```

## Permission numbers

| Number | Permission | Meaning               |
|--------|------------|-----------------------|
| 7      | rwx        | read, write, execute  |
| 6      | rw-        | read, write           |
| 4      | r--        | read only             |
| 2      | -w-        | write only            |
| 0      | ---        | no permission         |

The three numbers are for the owner, the group and others. For example, `660` means the owner and the group can read and write, others have no permission.

## What I learned

- A path that starts with `/` is an absolute path. Without `/`, Linux looks for the path inside the current folder. I got a "No such file or directory" error because of this.
- I need `sudo` to create files in another user's home directory.
- On new Ubuntu versions, home directories have `750` permission. Because of this, I could not list `/home/alice/proje_klasoru` without `sudo`.
- For folders, `x` is needed to enter the folder. Without `x`, the `w` permission is not useful.
- Files created with `sudo` belong to root. To give them to another user, I need `chown`.
