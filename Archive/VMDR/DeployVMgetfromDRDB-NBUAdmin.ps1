# CONSECO - Windows Server Administration - DR
# * NetBackup Interface*

[reflection.assembly]::LoadWithPartialName("'Microsoft.VisualBasic")
function fnGetDataSet([string]$SQL){
	$SqlServer = "VCENTER.CONSECO.AD";
	$SqlDatabase = "VCENTER";
	$SqlSecurity = "User Id=VCAdmin; Password=vcadm6ev;"
	
	# Get the T-SQL Query from .SQL file
	#$SqlQuery = Get-Content (".\" + $TaskName + ".sql")
	
	# Get the T-SQL 
	$SqlQuery = $SQL
	
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
	
	$DataSet = New-Object System.Data.DataSet
	$nRecs = $SqlAdapter.Fill($DataSet)
	Return $DataSet
}
function Set-SQL ([string]$Query,[string]$ConnString) {

if ($ConnString) {

	if($ConnString -match '"*"') {
		$ConnString = $ConnString.TrimStart('"')
		$ConnString = $ConnString.TrimEnd('"')
	}

} else {

	# Default ConnectionString
	$ConnString =
	"server=SQL;database=master;trusted_connection=true;"

}

$Connection = New-Object System.Data.SQLClient.SQLConnection

$Connection.ConnectionString = $ConnString
$Connection.Open()

$Command = New-Object System.Data.SQLClient.SQLCommand
$Command.Connection = $Connection
$Command.CommandText = $Query

return $Reader = $Command.ExecuteNonQuery()

$Connection.Close()

}
function fnModifyDRStatus([int]$RowID)
{

	$dsDS = fnGetDataSet "Select * FROM NT_DRSERVERINFO_DRSTATUSXREF WHERE DRSTATUS LIKE '%NBU%' ORDER BY RowID"
	$dsVM = fnGetDataSet "Select * FROM NT_DRSERVERINFO WHERE RowId= '$RowID'"
	$VMcol = $dsVM.Tables[0].Rows[0]
	$DRStatusDescript = ""
	$DRStatusOptions = ""
	$VMDRStatusCurrent = $VMcol[42]
	ForEach($Row In $dsDS.Tables[0].Rows)
	{
		$RC= [String]$Row[0]+". "+"["+$Row[1]+"] "+$Row[2]+"`n"
		$DRStatusOptions = $DRStatusOptions + $RC
		If($Row[1] -eq $VMcol[42]){$DRStatusDescript = $Row[2]}
	}

	
	fnPrintHeader "Modify VM DR Recovery Status"
	Write-Host ""
	Write-Host "*******************************************************************************" -foregroundcolor "White"
	Write-Host "VM: "$VMcol[1] -foregroundcolor "Blue"
	Write-Host "Current DR Recovery Status: "
	Write-Host " -- Code: ["$VMDRStatusCurrent" ]"
	Write-Host " -- Description: "$DRStatusDescript
	Write-Host "*******************************************************************************" -foregroundcolor "White"
	Write-Host ""
	Write-Host "Available DR Status Options:" -foregroundcolor "White"
	Write-Host $DRStatusOptions -foregroundcolor "White"
	Write-Host "Q. Return to the Main Menu"  -foregroundcolor "White"
	$strResponse = “0”
	do {$strResponse = Read-Host “Select an option: [#/Q]”}
	until (($strResponse -eq “Q”) -or ([Microsoft.VisualBasic.Information]::isnumeric($strResponse)))
		
	If($strResponse -ne "Q" )
	{
		$SQLReturn = Set-SQL "UPDATE dbo.NT_DRSERVERINFO SET DRStatus = DRSX.DRStatus FROM dbo.NT_DRSERVERINFO DRSI, NT_DRSERVERINFO_DRSTATUSXREF DRSX WHERE DRSI.RowID =  '$RowID' AND DRSX.RowID = '$strResponse'" "Server = VCENTER.CONSECO.AD; Database = VCENTER; User Id=VCAdmin; Password=vcadm6ev;"

		$dsVM = fnGetDataSet "Select * FROM NT_DRSERVERINFO WHERE RowId= '$RowID'"
		$VMcol = $dsVM.Tables[0].Rows[0]
		$DRStatusDescript = ""
		$DRStatusOptions = ""
		ForEach($Row In $dsDS.Tables[0].Rows)
		{
			$RC= [String]$Row[0]+". "+"["+$Row[1]+"] "+$Row[2]+"`n"
			$DRStatusOptions = $DRStatusOptions + $RC
			If($Row[1] -eq $VMcol[42]){$DRStatusDescript = $Row[2]}
		}

		
		fnPrintHeader "Modify VM DR Recovery Status"
		Write-Host ""
		Write-Host "*******************************************************************************" -foregroundcolor "White"
		Write-Host "VM: "$VMcol[1] -foregroundcolor "Blue"
		Write-Host "Current DR Recovery Status: "
		Write-Host " -- Code: ["$VMcol[42]"]"
		Write-Host " -- Description: "$DRStatusDescript
		Write-Host "*******************************************************************************" -foregroundcolor "White"
		Write-Host ""

		
		If($SQLReturn -gt 0)
		{
			Write-Host "VM DR Recovery Status Updated Sucessfully." -foregroundcolor "Green"
		}
		else
		{
			Write-Host "VM DR Recovery Status Failed to Update." -foregroundcolor "Red"
		}
		Read-Host “Press Any Key To Continue”}
	}
function fnPrintHeader([string]$Title){
	Clear-Host
	Write-Host  ""
	Write-Host  "..######...#######..##....##..######..########..######...#######." -foregroundcolor "DarkGreen"
	Write-Host  ".##....##.##.....##.###...##.##....##.##.......##....##.##.....##"	-foregroundcolor "DarkGreen"
	Write-Host  ".##.......##.....##.####..##.##.......##.......##.......##.....##" -foregroundcolor "DarkGreen"
	Write-Host  ".##.......##.....##.##.##.##..######..######...##.......##.....##" -foregroundcolor "DarkGreen"
	Write-Host  ".##.......##.....##.##..####.......##.##.......##.......##.....##" -foregroundcolor "DarkGreen"
	Write-Host  ".##....##.##.....##.##...###.##....##.##.......##....##.##.....##" -foregroundcolor "DarkGreen"
	Write-Host  "..######...#######..##....##..######..########..######...#######." -foregroundcolor "DarkGreen"
	Write-Host ""
	Write-Host " ** Disaster Recovery Script - NetBackup Interface ** "  -foregroundcolor "Green"
	Write-Host " ===> $Title <===" -foregroundcolor "Yellow"
	Write-Host ""
}
		
$RUN = $TRUE


do {
	fnPrintHeader "VMs With NetBackup Status Types "
	$dsVMs = fnGetDataSet "Select RowId, Server FROM NT_DRSERVERINFO WHERE DRStatus = 'RDYNBU'"
	Write-Host "The following VMs are ready for NetBackup restores:" -foregroundcolor "White"
	ForEach($Row In $dsVMs.Tables[0].Rows)
	{
		$RC= [String]$Row[0]+". "+$Row[1]
		Write-Host $RC
	}

	$dsVMs = fnGetDataSet "Select RowId, Server FROM NT_DRSERVERINFO WHERE DRStatus = 'NBUACK'"
	Write-Host "The following VMs have been acknowleged for NetBackup restores:" -foregroundcolor "White"
	ForEach($Row In $dsVMs.Tables[0].Rows)
	{
		$RC= [String]$Row[0]+". "+$Row[1]
		Write-Host $RC
	}

$dsVMs = fnGetDataSet "Select RowId, Server FROM NT_DRSERVERINFO WHERE DRStatus = 'NBURUN'"
Write-Host "The following VMs have NetBackup restores running:" -foregroundcolor "White"
	ForEach($Row In $dsVMs.Tables[0].Rows)
	{
		$RC= [String]$Row[0]+". "+$Row[1]
		Write-Host $RC
	}




Write-Host ""
Write-Host "SysAdmin Interface" -foregroundcolor "White"
Write-Host "#. To Modify a VM's Status, Enter the VM's Row ID"  -foregroundcolor "White"
Write-Host "R. Refresh Data"  -foregroundcolor "White"
Write-Host "Q. Quit"  -foregroundcolor "White"
Write-Host ""
$strResponse = “0”
do {$strResponse = Read-Host “Select an option: [#/R/Q]”}
until (($strResponse -eq “R”) -or($strResponse -eq “Q”) -or ([Microsoft.VisualBasic.Information]::isnumeric($strResponse)))

If($strResponse -ne "Q" -and $strResponse -ne “R”) { fnModifyDRStatus $strResponse }
If($strResponse -eq "Q") {$RUN = $FALSE}
}
while ($RUN)