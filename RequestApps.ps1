# Do not modify any of the below code unless you know what you are doing.
###################Load Assembly for creating form & button######
  
[void][System.Reflection.Assembly]::LoadWithPartialName( "System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName( "Microsoft.VisualBasic")
  
  
#####Define the form size & placement
  
$form = New-Object "System.Windows.Forms.Form";
$form.Width = 500;
$form.Height = 300;
$form.Text = "Just In Time Admin Request Portal";
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;
$form.ControlBox = $True
  
  
##############Define text for Group Selection
  
$textLabel2 = New-Object "System.Windows.Forms.Label";
$textLabel2.Left = 10;
$textLabel2.Top = 80;  
$textLabel2.Text = "Select your Tool";
##############Define text label for Time Limit
  
$textLabel = New-Object "System.Windows.Forms.Label";
$textLabel.Left = 10;
$textLabel.Top = 50;  
$textLabel.Text = "Length of Access";
##############Define text label for Time Limit
  
$textLabel3 = New-Object "System.Windows.Forms.Label";
$textLabel3.Left = 10;
$textLabel3.Top = 10; 
$textLabel3.Width = 500; 
$textLabel3.Text = "Please select your resource and time length below.";  

##############Define text for Group Selection
  
$textLabel2 = New-Object "System.Windows.Forms.Label";
$textLabel2.Left = 10;
$textLabel2.Top = 110;  
$textLabel2.Text = "Reason for Access";
  
############Define text box2 for input
  
$cBox2 = New-Object "System.Windows.Forms.combobox";
$cBox2.Left = 150;
$cBox2.Top = 80;
$cBox2.width = 200;

$cBox2time = New-Object "System.Windows.Forms.combobox";
$cBox2time.Left = 150;
$cBox2time.Top = 50;
$cBox2time.width = 200;

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(150,110)
$textBox.Size = New-Object System.Drawing.Size(260,200)

  
###############"Add descriptions to combo box"##############
 
$input = import-csv "resources.var" 
$cBox2.DisplayMember = 'Name'

$input | ForEach-Object {
    $cBox2.Items.Add($_)
}
import-csv "times.var" | ForEach-Object {
    $cBox2time.Items.Add($_.Times)
} 
  
#############define OK button
$button = New-Object "System.Windows.Forms.Button";
$button.Text = "Ok";
$Button.Location = New-Object System.Drawing.Point(75,200)
$Button.Size = New-Object System.Drawing.Size(75,23)
$Button.Cursor = [System.Windows.Forms.Cursors]::Hand

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,200)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

############# This is when you have to close the form after getting values
$eventHandler = [System.EventHandler]{
$cBox2.Text;
$cBox2time.Text;
$form.Close();};
$button.Add_Click($eventHandler) ;
  
#############Add controls to all the above objects defined
$form.Controls.Add($button);
$form.Controls.Add($textLabel);
$form.Controls.Add($textLabel2);
$form.Controls.Add($textLabel3);
$form.Controls.Add($cBox2);
$form.Controls.Add($cBox2time);
$form.Controls.Add($textBox)
  
#################return values
$button.add_Click({
      
    $script:GroupResult = $cBox2.selectedItem.Group 
    $script:TimeResult = $cBox2time.selectedItem 
    $script:PublishedApp = $cBox2.selectedItem.PublishedApp
    $script:Details = $textbox.text
})
  
$form.Controls.Add($button)
$form.Controls.Add($cBox2)
$form.Controls.Add($cBox2time)  
$form.ShowDialog() | out-null
  
$Group = $script:GroupResult
$Time = $script:TimeResult
$PublishedApp = $script:PublishedApp 
$Details = $script:Details

$generaterightsfile = ".\GenerateRights\rights" + (Get-Date -Format "yyyy-MM-dd-HH-mm-ss") + ".rt"
$RequestTime = (Get-Date -Format "yyyyMMddHHmm")
$EndTime = (Get-Date).AddMinutes([int]$time + 1)
$EndTimeCode =  Get-Date $EndTime -Format "HH:mm"
$NotificationTime = (Get-Date).AddMinutes([int]$time -5)
$NotificationTimeCode =  Get-Date $NotificationTime -Format "HH:mm"
$request = $group + "," + $time + "," + $Env:USERNAME + "," + $RequestTime + "," + $EndTimeCode + "," + $NotificationTimeCode + "," + $PublishedApp  + "," + $Details
$request | Out-File -FilePath $generaterightsfile -Append