Describe 'FunctionGet-RCVolumeInfoOnPipeline.Tests' {
    BeforeAll {
        Import-Module "$PSScriptRoot\..\ServerCollectionToolsModule.psm1" -Force

        Mock -CommandName Get-CimInstance -ModuleName ServerCollectionToolsModule -MockWith {
            return (
                [PSCustomObject]@{
                    freespace=314892288
                    capacity=366997504
                    drivetype=3
                    driveletter='C:'
                }
            )
        }
    }

    Context 'Output Test - No Error Checking' {
        BeforeAll {
            $obj = [PSCustomObject]@{
                ComputerName = 'AnyServer'
            }
            $obj | Out-Null

            $Actual = ($obj | Get-VolumeInfoOnPipeline -NoErrorCheck)
            $Actual | Out-Null
        }

        It 'Should return a custom object' {
            #$obj | Get-VolumeInfoOnPipeline -NoErrorCheck | Should -BeOfType PSCustomObject
            $Actual | Should -BeOfType PSCustomObject
        }

        It 'Should have a C: drive' {
            $Actual.Volumes | Should -Be 'C:'
        }

        It 'Should have drive type 3' {
            $Actual.DriveType | Should -Be 3
        }

        It 'Should have capacity less than 1 GB' {
            $Actual.Capacity | Should -Be 0
        }

        It 'Should have percent free of 85.8' {
            $Actual.PctFree | Should -Be 85.8
        }

        It 'Should have 1 new property' {
            $MemberArray = $obj | Get-VolumeInfoOnPipeline -NoErrorCheck | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
            $MemberArray | Should -Contain 'Volumes'
            $MemberArray | Should -Contain 'DriveType'
            $MemberArray | Should -Contain 'Capacity'
            $MemberArray | Should -Contain 'PctFree'
        }
    }
}