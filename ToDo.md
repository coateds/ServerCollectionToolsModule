# ToDo Phase one
* Glean from PowerShellModuleProject and Delete
  * azure-pipelines.yml
* Study and build out other pipeline stages
  * Build Stage -> 
    * Produces an Artifact
      * NuGetPackage
      * PowerShellModuleProject.0.0.25.nupkg
    * Artifact does not go anywhere?
  * Test (Pester) stage - Largely understood
    * Last Pester Tests are done
  * Deploy stage
    * Takes artifact from build stage and ??
* Add One more WMI based function and Tests (Copy from RC)
* Complete Test-ServerConnection Tests
* Build Story
* Publish to PowerShell Gallery

Follow two examples for Pipeline:

Lets create a PowerShell Module and publish it to the PSGallery using GitHub Actions!
https://www.jeroentrimbach.com/2021/07/powershell-module-ci/

Make an origin-git for the ServerCollectionToolsModule - Done
Push this to a new GitHub Repo for this purpose - Done

(Delete the old repo in Git)

PowerShell Gallery 
    Register (tied with my Live account?)
    Set up API Key
        Name: ServerCollectionToolsModule
        Glob Pattern: *
Add the API Key to the GitHub Repo
    Name: PSGALLERYAPIKEY
Build Out the build_scripts\build-git.ps1 (To distinguish it from the Azure one already there)


Use Azure Artifacts as a private PowerShell repository
https://docs.microsoft.com/en-us/azure/devops/artifacts/tutorials/private-powershell-library?view=azure-devops#:~:text=%20Use%20Azure%20Artifacts%20as%20a%20private%20PowerShell,of%20different%20types.%20To%20store%20our...%20More%20

