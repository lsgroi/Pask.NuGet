Import-Task Clean, Build, New-Artifact, Pack

# Synopsis: Default task
Task . Clean, Build, New-Artifact, Pack

# Synopsis: Pack ClassLibrary project
Task Pack-ClassLibrary {
	Set-Project -Name ClassLibrary
}, Clean, Build, New-Artifact, Pack

# Synopsis: Pack ClassLibrary.Other project
Task Pack-ClassLibraryOther {
	Set-Project -Name ClassLibrary
	Set-Project -Name ClassLibrary.Other
}, Clean, Build, New-Artifact, Pack