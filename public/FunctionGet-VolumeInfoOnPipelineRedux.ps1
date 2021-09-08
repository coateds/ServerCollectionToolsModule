Function Get-VolumeInfoOnPipelineRedux
{
    <#
        .Synopsis
            Adds Volume Info Columns to an object
        .DESCRIPTION
            This typically takes an imported csv file with a ComputerName Column as an imput object
            but just about any collection of objects that exposes .ComputerName should work
            The output is the same type of object as the input (hopefully) so that it can be piped
            to the next function to add another column
            Columns returned are a subset of Win32_Volume

            Adds rows as needed. One per drive after the first (usually c:)

            By default, each new row gets a copy of all the data in the non Volume columns. This allows
            for filtering with Where-Object.

            Use the -ReportMode switch to provision a new empty row for all added rows. This is more readable.
        .EXAMPLE
            Get-RCServerCollection | Test-RCServerConnectionOnPipeline | Get-RCProcInfoOnPipeline | Get-RCVolumeInfoOnPipeline -ReportMOde | Select ComputerName,TotalProcs,ProcName,Cores,Volumes,DriveType,Capacity,PctFree | ft -autosize
            A Sampling of Functions and Columns in ReportMode
        .EXAMPLE
            Get-RCServerCollection | Test-RCServerConnectionOnPipeline | Get-RCProcInfoOnPipeline | Get-RCVolumeInfoOnPipeline | Select ComputerName,TotalProcs,Cores,Volumes,DriveType,Capacity,PctFree | Where PctFree -gt 95 | ft -autosize
            Gets all of the drives either over or under a threshold. IN this case % free greater than 95%
        .EXAMPLE
            Get-RCServerCollection | Test-RCServerConnectionOnPipeline | Get-RCOSCaptionOnPipeline | Get-RCTimeZoneOnPipeline | Get-RCTotalMemoryOnPipeline | Get-RCMachineModelOnPipeline | Get-RCProcInfoOnPipeline | Get-RCVolumeInfoOnPipeline -ReportMOde | Select ComputerName,OSVersion,TotalMemory,MachineModel,TotalProcs,ProcName,Cores,Volumes,DriveType,Capacity,PctFree | Where DriveType -eq 3 | Export-Csv -path .\ServerSpecs.csv -NoTypeInformation
            Gets a nice specs report and outputs it to a CSV file in the working directory
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

    Process {
        $ComputerProperties | Out-Null
        $NoErrorCheck | Out-Null
        $PSItem | Select-Object *, Volumes, DriveType, Capacity, PctFree | ForEach-Object {
            If ((($PSItem.Ping) -and ($PSItem.WMI)) -or ($NoErrorCheck)) {
                $Volumes = Get-CimInstance -ComputerName $PSItem.ComputerName -Query "Select DriveLetter,DriveType,Capacity,FreeSpace from Win32_Volume"
                $PSItem.Volumes = $Volumes.DriveLetter
                $PSItem.DriveType = $Volumes.DriveType
                $PSItem.Capacity = [Math]::Round(($Volumes.Capacity / 1GB), 0)
                $PSItem.PctFree = [Math]::Round($Volumes.FreeSpace/$Volumes.Capacity*100,1)
                $PSItem
            }
        }
    }
}