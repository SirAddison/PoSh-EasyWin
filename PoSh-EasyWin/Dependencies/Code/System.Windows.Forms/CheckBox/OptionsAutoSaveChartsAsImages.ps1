$OptionsAutoSaveChartsAsImagesAdd_Click = { 
    if (-not $(Test-Path -Path $AutosavedChartsDirectory)) {
        New-Item -Type Directory -Path $AutosavedChartsDirectory -Force
    } 
}

$OptionsAutoSaveChartsAsImagesAdd_MouseHover = {
    Show-ToolTip -Title "AutoSave Charts" -Icon "Info" -Message @"
+  Autosaves Multi-Series charts that are viewed
+  Images will be saved to the 'Autosaved Charts' folder in PoSh-AMCE's root directory 
"@
}
