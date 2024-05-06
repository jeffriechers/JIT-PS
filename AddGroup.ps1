# Enter the path to the Powershell scripts
$PSPath = "C:\JIT-PS\"
# Enter the username for the Scheduled Task.  This user must match the password generated from the SecurePassword.ps1 script.
$UserName = "DomainName\AdminAccount"

# Replace the below code with your data located in the cred.txt
# If this file does not exist, you must modify and run the SecurePassword.ps1 process

[string]$encPassword = "acfc"
[SecureString]$securePwd = $encPassword  | ConvertTo-SecureString 
$password = [System.Net.NetworkCredential]::new("", $securePwd).Password

#Do not modify any of the below code unless you know what you are doing.
#Cleanup completed Tasks that have already completed.
get-scheduledtask |where-object{$_.taskpath -match "JITGROUP"}|Get-ScheduledTaskInfo | where-object{$_.NextRuntime -lt 1} | unregister-scheduledtask -Confirm:$false

#Read all the request files and process their entries
$RTFiles = Get-ChildItem ".\GenerateRights\*.rt"
$RTList = $RTFiles 
# Variables in Request file AD group = 1 Length of session = 2 USERNAME = 3 RequestTime =  4 EndTimeCode = 5 NotificationTimeCode = 6 PublishedApp = 7 Details on Connection Request = 8
foreach ($var in Import-CSV $RTList -Header (1..99)){

#Add user to Active Directory Group
Add-ADGroupMember -Identity $var.1 -Members $var.3

#Create a Scheduled Task to run the Cleanup.ps1
#That script will remove user's from the Active Directory Group and end that specific Citrix Session.

$RemoveAction = $PSPath + "Cleanup.ps1 " + $var.3 + " " + $var.1 + " " + $var.7
$action = New-ScheduledTaskAction -execute "Powershell.exe" -Argument $RemoveAction
$trigger = New-ScheduledTaskTrigger -Once -At $var.5
$settings = New-ScheduledTaskSettingsSet
$task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings
$taskname = $var.1 + "-" + $var.4
Register-ScheduledTask -TaskName \JITGroup\$taskname -InputObject $task -User $Username -Password $Password

#Create a Scheduled Task to run the UserNotification.ps1
#That script will notify user's when their session has 5 minutes left before it is ended.

$NotificationAction = $PSPath + "UserNotification.ps1 " + $var.3 + " " + $var.1 + " " + $var.7
$Notaction = New-ScheduledTaskAction -execute "Powershell.exe" -Argument $NotificationAction
$Nottrigger = New-ScheduledTaskTrigger -Once -At $var.6
$Notsettings = New-ScheduledTaskSettingsSet
$Nottask = New-ScheduledTask -Action $Notaction -Trigger $Nottrigger -Settings $Notsettings
$Notttaskname = "Notification" + $var.1 + "-" + $var.4
Register-ScheduledTask -TaskName \JITGroup\$Notttaskname -InputObject $Nottask -User $Username -Password $Password

#Generate a Logfile entry for when user is added to AD.
#Include the username, name of the AD Group, the time it was requested, and how long they requested time for.
$LoggingFile = ".\logs\RequestLog" + (Get-Date -Format "yyyy-MM-dd")
$Logging = "User " + $var.3 + " was given access to " + $var.1 + " at " + $var.4 + " for " + $var.2 + " minutes.  The reason for the connection request is " + $var.8
$Logging | Out-File -FilePath $LoggingFile -Append
}
Remove-Item $RTList