Function Get-VolumeInfoOnPipeline
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
        $NoErrorCheck,
        [switch]
        $ReportMode
    )

    Process {
        $ComputerProperties | Out-Null
        $NoErrorCheck | Out-Null
        $ReportMode | Out-Null
        $PSItem | Select-Object *, Volumes, DriveType, Capacity, PctFree | ForEach-Object {
            If ((($PSItem.Ping) -and ($PSItem.WMI)) -or ($NoErrorCheck)) {
                # When there is only one drive $Volumes.Count will be null
                # Otherwise we will use it to determine how many rows to add

                If ($null -eq $PSitem) {Write-Warning "PSItem is Null!"}

                $Volumes = Get-CimInstance -ComputerName $PSItem.ComputerName -Query "Select DriveLetter,DriveType,Capacity,FreeSpace from Win32_Volume"

                If ($null -eq $Volumes.Count) {
                    #Write-Warning "Mock one should get here"
                    $PSItem.Volumes = $Volumes.DriveLetter
                    $PSItem.DriveType = $Volumes.DriveType
                    $PSItem.Capacity = [Math]::Round(($Volumes.Capacity / 1GB), 0)
                    $PSItem.PctFree = [Math]::Round($Volumes.FreeSpace/$Volumes.Capacity*100,1)
                    $PSItem
                    If ($ReportMode){""}
                    #New-Object PSObject -Property @{}
                }

                # There is more than one drive
                Else {
                    $Count = $Volumes.Count - 1
                    For ($i=0; $i -le $Count; $i++) {
                        If ($null -eq $Volumes[$i]) {Write-Warning "Volumes[$i] is Null!"}

                        # For the first drive just fill in the normal row with the [0] (first) Value
                        If ($i -eq 0) {
                            #Write-Warning $PSItem
                            $PSItem.Volumes = $Volumes[$i].DriveLetter
                            $PSItem.DriveType = $Volumes[$i].DriveType
                            $PSItem.Capacity = [Math]::Round(($Volumes[$i].Capacity / 1GB), 0)
                            $PSItem.PctFree = [Math]::Round($Volumes[$i].FreeSpace/$Volumes[$i].Capacity*100,1)
                            $PSItem

                            #Write-Warning "Zero"
                        }
                        # For all subsequent rows a new (blank or copied) row must be created
                        Else {
                            # Calculate PctFree
                            $PctFree = ""
                            If ($Volumes[$i].DriveType -eq 3) {
                                Try
                                {$PctFree = [Math]::Round($Volumes[$i].FreeSpace/$Volumes[$i].Capacity*100,1)}
                                Catch {$null}
                            }

                            If ($ReportMode) {
                                # Here a brand new row is built without all of the other deatils
                                New-Object PSObject -Property @{
                                    # ComputerName = $PSItem.ComputerName
                                    Volumes = $Volumes[$i].DriveLetter
                                    Capacity = [Math]::Round(($Volumes[$i].Capacity / 1GB), 0)
                                    DriveType = $Volumes[$i].DriveType
                                    PctFree = $PctFree
                                }
                            }
                            Else {
                                # In this case a new row is built from a copy of the current row
                                # This preserves the full details
                                # Write-Warning $PSItem
                                $PSItem.Volumes = $Volumes[$i].DriveLetter
                                $PSItem.Capacity = [Math]::Round(($Volumes[$i].Capacity / 1GB), 0)
                                $PSItem.DriveType = $Volumes[$i].DriveType
                                $PSItem.PctFree = $PctFree
                                New-Object PsObject $PSItem
                                # Write-Warning "Add new row: $i"
                            }
                        }
                    } # End Loop
                    If ($ReportMode){""}
                    New-Object PSObject -Property @{}
                }
            }
            Else {
                $PSItem.Volumes = 'No Try'
                $PSItem.Capacity = 'No Try'
                $PSItem.DriveType = 'No Try'
                $PSItem.PctFree = 'No Try'
                $PSItem
            }
        }
    }
}