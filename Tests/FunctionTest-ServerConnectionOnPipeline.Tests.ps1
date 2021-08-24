Describe 'Test-ServerConnectionOnPipeline.Tests' {
    BeforeAll {
        Import-Module "$PSScriptRoot\..\ServerCollectionToolsModule.psm1" -Force
    }
    
    Context 'Output test - Ping Fail' {
        BeforeAll {
            #Import-Module "$PSScriptRoot\..\ServerCollectionToolsModule.psm1" -Force
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

        It 'Ping Should have failed' {
            $Actual[0].ping | Should -Be $false
            $Actual[0].WMI | Should -Be $null
            $Actual[0].PSRemote | Should -Be $null
            $Actual[0].BootTime | Should -Be $null
        }
    }

    Context 'Output test - Ping Success, WMI Fail, PSRemote Fail' {
        BeforeAll {
            #Import-Module "$PSScriptRoot\..\ServerCollectionToolsModule.psm1" -Force

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
            $Actual
            #$MemberArray = $Actual | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
            #$MemberArray
        }

        It 'Ping, but not WMI or PSRemote' {
            $Actual[0].ping | Should -Be $true
            $Actual[0].WMI | Should -Be $false
            $Actual[0].PSRemote | Should -Be $false
            $Actual[0].BootTime | Should -Be 'No Try'
        }
    }

    Context 'Output test - Ping Success, WMI Success, PSRemote Fail' {
        BeforeAll {
            Mock -CommandName Test-Connection -ModuleName ServerCollectionToolsModule -MockWith {
                return $true
            }
    
            Mock -CommandName Get-WMI_OS -ModuleName ServerCollectionToolsModule -MockWith {
                return [PSCustomObject]@{
                    LastBootUpTime = '20210526203558.301043-420'
                }
            }
    
            Mock -CommandName Get-PSRemoteComputerName -ModuleName ServerCollectionToolsModule -MockWith {
                return $null
            }
    
            $Actual = ('Server1', 'Server2') | Get-ServerObjectCollection | 
                Test-ServerConnectionOnPipeline
            $Actual
        }

        It 'Ping and WMI but not PSRemote' {
            $Actual[0].ping | Should -Be $true
            $Actual[0].WMI | Should -Be $true
            $Actual[0].PSRemote | Should -Be $false
            [string]$Actual[0].BootTime | Should -Be '05/26/2021 20:35:58'
        }
    }
}