$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Script Pask.Tests.Infrastructure

Describe "Pack-Nuspec" {
    BeforeAll {
        # Arrange
        $TestSolutionFullPath = Join-Path $Here "Pack-Nuspec"
        Install-NuGetPackage -Name Pask.NuGet
    }

    Context "Pack without symbols package" {
        BeforeAll {
            # Act
            Invoke-Pask $TestSolutionFullPath -Task Clean, Build, Pack-Nuspec
        }

        It "creates the package" {
            Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.2.1.0*.nupkg" | Should Exist
        }

        It "does not create the symbols package" {
            Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.2.1.0*.symbols.nupkg" | Should Not Exist
        }

        It "should pack the files defined in the Nuspec excluding PDB files" {
            $7za = Join-Path (Get-PackageDir "7-Zip.CommandLine") "tools\7za.exe"
            $Package = Get-Item -Path (Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.2.1.0*.nupkg")
            $PackageExtractedFullPath = Join-Path $TestSolutionFullPath (".build\output\{0}" -f $Package.BaseName)
            Exec { & "$7za" x ("{0}" -f $Package.FullName) -aoa "-o$PackageExtractedFullPath" | Out-Null }
            
            Join-Path $PackageExtractedFullPath "lib\net462\ClassLibrary.dll" | Should Exist
            Join-Path $PackageExtractedFullPath "lib\net462\*.pdb" | Should Not Exist
            Join-Path $PackageExtractedFullPath "src\Class1.cs" | Should Exist
        }
    }

    Context "Pack with symbols package" {
        BeforeAll {
            # Act
            Invoke-Pask $TestSolutionFullPath -Task Clean, Build, Pack-Nuspec -CreateSymbolsPackage $true
        }

        It "creates the package" {
            Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.2.1.0*.nupkg" | Should Exist
        }

        It "creates the symbols package" {
            Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.2.1.0*.symbols.nupkg" | Should Exist
        }

        It "the package should contain the files defined in the Nuspec excluding PDB files" {
            $7za = Join-Path (Get-PackageDir "7-Zip.CommandLine") "tools\7za.exe"
            $Package = Get-Item -Path (Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.2.1.0*.nupkg")
            $PackageExtractedFullPath = Join-Path $TestSolutionFullPath (".build\output\{0}" -f $Package.BaseName)
            Exec { & "$7za" x ("{0}" -f $Package.FullName) -aoa "-o$PackageExtractedFullPath" | Out-Null }
            
            Join-Path $PackageExtractedFullPath "lib\net462\ClassLibrary.dll" | Should Exist
            Join-Path $PackageExtractedFullPath "lib\net462\ClassLibrary.pdb" | Should Not Exist
            Join-Path $PackageExtractedFullPath "src\Class1.cs" | Should Not Exist
        }

        It "the symbols package should contain the files defined in the Nuspec including PDB files" {
            $7za = Join-Path (Get-PackageDir "7-Zip.CommandLine") "tools\7za.exe"
            $Package = Get-Item -Path (Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.2.1.0*.symbols.nupkg")
            $PackageExtractedFullPath = Join-Path $TestSolutionFullPath (".build\output\{0}" -f $Package.BaseName)
            Exec { & "$7za" x ("{0}" -f $Package.FullName) -aoa "-o$PackageExtractedFullPath" | Out-Null }
            
            Join-Path $PackageExtractedFullPath "lib\net462\ClassLibrary.dll" | Should Exist
            Join-Path $PackageExtractedFullPath "lib\net462\ClassLibrary.pdb" | Should Exist
            Join-Path $PackageExtractedFullPath "src\Class1.cs" | Should Exist
        }
    }

    Context "Pack including PDB files" {
        BeforeAll {
            # Act
            Invoke-Pask $TestSolutionFullPath -Task Clean, Build, Pack-Nuspec -IncludePdb $true
        }

        It "creates the package" {
            Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.2.1.0*.nupkg" | Should Exist
        }

        It "does not create the symbols package" {
            Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.2.1.0*.symbols.nupkg" | Should Not Exist
        }

        It "should pack the files defined in the Nuspec including PDB files" {
            $7za = Join-Path (Get-PackageDir "7-Zip.CommandLine") "tools\7za.exe"
            $Package = Get-Item -Path (Join-Path $TestSolutionFullPath ".build\output\ClassLibrary.2.1.0*.nupkg")
            $PackageExtractedFullPath = Join-Path $TestSolutionFullPath (".build\output\{0}" -f $Package.BaseName)
            Exec { & "$7za" x ("{0}" -f $Package.FullName) -aoa "-o$PackageExtractedFullPath" | Out-Null }
            
            Join-Path $PackageExtractedFullPath "lib\net462\ClassLibrary.dll" | Should Exist
            Join-Path $PackageExtractedFullPath "lib\net462\ClassLibrary.pdb" | Should Exist
            Join-Path $PackageExtractedFullPath "src\Class1.cs" | Should Exist
        }
    }
}