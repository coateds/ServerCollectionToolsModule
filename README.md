# Introduction 
This repo has a pipeline and all tests are v5

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
  * Deploy stage
    * Takes artifact from build stage and ??
* Add One more WMI based function and Tests (Copy from RC)
* Complete Test-ServerConnection Tests
* Build Story
* Publish to PowerShell Gallary