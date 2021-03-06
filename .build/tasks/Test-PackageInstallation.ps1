Import-Script Pask.Tests.Infrastructure -Package Pask

# Synopsis: Test manually the package installation
Task Test-PackageInstallation Clean, Pack-Nuspec, Push-Local, {
    $Assertion = {
        $ApplicationProject = $DTE.Solution.Projects | Where { $_.Name -eq "Application" }
        Assert ($ApplicationProject.ProjectItems | Where { $_.Name -eq "version.txt" }) "Cannot find 'version.txt'"
        Assert ($ApplicationProject.ProjectItems | Where { $_.Name -eq "readme.txt" }) "Cannot find 'readme.txt'"
        $PaskVersion = (([xml](Get-Content (Join-Path $ProjectFullPath "Pask.NuGet.nuspec"))).package.metadata.dependencies.dependency | Where { $_.id -eq "Pask" }).version
        Assert ((([xml](Get-Content (Join-Path $SolutionFullPath "Application\packages.config"))).packages.package | Where { $_.id -eq "Pask" }).version -eq $PaskVersion) "Incorrect version of Pask installed into project 'Application'"
    }

    Test-PackageInstallation -Name Pask.NuGet -Assertion $Assertion -InstallationTargetProject "Application"
}