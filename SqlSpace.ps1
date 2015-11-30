$debug = $true
$table = New-Object system.Data.DataTable "Volume"
$col01 = New-Object system.Data.DataColumn Server,([string])
$col02 = New-Object system.Data.DataColumn Volumes,([string])
$table.columns.add($col01)
$table.columns.add($col02)

function getserverinfo([string]$strComputer)
{
	$ComputerSystem = Gwmi Win32_ComputerSystem -ComputerName $strComputer
	$Volumes = GWMI -cl "Win32_Volume" -name "root\CimV2" -comp $strComputer -Filter "DriveType = 3"
	
	$myVols = " -- Volumes -- `n"
		
	ForEach ($Volume in $Volumes)
	{
			$SpaceUsed = [math]::round(([double]$Volume.Capacity - [double]$Volume.FreeSpace)/1gb,2)
			$SpaceFree = [math]::round(([double]$Volume.FreeSpace)/1gb,2)
			$SpaceTotal = [math]::round(([double]$Volume.Capacity)/1gb,2)
			
			Write-Host $Volume.Name " : " $SpaceTotal "GB Total :: " $SpaceUsed "GB Used - " $SpaceFree "GB Free"
			$myVols = $myVols + $Volume.Name + " : " + $SpaceTotal + "GB Total :: " + $SpaceUsed + "GB Used :: " + $SpaceFree + "GB Free" + "`n"
	}

$row = $table.NewRow()
$row.Server = $myName
$row.Volumes = $myVols
$table.Rows.Add($row) 
	
}

$Catalog = GC "\\ntadminp01\PUBLIC\SQLServers.txt" # File containing server list
ForEach($Machine in $Catalog) # Loop through file, for each server
{
	Write-Host "Processing System: " $Machine
	getserverinfo($Machine)
	Write-Host "*********************************************"
}
$table | Export-Csv H:\SQLSpaceSize.csv