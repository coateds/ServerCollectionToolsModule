Describe 'Get-ServerObjectCollection.Tests' {
    Context 'Output test' {
        BeforeAll {
            Import-Module "$PSScriptRoot\..\ServerCollectionToolsModule.psm1" -Force
            
            $Actual = ('Server1', 'Server2') | Get-ServerObjectCollection

            $Actual
        }

        It 'Should return a custom object' {
            $Actual | Should -BeOfType PSCustomObject
        }

        It 'Should have ComputerName Property' {

            $TestDrive
            $TestFile = "out.csv"

            $Actual | export-csv "$($TestDrive)\$($TestFile)"
            $FirstLine = Get-Content "$($TestDrive)\$($TestFile)"
            $FirstLine[1] | Should -Be '"ComputerName"'
        }
    }
}