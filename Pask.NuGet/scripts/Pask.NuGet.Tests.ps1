$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace "\.Tests\.", "."
. "$Here\$Sut"

Describe "Push-Package" {
    Context "Push a package" {
        BeforeAll {
            # Arrange
            function Exec { param([scriptblock]$Command) }
            function Get-NuGetExe { return "NuGet.exe" }
            Mock Exec {} -ParameterFilter { $Command -like { & (Get-NuGetExe) push "$Package" -Source $Source -NonInteractive } }

            # Act
            Push-Package "Foo.0.1.0.nupkg"
        }

        It "pushes the package to the default source" {
            Assert-MockCalled Exec 1
        }
    }

    Context "Push two packages" {
        BeforeAll {
            # Arrange
            function Exec { param([scriptblock]$Command) }
            function Get-NuGetExe { return "NuGet.exe" }
            Mock Exec {} -ParameterFilter { $Command -like { & (Get-NuGetExe) push "$Package" -Source $Source -NonInteractive } }

            # Act
            Push-Package "Foo.0.1.0.nupkg", "Bar.0.1.0.nupkg" 
        }

        It "pushes both packages to the default source" {
            Assert-MockCalled Exec 2
        }
    }

    Context "Push a package with API key" {
        BeforeAll {
            # Arrange
            function Exec { param([scriptblock]$Command) }
            function Get-NuGetExe { return "NuGet.exe" }
            Mock Exec {} -ParameterFilter { $Command -like { & (Get-NuGetExe) push "$Package" -ApiKey $ApiKey -Source $Source -NonInteractive } }

            # Act
            Push-Package "Foo.0.1.0.nupkg" -ApiKey "123"
        }

        It "pushes the package to the default source with API key" {
            Assert-MockCalled Exec 1
        }
    }

    Context "Push a package to a source" {
        BeforeAll {
            # Arrange
            function Exec { param([scriptblock]$Command) }
            function Get-NuGetExe { return "NuGet.exe" }
            Mock Exec {} -ParameterFilter { $Command -like { & (Get-NuGetExe) push "$Package" -Source $Source -NonInteractive } }

            # Act
            Push-Package "Foo.0.1.0.nupkg" -Source "myget"
        }

        It "pushes the package to the given source" {
            Assert-MockCalled Exec 1
        }
    }

    Context "Push a package to a source with API key" {
        BeforeAll {
            # Arrange
            function Exec { param([scriptblock]$Command) }
            function Get-NuGetExe { return "NuGet.exe" }
            Mock Exec {} -ParameterFilter { $Command -like { & (Get-NuGetExe) push "$Package" -ApiKey $ApiKey -Source $Source -NonInteractive } }

            # Act
            Push-Package "Foo.0.1.0.nupkg" -Source "myget" -ApiKey "123"
        }

        It "pushes the package to the given source with API key" {
            Assert-MockCalled Exec 1
        }
    }

    Context "Push a package to a source and symbol source" {
        BeforeAll {
            # Arrange
            function Exec { param([scriptblock]$Command) }
            function Get-NuGetExe { return "NuGet.exe" }
            Mock Exec {} -ParameterFilter { $Command -like { & (Get-NuGetExe) push "$Package" -Source $Source -SymbolSource $SymbolSource  -NonInteractive } }

            # Act
            Push-Package "Foo.0.1.0.nupkg" -Source "myget" -SymbolSource "myget.symbols"
        }

        It "pushes the package to the given source and symbol source" {
            Assert-MockCalled Exec 1
        }
    }

    Context "Push a package to a source with API key and symbol source" {
        BeforeAll {
            # Arrange
            function Exec { param([scriptblock]$Command) }
            function Get-NuGetExe { return "NuGet.exe" }
            Mock Exec {} -ParameterFilter { $Command -like { & (Get-NuGetExe) push "$Package" -ApiKey $ApiKey -Source $Source -SymbolSource $SymbolSource -NonInteractive } }

            # Act
            Push-Package "Foo.0.1.0.nupkg" -Source "myget" -SymbolSource "myget.symbols" -ApiKey "123"
        }

        It "pushes the package to the given source with API key and symbol source" {
            Assert-MockCalled Exec 1
        }
    }

    Context "Push a package to a source and symbol source with API keys" {
        BeforeAll {
            # Arrange
            function Exec { param([scriptblock]$Command) }
            function Get-NuGetExe { return "NuGet.exe" }
            Mock Exec {} -ParameterFilter { $Command -like { & (Get-NuGetExe) push "$Package" -ApiKey $ApiKey -Source $Source -SymbolApiKey $SymbolApiKey -SymbolSource $SymbolSource -NonInteractive } }

            # Act
            Push-Package "Foo.0.1.0.nupkg" -Source "myget" -SymbolSource "myget.symbols" -ApiKey "123" -SymbolApiKey "456"
        }

        It "pushes the package to the given source and symbol source with API keys" {
            Assert-MockCalled Exec 1
        }
    }
}