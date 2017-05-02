Import-Properties -Package Pask

if(Test-Path (Join-Path $ProjectFullPath "version.txt")) {
    Set-Property Version -Value (Get-ProjectSemanticVersion)
}