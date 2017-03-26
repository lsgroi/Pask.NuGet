Import-Properties -Package Pask.NuGet

Set-Property CreateSymbolsPackage -Default $false

# Synopsis: Create a NuGet package targeting a CSProj
Task Pack {
    $CSProj = Join-Path "$ProjectFullPath" "$ProjectName.csproj"
	Assert (Test-Path $CSProj) "Could not find '$ProjectName.csproj'"
	Assert (Test-Path $ArtifactFullPath) "Could not find artifact directory '$ArtifactFullPath'"

    # Set or not the symbols package flag
	$Symbols = @{$true="-Symbols";$false=""}[$CreateSymbolsPackage -eq $true]

    # Create the build output directory
    New-Directory $BuildOutputFullPath | Out-Null

    "Packing $CSProj"
	Exec { & (Get-NuGetExe) pack "$CSProj" -BasePath "$ProjectFullPath" -IncludeReferencedProjects -NoDefaultExcludes -OutputDirectory "$BuildOutputFullPath" -Version $Version.SemVer -Properties "OutputPath=$ArtifactFullPath;Configuration=$BuildConfiguration" $Symbols }
}