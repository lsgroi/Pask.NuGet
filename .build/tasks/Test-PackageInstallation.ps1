Import-Script Pask.Tests.Infrastructure -Package Pask

# Synopsis: Test manually the package installation
Task Test-PackageInstallation Clean, Pack-Nuspec, Push-Local, {
    $Assertion = {
    }

    Test-PackageInstallation -Name Pask.NuGet -Assertion $Assertion -InstallationTargetInfo "Install into 'Application.Contracts' project"
}