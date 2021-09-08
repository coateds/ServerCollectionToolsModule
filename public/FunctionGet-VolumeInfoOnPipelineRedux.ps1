Function Get-VolumeInfoOnPipelineRedux
{
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