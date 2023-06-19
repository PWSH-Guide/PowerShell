Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Form = New-Object System.Windows.Forms.Form
$Form.Size = New-Object System.Drawing.Size(500, 400)
$Form.Font = New-Object System.Drawing.Font("Calibri", 11)
$Form.FormBorderStyle = "FixedSingle"

$ListBox = New-Object System.Windows.Forms.ListBox
$ListBox.Location = New-Object System.Drawing.Point(10, 10)
$ListBox.Size = New-Object System.Drawing.Size(400, 300)
$ListBox.Font = New-Object System.Drawing.Font("Calibri", 11)
$Form.Controls.Add($ListBox)

$EventLog = Get-WinEvent -LogName "Application" -MaxEvents 100
foreach ($event in $EventLog) {
    $ListBox.Items.Add($event.Message)
}

$Form.ShowDialog()
