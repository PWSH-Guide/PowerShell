$folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$result = $folderBrowserDialog.ShowDialog()
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $selectedFolder = $folderBrowserDialog.SelectedPath
    [System.Windows.Forms.MessageBox]::Show("Selected folder: $selectedFolder")
}
