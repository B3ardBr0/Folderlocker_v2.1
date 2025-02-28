# Secure Folder Locker v2.1 - Documentation

## Overview

Secure Folder Locker is a Windows batch script utility designed to protect sensitive files by creating a hidden, password-protected folder on your system. The script works by renaming your folder to a special Windows Control Panel CLSID and applying hidden attributes to make it inaccessible to casual users.

## Features

- Create a secure, hidden folder for storing sensitive files
- Password protection for accessing the secure folder
- Simple menu-driven interface
- Password change capability
- Status indicators showing whether the folder is locked or unlocked
- Basic password validation and verification
- Improved error handling and operation feedback

## System Requirements

- Windows 7/8/10/11
- Administrator privileges (required)
- Command Prompt access

## Installation

1. Copy the entire batch script into a text editor
2. Save the file with a `.bat` extension (e.g., `FolderLocker.bat`)
3. Place the batch file in the directory where you want to create your secure folder
4. Right-click the batch file and select "Run as administrator"

## Usage Instructions

### First-Time Setup

1. Run the batch script as administrator
2. The main menu will display "Status: NOT SETUP"
3. Select option [1] to create a secure folder
4. You'll be prompted to set up a password
   - Enter a password at least 6 characters long
   - Confirm your password when prompted
5. The script will create a folder named "Locker" in the same directory
6. Place any files you want to secure inside this folder

### Locking Your Folder

1. Run the batch script as administrator
2. The main menu will show "Status: UNLOCKED"
3. Select option [1] to lock the folder
4. Confirm your intention to lock the folder by pressing Y
5. Enter your password when prompted
6. The folder will be hidden and locked
7. The script will confirm if the operation was successful

### Unlocking Your Folder

1. Run the batch script as administrator
2. The main menu will show "Status: LOCKED"
3. Select option [1] to unlock the folder
4. Enter your password when prompted
5. If the password is correct, the folder will become visible and accessible
6. The script will confirm if the operation was successful

### Changing Your Password

1. Run the batch script as administrator
2. Select option [2] to change your password
3. Enter your current password when prompted
4. Enter and confirm your new password
5. The password will be updated

## Security Information

### Security Level

This script provides **basic privacy protection** suitable for:
- Hiding sensitive files from casual users
- Preventing accidental discovery of personal files
- Basic privacy on shared computers

This script is **not** suitable for:
- Protection against determined attackers
- Security against users with technical knowledge
- True encryption of sensitive data

### Security Mechanisms

The script uses several techniques to provide basic security:
1. **Special Folder Naming**: Renaming the folder to a Windows Control Panel CLSID
2. **Hidden Attributes**: Setting system and hidden attributes on the folder
3. **Password Protection**: Basic password verification before allowing access
4. **Simple Password Storage**: The password is stored in a hidden file

### Security Limitations

Users should be aware of the following limitations:
1. The folder protection can be bypassed by users who know how to show hidden files
2. The password is stored in a hidden file with minimal protection, not true encryption
3. The files inside the folder are not encrypted - only the folder itself is hidden
4. If someone gains access to the batch file and the password file, they could potentially access your folder

## Best Practices

For maximum effectiveness:
1. Always run the script as administrator
2. Use a strong, unique password
3. Do not share the batch file or its location with others
4. Consider renaming the batch file to something inconspicuous
5. Do not store the only copy of important files in the secure folder
6. Always lock the folder when not in use

## Troubleshooting

### Common Issues

1. **"Administrative privileges required" message**
   - Right-click the batch file and select "Run as administrator"

2. **Cannot see the folder after unlocking**
   - Refresh the Explorer window (F5)
   - Ensure the folder was properly unlocked

3. **"Invalid password" when you know it's correct**
   - Make sure Caps Lock is not enabled
   - Try restarting the script

4. **Cannot lock/unlock folder**
   - Ensure no files in the folder are currently open
   - Close any Explorer windows showing the folder contents
   - Run the script as administrator
   - Check the script output for specific error messages

5. **Folder not locking properly**
   - Make sure you're using the latest v2.1 script 
   - Ensure the folder isn't being accessed by another program
   - Try closing and reopening File Explorer

## Technical Details

### Files Created

The script creates the following files:
- `Locker` - The visible folder where you store your files (when unlocked)
- `Control Panel.{21EC2020-3AEA-1069-A2DD-08002B30309D}` - The hidden folder (when locked)
- `.config.dat` - Hidden file storing the password

### Technical Improvements in v2.1

Version 2.1 includes several important technical improvements:
1. Improved password handling with more reliable storage and comparison
2. Better folder operation sequence (remove attributes, rename, apply new attributes)
3. Added verification checks after locking/unlocking operations
4. Better error handling and suppression of distracting messages
5. Fixed issues with folder attributes that could prevent locking

### Customization

Advanced users can modify the script to:
- Change the default folder name by editing the `LOCKERNAME` variable
- Change the Control Panel CLSID by editing the `HIDDENNAME` variable
- Change the password file name by editing the `PASSWORDFILE` variable

## Legal and Ethical Considerations

- This tool is intended for personal privacy and organization
- Do not use this tool to hide illegal content
- This tool does not provide legally compliant data protection
- Not recommended for highly sensitive information that requires true encryption

## Disclaimer

This script provides basic privacy through obscurity techniques and is not a substitute for proper encryption software. The creator assumes no responsibility for any data loss or security breaches that may occur while using this utility.
