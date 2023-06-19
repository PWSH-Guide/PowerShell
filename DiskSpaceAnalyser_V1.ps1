Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Disk Sense"
$Form.Size = New-Object System.Drawing.Size(700, 600)
$Form.Font = New-Object System.Drawing.Font("Calibri", 11)
$Form.FormBorderStyle = "FixedSingle"

# Create the label and text box
$Label = New-Object System.Windows.Forms.Label
$Label.Location = New-Object System.Drawing.Point(10, 20)
$Label.Size = New-Object System.Drawing.Size(150, 20)
$Label.Text = "Select a directory:"
$Form.Controls.Add($Label)

$TextBox = New-Object System.Windows.Forms.TextBox
$TextBox.Location = New-Object System.Drawing.Point(10, 50)
$TextBox.Size = New-Object System.Drawing.Size(500, 20)
$Form.Controls.Add($TextBox)

# Create the browse button
$BrowseButton = New-Object System.Windows.Forms.Button
$BrowseButton.Location = New-Object System.Drawing.Point(520, 48)
$BrowseButton.Size = New-Object System.Drawing.Size(75, 25)
$BrowseButton.Text = "Browse"
$BrowseButton.Add_Click({
    $folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowserDialog.SelectedPath = $TextBox.Text
    $result = $folderBrowserDialog.ShowDialog()
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $TextBox.Text = $folderBrowserDialog.SelectedPath
    }
})
$Form.Controls.Add($BrowseButton)

# Create the analyse button
$AnalyzeButton = New-Object System.Windows.Forms.Button
$AnalyzeButton.Location = New-Object System.Drawing.Point(10, 80)
$AnalyzeButton.Size = New-Object System.Drawing.Size(75, 25)
$AnalyzeButton.Text = "Analyse"
$AnalyzeButton.Add_Click({
    $path = $TextBox.Text
    if (Test-Path $path) {
        $Results = Get-ChildItem $path -Recurse | Where-Object { -not $_.PSIsContainer } | Sort-Object -Property Length -Descending | Select-Object -First 20
        if ($Results) {
            # Total Directory Size
            $totalSize = ($Results | Measure-Object -Property Length -Sum).Sum
            $ResultTextBox.Text = "Total Directory Size: {0:N2} MB`r`n`r`n" -f ($totalSize / 1MB)

            # File Count
            $fileCount = $Results.Count
            $ResultTextBox.Text += "File Count: $fileCount`r`n`r`n"

            # File Type Distribution
            $fileTypeDistribution = $Results | Group-Object Extension | Sort-Object Count -Descending
            $ResultTextBox.Text += "File Type Distribution:`r`n"
            foreach ($fileType in $fileTypeDistribution) {
                $ResultTextBox.Text += "File Type: $($fileType.Name), Count: $($fileType.Count)`r`n"
            }

            $ResultTextBox.Text += "`r`nTop 10 Largest Files:`r`n`r`n"
            foreach ($result in $Results) {
                $ResultTextBox.Text += "Name: $($result.Name)`r`n"
                $ResultTextBox.Text += "Size: {0:N2} MB`r`n`r`n" -f ($result.Length / 1MB)
            }
        } else {
            $ResultTextBox.Text = "No files found in '$path'."
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Invalid directory path.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})
$Form.Controls.Add($AnalyzeButton)

# Create the result text box
$ResultTextBox = New-Object System.Windows.Forms.TextBox
$ResultTextBox.Multiline = $true
$ResultTextBox.ScrollBars = "Vertical"
$ResultTextBox.Location = New-Object System.Drawing.Point(10, 120)
$ResultTextBox.Size = New-Object System.Drawing.Size(670, 450)
$ResultTextBox.Font = New-Object System.Drawing.Font("Calibri", 11)
$Form.Controls.Add($ResultTextBox)

# Show the form
$Form.ShowDialog()
