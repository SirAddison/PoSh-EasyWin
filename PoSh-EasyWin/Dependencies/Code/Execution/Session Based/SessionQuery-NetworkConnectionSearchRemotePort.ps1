$CollectionCommandStartTime = Get-Date
$CollectionName = "Network Connection - Search Remote Port"
$StatusListBox.Items.Clear()
$StatusListBox.Items.Add("Executing: $CollectionName")
$ResultsListBox.Items.Insert(1,"$(($CollectionCommandStartTime).ToString('yyyy/MM/dd HH:mm:ss'))  $CollectionName")
$PoShEasyWin.Refresh()

$script:ProgressBarEndpointsProgressBar.Value = 0

$NetworkConnectionSearchRemotePort = $NetworkConnectionSearchRemotePortRichTextbox.Lines
#$NetworkConnectionSearchRemotePort = ($NetworkConnectionSearchRemotePortRichTextbox.Text).split("`r`n")
#$NetworkConnectionSearchRemotePort = $NetworkConnectionSearchRemotePort | Where $_ -ne ''

$OutputFilePath = "$($script:CollectionSavedDirectoryTextBox.Text)\Network Connection - Remote Port"

#Invoke-Command -ScriptBlock ${function:Query-NetworkConnection} -argumentlist $null,$NetworkConnectionSearchRemotePort,$null -Session $PSSession | Export-Csv -Path $OutputFilePath -NoTypeInformation -Force
Invoke-Command -ScriptBlock {
    param($QueryNetworkConnection,$NetworkConnectionSearchRemotePort)
    Invoke-Expression -Command $QueryNetworkConnection
    Query-NetworkConnection -RemotePort $NetworkConnectionSearchRemotePort
} -argumentlist $QueryNetworkConnection,$NetworkConnectionSearchRemotePort -Session $PSSession `
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
 