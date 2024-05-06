#Run this Powershell script to generate cert.txt
#Cert.txt contains the code that you will paste to the top of AddGroups.ps1 with the encrypted password to run scheduled tasks.
#In the "Enter Password here for AD Schedule Task" section below type the password for the account. 
#
#
# AFTER GENERATING THIS PASSWORD, EITHER DELETE THIS FILE, OR THE PASSWORD FROM THE SECTION BELOW
# FAILURE TO DO THIS COULD LEAD TO DATA LOSS OR SYSTEM SECURITY ISSUES

$password = ConvertTo-SecureString "Enter Password here for AD Schedule Task" -AsPlainText -Force
 
# Get content of the string
[string]$stringObject = $password |  ConvertFrom-SecureString
 
@"
 [string]`$encPassword = "$($stringObject)"
 [SecureString]`$securePwd = `$encPassword  | ConvertTo-SecureString
 `$password = [System.Net.NetworkCredential]::new("", `$securePwd).Password
"@ | Set-Content -Path "cred.txt"