Import-Script Pask.Tests.Infrastructure

<#
.SYNOPSIS
   Installs a Pask extension package found in $BuildOutputFullPath into a target solution

.PARAMETER Version <string> = 0.1.0
   The package version

.PARAMETER SolutionFullPath <string>
   The target solution's directory

.OUTPUTS
   None
#>
function script:Install-PaskExtension {
    param(
        [Parameter(Mandatory=$true)][string]$Name,
        [string]$Version = "0.1.0",
        [Alias(“SolutionFullPath”)][string]$TargetSolutionFullPath
    )

    $InstallDir = Get-PackagesDir
    $PackageFullPath = (Join-Path $InstallDir "$Name.$Version")

    Install-NuGetPackage -Name $Name -Version $Version -InstallDir $InstallDir
}