Import-Properties -Package Pask

Set-Property Version -Value {
    if(Test-Path (Join-Path $ProjectFullPath "version.txt")) {
        return (Get-ProjectSemanticVersion)
    } else {
        $Version
    }
}