# Folder Locker v2.2

> **This is a privacy trick, not security.** It hides a folder from casual
> view; it does not encrypt anything, and anyone who knows how to show
> hidden files can open it without the password. For anything that actually
> matters, use real encryption such as BitLocker or VeraCrypt.

## Overview

Folder Locker is a Windows batch script that tucks a folder out of casual
sight. It works by renaming the folder to a special Windows CLSID and
applying hidden and system attributes, then gating the script's own
lock/unlock menu behind a password. It is a fun exercise in what plain
batch can do with only built-in Windows tools, and a practical way to keep
a folder away from curious but non-technical eyes on a shared machine.

## Features

- Create and hide a folder through a simple menu-driven interface
- Password gate on the script's lock/unlock/change operations
- Passwords stored as a SHA-256 hash (via built-in `certutil`), never as plain text
- Masked password entry: nothing is echoed to the screen while you type
- Automatic, silent upgrade of password files created by older versions
- Status indicator showing whether the folder is locked or unlocked
- No dependencies beyond what ships with Windows

## System Requirements

- Windows 7/8/10/11
- Administrator privileges (required)
- Command Prompt access

## Installation

1. Copy the batch script into a text editor
2. Save the file with a `.bat` extension (e.g., `FolderLocker.bat`)
3. Place the batch file in the directory where you want the hidden folder
4. Right-click the batch file and select "Run as administrator"

## Usage Instructions

### First-Time Setup

1. Run the batch script as administrator
2. The main menu will display "Status: NOT SETUP"
3. Select option [1] to create the folder
4. You'll be prompted to set a password
   - At least 6 characters
   - Avoid quotes, percent, caret, and exclamation characters (batch
     scripting cannot handle them reliably)
5. The script creates a folder named "Locker" in the same directory
6. Place the files you want hidden inside that folder

### Locking the Folder

1. Run the batch script as administrator
2. The main menu will show "Status: UNLOCKED"
3. Select option [1] to lock the folder
4. Confirm with Y and enter your password
5. The folder is renamed and hidden

### Unlocking the Folder

1. Run the batch script as administrator
2. The main menu will show "Status: LOCKED"
3. Select option [1] to unlock the folder
4. Enter your password
5. The folder becomes visible and accessible again

### Changing the Password

1. Run the batch script as administrator
2. Select option [2]
3. Enter your current password, then set and confirm the new one

## What This Does and Does Not Protect Against

Reasonable uses:

- Keeping personal files out of sight of casual users on a shared computer
- Preventing accidental discovery or deletion of a folder
- Learning how CLSID renames, file attributes, and batch subroutines work

Explicitly **not** protection against:

- Anyone who enables "show hidden files" or runs `dir /a` in a terminal
- Anyone who runs `attrib -h -s` on the folder
- Anyone with technical knowledge, forensic tools, or unsupervised time
- Data theft: the files themselves are never encrypted

The password protects the *script's menu*, not the folder. The rename and
attribute tricks are obscurity, and obscurity is not security.

### How the password is handled

- Only a SHA-256 hash of the password is stored (in a hidden `.config.dat`
  file next to the script), computed with Windows' built-in `certutil`
- Password prompts are masked, so the password is not echoed on screen
- Password files written by versions before v2.2 contained the password in
  plain text; v2.2 detects those and silently replaces them with a hash the
  first time the correct password is entered

## Troubleshooting

1. **"Administrative privileges required" message**
   - Right-click the batch file and select "Run as administrator"

2. **Cannot see the folder after unlocking**
   - Refresh the Explorer window (F5)

3. **"Invalid password" when you know it's correct**
   - Check Caps Lock
   - If your password contains quotes, percent, caret, or exclamation
     characters, it may not survive batch processing; reset it to one
     without those characters

4. **Cannot lock/unlock folder**
   - Ensure no files in the folder are open and no Explorer window is
     showing its contents
   - Run the script as administrator

## Technical Details

### Files Created

- `Locker` - the visible folder (when unlocked)
- `This PC.{20D04FE0-3AEA-1069-A2D8-08002B30309D}` - the renamed, hidden
  folder (when locked)
- `.config.dat` - hidden file storing the SHA-256 hash of the password

### Changes in v2.2

1. Passwords are now stored as SHA-256 hashes instead of plain text, with
   silent one-time migration of old plaintext password files
2. Password entry is masked at every prompt
3. Fixed a real bug: changing the password used to fail silently, because
   the script redirected output to `.config.dat` while it still had
   hidden and system attributes set, and that redirection is refused by
   Windows; attributes are now removed before writing and restored after
4. Fixed the documented CLSID: earlier documentation described a
   `Control Panel` CLSID while the script actually uses `This PC`
5. Fixed a stray `%` in the path variables (`%~dp0%Locker`) that only
   worked by accident of the batch parser
6. Renamed from "Secure Folder Locker": the old name oversold what a
   folder-hiding trick can honestly claim

### Customisation

- Change the folder name by editing the `LOCKERNAME` variable
- Change the CLSID by editing the `HIDDENNAME` variable
- Change the password file name by editing the `PASSWORDFILE` variable

## Disclaimer

This script provides privacy through obscurity and is not a substitute for
encryption software. Do not store the only copy of anything important in
the hidden folder, and do not rely on it to protect genuinely sensitive
data.
