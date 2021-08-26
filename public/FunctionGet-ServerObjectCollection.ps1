Function Get-ServerObjectCollection
{
    <#
        .Synopsis
            Converts a collection of Server Name Strings into a Colection of objects
        .DESCRIPTION
            This function will take a random list of servers, such as an array or txt file
            and convert it on the pipeline to a collection of PSObjects. This collection
            will function exactly like an imported CSV with ComputerName as the column heading.
        .EXAMPLE
            ('Server2','Server4') | Get-ServerObjectCollection | Test-ServerConnectionOnPipeline | ft
        .EXAMPLE
            Get-Content -Path .\RndListOfServers.txt | Get-ServerObjectCollection | Test-ServerConnectionOnPipeline | ft
        .EXAMPLE
            (Get-ADComputer -Filter *).Name | Get-ServerObjectCollection | Test-ServerConnectionOnPipeline | ft
            Active Directory!! (All Computers)
        .EXAMPLE
            (Get-ADComputer -SearchBase "OU=Domain Controllers,DC=coatelab,DC=com" -Filter *).Name | Get-ServerObjectCollection | Test-ServerConnectionOnPipeline | ft
            Active Directory!! (Just Domain Controllers)
    #>

    Param(
        [parameter(
        Mandatory=$true,
        ValueFromPipeline= $true)]
        [string]
        $ComputerName
    )

    Process {
        [PSCustomObject]@{
            'ComputerName' = $ComputerName
        }
    }
}