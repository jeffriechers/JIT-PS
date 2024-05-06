# JIT-PS
Just in time administration through published Citrix Apps

Setup Procedcure
1. Add your Desktop Delivery Controller to the Cleanup.ps1
2. Add your Desktop Delivery Controller to the UserNotification.ps1
3. Select an admin account that has permission to add/remove users from AD groups, and has permission to shutdown Citrix Sessions.
4. Take the admin account password and use the SecurePassword.ps1 to generate a secure cred.txt file.
5. Copy the contents of cred.txt and paste it into the appropriate section in AddGroup.ps1.
6. Enter the username for the admin account into the appropriate section in AddGroup.ps1.
7. Enter the path to the PowerShell files in AddGroup.ps1
8. Import the ProcessGroupRequests.xml scheduled task on the machine that will process Requests.
9. Modify the times.var file to put in the minutes options end-users will need.
10. Modify the resources.var to identify your groups and published applications.
11. Install the Active Directory module for Windows PowerShell on the machine executing the AddGroup.ps1.

Recommended Citrix Virtual Apps Configuration.
1. Create a dedicated 2022 server for hosting your consoles.
2. Use mandatory profiles on this 2022 server.
3. Create an Application Group that uses this dedicated 2022 Delivery Group.
4. Modify the Application Group to disable Session Sharing on the admin connections.
ie.  Set-BrokerApplicationGroup -Name "Admin Apps" -SessionSharingEnabled $false -SingleAppPerSession $true
5. If publishing Edge Browser, consider disabling all the Edge Sign-in settings in GPO.
6. Create necessary Active Directory Groups for each application.
7. Publish Applications and Limit Visibiltiy to those groups you just created in 6.
8. Publish RequestApps.ps1 as a published application for an Admin User's Group.
9. If you are placing your Published Applications into a subfolder under Delivery->Application Category, modify Cleanup.ps1 and UserNotification.ps1 to include that in the ApplicationsInUse -eq "$using:PublishedApp" section.
ie. ApplicationsInUse -eq "Admin Apps\$using:PublishedApp"
