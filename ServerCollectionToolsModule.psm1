. "$PSScriptRoot\public\FunctionGet-ServerObjectCollection.ps1"
. "$PSScriptRoot\public\FunctionGet-MyServerCollection.ps1"
. "$PSScriptRoot\public\FunctionTest-ServerConnectionOnPipeline.ps1"

<#
Simple Private Function to test WMI connectivity on a remote machine 
moving the Try...Catch block into isolation helps prevent any errors on the console
Return is the WMI OS object when sucessfully connects, Null when it does not
#>
Function Get-WMI_OS ($ComputerName)
    {
    
    Try {Get-Wmiobject -ComputerName $ComputerName -Class Win32_OperatingSystem -ErrorAction Stop}
    Catch {}
    }

<#
Simple Private Function to test PS Remote connectivity on a remote machine 
moving the Try...Catch block into isolation helps prevent any errors on the console
Return is the the remote computer's name when sucessfully connects, Null when it does not
#>
Function Get-PSRemoteComputerName  ($ComputerName)
    {
    Try {Invoke-Command -ComputerName $ComputerName -ScriptBlock {1} -ErrorAction Stop}
    Catch {} 
    }