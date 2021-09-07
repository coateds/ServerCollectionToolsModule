Function Get-MachineModelOnPipeline
{
    <#
        .Synopsis
            Adds a MachineModel Column to an object
        .DESCRIPTION
            This typically takes an imported csv file with a ComputerName Column as an imput object
            but just about any collection of objects that exposes .ComputerName should work
            The output is the same type of object as the input (hopefully) so that it can be piped
            to the next function to add another column
        .EXAMPLE
            Get-RCServerCollection | Test-RCServerConnectionOnPipeline | Get-RCTimeZoneOnPipeline | Get-RCTotalMemoryOnPipeline | Get-RCMachineModelOnPipeline | ft
    #>

    [CmdletBinding()]

    Param (
        [parameter(
        Mandatory=$true,
        ValueFromPipeline= $true)]
        $ComputerProperties,

        [switch]
        $NoErrorCheck
    )

    Begin
        {}
    Process {
        $NoErrorCheck | Out-Null
        $ComputerProperties | Select-Object *, MachineModel | ForEach-Object {
            If ((($PSItem.Ping) -and ($PSItem.WMI)) -or ($NoErrorCheck))
                {
                #$PSItem.MachineModel = [string](Get-WMIObject -class Win32_ComputerSystem -ComputerName $PSItem.ComputerName).Model
                $PSItem.MachineModel = [string](Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $PSItem.ComputerName).Model
                }
            Else{$PSItem.MachineModel = 'No Try'}
            $PSItem
        }
    }
}