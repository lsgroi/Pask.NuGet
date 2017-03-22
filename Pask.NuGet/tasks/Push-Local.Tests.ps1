$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Script Pask.Tests.Infrastructure

Describe "Push-Local" {
    BeforeAll {
        # Arrange
        $TestSolutionFullPath = Join-Path $Here "Push-Local"
        Install-NuGetPackage -Name Pask.NuGet
        $LocalNuGetFeed = Join-Path $TestSolutionFullPath "LocalNuGetFeed"
        Exec { Robocopy (Join-Path "$TestSolutionFullPath" ".build\test") (Join-Path "$TestSolutionFullPath" ".build\output") "*.nupkg" /256 /XO /NP /NFL /NDL /NJH /NJS } (0..7)
    }

    Context "Push package with symbols to local feed" {
        BeforeAll {
            # Arrange
            Remove-ItemSilently $LocalNuGetFeed
            
            # Act
            Invoke-Pask $TestSolutionFullPath -Task Push-Local -LocalNuGetFeed $LocalNuGetFeed
        }

        It "pushes the package" {
            Join-Path $LocalNuGetFeed "ClassLibrary.3.2.0.nupkg" | Should Exist
        }

        It "pushes the symbols package" {
            Join-Path $LocalNuGetFeed "ClassLibrary.3.2.0.symbols.nupkg" | Should Exist
        }
    }
}