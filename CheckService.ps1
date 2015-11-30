# Windows Powershell script to show the status of IIS6+ (HTTP only, doesn't include FTP or SSL)
# The script has been written using PowerShell functions to make the whole thing shorter
#
# Checks for the IIS Admin, World Wide Web Publishing Service, FTP Publishing Service, NNTP and SMTP services
#
# Chris Rasmussen, March 2008

# be tidy - clear the screen  :)
cls

# show a welcome message
write-host "IIS6+ Status Summary"
write-host "--------------------"
write-host ""

# this function accepts the name of a service (either the display name or short name) and the name of a machine to check
# the services on the specified machine are enumerated to see if the specified service exists
# if the service does exist the status is checked
# if the service does not exist an appropriate error is displayed
function checkService ($serviceName, $machineName) {

	# do some very basic error checking
	if (($serviceName -eq $null) -or ($machineName -eq $null))
	{
		write-host "Service or machine name missing.  Please correct and retry."
	}
	else
	{
		# use the .NET abilities of PowerShell to get a list of all services that match the service name we're looking for
		# note that we are checking both the short and display names, i.e. you can check for either
		# e.g. "iisadmin" and "IIS Admin Service" will both work
		$serviceResults = [System.ServiceProcess.ServiceController]::GetServices($machineName) | where{ (($_.name -eq $serviceName) -or ($_.displayname -eq $serviceName))}

		# check to see if the results is an empty object
		# if it is empty the requested service wasn't found
		if ($serviceResults -eq $null)
		{
			# the service wasn't found so set the result to an empty string (it's used later)
			$isServiceFound = ""
		}
		else
		{
			# the service was found so get the service's name
			$isServiceFound = $serviceResults.name
		}

		# check to see if any service names were returned
		if ($isServiceFound -eq "")
		{
			# the service wasn't found
			$resultDisplay = "Not found"
		}
		else
		{
			# the requested service was found so get its status
			$serviceStatus = get-service $isServiceFound
			$resultDisplay = $serviceStatus.status
		}

		# return the result of the service check
		if ($resultDisplay -eq "Running")
		{
			# it is running so display an appropriate confirmation in normal text colour
			write-host $machineName  -noNewLine
			write-host " : $serviceName : " -noNewLine
			write-host $resultDisplay
		}
		else
		{
			# the service isn't running to display a warning in red text colour
			write-host "$serviceName : " -noNewLine
			write-host $resultDisplay -foregroundColor('red')
		}
	}
}

# this line dynamicaly loads the .NET assemblies into memory so they can be used by this script
$loadAssemblies = [System.Reflection.Assembly]::LoadWithPartialName('system.serviceprocess')

# setup the list of services we want to check
# modify this array to suit your needs
$serviceList = "Server"


$Catalog = GC "h:\ps\servers.txt" # File containing server list
ForEach($Machine in $Catalog) # Loop through file, for each server
{
checkService "Server" $Machine
}

