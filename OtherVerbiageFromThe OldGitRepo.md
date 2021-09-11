This started out as a thought experiment in extreme pipelining. The idea is to start with
a generic collection of objects (PSObject). One column of this 'table' will be ComputerName.

The original conception (and still a very good one) was to use a CSV via Import-Csv. This file
filtered by any of the other columns in the CSV. For instance Location -eq Arizona or some such.
Get-MyServerCollection is an example of how this could work.

A late additon function, Get-ServerObjectCollection, will create a similar object as Import-Csv but
from a simple collection/array of strings that are computer names. Using Get-Content, this can 
even be a txt file of server names, one name per line.

Each subsequent function will add one of more columns to the object being passed down the pipe. At
least one function, Get-VolumeInfoOnPipeline, will add rows as well.

The Test-ServerConnectionOnPipeline will almost always be included just after one or more functions/
cmdlets gathers a collection with ComputerName. The Test function will run a series of server health
tests and will return true/false on a column for that test. Subsequent functions are then coded to 
only proceed on an action against a server if the test returns true. The current tests are Ping,
WMI and PSRemote.

The rest of the functions in this example will gather Server properties describing its capacity
such as memory, processors and disk. This solution is designed to answer questions like: Are there
any SQL servers with drives less that 5% free space? Do all of the Web Servers in Arizona have more
than 48 GB of memory? You are handed a seemingly random list of servers and asked what Make and Model
of hardware are they?

The output of these functions can be piped through the Cmdlets Select-Object, Where-Object, Sort-Object
or sent to Export-Csv to be saved or later opened in Excel
ot sent to the Out-GridView to be tweaked immediately and interactively.