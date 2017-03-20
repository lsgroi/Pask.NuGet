Import-Properties -Project Pask
Import-Script Properties.MSBuild -Package Pask

# Synopsis: Create a NuGet package targeting a Nuspec
Task Pack-Nuspec {
    Set-Property CreateSymbolsPackage -Default $false
    Set-Property IncludePdb -Default $false

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

    $Nuspec = "$(Join-Path "$ProjectFullPath" "$ProjectName").nuspec"
    "Packing $Nuspec"
	Exec { & (Get-NuGetExe) pack "$Nuspec" -BasePath "$ProjectFullPath" -NoDefaultExcludes -OutputDirectory "$BuildOutputFullPath" -Version $Version.SemVer -Properties "id=$ProjectName;configuration=$BuildConfiguration" $Symbols $Exclude $ExcludePattern }
}
