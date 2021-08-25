<#
Simple Private Function to test WMI connectivity on a remote machine
moving the Try...Catch block into isolation helps prevent any errors on the console
Return is the WMI OS object when sucessfully connects, Null when it does not
#>
Function Get-WMI_OS ($ComputerName)
    {
    Try {Get-Wmiobject -ComputerName $ComputerName -Class Win32_OperatingSystem -ErrorAction Stop}
    Catch {$null}
    }