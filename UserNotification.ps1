#Enter the name of your Desktop Delivery Controller below.
#If you have Load Balanced your Desktop Delivery Controllers, use that address instead.
$DDC = "Delivery Control.FQDN.HERE"

#Do not modify any of the below code unless you know what you are doing.
$username = $args[0]
$group =$args[1]
$PublishedApp = $args[2]
Invoke-Command -ComputerName $DDC -ScriptBlock{get-brokersession | where-object ApplicationsInUse -eq "$using:PublishedApp" | where-object Username -CLike "*\$using:username" | Send-BrokerSessionMessage -MessageStyle Information -Title "Session Will End in 5 minutes" -Text "This admin session will end in 5 minutes.  Please save your work to prevent loss of data."}

