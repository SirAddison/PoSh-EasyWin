$CollectionCommandStartTime = Get-Date
$CollectionName = "Network Connection - Search Local Port"
$StatusListBox.Items.Clear()
$StatusListBox.Items.Add("Executing: $CollectionName")
$ResultsListBox.Items.Insert(1,"$(($CollectionCommandStartTime).ToString('yyyy/MM/dd HH:mm:ss'))  $CollectionName")
$PoShEasyWin.Refresh()

$script:ProgressBarEndpointsProgressBar.Value = 0

$NetworkConnectionSearchLocalPort = $NetworkConnectionSearchLocalPortRichTextbox.Lines
#$NetworkConnectionSearchLocalPort = ($NetworkConnectionSearchLocalPortRichTextbox.Text).split("`r`n")
#$NetworkConnectionSearchLocalPort = $NetworkConnectionSearchLocalPort | Where $_ -ne ''

$OutputFilePath = "$($script:CollectionSavedDirectoryTextBox.Text)\Network Connection - Local Port"

#Invoke-Command -ScriptBlock ${function:Query-NetworkConnection} -argumentlist $null,$NetworkConnectionSearchLocalPort,$null -Session $PSSession | Export-Csv -Path $OutputFilePath -NoTypeInformation -Force
Invoke-Command -ScriptBlock {
    param($QueryNetworkConnection,$NetworkConnectionSearchLocalPort)
    Invoke-Expression -Command $QueryNetworkConnection
    Query-NetworkConnection -LocalPort $NetworkConnectionSearchLocalPort
} -argumentlist $QueryNetworkConnection,$NetworkConnectionSearchLocalPort -Session $PSSession `
| Set-Variable SessionData
$SessionData | Export-Csv    -Path "$OutputFilePath.csv" -NoTypeInformation -Force
$SessionData | Export-Clixml -Path "$OutputFilePath.xml" -Force
Remove-Variable -Name SessionData -Force

$ResultsListBox.Items.RemoveAt(1)
$ResultsListBox.Items.Insert(1,"$(($CollectionCommandStartTime).ToString('yyyy/MM/dd HH:mm:ss'))  [$(New-TimeSpan -Start $CollectionCommandStartTime -End (Get-Date))]  $CollectionName")
$PoShEasyWin.Refresh()

$script:ProgressBarQueriesProgressBar.Value += 1
$script:ProgressBarEndpointsProgressBar.Value = ($PSSession.ComputerName).Count
$PoShEasyWin.Refresh()
Start-Sleep -match 500
 