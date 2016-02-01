# CONSECO - Windows Server Administration - DR
# * VM Deployment Configuration *

$VMDSfn = "DeployVMfunction.ps1"

$VMDSincludes = ($VMDSfn)

$VMDSincludes | % {
	if (Test-Path $_)
	{
		. ./$_
		Write-Host $_ Loaded
	}
	else
	{
		Write-Host "Essential file missing." -foregroundcolor "red"
		Write-Host "Make sure file '$_' is present in the current directory"
		exit
	}
}

$DEBUG = $False

#Connect to Virutal Center
load-VITK
Connect-VIServer -Server "vcenter.conseco.ad"

#$TaskName = "GetVMsForDeploy"
$SqlServer = "VCENTER.CONSECO.AD";
$SqlDatabase = "VCENTER";
$SqlSecurity = "User Id=VCAdmin; Password=vcadm6ev;"

# Get the T-SQL Query from .SQL file
#$SqlQuery = Get-Content (".\" + $TaskName + ".sql")

# Get the T-SQL 
$SqlQuery = "Select * FROM NT_DRSERVERINFO_RESTORE WHERE DRStatus = 'RDYCFG'"

#Write-Host ($SqlQuery) -foregroundcolor "gray"

# Setup SQL Connection
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SqlServer; Database = $SqlDatabase; $SqlSecurity"

# Setup SQL Command
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection

# Setup .NET SQLAdapter to execute and fill .NET Dataset
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd


#Execute and Get Row Count

for($i=1; $i -le 1000; $i++)
{
	If ($DEBUG) {Write-Host "DEBUG: Begin For"}
	$DataSet = New-Object System.Data.DataSet
	$nRecs = $SqlAdapter.Fill($DataSet)
	Clear-Host
	Write-Host 
	
	Write-Host  "..######...#######..##....##..######..########..######...#######." -foregroundcolor "DarkGreen"
	Write-Host  ".##....##.##.....##.###...##.##....##.##.......##....##.##.....##"	-foregroundcolor "DarkGreen"
	Write-Host  ".##.......##.....##.####..##.##.......##.......##.......##.....##" -foregroundcolor "DarkGreen"
	Write-Host  ".##.......##.....##.##.##.##..######..######...##.......##.....##" -foregroundcolor "DarkGreen"
	Write-Host  ".##.......##.....##.##..####.......##.##.......##.......##.....##" -foregroundcolor "DarkGreen"
	Write-Host  ".##....##.##.....##.##...###.##....##.##.......##....##.##.....##" -foregroundcolor "DarkGreen"
	Write-Host  "..######...#######..##....##..######..########..######...#######." -foregroundcolor "DarkGreen"
	Write-Host ""
	Write-Host " ** Disaster Recovery Script - VM Deployment Configuration ** "  -foregroundcolor "Green"
	Write-Host ("*** " + $nRecs.ToString() + " VMs to be config") -foregroundcolor "Blue"
	if ($nRecs -gt 0)
	{
		If ($DEBUG) {Write-Host "DEBUG: Begin IF Records Returned > 0"}
		If ($DEBUG) {Write-Host "DEBUG: Rows Returned: $nRecs"}
		# Do Stuff
		ForEach ($Row In $DataSet.Tables[0].Rows)
		{
			$vmname = $Row[0]
			If ($DEBUG) {Write-Host "DEBUG: Begin Each Row"}
			
			fnVMConfig $Row[0] $Row[1] $Row[2] $Row[3] $Row[4] $Row[5] $Row[6] $Row[7] $Row[8] $Row[9] $Row[10] $Row[11] $Row[12] $FALSE $TRUE $Row[15] $TRUE
			$SQLReturn = Set-SQL "UPDATE dbo.NT_DRSERVERINFO SET DRStatus = 'RDYSET' WHERE Server = '$vmname'" "Server = VCENTER.CONSECO.AD; Database = VCENTER; User Id=VCAdmin; Password=vcadm6ev;"
			
			If ($DEBUG) {Write-Host "DEBUG: End Each Row"}
			
		}
		If ($DEBUG) {Write-Host "DEBUG: End IF Records Returned > 0"}
	}
	Start-Sleep 10
	If ($DEBUG) {Write-Host "DEBUG: End For"}
}

$SqlConnection.Close();
Disconnect-VIServer -Confirm:$false
