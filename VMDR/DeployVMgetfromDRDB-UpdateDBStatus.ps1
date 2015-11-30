# CONSECO - Windows Server Administration - DR
# * VM Deployment Status Check *

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
$SqlQuery = "Select * FROM NT_DRSERVERINFO_RESTORE WHERE DRStatus LIKE 'CLO%'"

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
	Write-Host " ** Disaster Recovery Script - VM Deployment Status Check ** "  -foregroundcolor "Green"
	Write-Host ("*** " + $nRecs.ToString() + " VMs to be checked") -foregroundcolor "Blue"
	if ($nRecs -gt 0)
	{
		If ($DEBUG) {Write-Host "DEBUG: Begin IF Records Returned > 0"}
		If ($DEBUG) {Write-Host "DEBUG: Rows Returned: $nRecs"}
		# Do Stuff
		ForEach ($Row In $DataSet.Tables[0].Rows)
		{
			If ($DEBUG) {Write-Host "DEBUG: Begin Each Row"}
			$Task = Get-Task | Where {$_.id -eq $Row[17]}
			$vmname = $Row[0]
			
			If($Task.State -eq "Success")
			{
			Write-Host "Task Complete for VM $vmname" -foregroundcolor "Green"
			$SQLReturn = Set-SQL "UPDATE dbo.NT_DRSERVERINFO SET DRStatus = 'RDYCFG' WHERE Server = '$vmname'" "Server = VCENTER.CONSECO.AD; Database = VCENTER; User Id=VCAdmin; Password=vcadm6ev;"
			}
			If($Task.State -eq "Error")
			{
			Write-Host "Task Failed for VM $vmname"  -foregroundcolor "Red"
			$SQLReturn = Set-SQL "UPDATE dbo.NT_DRSERVERINFO SET DRStatus = 'ERROR' WHERE Server = '$vmname'" "Server = VCENTER.CONSECO.AD; Database = VCENTER; User Id=VCAdmin; Password=vcadm6ev;"
			}	
			If($Task.State -eq "Running")
			{
			Write-Host "Task Running for VM $vmname ["$Task.PercentComplete"% Complete]" -foregroundcolor "Yellow"
			$SQLReturn = Set-SQL "UPDATE dbo.NT_DRSERVERINFO SET DRStatus = 'CLORUN' WHERE Server = '$vmname'" "Server = VCENTER.CONSECO.AD; Database = VCENTER; User Id=VCAdmin; Password=vcadm6ev;"
			}
			If($Task.State -eq "Queued")
			{
			Write-Host "Task Queued for VM $vmname" -foregroundcolor "Cyan"
			$SQLReturn = Set-SQL "UPDATE dbo.NT_DRSERVERINFO SET DRStatus = 'CLOQUE' WHERE Server = '$vmname'" "Server = VCENTER.CONSECO.AD; Database = VCENTER; User Id=VCAdmin; Password=vcadm6ev;"
			}	

			If ($DEBUG) {Write-Host "DEBUG: End Each Row"}
		
		
		
		}
		If ($DEBUG) {Write-Host "DEBUG: End IF Records Returned > 0"}
	}
	Start-Sleep 10
	If ($DEBUG) {Write-Host "DEBUG: End For"}
}

$SqlConnection.Close();
Disconnect-VIServer -Confirm:$false
