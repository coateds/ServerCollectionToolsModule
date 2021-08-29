#$ModulePublicFolder = (Resolve-Path "$PSScriptRoot\public").Path
#$PublicScriptFiles = (Get-ChildItem $PSScriptRoot -Exclude Execute*, *Research* | Where-Object Name -like "*.ps1").BaseName

Get-ChildItem "$PSScriptRoot\public" | ForEach-Object {
    . $PSItem.FullName
}

Get-ChildItem "$PSScriptRoot\private" | ForEach-Object {
    . $PSItem.FullName
}

#. "$PSScriptRoot\public\FunctionGet-ServerObjectCollection.ps1"
#. "$PSScriptRoot\public\FunctionGet-ServerCollection.ps1"
#. "$PSScriptRoot\public\FunctionTest-ServerConnectionOnPipeline.ps1"
#. "$PSScriptRoot\public\FunctionGet-MachineModelOnPipeline.ps1"

# . "$PSScriptRoot\private\FunctionGet-WMI_OS.ps1"
# . "$PSScriptRoot\private\FunctionGet-PSRemoteComputerName.ps1"