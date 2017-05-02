$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Script Pask.Tests.Infrastructure

Describe "Pack" {
    BeforeAll {
        # Arrange
        $TestSolutionFullPath = Join-Path $Here "Pack"
        Install-NuGetPackage -Name Pask.NuGet
    }

    Context "Create a package without symbols package" {
        BeforeAll {
            # Act
            Invoke-Pask $TestSolutionFullPath -Task Clean, Build, New-Artifact, Pack -RemoveArtifactPDB $false
        }

        It "creates the package" {
            Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.3.6.0.nupkg" | Should Exist
        }

        It "does not create the symbols package" {
            Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.3.6.0.symbols.nupkg" | Should Not Exist
        }

        It "the package should contain the assemblies and should not contain the PDB files" {
            $7za = Join-Path (Get-PackageDir "7-Zip.CommandLine") "tools\7za.exe"
            $Package = Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.3.6.0.nupkg"
            $PackageExtractedFullPath = Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.3.6.0"
            Exec { & "$7za" x "$Package" -aoa "-o$PackageExtractedFullPath" | Out-Null }
            
            Join-Path $PackageExtractedFullPath "lib\net462\ClassLibrary.dll" | Should Exist
            Join-Path $PackageExtractedFullPath "lib\net462\*.pdb" | Should Not Exist
        }
    }

    Context "Create a package and symbols package" {
        BeforeAll {
            # Act
            Invoke-Pask $TestSolutionFullPath -Task Clean, Build, New-Artifact, Pack -CreateSymbolsPackage $true -RemoveArtifactPDB $false
        }

        It "creates the package" {
            Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.3.6.0.nupkg" | Should Exist
        }

        It "creates the symbols package" {
            Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.3.6.0.symbols.nupkg" | Should Exist
        }

        It "the package should contain the assemblies and should not contain the PDB files" {
            $7za = Join-Path (Get-PackageDir "7-Zip.CommandLine") "tools\7za.exe"
            $Package = Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.3.6.0.nupkg"
            $PackageExtractedFullPath = Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.3.6.0"
            Exec { & "$7za" x "$Package" -aoa "-o$PackageExtractedFullPath" | Out-Null }
            
            Join-Path $PackageExtractedFullPath "lib\net462\ClassLibrary.dll" | Should Exist
            Join-Path $PackageExtractedFullPath "lib\net462\*.pdb" | Should Not Exist
        }

        It "the symbols package should contain the assemblies and PDB files" {
            $7za = Join-Path (Get-PackageDir "7-Zip.CommandLine") "tools\7za.exe"
            $Package = Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.3.6.0.symbols.nupkg"
            $PackageExtractedFullPath = Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.3.6.0.symbols"
            Exec { & "$7za" x "$Package" -aoa "-o$PackageExtractedFullPath" | Out-Null }
            
            Join-Path $PackageExtractedFullPath "lib\net462\ClassLibrary.dll" | Should Exist
            Join-Path $PackageExtractedFullPath "lib\net462\ClassLibrary.pdb" | Should Exist
            Join-Path $PackageExtractedFullPath "src\ClassLibrary\Class1.cs" | Should Exist
        }
    }

    Context "Create a package without default semantic version" {
        BeforeAll {
            # Arrange
            $PackageVersion = Get-Version

            # Act
            Invoke-Pask $TestSolutionFullPath -Task Clean, Build, New-Artifact, Pack -ProjectName ClassLibrary.Other
        }

        It "creates the package with default Pask version" {
            Join-Path $TestSolutionFullPath (".build\output\ClassLibrary.Other.{0}.nupkg" -f $PackageVersion.SemVer) | Should Exist
        }
    }
}