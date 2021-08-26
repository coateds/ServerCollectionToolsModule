Describe 'Get-ServerObjectCollection.Tests' {
    Context 'Output test' {
        BeforeAll {
            Import-Module "$PSScriptRoot\..\ServerCollectionToolsModule.psm1" -Force
            
            $Actual = ('Server1', 'Server2') | Get-ServerObjectCollection

            $MemberArray = $Actual | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
            $MemberArray | Out-Null
        }

        It 'Should return a custom object' {
            $Actual | Should -BeOfType PSCustomObject
        }

        # This test only works on the original object. No added properties
        # It 'Should have ComputerName Property' {
        #     ($null -ne $Actual.ComputerName) | Should -Be $true
        # }

        It 'Should have ComputerName Property' {
            $MemberArray | Should -Contain 'ComputerName'
        }
    }
}