Import-Task Clean, Version-BuildServer, Pack-Nuspec, Test-Pester, Push-Local
Import-Script Pask.NuGet -Project Pask.NuGet

# Synopsis: Default task
Task . Clean, Pack-Nuspec, Test, Push-Local

# Synopsis: Run all automated tests
Task Test Pack-Nuspec, Test-Pester

# Synopsis: Test a release
Task PreRelease Version-BuildServer, Clean, Pack-Nuspec, Test

# Synopsis: Release the package
Task Release Version-BuildServer, Clean, Pack-Nuspec, Test #, Push

