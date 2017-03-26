$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Script Pask.Tests.Infrastructure

Describe "Push-Local" {
    BeforeAll {
        # Arrange
        $TestSolutionFullPath = Join-Path $Here "Push-Local"
        Install-NuGetPackage -Name Pask.NuGet
        $LocalNuGetSource = Join-Path $TestSolutionFullPath "LocalNuGetSource"
        if (Test-Path $LocalNuGetSource) {
            Remove-ItemSilently $LocalNuGetSource
        }
    }

    Context "Push package without symbols to local feed" {
        BeforeAll {
            # Arrange
            Remove-ItemSilently (Join-Path $TestSolutionFullPath ".build\output")
            Exec { Robocopy (Join-Path "$TestSolutionFullPath" ".build\test") (Join-Path "$TestSolutionFullPath" ".build\output") "ClassLibrary.3.2.0.nupkg" /256 /XO /NP /NFL /NDL /NJH /NJS } (0..7)
            
            # Act
            Invoke-Pask $TestSolutionFullPath -Task Push-Local -LocalNuGetSource $LocalNuGetSource
        }

        It "pushes the package" {
            Join-Path $LocalNuGetSource "ClassLibrary.3.2.0.nupkg" | Should Exist
        }
    }
}