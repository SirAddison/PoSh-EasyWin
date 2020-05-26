$SingleHostIPCheckBoxAdd_Click = {
    if ($script:SingleHostIPCheckBox.Checked -eq $true){
        $script:SingleHostIPTextBox.Text       = ""
        $script:ComputerTreeView.Enabled   = $false
        $script:ComputerTreeView.BackColor = "lightgray"
    }
    elseif ($script:SingleHostIPCheckBox.Checked -eq $false) {
        $script:SingleHostIPTextBox.Text = $DefaultSingleHostIPText
        $script:ComputerTreeView.Enabled    = $true
        $script:ComputerTreeView.BackColor  = "white"
    }
}

$SingleHostIPCheckBoxAdd_MouseHover = {
    Show-ToolTip -Title "Query A Single Host" -Icon "Info" -Message @"
+  Queries a single host provided in the input field,
     disabling the computer treeview list.
+  This is compatiable with the 'Import from AD' button to pull-in
     data on all domain hosts to populate the computer treeview.
+  Enter a valid hostname or IP address to collect data from. 
     Depending upon host or domain configurations, some queries 
     such as WinRM against valid IPs may not yield results.
"@ 
}