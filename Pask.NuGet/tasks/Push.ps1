Import-Properties -Package Pask.NuGet
Import-Script Pask.NuGet -Package Pask.NuGet

Set-Property NuGetSource -Default ""
Set-Property NuGetApiKey -Default ""
Set-Property SymbolSource -Default ""
Set-Property SymbolApiKey -Default ""

# Synopsis: Publish the NuGet package(s) to a package source
Task Push {
    $Packages = Get-ChildItem (Join-Path $BuildOutputFullPath "*") -Include *.nupkg -Exclude *.symbols.nupkg

    if (-not $Packages) {
        Write-BuildMessage "NuGet packages not found" -ForegroundColor "Yellow"
    } elseif($NuGetSource -and $NuGetApiKey -and $SymbolSource -and $SymbolApiKey) {
	    Exec { Push-Package $Packages -Source $NuGetSource -ApiKey $NuGetApiKey -SymbolSource $SymbolSource -SymbolApiKey $SymbolApiKey }
    } elseif($NuGetSource -and $NuGetApiKey -and $SymbolSource) {
	    Exec { Push-Package $Packages -Source $NuGetSource -ApiKey $NuGetApiKey -SymbolSource $SymbolSource }
    } elseif($NuGetSource -and $NuGetApiKey) {
	    Exec { Push-Package $Packages -Source $NuGetSource -ApiKey $NuGetApiKey }
    } elseif($NuGetApiKey) {
	    Exec { Push-Package $Packages -ApiKey $NuGetApiKey }
    } elseif($NuGetSource) {
	    Exec { Push-Package $Packages -Source $NuGetSource }
    } else {
        throw "Cannot Push without NuGetSource or NuGetApiKey"
    }
}