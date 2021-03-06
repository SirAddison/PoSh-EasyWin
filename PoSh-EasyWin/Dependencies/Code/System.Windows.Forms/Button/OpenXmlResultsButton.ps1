$OpenXmlResultsButtonAdd_Click = {
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    $ViewXMLResultsOpenResultsOpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog -Property @{
        Title            = "View Collection Results"
        InitialDirectory = $(if (Test-Path "$($script:CollectionSavedDirectoryTextBox.Text)") {$($script:CollectionSavedDirectoryTextBox.Text)} else {$CollectedDataDirectory})
        filter           = "Results (*.xml)|*.xml|XML (*.xml)|*.xml|All files (*.*)|*.*"
        #filter           = "Results (*.txt;*.csv;*.xlsx;*.xls)|*.txt;*.csv;*.xls;*.xlsx|Text (*.txt)|*.txt|CSV (*.csv)|*.csv|Excel (*.xlsx)|*.xlsx|Excel (*.xls)|*.xls|All files (*.*)|*.*"
        ShowHelp = $true
    }
    $ViewXMLResultsOpenResultsOpenFileDialog.ShowDialog()
    if ($ViewXMLResultsOpenResultsOpenFileDialog.filename) { 
        $ViewXMLResultsOpenResultsOpenFileDialog.filename | Set-Variable -Name ViewImportResults 
        $SavePath = Split-Path -Path $ViewXMLResultsOpenResultsOpenFileDialog.filename
        $FileName = Split-Path -Path $ViewXMLResultsOpenResultsOpenFileDialog.filename -Leaf

        if ($ViewImportResults) {
            Open-XmlResultsInShell -ViewImportResults $ViewImportResults -FileName $FileName -SavePath $SavePath    
        }
    }
    else {
        Remove-Variable -Name ViewImportResults -Force -ErrorAction SilentlyContinue
    }

    CommonButtonSettings -Button $RetrieveFilesButton

    CommonButtonSettings -Button $OpenXmlResultsButton
    CommonButtonSettings -Button $OpenCsvResultsButton

    CommonButtonSettings -Button $BuildChartButton
    CommonButtonSettings -Button $AutoCreateDashboardChartButton
    CommonButtonSettings -Button $AutoCreateMultiSeriesChartButton
}
$OpenXmlResultsButtonAdd_MouseHover = {
    Show-ToolTip -Title "Open Data In Shell (PowerShell Terminal)" -Icon "Info" -Message @"
+ Allows you to view and manipulate the results as object data from xml files
+ The results are stored in `$Results and passed into a new PowerShell terminal
+ The 'C:\Windows\Temp\PoSh-EasyWin' dir is created, mounted as a PSDrive, and used
"@ 
}

