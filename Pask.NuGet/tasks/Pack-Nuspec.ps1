Import-Properties -Project Pask
Import-Script Properties.MSBuild -Package Pask

Set-Property CreateSymbolsPackage -Default $false
Set-Property IncludePdb -Default $false

# Synopsis: Create a NuGet package targeting a Nuspec
Task Pack-Nuspec {
    $Nuspec = "$(Join-Path "$ProjectFullPath" "$ProjectName").nuspec"
    Assert (Test-Path $Nuspec) "Could not find '$ProjectName.nuspec'"

    # Set or not the symbols package flag
    $Symbols = @{$true="-Symbols";$false=""}[$CreateSymbolsPackage -eq $true]

    if ($CreateSymbolsPackage -eq $false -and $IncludePdb -eq $false) {
        # Exclude PDB files
        $Exclude = "-Exclude"
        $ExcludePattern = "**/*.pdb"
    } else {
        $Exclude = $ExcludePattern = ""
    }

    # Create the build output directory
    New-Directory $BuildOutputFullPath | Out-Null

    "Packing $Nuspec"
	Exec { & (Get-NuGetExe) pack "$Nuspec" -BasePath "$ProjectFullPath" -NoDefaultExcludes -OutputDirectory "$BuildOutputFullPath" -Version $Version.SemVer -Properties "id=$ProjectName;Configuration=$BuildConfiguration" $Symbols $Exclude $ExcludePattern }
}
