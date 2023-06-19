Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Form = New-Object System.Windows.Forms.Form
$Form.Size = New-Object System.Drawing.Size(900, 600) # Increased size to be 3x larger
$TextBox = New-Object System.Windows.Forms.TextBox
$TextBox.Multiline = $true
$TextBox.ScrollBars = "Vertical"
$TextBox.Location = New-Object System.Drawing.Point(10, 10)
$TextBox.Size = New-Object System.Drawing.Size(870, 550) # Adjusted size to fit within the larger window
$Form.Controls.Add($TextBox)

$computerName = $env:COMPUTERNAME

$operatingSystem = (Get-WmiObject Win32_OperatingSystem).Caption

$processor = Get-WmiObject Win32_Processor
$processorInfo = "Processor: $($processor.Manufacturer) $($processor.Name)"
$processorCores = "Cores: $($processor.NumberOfCores)"

$memory = Get-WmiObject Win32_ComputerSystem
$totalMemory = "Total Memory: {0:N2} GB" -f ($memory.TotalPhysicalMemory / 1GB)
$availableMemory = "Available Memory: {0:N2} GB" -f ($memory.FreePhysicalMemory / 1GB)

$disks = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
$diskInfo = "Disk Information:"
foreach ($disk in $disks) {
    $totalSpace = "{0}: {1:N2} GB" -f $disk.DeviceID, ($disk.Size / 1GB)
    $freeSpace = "{0}: {1:N2} GB" -f $disk.DeviceID, ($disk.FreeSpace / 1GB)
    $diskInfo += "`r`n$totalSpace (Free: $freeSpace)"
}

$networkAdapter = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled }
$ipAddresses = "IP Address(es): $($networkAdapter.IPAddress -join ', ')"
$defaultGateway = "Default Gateway: $($networkAdapter.DefaultIPGateway -join ', ')"
$dnsServers = "DNS Servers: $($networkAdapter.DNSServerSearchOrder -join ', ')"

$systemUptime = (Get-WmiObject -Class Win32_OperatingSystem).LastBootUpTime
$uptime = "System Uptime: $((Get-Date) - [Management.ManagementDateTimeConverter]::ToDateTime($systemUptime))"

$loggedInUser = Get-WmiObject Win32_ComputerSystem | Select-Object -ExpandProperty UserName

$architecture = if ([Environment]::Is64BitOperatingSystem) { "64-bit" } else { "32-bit" }

$textBox.Text = @"
Computer Name: $computerName
Operating System: $operatingSystem

$processorInfo
$processorCores

$totalMemory
$availableMemory

$diskInfo

$ipAddresses
$defaultGateway
$dnsServers

$uptime

Logged-In User: $loggedInUser

System Architecture: $architecture
"@

$Form.ShowDialog()
