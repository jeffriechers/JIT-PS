#Enter the name of your Desktop Delivery Controller below.
#If you have Load Balanced your Desktop Delivery Controllers, use that address instead.
$DDC = "Delivery Control.FQDN.HERE"

#Do not modify any of the below code unless you know what you are doing.
$username = $args[0]
$group =$args[1]
$PublishedApp = $args[2]
$DeleteTimeCode =  Get-Date -Format "yyyy-MM-dd'T'HH:mm:ss"
Remove-ADGroupMember -Identity $group -Members $username -Confirm:$false
Invoke-Command -ComputerName $DDC -ScriptBlock{get-brokersession | where-object ApplicationsInUse -eq "$using:PublishedApp" | where-object Username -CLike "*\$using:username" | Stop-Brokersession }

#Generate a Logfile entry for when user is removed from AD, and Published Application is logged off.
$LoggingFile = ".\logs\SecureLog" + (Get-Date -Format "yyyy-MM-dd")
$Logging = "User " + $username + " was removed from " + $group + " Active Directory Group at " + $DeleteTimeCode + "  and published application " + $PublishedApp + " was signed out."
$Logging | Out-File -FilePath $LoggingFile -Append