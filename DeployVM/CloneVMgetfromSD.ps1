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

load-VITK

$TaskName = "GetVMsForClone"
$SqlServer = "S5PRD1";
$SqlDatabase = "MDB";

# Get the T-SQL Query from .SQL file
$SqlQuery = Get-Content (".\" + $TaskName + ".sql")

#Write-Host ($SqlQuery) -foregroundcolor "gray"

# Setup SQL Connection
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SqlServer; Database = $SqlDatabase; Integrated Security = True"

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

if ($nRecs -gt 0)
{
 Connect-VIServer -Server "vcenter.conseco.ad"
  # Do Stuff
 ForEach ($Row In $DataSet.Tables[0].Rows)
  {
	Write-Host "*************** VM:" $Row[0] "*************** " 
	fnDeployVM $Row[0] $Row[1] $Row[2] $Row[3] $Row[4] $Row[5] $Row[6] $Row[7] $Row[8] $Row[9] $Row[10] $Row[11] $Row[12] $false $false $Row[13] $false
	Write-Host "*************** VM:" $Row[0] "*************** "
	Write-Host " "
  }
  Disconnect-VIServer -Server $defaultviserver -Confirm:$false
}


  