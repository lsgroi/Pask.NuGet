<#
.SYNOPSIS 
   Pushes NuGet packages to a repository

.PARAMETER Packages <string[]>
   Packages path

.PARAMETER ApiKey <string[]>
   The Api key for the target repository

.PARAMETER Source <string[]>
   The packages repository
   This is a mandatory parameter unless the NuGet.config file specifies a DefaultPushSource value

.OUTPUTS
   Output of NuGet.exe push
#>
function script:Push-Package {
    [CmdletBinding(DefaultParameterSetName="DefaultPushSource")] 
    param(		
        [Parameter(Mandatory=$true)]
        [string[]]$Packages,

        [Parameter(Mandatory=$true,ParameterSetName="DefaultPushSourceWithKey")]
        [Parameter(Mandatory=$true,ParameterSetName="SourceWithKey")]
        [string]$ApiKey,
        
        [Parameter(Mandatory=$true,ParameterSetName="Source")]
        [Parameter(Mandatory=$true,ParameterSetName="SourceWithKey")]
        [string]$Source
    )

    foreach($Package in $Packages) {
        switch ($PsCmdlet.ParameterSetName) {
            "DefaultPushSource"  { Exec { & (Get-NuGetExe) push "$Package" -NonInteractive } }
            "DefaultPushSourceWithKey" { Exec { & (Get-NuGetExe) push "$Package" -ApiKey $ApiKey -NonInteractive } }
            "Source"  { Exec { & (Get-NuGetExe) push "$Package" -Source $Source -NonInteractive } }
            "SourceWithKey" { Exec { & (Get-NuGetExe) push "$Package" -ApiKey $ApiKey -Source $Source -NonInteractive } }
        }
    }
}
