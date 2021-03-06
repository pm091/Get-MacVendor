# Generic module deployment.
# This stuff should be moved to psake for a cleaner deployment view

# ASSUMPTIONS:

 # folder structure of:
 # - RepoFolder
 #   - This PSDeploy file
 #   - ModuleName
 #     - ModuleName.psd1

 # Nuget key in $ENV:NugetApiKey

 # Set-BuildEnvironment from BuildHelpers module has populated ENV:BHProjectName

# Publish to gallery with a few restrictions
if(
    $env:BHBuildSystem -ne 'Unknown' -and
    $env:BHBranchName -eq "master" -and
    $env:BHCommitMessage -match 'deploy'
)
{
   Deploy Script {
    By PSGalleryScript {
        FromSource "$ProjectRoot\Get-MacVendor\Get-MacVendor.ps1"
        To PSGallery
        WithOptions @{
            ApiKey = $ENV:NugetApiKey
            Version =  $env:APPVEYOR_BUILD_VERSION
            Author = "PM091"
            Description = "Get-MacVendor"
        }
    }
}
}
else
{
    "Skipping deployment: To deploy, ensure that...`n" +
    "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
    "`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n" +
    "`t* Your commit message includes !deploy (Current: $ENV:BHCommitMessage)" |
        Write-Host
}

# Publish to AppVeyor if we're in AppVeyor
if(
    $env:BHPSModulePath -and
    $env:BHBuildSystem -eq 'AppVeyor'
   )
{
    Deploy DeveloperBuild {
        By AppVeyorModule {
            FromSource $ENV:BHPSModulePath
            To AppVeyor
            WithOptions @{
                Version = $env:APPVEYOR_BUILD_VERSION
            }
        }
    }
}