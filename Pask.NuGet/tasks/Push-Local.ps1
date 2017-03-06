# Synopsis: Push the NuGet package(s) to a local NuGet feed
Task Push-Local {
    Import-Properties -Package Pask.NuGet
    Import-Script Pask.NuGet
    
    $Packages = Get-ChildItem (Join-Path $BuildOutputFullPath "*") -Include *.nupkg

	New-Directory $LocalNuGetFeed | Out-Null

	Exec { Push-Package -Packages $Packages -Source "$LocalNuGetFeed" }
}