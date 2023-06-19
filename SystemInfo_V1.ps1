$Form = New-Object System.Windows.Forms.Form
$TextBox = New-Object System.Windows.Forms.TextBox
$TextBox.Multiline = $true
$TextBox.ScrollBars = "Vertical"
$TextBox.Location = New-Object System.Drawing.Point(10, 10)
$TextBox.Size = New-Object System.Drawing.Size(600, 300)
$Form.Controls.Add($TextBox)

$computerName = $env:COMPUTERNAME
$operatingSystem = (Get-WmiObject Win32_OperatingSystem).Caption
$textBox.Text = "Computer Name: $computerName`r`nOperating System: $operatingSystem"

$Form.ShowDialog()
