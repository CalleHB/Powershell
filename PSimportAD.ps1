Import-Module ActiveDirectory

# Import users from a CSV file on the computer and save to a variable.
$CSVData = Import-Csv -Path "C:\Powershell\ADimport1.csv" -Delimiter ";"

# Loop through each row with user details in the CSV file
foreach ($User in $CSVData) {
    $FirstName = $User.Förnamn
    $LastName = $User.Efternamn
    $Department = $User.Avdelning
    $Country = $User.LAND
    $SamAccountName = ($FirstName + "." + $LastName).ToLower()
    $PasswordUser = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 20 | ForEach-Object {[char]$_})
    $UPN = "@CarlAB.com"
    $DomainUsers = Get-ADGroupMember "Domain Users" | Select-Object -ExpandProperty SamAccountName
    $FilePathAccAndPass = "C:\Powershell\UsernameAndPasswordAD.txt"
    try {
        if ($SamAccountName -notin $DomainUsers) {
            # Action to perform if the condition is true
            New-ADUser -Name "$FirstName $LastName" -SamAccountName $SamAccountName -UserPrincipalName "$SamAccountName$UPN" -GivenName $FirstName -Surname $LastName -EmailAddress "$SamAccountName$UPN" -Department $Department -Country $Country -Enabled $true -AccountPassword (ConvertTo-SecureString -String $PasswordUser -AsPlainText -Force) -ChangePasswordAtLogon $true
            "$SamAccountName, $PasswordUser" | Out-File -FilePath $FilePathAccAndPass -Append
        } else {
            # Action when all if and elseif conditions are false
            # Attempt to create a new user in Active Directory
            # Catch an error and handle it here
            $RandomNumber = Get-Random -Minimum 1 -Maximum 10
            $SamAccountName2 = ($FirstName + $RandomNumber + "-" + $LastName).ToLower()
            Write-Host "Something went wrong: $_"
            Write-Host "Attempting with alternative username $SamAccountName2"
            New-ADUser -Name "$FirstName$RandomNumber $LastName" -SamAccountName $SamAccountName2 -UserPrincipalName "$SamAccountName2$UPN" -GivenName $FirstName -Surname $LastName -EmailAddress "$SamAccountName2$UPN" -Department $Department -Country $Country -Enabled $true -AccountPassword (ConvertTo-SecureString -String $PasswordUser -AsPlainText -Force) -ChangePasswordAtLogon $true
            "$SamAccountName2, $PasswordUser" | Out-File -FilePath $FilePathAccAndPass -Append
        }
    } catch {
        # Catch an error and handle it here
        Write-Host "Something went wrong: $_"
    }
}
