Import-Script Properties.Push -Project Pask.NuGet

Set-Property Version -Value (Get-ProjectSemanticVersion)