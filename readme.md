# Create AD Users from CSV

This PowerShell script automates creating Active Directory users by importing their data from a CSV file. It will generate a 10-character random password for each user. The password must be changed at first logon.

Modify the script to set the location of your CSV file and home directories for the user accounts. An example CSV file is provided.

The script will also make the users members of a group named "Users - Staff" and move the users into an OU named "Staff". Modify this as needed.