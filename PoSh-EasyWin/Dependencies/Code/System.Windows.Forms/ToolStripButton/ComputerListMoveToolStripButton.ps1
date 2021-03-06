function Show-MoveForm {
    param(
        $FormTitleEndpoints,
        [switch]$SelectedEndpoint
    )
    $StatusListBox.Items.Clear()
    $StatusListBox.Items.Add("Move Selection:  ")

    #----------------------------------
    # ComputerList TreeView Popup Form
    #----------------------------------
    $ComputerTreeNodePopup = New-Object system.Windows.Forms.Form -Property @{
        Text          = "Move"
        Size          = New-Object System.Drawing.Size(330,107)
        StartPosition = "CenterScreen"
        Icon          = [System.Drawing.Icon]::ExtractAssociatedIcon("$Dependencies\Images\favicon.ico")
    }
    $ComputerTreeNodePopup.Text = $FormTitleEndpoints
    
    #----------------------------------------------
    # ComputerList TreeView Popup Execute ComboBox
    #----------------------------------------------
    $ComputerTreeNodePopupMoveComboBox = New-Object System.Windows.Forms.ComboBox -Property @{
        Text     = "Select A Category"
        Location = @{ X = 10
                      Y = 10 }
        Size     = @{ Width  = 300
                      Height = 25 }
        AutoCompleteSource = "ListItems" # Options are: FileSystem, HistoryList, RecentlyUsedList, AllURL, AllSystemSources, FileSystemDirectories, CustomSource, ListItems, None
        AutoCompleteMode   = "SuggestAppend" # Options are: "Suggest", "Append", "SuggestAppend"
        Font               = New-Object System.Drawing.Font("$Font",11,0,0,0)
    }
    # Dynamically creates the combobox's Category list used for the move destination
    $ComputerTreeNodeCategoryList = @()
    [System.Windows.Forms.TreeNodeCollection]$AllHostsNode = $script:ComputerTreeView.Nodes 
    ForEach ($root in $AllHostsNode) { foreach ($Category in $root.Nodes) { $ComputerTreeNodeCategoryList += $Category.text } }
    ForEach ($Item in $ComputerTreeNodeCategoryList) { $ComputerTreeNodePopupMoveComboBox.Items.Add($Item) }

    # Moves the hostname/IPs to the new Category
    $ComputerTreeNodePopupMoveComboBox.Add_KeyDown({ if ($_.KeyCode -eq "Enter") { 
        if ($SelectedEndpoint){ Move-ComputerTreeNodeSelected -SelectedEndpoint }
        else { Move-ComputerTreeNodeSelected }
    } })
    $ComputerTreeNodePopup.Controls.Add($ComputerTreeNodePopupMoveComboBox)

    #--------------------------------------------
    # ComputerList TreeView Popup Execute Button
    #--------------------------------------------
    $ComputerTreeNodePopupExecuteButton = New-Object System.Windows.Forms.Button -Property @{
        Text     = "Execute"
        Location = @{ X = 210
                      Y = $ComputerTreeNodePopupMoveComboBox.Size.Height + 15 }
        Size     = @{ Width  = 100
                      Height = 25 }
    }
    CommonButtonSettings -Button $ComputerTreeNodePopupExecuteButton
    $ComputerTreeNodePopupExecuteButton.Add_Click({ 
        # This brings specific tabs to the forefront/front view
        $MainBottomTabControl.SelectedTab = $Section3ResultsTab
        if ($SelectedEndpoint){ Move-ComputerTreeNodeSelected -SelectedEndpoint }
        else { Move-ComputerTreeNodeSelected }
        $ComputerTreeNodePopup.close()
    })
    $ComputerTreeNodePopup.Controls.Add($ComputerTreeNodePopupExecuteButton)
    $ComputerTreeNodePopup.ShowDialog()               

}





$ComputerListMoveSelectedToolStripButtonAdd_Click = {
    $MainBottomTabControl.SelectedTab = $Section3ResultsTab
    
    Create-ComputerNodeCheckBoxArray
    if ($script:EntrySelected) {
        Show-MoveForm -FormTitleEndpoints "Move: $($script:EntrySelected.Text)" -SelectedEndpoint
               
        $script:ComputerTreeView.Nodes.Clear()
        Initialize-ComputerTreeNodes

        if ($ComputerTreeNodeOSHostnameRadioButton.Checked) {
            Foreach($Computer in $script:ComputerTreeViewData) { Add-ComputerTreeNode -RootNode $script:TreeNodeComputerList -Category $Computer.OperatingSystem -Entry $Computer.Name -ToolTip $Computer.IPv4Address }
        }
        elseif ($ComputerTreeNodeOUHostnameRadioButton.Checked) {
            Foreach($Computer in $script:ComputerTreeViewData) { Add-ComputerTreeNode -RootNode $script:TreeNodeComputerList -Category $Computer.CanonicalName -Entry $Computer.Name -ToolTip $Computer.IPv4Address }
        }
        Remove-EmptyCategory
        Save-HostData
        KeepChecked-ComputerTreeNode -NoMessage

        $StatusListBox.Items.Clear()
        $StatusListBox.Items.Add("Moved:  $($script:EntrySelected.text)")
    }
}





$ComputerListMoveAllCheckedToolStripButtonAdd_Click = {
    $MainBottomTabControl.SelectedTab = $Section3ResultsTab
    
    Create-ComputerNodeCheckBoxArray
    if ($script:ComputerTreeViewSelected.count -ge 0) {
        Show-MoveForm -FormTitleEndpoints "Moving $($script:ComputerTreeViewSelected.count) Endpoints"

        $script:ComputerTreeView.Nodes.Clear()
        Initialize-ComputerTreeNodes

        if ($ComputerTreeNodeOSHostnameRadioButton.Checked) {
            Foreach($Computer in $script:ComputerTreeViewData) { Add-ComputerTreeNode -RootNode $script:TreeNodeComputerList -Category $Computer.OperatingSystem -Entry $Computer.Name -ToolTip $Computer.IPv4Address }
        }
        elseif ($ComputerTreeNodeOUHostnameRadioButton.Checked) {
            Foreach($Computer in $script:ComputerTreeViewData) { Add-ComputerTreeNode -RootNode $script:TreeNodeComputerList -Category $Computer.CanonicalName -Entry $Computer.Name -ToolTip $Computer.IPv4Address }
        }
        
        Remove-EmptyCategory
        AutoSave-HostData
        Save-HostData
        KeepChecked-ComputerTreeNode -NoMessage

        $StatusListBox.Items.Clear()
        $StatusListBox.Items.Add("Moved $($script:ComputerTreeNodeToMove.Count) Endpoints")
        $ResultsListBox.Items.Clear()
        $ResultsListBox.Items.Add("The following hostnames/IPs have been moved to $($ComputerTreeNodePopupMoveComboBox.SelectedItem):")
    }
    else { ComputerNodeSelectedLessThanOne -Message 'Move Selection' }
}
