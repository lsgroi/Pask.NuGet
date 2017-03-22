Import-Properties -Package Pask.NuGet
Import-Script Pask.NuGet -Package Pask.NuGet

# Synopsis: Push the NuGet package(s) to a local NuGet feed
Task Push-Local {   
    $Packages = Get-ChildItem (Join-Path $BuildOutputFullPath "*") -Include *.nupkg

    if (-not $Packages) {
        Write-BuildMessage "NuGet packages not found" -ForegroundColor "Yellow"
    } else {
        New-Directory $LocalNuGetFeed | Out-Null

	    Exec { Push-Package -Packages $Packages -Source "$LocalNuGetFeed" }
    }
}