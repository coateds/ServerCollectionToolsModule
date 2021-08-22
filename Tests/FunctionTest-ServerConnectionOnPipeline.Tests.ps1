Describe 'Test-ServerConnectionOnPipeline.Tests' {
    Context 'Output test - Ping Fail' {
        BeforeAll {
            Import-Module "$PSScriptRoot\..\ServerCollectionToolsModule.psm1" -Force
            
            $Actual = ('Server1', 'Server2') | Get-ServerObjectCollection | 
            Test-ServerConnectionOnPipeline

            $Actual
        }

        Mock -CommandName Test-Connection -ModuleName ServerCollectionTools -MockWith {
            return $false
        }

        It 'Should return a custom object' {
            $Actual | Should -BeOfType PSCustomObject
        }

        #It 'Should have 4 new properties' {
        #    $TestDrive
        #    $TestFile = "out.csv"
        #    $Actual | export-csv "$($TestDrive)\$($TestFile)"
        #    $FirstLine = Get-Content "$($TestDrive)\$($TestFile)"
        #    $ActualProperties = $FirstLine[1].Split(',')
        #    $ActualProperties | Should -Contain '"Ping"'
        #    $ActualProperties | Should -Contain '"WMI"'
        #    $ActualProperties | Should -Contain '"PSRemote"'
        #    $ActualProperties | Should -Contain '"BootTime"'
        #}

        It 'Should have Ping Property' {
            ($null -ne $Actual.Ping) | Should -Be $true
        }

        It 'Ping should have failed' {
            $Actual[0].ping | should -be $false
            $Actual[0].WMI | should -be $null
            $Actual[0].PSRemote | should -be $null
            $Actual[0].BootTime | should -be $null
        }
    }
}