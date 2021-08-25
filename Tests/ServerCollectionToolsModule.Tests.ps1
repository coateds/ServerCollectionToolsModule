if (!(Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
    #"Module not installed"
    Install-Module -Name PSScriptAnalyzer -Force
}


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

    it 'the module has an associated psm1' {
        Test-Path "$PSScriptRoot\..\ServerCollectionToolsModule.psm1" | should -Be $true
    }

    it 'the module has an associated manifest' {
        Test-Path "$PSScriptRoot\..\ServerCollectionToolsModule.psd1" | should -Be $true
    }

    it 'passes all default PSScriptAnalyzer rules' {
        Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\ServerCollectionToolsModule.psm1" | should -BeNullOrEmpty
    }
}