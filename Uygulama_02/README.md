# Uygulama 02 - Customer Files and Log Analysis

This is the second lab exercise from my Linux course. I solved it again at home on Ubuntu terminal to study for the exam.

In this exercise I work in an IT department. My job is to organize customer folders, make backups and check the error logs on the system.

## Files

- `error.log` - log file from Moodle (copied to `/var/log/`)
- `temp.txt` - test file for the cleaning part

## Tasks

### 1. Organizing customer information

First I created the main folder and one folder for each customer.

```bash
mkdir -p musteriler/musteri_A musteriler/musteri_B musteriler/musteri_C
```

Then I added the customer info to `bilgiler.txt` in `musteri_A`.

```bash
echo "İsim: Ali Demir" > musteriler/musteri_A/bilgiler.txt
echo "Telefon: 05412345678" >> musteriler/musteri_A/bilgiler.txt
echo "Email: ali@example.com" >> musteriler/musteri_A/bilgiler.txt
```

Listing the customer folders:

```bash
ls musteriler
```

### 2. Backup and copy

I copied the whole `musteriler` folder into `yedekler`.

```bash
mkdir yedekler
cp -r musteriler yedekler/
```

To check if the copy worked, I listed both folders:

```bash
ls -R musteriler
ls -R yedekler/musteriler
```

### 3. Changing customer information

The customer wanted a new phone number, so I changed it with `sed`.

```bash
sed -i 's/05412345678/05498765432/' musteriler/musteri_A/bilgiler.txt
cat musteriler/musteri_A/bilgiler.txt
```

### 4. Checking error logs

I needed sudo to put the log file in `/var/log/`, because this folder belongs to root.

```bash
sudo cp error.log /var/log/
cat /var/log/error.log
```

Only the lines with "ERROR":

```bash
grep "ERROR" /var/log/error.log
```

Getting the error codes (the second word of each line):

```bash
grep "ERROR" /var/log/error.log | awk '{print $2}'
```

### 5. Cleaning unnecessary files

I created `temp.txt` in `musteri_A` and copied it to the other customer folders.

```bash
touch musteriler/musteri_A/temp.txt
cp musteriler/musteri_A/temp.txt musteriler/musteri_B/
cp musteriler/musteri_A/temp.txt musteriler/musteri_C/
```

Finding and deleting all `temp.txt` files:

```bash
find musteriler -name "temp.txt"
find musteriler -name "temp.txt" -delete
```

`musteri_C` is not used anymore, so I removed it with everything inside:

```bash
rm -r musteriler/musteri_C
```

### 6. Report

I searched for the lines with "Ali" in the customer files and saved them to a report file.

```bash
grep -r "Ali" musteriler > guncelleme_raporu.txt
cat guncelleme_raporu.txt
```

### 7. Moving and updating the backup

I moved `musteri_B` to the `yedekler` folder and checked the result.

```bash
mv musteriler/musteri_B yedekler/
ls musteriler
ls yedekler
```

## What I learned

- `cp -r` is needed to copy folders, without `-r` it does not work
- `>` writes a new file, `>>` adds to the end of the file
- `grep` and `awk` together are very useful for reading log files
- `find` with `-delete` can remove many files at the same time
- Be careful with `rm -r`, there is no undo
