$Catalog = GC "c:\server.lst"	# File containing server list
ForEach($Machine in $Catalog)	# Loop through file, for each server
{$QueryString = Gwmi Win32_OperatingSystem -Comp $Machine
$QueryString = $QueryString.Caption +"," + $QueryString.ServicePackMajorVersion 
Write-Output $Machine","$QueryString} # Write the output to active pipe



