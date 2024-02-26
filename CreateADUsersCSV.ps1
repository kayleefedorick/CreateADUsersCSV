#Set home directory
$HomePath="\\KAYLEEDC\HomeDir$\%username%"
$HomeLetter="H:"

#Find the domain to create UPN later
$Domain = Get-ADDomain
$DNSRoot = $Domain.DNSRoot

Write-Host $DNSRoot
#Import the CSV
$UserData = Import-CSV -Path "C:\Automation\Users.csv" 
 
#Format the data as a table
$UserData | Format-Table

#Count total number of rows
$TotalUsers = $UserData.count
Write-Host $TotalUsers rows of user data imported.

#Account creation loop
foreach ($User in $UserData)
{
    #Create logon name using first initial and last name
    $SamAccountName=($User.FirstName.Substring(0,1)+$User.LastName).toLower()
    $FullName = $User.FirstName+" "+$User.LastName

    #Check if account already exists
    if (-Not (Get-ADUser -Filter { SamAccountName -eq $SamAccountName }))
    {
        #Generate a random password with 10 characters
        $rPassword = -join ((48..57) + (65..90) + (97..122) `
        | Get-Random -Count 10 | ForEach-Object {[char]$_})
        $sPassword = ConvertTo-SecureString -String $rPassword -AsPlainText -Force

        #Calculate the expiration date
        $expiration = New-TimeSpan -Days $User.Expires

        #Create the user account
        New-ADUser -Name $FullName -SamAccountName $SamAccountName `
        -ChangePasswordAtLogon $true -Enabled $true `
        -AccountPassword $sPassword `
        -OtherAttributes @{
            'userPrincipalName'=$SamAccountName+"@"+$DNSRoot
            'displayName'=$FullName
            'givenName'=$User.FirstName
            'sn'=$User.LastName
            'description'=$User.Description
            'mail'=$User.Email
            'telephoneNumber'=$User.Phone
            'accountExpires'=(Get-Date)+$expiration
            'homeDirectory'=$HomePath
            'homeDrive'=$HomeLetter
        }
        #Get GUID for User and OU
        $UserGUID=(Get-ADUser -Filter {Name -like $FullName}).ObjectGUID
        $OUGUID=(Get-ADOrganizationalUnit -Filter {Name -like "Staff"}).ObjectGUID

        #Add account to Staff group
        Add-ADGroupMember -Identity "Users - Staff" -Members $UserGUID

        #Move account to Staff OU
        Move-ADObject -Identity $UserGUID -TargetPath $OUGUID

        Write-Host "User" $SamAccountName "created with password" `
        ([System.Net.NetworkCredential]::new("", $sPassword).Password)
    }

    else {Write-Host "Error:" $SamAccountName "already exists."}
}