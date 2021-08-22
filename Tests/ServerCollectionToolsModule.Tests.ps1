Describe 'Module-Level tests' {
    BeforeAll {
        Import-Module "$PSScriptRoot\..\ServerCollectionToolsModule.psm1" -Force
    } 

    It 'Runs a simple test to verify Pester works' {
        $false | Should -Be $false
    }

    it 'the module imports successfully' {
        #{ Import-Module "$PSScriptRoot\PowerShellModuleProject.psm1" } | should -not throw
        (Get-Command Get-ServerObjectCollection ).Source | Should -Be ServerCollectionToolsModule
    }
}