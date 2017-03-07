$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Script Pask.NuGet.Tests.Infrastructure

Describe "Pack-Nuspec" {
    BeforeAll {
        # Arrange
        $TestSolutionFullPath = Join-Path $Here "Pack-Nuspec"
        Install-PaskExtension -Name Pask.NuGet -SolutionFullPath $TestSolutionFullPath
    }

    Context "Pack without symbols package" {

    }

    Context "Pack with symbols package" {

    }

    Context "Pack including PDB files" {

    }
}