Describe 'FunctionGet-RCMachineModelOnPipeline.Tests' {
    BeforeAll {
        Mock -CommandName Get-CimInstance -ModuleName ServerCollectionToolsModule -MockWith {
            return (
                [PSCustomObject]@{Model = 'AnyModel'}
            )
        }
    }

    Context 'Output Test - No Error Checking' {
        BeforeAll {
            $obj = [PSCustomObject]@{
                ComputerName = 'AnyServer'
            }
            $obj | Out-Null
        }

        It 'Should be of Model AnyModel' {
            ($obj | Get-RCMachineModelOnPipeline -NoErrorCheck).MachineModel | Should -Be 'AnyModel'
        }

        It 'Should return a custom object' {
            $obj | Get-RCMachineModelOnPipeline -NoErrorCheck | Should -BeOfType PSCustomObject
        }

        It 'Should have 1 new property' {
            $MemberArray = $obj | Get-RCMachineModelOnPipeline -NoErrorCheck | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
            $MemberArray | Should -Contain 'MachineModel'
        }
    }

    Context 'Output Test - Conn Test Pass' {
        BeforeAll {
            $obj = [PSCustomObject]@{
                ComputerName = 'AnyServer'
                Ping = $true
                WMI = $true
            }
            $obj | Out-Null
        }

        It 'Should be of Model AnyModel' {
            ($obj | Get-RCMachineModelOnPipeline).MachineModel | Should -Be 'AnyModel'
        }

        It 'Should return a custom object' {
            $obj | Get-RCMachineModelOnPipeline | Should -BeOfType PSCustomObject
        }

        It 'Should have 1 new property' {
            $MemberArray = $obj | Get-RCMachineModelOnPipeline -NoErrorCheck | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
            $MemberArray | Should -Contain 'MachineModel'
        }
    }

    Context 'Output Test - Conn Test Fail (Ping)' {
        BeforeAll {
            $obj = [PSCustomObject]@{
                ComputerName = 'AnyServer'
                Ping = $false
                WMI = $true
            }
            $obj | Out-Null
        }

        It 'Should be of Model No Try' {
            ($obj | Get-RCMachineModelOnPipeline).MachineModel | Should -Be 'No Try'
        }

        It 'Should return a custom object' {
            $obj | Get-RCMachineModelOnPipeline | Should -BeOfType PSCustomObject
        }

        It 'Should have 1 new property' {
            $MemberArray = $obj | Get-RCMachineModelOnPipeline -NoErrorCheck | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
            $MemberArray | Should -Contain 'MachineModel'
        }
    }

    Context 'Output Test - Conn Test Fail (WMI)' {
        BeforeAll{
            $obj = [PSCustomObject]@{
                ComputerName = 'AnyServer'
                Ping = $true
                WMI = $false
            }
            $obj | Out-Null
        }

        It 'Should be of Model AnyModel' {
            ($obj | Get-RCMachineModelOnPipeline).MachineModel | Should -Be 'No Try'
        }

        It 'Should return a custom object' {
            $obj | Get-RCMachineModelOnPipeline | Should -BeOfType PSCustomObject
        }

        It 'Should have 1 new property' {
            $MemberArray = $obj | Get-RCMachineModelOnPipeline -NoErrorCheck | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
            $MemberArray | Should -Contain 'MachineModel'
        }
    }
}