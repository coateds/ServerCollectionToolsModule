BeforeDiscovery {
    if (!(Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
        #"Module not installed"
        Install-Module -Name PSScriptAnalyzer -Force
    }

    $ModulePublicFolder = (Resolve-Path "$PSScriptRoot\..\public").Path
    $PublicScriptFiles = (Get-ChildItem $ModulePublicFolder -Exclude Execute*, *Research* | Where-Object Name -like "*.ps1").BaseName
    $PublicScriptFiles | Out-Null

    $ModulePrivateFolder = (Resolve-Path "$PSScriptRoot\..\private").Path
    $PrivateScriptFiles = (Get-ChildItem $ModulePrivateFolder -Exclude Execute*, *Research* | Where-Object Name -like "*.ps1").BaseName
    $PrivateScriptFiles | Out-Null

    $Functions = Get-Command -Module ServerCollectionToolsModule -CommandType Function
    $Functions | Out-Null
}

Describe 'Module-Level tests' {
    BeforeAll {
        Import-Module "$PSScriptRoot\..\ServerCollectionToolsModule.psm1" -Force
    } 

    It 'Runs a simple test to verify Pester works' {
        $false | Should -Be $false
    }

    it 'the module imports successfully' {
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

Describe 'Per public file tests' -ForEach $PublicScriptFiles {
    It 'Script Analyzer' {
        Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\public\$PSItem.ps1" | should -BeNullOrEmpty
    }

    It 'Should be an advanced function' {
        $ScriptContents = Get-Content -Path "$PSScriptRoot\..\public\$PSItem.ps1" -Raw
        $ScriptContents | Should -BeLike "*CmdletBinding()*"
        $ScriptContents | Should -BeLike "*Param (*"
    }
}

Describe 'Per private file tests' -ForEach $PrivateScriptFiles {
    It 'Script Analyzer' {
        Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\private\$PSItem.ps1" | should -BeNullOrEmpty
    }

    It 'Should be an advanced function' {
        $ScriptContents = Get-Content -Path "$PSScriptRoot\..\private\$PSItem.ps1" -Raw
        $ScriptContents | Should -BeLike "*CmdletBinding()*"
        $ScriptContents | Should -BeLike "*Param (*"
    }
}

Describe 'Each Function' -ForEach $Functions {
    Context "Pester Tests for $PSItem" {
        BeforeAll {
            # Write-Warning $PSItem.Name | Out-String
            
            $objGetHelp = Get-Help $($PSItem.Name)
            $objGetHelp | Out-Null
            $Help = Get-Help -Name $PSItem -Full
            $Help | Out-Null
        }

        # This one does not work quite as expected
        It 'Should have a Synopsis' {
            $objGetHelp.Synopsis | Should -not -BeLike "*<Object>*"
            $objGetHelp | Out-Null
        }
        
        It 'Should have a Help Description' {
            $objGetHelp.Description | Should -Not -BeNullOrEmpty
        }
        
        It 'Should have more than 0 Examples - Count should be greater than 0' {
            $Help.examples.example.code.count | Should -BeGreaterthan 0
        }
    }
}