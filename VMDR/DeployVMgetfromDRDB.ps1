# CONSECO - Windows Server Administration - DR
# * VM Deployment DR Deploy *

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

#$TaskName = "GetVMsForDeploy"
$SqlServer = "VCENTER.CONSECO.AD";
$SqlDatabase = "VCENTER";
$SqlSecurity = "User Id=VCAdmin; Password=vcadm6ev;"

# Get the T-SQL Query from .SQL file
#$SqlQuery = Get-Content (".\" + $TaskName + ".sql")

# Get the T-SQL 
$SqlQuery = "Select * FROM NT_DRSERVERINFO_RESTORE WHERE DRStatus = 'RESTORE' ORDER BY Cast(DRPriority As Int)"

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
$DataSet = New-Object System.Data.DataSet

#Execute and Get Row Count
$nRecs = $SqlAdapter.Fill($DataSet)

Write-Host ($nRecs.ToString() + " VMs to be deployed") -foregroundcolor "Cyan"
$SqlConnection.Close();

load-VITK

if ($nRecs -gt 0)
{
 Connect-VIServer -Server "vcenter.conseco.ad"
  # Do Stuff
  ForEach ($Row In $DataSet.Tables[0].Rows)
  {
  	$Row
	Write-Host "*************** VM:" $Row[0] "*************** " 
	#Definted in deployVMfunction.ps1
    #function fnDeployVM([string]$vmname, [string]$OS, [string]$OSver, [string]$vmIPaddress, [string]$vmBOIPaddress, [string]$vmvcpus, [string]$vmram, [string]$vmdisk, [string]$vmhost, [string]$vmdatastore, [string]$vmfolder, [string]$vmcluster, [string]$vmresourcepool, $gui, $deploy, [string]$vmsource, $dr)
	fnDeployVM $Row[0] $Row[1] $Row[2] $Row[3] $Row[4] $Row[5] $Row[6] $Row[7] $Row[8] $Row[9] $Row[10] $Row[11] $Row[12] $FALSE $TRUE $Row[15] $TRUE
	Write-Host "*************** VM:" $Row[0] "*************** "
	Write-Host " "
  }
  Disconnect-VIServer -Server $defaultviserver -Confirm:$false
}

