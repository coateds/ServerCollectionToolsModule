$Global:ErrorActionPreference = 'Stop'
$Global:VerbosePreference = 'SilentlyContinue'

$buildVersion = $env:BUILDVER
$manifestPath = "./ServerCollectionToolsModule/ServerCollectionToolsModule.psd1"
$publicFuncFolderPath = './ServerCollectionToolsModule/public'
$privateFuncFolderPath = './ServerCollectionToolsModule/private'

if (!(Get-PackageProvider | Where-Object { $_.Name -eq 'NuGet' })) {
    Install-PackageProvider -Name NuGet -force | Out-Null
}
Import-PackageProvider -Name NuGet -force | Out-Null

if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

$manifestContent = (Get-Content -Path $manifestPath -Raw) -replace '<ModuleVersion>', $buildVersion

if ((Test-Path -Path $publicFuncFolderPath) -and ($publicFunctionNames = Get-ChildItem -Path $publicFuncFolderPath -Filter '*.ps1' | Select-Object -ExpandProperty BaseName)) {
    $publicfuncStrings = "'$($publicFunctionNames.Replace('Function', '') -join "','")'"
} else {
    $publicfuncStrings = $null
}

if ((Test-Path -Path $privateFuncFolderPath) -and ($privateFunctionNames = Get-ChildItem -Path $privateFuncFolderPath -Filter '*.ps1' | Select-Object -ExpandProperty BaseName)) {
    $privatefuncStrings = "'$($privateFunctionNames.Replace('Function', '') -join "','")'"
} else {
    $privatefuncStrings = $null
}

$funcStrings = $publicfuncStrings + ',' + $privatefuncStrings

$manifestContent = $manifestContent -replace "'<FunctionsToExport>'", $funcStrings
$manifestContent | Set-Content -Path $manifestPath