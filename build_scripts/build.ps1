# BUILDVER gets set in the variables section of the azure-pipelines.yml
$buildVersion = $env:BUILDVER
$moduleName = 'ServerCollectionToolsModule'

$manifestPath = Join-Path -Path $env:SYSTEM_DEFAULTWORKINGDIRECTORY -ChildPath "$moduleName.psd1"

## Update build version in manifest
$manifestContent = Get-Content -Path $manifestPath -Raw
$manifestContent = $manifestContent -replace '<ModuleVersion>', $buildVersion

# The next section gathers up all of the functions to export
# At this time, that may not be necessary?

# Ineed to set the contents of the .psd1 file to be ready
# for the 'replaces'