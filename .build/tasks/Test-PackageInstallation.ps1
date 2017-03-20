Import-Script Pask.Tests.Infrastructure -Package Pask

# Synopsis: Test manually the package installation
Task Test-PackageInstallation Clean, Pack-Nuspec, Push-Local, {
    $Assertion = {
        $ApplicationDomainProject = $DTE.Solution.Projects | Where { $_.Name -eq "Application.Domain" }
        Assert ($ApplicationDomainProject.ProjectItems | Where { $_.Name -eq "version.txt" }) "Cannot find 'version.txt'"
        Assert ($ApplicationDomainProject.ProjectItems | Where { $_.Name -eq "readme.txt" }) "Cannot find 'readme.txt'"
    }

    Test-PackageInstallation -Name Pask.NuGet -Assertion $Assertion -InstallationTargetInfo "Install into 'Application.Domain' project"
}