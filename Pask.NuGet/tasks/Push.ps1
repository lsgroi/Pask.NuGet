Import-Properties -Package Pask.NuGet
Import-Script Pask.NuGet -Package Pask.NuGet

Set-Property PushSource -Default ""
Set-Property ApiKey -Default ""
Set-Property SymbolSource -Default ""
Set-Property SymbolApiKey -Default ""

# Synopsis: Publish the NuGet package(s) to a package source
Task Push {
    $Packages = Get-ChildItem (Join-Path $BuildOutputFullPath "*") -Include *.nupkg -Exclude *.symbols.nupkg

    if (-not $Packages) {
        Write-BuildMessage "NuGet packages not found" -ForegroundColor "Yellow"
    } elseif($PushSource -and $ApiKey -and $SymbolSource -and $SymbolApiKey) {
	    Exec { Push-Package $Packages -Source $PushSource -ApiKey $ApiKey -SymbolSource $SymbolSource -SymbolApiKey $SymbolApiKey }
    } elseif($PushSource -and $ApiKey -and $SymbolSource) {
	    Exec { Push-Package $Packages -Source $PushSource -ApiKey $ApiKey -SymbolSource $SymbolSource }
    } elseif($PushSource -and $ApiKey) {
	    Exec { Push-Package $Packages -Source $PushSource -ApiKey $ApiKey }
    } elseif($ApiKey) {
	    Exec { Push-Package $Packages -ApiKey $ApiKey }
    } elseif($PushSource) {
	    Exec { Push-Package $Packages -Source $PushSource }
    } else {
        throw "Cannot Push without PushSource or ApiKey"
    }
}