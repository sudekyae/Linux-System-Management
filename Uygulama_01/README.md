# Practice 01 - Project Directory and File Management

## Objective
The goal of this practice is to learn how to create directories, manage files, navigate between directories, and view file contents using Linux terminal commands.

## Step 1 - Create the Project Directory

First, I moved to my home directory and created a new directory named `YazilimProjesi`.

- `cd ~` - Move to the home directory.
- `mkdir YazilimProjesi` - Create the project directory.
- `cd YazilimProjesi` - Enter the project directory.

## Step 2 - Create Subdirectories

I created three subdirectories inside the project directory.

- `mkdir src docs tests` - Create three directories.

Their purposes are:

- `src` - Stores source code files.
- `docs` - Stores project documentation.
- `tests` - Stores test files.

## Step 3 - Create Python Files

I moved to the `src` directory and created two empty Python files.

- `cd src` - Enter the source directory.
- `touch main.py utils.py` - Create two empty Python files.
- `cd ..` - Return to the parent directory.

## Step 4 - Create a Test File

I created a Python test file inside the `tests` directory.

- `cd tests`
- `touch test_main.py` - Create the test file.

## Step 5 - Create a Documentation File

I created a text file for project documentation.

- `cd docs`
- `touch proje_tanimi.txt` - Create an empty documentation file.

## Step 6 - View Directories and Files

I checked the project structure using the following command:

- `ls -R` - List files and directories recursively.

## Step 7 - Check File Contents

I used the `cat` command to view the contents of two files.

- `cat src/main.py` - Display the main Python file.
- `cat docs/proje_tanimi.txt` - Display the project documentation file.

Both files were empty because no content was added.

## Bonus Task - Create an Additional File

I created an additional documentation file and checked the files in the `docs` directory.

- `touch docs/kullanim_kilavuzu.txt` - Create a user guide file.
- `ls docs` - List the files inside the documentation directory.

## What I Learned

In this practice, I learned how to:

- Create directories using `mkdir`.
- Navigate directories using `cd`.
- Create empty files using `touch`.
- List files and directories using `ls`.
- View file contents using `cat`.
- Organize files in a Linux project.
