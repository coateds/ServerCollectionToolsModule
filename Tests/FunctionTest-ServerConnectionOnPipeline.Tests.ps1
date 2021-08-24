Describe 'Test-ServerConnectionOnPipeline.Tests' {
    Context 'Output test - Ping Fail' {
        BeforeAll {
            Import-Module "$PSScriptRoot\..\ServerCollectionToolsModule.psm1" -Force
            Mock -CommandName Test-Connection -ModuleName ServerCollectionToolsModule -MockWith {
                return $false
            }            
            $Actual = ('Server1', 'Server2') | Get-ServerObjectCollection | 
                Test-ServerConnectionOnPipeline
            $MemberArray = $Actual | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
            $MemberArray
        }

        It 'Should return a custom object' {
            $Actual | Should -BeOfType PSCustomObject
        }

        It 'Should have 4 new properties' {
            $MemberArray | Should -Contain 'Ping'
            $MemberArray | Should -Contain 'WMI'
            $MemberArray | Should -Contain 'PSRemote'
            $MemberArray | Should -Contain 'BootTime'
        }

        It 'Ping should have failed' {
            $Actual[0].ping | should -be $false
            $Actual[0].WMI | should -be $null
            $Actual[0].PSRemote | should -be $null
            $Actual[0].BootTime | should -be $null
        }
    }

    Context 'Output test - Ping Success, WMI Fail, PSRemote Fail' {
        BeforeAll {
            Import-Module "$PSScriptRoot\..\ServerCollectionToolsModule.psm1" -Force

            Mock -CommandName Test-Connection -ModuleName ServerCollectionToolsModule -MockWith {
                return $true
            }
    
            Mock -CommandName Get-WMI_OS -ModuleName ServerCollectionToolsModule -MockWith {
                return $null
            }
    
            Mock -CommandName Get-PSRemoteComputerName -ModuleName ServerCollectionToolsModule -MockWith {
                return $null
            }
            
            $Actual = ('Server1', 'Server2') | Get-ServerObjectCollection | 
                Test-ServerConnectionOnPipeline
            $MemberArray = $Actual | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
            $MemberArray
        }

        It 'Ping, but not WMI or PSRemote' {
            $Actual[0].ping | should -be $true
            $Actual[0].WMI | should -be $false
            $Actual[0].PSRemote | should -be $false
            $Actual[0].BootTime | should -be 'No Try'
        }
    }
}