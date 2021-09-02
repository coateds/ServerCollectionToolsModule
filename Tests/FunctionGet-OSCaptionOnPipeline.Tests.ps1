Describe 'Get-OSCaptionOnPipeline.Tests' {
    Import-Module "$PSScriptRoot\..\ServerCollectionToolsModule.psm1" -Force

    BeforeAll {
        Mock -CommandName Get-CimInstance -ModuleName ServerCollectionToolsModule -MockWith {
            return [PSCustomObject]@{
                caption = 'Microsoft Windows 10 Pro'
            }
        }
    }

    Context 'Output Test - No Error Checking' {
        BeforeAll {
            $obj = [PSCustomObject]@{
                ComputerName = 'AnyServer'
            }
            $obj | Out-Null
        }

        It 'Gets OS Caption Number' {
            ($obj | Get-OSCaptionOnPipeline -NoErrorCheck).OSVersion | Should -Be 10
        }

        It 'Should return a custom object' {
            $obj | Should -BeOfType PSCustomObject
            $obj | Get-OSCaptionOnPipeline -NoErrorCheck | Should -BeOfType PSCustomObject
        }

        It 'Should have 1 new property' {
            $MemberArray = $obj | Get-OSCaptionOnPipeline -NoErrorCheck | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
            $MemberArray | Should -Contain 'OSVersion'
        }
    }

    Context 'Output Test - Conn Test Pass' {
        BeforeAll {
            $obj = [PSCustomObject]@{
                ComputerName = 'AnyServer'
                Ping = $true
                WMI = $true
                PSRemote = $true
            }
            $obj | Out-Null
        }

        It 'Gets OS Caption Number' {
            ($obj | Get-OSCaptionOnPipeline).OSVersion | Should -Be 10
        }

        It 'Should return a custom object' {
            $obj | Get-OSCaptionOnPipeline | Should -BeOfType PSCustomObject
        }

        It 'Should have 1 new property' {
            $MemberArray = $obj | Get-OSCaptionOnPipeline -NoErrorCheck | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
            $MemberArray | Should -Contain 'OSVersion'
        }
    }

    Context 'Output Test - Conn Test Fail (Ping)' {
        BeforeAll {
            $obj = [PSCustomObject]@{
                ComputerName = 'AnyServer'
                Ping = $false
                WMI = $true
                PSRemote = $true
            }
            $obj | Out-Null
        }

        It 'Cannot get Caption Number' {
            ($obj | Get-OSCaptionOnPipeline).OSVersion | Should -Be 'No Try'
        }

        It 'Should return a custom object' {
            $obj | Get-OSCaptionOnPipeline | Should -BeOfType PSCustomObject
        }

        It 'Should have 1 new property' {
            $MemberArray = $obj | Get-OSCaptionOnPipeline -NoErrorCheck | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
            $MemberArray | Should -Contain 'OSVersion'
        }
    }

    Context 'Output Test - Conn Test Fail (WMI)' {
        BeforeAll {
            $obj = [PSCustomObject]@{
                ComputerName = 'AnyServer'
                Ping = $true
                WMI = $false
                PSRemote = $true
            }
            $obj | Out-Null
        }
    
        It 'Cannot get Caption Number' {
            ($obj | Get-OSCaptionOnPipeline).OSVersion | Should -Be 'No Try'
        }

        It 'Should return a custom object' {
            $obj | Get-OSCaptionOnPipeline | Should -BeOfType PSCustomObject
        }

        It 'Should have 1 new property' {
            $MemberArray = $obj | Get-OSCaptionOnPipeline -NoErrorCheck | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
            $MemberArray | Should -Contain 'OSVersion'
        }
    }
}