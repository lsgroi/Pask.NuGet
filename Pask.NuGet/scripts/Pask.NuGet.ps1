<#
.SYNOPSIS 
   Pushes NuGet packages to a repository

.PARAMETER Packages <string[]>
   Packages path

.PARAMETER ApiKey <string>
   The API key for the target repository

.PARAMETER Source <string>
   The packages repository
   Default to nuget.org

.PARAMETER SymbolSource <string>
   The symbol server URL

.PARAMETER SymbolApiKey <string>
   The API key for the symbol server

.OUTPUTS
   Output of NuGet.exe push
#>
function script:Push-Package {
    [CmdletBinding(DefaultParameterSetName="DefaultPushSource")] 
    param(		
        [Parameter(Position=0,Mandatory=$true)]
        [string[]]$Packages,

        [Parameter(Mandatory=$true,ParameterSetName="DefaultPushSourceWithKey")]
        [Parameter(Mandatory=$true,ParameterSetName="SourceWithKey")]
        [Parameter(Mandatory=$true,ParameterSetName="SourceAndSymbolWithKey")]
        [Parameter(Mandatory=$true,ParameterSetName="SourceAndSymbolWithKeys")]
        [string]$ApiKey,
        
        [Parameter(Mandatory=$true,ParameterSetName="Source")]
        [Parameter(Mandatory=$true,ParameterSetName="SourceWithKey")]
        [Parameter(Mandatory=$true,ParameterSetName="SourceAndSymbol")]
        [Parameter(Mandatory=$true,ParameterSetName="SourceAndSymbolWithKey")]
        [Parameter(Mandatory=$true,ParameterSetName="SourceAndSymbolWithKeys")]
        [string]$Source = "https://www.nuget.org/",

        [Parameter(Mandatory=$true,ParameterSetName="SourceAndSymbol")]
        [Parameter(Mandatory=$true,ParameterSetName="SourceAndSymbolWithKey")]
        [Parameter(Mandatory=$true,ParameterSetName="SourceAndSymbolWithKeys")]
        [string]$SymbolSource,

        [Parameter(Mandatory=$true,ParameterSetName="SourceAndSymbolWithKeys")]
        [string]$SymbolApiKey
    )

    foreach($Package in $Packages) {
        switch ($PsCmdlet.ParameterSetName) {
            { ($_ -eq "DefaultPushSource") -or ($_ -eq "Source") }  { Exec { & (Get-NuGetExe) push "$Package" -Source $Source -NonInteractive } }
            { ($_ -eq "SourceWithKey") -or ($_ -eq "DefaultPushSourceWithKey") } { Exec { & (Get-NuGetExe) push "$Package" -ApiKey $ApiKey -Source $Source -NonInteractive } }
            "SourceAndSymbol"  { Exec { & (Get-NuGetExe) push "$Package" -Source $Source -SymbolSource $SymbolSource  -NonInteractive } }
            "SourceAndSymbolWithKey" { Exec { & (Get-NuGetExe) push "$Package" -ApiKey $ApiKey -Source $Source -SymbolSource $SymbolSource -NonInteractive } }
            "SourceAndSymbolWithKeys" { Exec { & (Get-NuGetExe) push "$Package" -ApiKey $ApiKey -Source $Source -SymbolApiKey $SymbolApiKey -SymbolSource $SymbolSource -NonInteractive } }
        }
    }
}