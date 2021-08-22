Describe 'Module-Level tests' {
    BeforeAll {
        Import-Module "$PSScriptRoot\ServerCollectionToolsModule.psm1" -Force
    } 

    It 'Runs a simple test to verify Pester works' {
        $false | Should -Be $false
    }
}