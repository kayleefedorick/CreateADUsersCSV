# Create AD Users from CSV

This PowerShell script automates creating Active Directory users by importing their data from a CSV file. The user's logon name will be created using their first initial and last name. The script will generate a 10-character random password for each user. The password must be changed at first logon.

Modify the script to set the location of your CSV file and home directories for the user accounts. An example CSV file is provided.

The script will also make the users members of a group named "Users - Staff" and move the users into an OU named "Staff". Modify this as needed.

If the Username already exists, it will be skipped and an error will be displayed.

Tested with PowerShell Version 5.1 on Windows Server 2016.

## Example output:

```
FirstName LastName  Email                     Phone      Description        Expires
--------- --------  -----                     -----      -----------        -------
Merve     MacGowan  mmacgowan@betterguitar.co 5874862965 Software Developer 120    
Pasi      Anand     panand@betterguitar.co    5872051946 Web Developer      120    
Jaci      Schroeter schroeter@betterguitar.co 7801843726 SEO Specialist     120    
Corinna   Wetzel    cwetzel@betterguitar.co   5872931273 Data Scientist     365    
Anu       Uberti    auberti@betterguitar.co   5879281634 Media Consultant   120    


5 rows of user data imported.
User mmacgowan created with password iku9vUELIK
User panand created with password NqVtCEgv1d
User jschroeter created with password Zbi5Dn2Vx9
User cwetzel created with password NM5UsrW9wS
User auberti created with password tAfB2ZJCwp
```