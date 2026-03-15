# RV32I

This repository is used for the Graduation Project.  
Each team member must work on their **own branch named with their personal name**.

Example:
```
Abdelrahman Ahmed 
Mahmoud Magdy
Manar Mohammed
```

Never work directly on `main`.

---

# 1. Install Git (Windows)

1. Download Git from:
   
   https://git-scm.com/download/win

2. Run the installer.

3. Keep clicking **Next** with default settings.

4. After installation open **Git Bash**.

---

# 2. Clone the Repository

Open **Git Bash** and run:

```bash
git clone https://github.com/abdoAhmed704/RV32I
```

Then enter the project folder:

```bash
cd RV32I
```

```bash
git config --global user.email "your-email@example.com"
git config --global user.name = "your_user_name"

```



---

# 3. Create Your Own Branch

Each member must create a branch with **their own name**.

Example:

```bash
git checkout -b Your_name 
```


Check the current branch:

```bash
git branch
```

Example output:

```bash
* ahmed
  main
```

The `*` means this is the current branch you are working on.

---





# 4. Add and Commit Changes


create for example the version of RISC V your are in
``` bash
mkdir RV32I_Single_Cycle

cd RV32I_Single_Cycle

```

then you can open them using VS Code by doing this command:

```bash
code .
```

then add the files you want then:

After editing files:

```bash
git add .
```

Then commit the changes:

```bash
git commit -m "describe your changes"
```

---

# 5. Push Your Branch to GitHub

First push of the branch:

```bash
git push -u origin your-name
```

Example:

```bash
git push -u origin ahmed_Abdulnasser
```

---



# 6. Pull Latest Changes

Before starting new work always pull the latest updates:

```bash
git pull
```

---

# Basic Workflow

Every time you work on the project:

```bash
git pull
git add .
git commit -m "update"
git push
```

---

# Important Rules

- Do NOT push directly to `main`
- Each member must work on a **branch with their own name**
- Always `pull` before starting work
- Always write a clear commit message

