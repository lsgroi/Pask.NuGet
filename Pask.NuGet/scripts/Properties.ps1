Import-Properties -Package Pask

Set-Property LocalNuGetFeed -Default "C:\LocalNuGetFeed"
Set-Property Version -Value (Get-ProjectSemanticVersion)