# This script runs:
# - the first time a package is installed in a solution
# - every time the solution is opened (Package Manager Console window has to be open at the same time for the script to run)

param($InstallPath, $ToolsPath, $Package, $Project)

if ($Project -eq $null) {
    # Solution level packages are not supported in Visual Studio 2015
    return
}

<#
.SYNOPSIS 
   Adds a file to a solution project

.PARAMETER $Project <EnvDTE.Project>
   The project

.PARAMETER File <string>
   Full name of the file

.OUTPUTS
   None
#>
function Add-FileToProject {
    param($Project, [string]$File)

    $FileName = Split-Path -Path $File -Leaf
    if (($Project.ProjectItems | Where { $_.FileNames(1) -eq $File }) -eq $null) {
		Write-Host "Adding '$FileName' to project '$($Project.Name)'."
		$Project.ProjectItems.AddFromFile($File) | Out-Null
        $($Project.ProjectItems | Where { $_.FileNames(1) -eq $File }).Properties.Item("BuildAction").Value = 0
    }
}

$Solution = Get-Interface $dte.Solution ([EnvDTE80.Solution2])
$SolutionFullPath = Split-Path -Path $Solution.FullName
$ProjectFullPath = Split-Path -Path $Project.FullName

$PackagesConfig = Join-Path (Split-Path -Path $Project.FullName) "packages.config"
[xml]$PackagesXml = Get-Content $PackagesConfig
$Package = $PackagesXml.packages.package | Where { $_.id -eq $Package.Id -and $_.version -eq $Package.Version };

# To prevent NuGet Package Manager from running this for every version of the package that happens to be in the packages folder
if ($Package -ne $null) {
    Write-Host "Initializing '$($Package.Id) $($Package.Version)'."
      
    # Copy version.txt
    $VersionTxtFullPath = Join-Path $ProjectFullPath "version.txt"
    if (-not (Test-Path $VersionTxtFullPath)) {
        Write-Host "Copying 'version.txt'."
        Copy-Item (Join-Path $InstallPath "init\version.txt") $VersionTxtFullPath -Force

        # Copy readme.txt (first install only)
        $ReadmeTxtFullPath = Join-Path $ProjectFullPath "readme.txt"
        if (-not (Test-Path $ReadmeTxtFullPath)) {
            Write-Host "Copying 'readme.txt'."
            Copy-Item (Join-Path $InstallPath "init\readme.txt") $ReadmeTxtFullPath -Force
            # Replace project name in readme.txt
            (Get-Content $ReadmeTxtFullPath).Replace('$projectname$', $Project.Name) | Set-Content $ReadmeTxtFullPath
            Add-FileToProject $Project $ReadmeTxtFullPath
        }
    }

    # Add files to the solution
    Add-FileToProject $Project $VersionTxtFullPath

    # Save the solution
    $Solution.SaveAs($Solution.FullName)
}