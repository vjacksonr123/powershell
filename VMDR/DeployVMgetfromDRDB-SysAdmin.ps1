# CONSECO - Windows Server Administration - DR
# * SysAdmin Interface*
[reflection.assembly]::LoadWithPartialName("'Microsoft.VisualBasic")

function Get-SQL ([string]$Query,[string]$ConnString) {

if ($ConnString) {

	if($ConnString -match '"*"') {
		$ConnString = $ConnString.TrimStart('"')
		$ConnString = $ConnString.TrimEnd('"')
	}

} else {

	# Default Connection String
	$ConnString =
	"server=ServerName;database=DbName;trusted_connection=true;"

}

$Connection = New-Object System.Data.SQLClient.SQLConnection

$Connection.ConnectionString = $ConnString
$Connection.Open()

$Command = New-Object System.Data.SQLClient.SQLCommand
$Command.Connection = $Connection
$Command.CommandText = $Query

$Reader = $Command.ExecuteReader()
$Counter = $Reader.FieldCount
while ($Reader.Read()) {
	$SQLObject = @{}
	for ($i = 0; $i -lt $Counter; $i++) {
		$SQLObject.Add(
			$Reader.GetName($i),
			$Reader.GetValue($i));
	}
	$SQLObject
}

$Connection.Close()

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
	Write-Host " ** Disaster Recovery Script - System Administrator's Interface ** "  -foregroundcolor "Green"
	Write-Host " ===> $Title <===" -foregroundcolor "Yellow"
	Write-Host ""
}
function fnStatWrap() {
	do {
	fnPrintHeader "Change Disaster Recovery Status for a Specified VM"
	Write-Host ""
	Write-Host "Enter the name of the VM for which to modify Disaster Recovery Status" -foregroundcolor "White"
	Write-Host ""
	$strResponse = Read-Host "Enter VM Name”
	$dsVM = fnGetDataSet "Select * FROM NT_DRSERVERINFO WHERE Server = '$strResponse'"
	If($dsVM.Tables[0].Rows.Count -gt 0)
	{
		$dsVMrow = $dsVM.Tables[0].Rows[0]
		Write-Host "VM Name:"$dsVMrow.Server
		Write-Host "VM ID  :"$dsVMrow.RowID
	}
	$strResponse = “Z”
	$strResponse = Read-Host “VM Correctly Identified? [Y/N/Q]”
	}
	until (($strResponse -eq “Y”) -or ($strResponse -eq “Q”))
	If($strResponse -eq "Y") {
		fnModifyDRStatus $dsVMrow.RowID
	} 
}
function fnViewWrap() {
	do {
	fnPrintHeader "View Deployment Information for a Specified VM"
	Write-Host ""
	Write-Host "Enter the name of the VM for which you wish to view deployment information" -foregroundcolor "White"
	Write-Host ""
	$strResponse = Read-Host "Enter VM Name”
	$dsVM = fnGetDataSet "Select * FROM NT_DRSERVERINFO WHERE Server = '$strResponse'"
	If($dsVM.Tables[0].Rows.Count -gt 0)
	{
		$dsVMrow = $dsVM.Tables[0].Rows[0]
		Write-Host "VM Name:"$dsVMrow.Server
		Write-Host "VM ID  :"$dsVMrow.RowID
	}
	$strResponse = “Z”
	$strResponse = Read-Host “VM Correctly Identified? [Y/N/Q]”
	}
	until (($strResponse -eq “Y”) -or ($strResponse -eq “Q”))
	If($strResponse -eq "Y") {
		fnModifyVM $dsVMrow.RowID
	} 
}
function fnlistVMsWrap() {
	do {
	fnPrintHeader "List VMs in a Specified Disaster Recovery Status"
	Write-Host ""
	Write-Host "Enter the CODE of the Disaster Recovery Status" -foregroundcolor "White"
	Write-Host ""
	$strResponse = Read-Host "DRStatus"
	$dsVM = fnGetDataSet "Select * FROM NT_DRSERVERINFO_DRSTATUSXREF WHERE DRStatus = '$strResponse'"
	If($dsVM.Tables[0].Rows.Count -gt 0)
	{
		$dsVMrow = $dsVM.Tables[0].Rows[0]
		Write-Host "DR Status Code:"$dsVMrow.DRStatus
		Write-Host "DR Status Description:"$dsVMrow.DRStatusDescript
	}
	$strResponse = “Z”
	$strResponse = Read-Host “Status Correctly Identified? [Y/N/Q]”
	}
	until (($strResponse -eq “Y”) -or ($strResponse -eq “Q”))
	If($strResponse -eq "Y") {
		fnListVMs $dsVMrow.DRStatus
	} 
}
function fnModifyDRStatus([int]$RowID) {

	$dsDS = fnGetDataSet "Select * FROM NT_DRSERVERINFO_DRSTATUSXREF ORDER BY RowID"
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
	Write-Host " ** Using Option Codes >90 May Result In Errors!" -foregroundcolor "Magenta"
	Write-Host $DRStatusOptions -foregroundcolor "White"
	Write-Host "P. Return to Previous List"  -foregroundcolor "White"
	Write-Host "Q. Return to the Main Menu"  -foregroundcolor "White"
	$strResponse = “0”
	do {$strResponse = Read-Host “Select an option: [#/P/Q]”}
	until (($strResponse -eq “Q”) -or ($strResponse -eq "P") -or ([Microsoft.VisualBasic.Information]::isnumeric($strResponse)))
		
	If($strResponse -ne "Q" -and $strResponse -ne "P")
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
		$strResponse = “0”
		do {$strResponse = Read-Host “Return to [P]revious Menu or [Q]uit: [P/Q]”}
		until (($strResponse -eq “Q”) -or ($strResponse -eq "P") )		
	}
	
	If($strResponse -eq "P")
	{
		fnListVMs $VMDRStatusCurrent
	}
}	
function fnModifyVM([int]$RowID) {
	fnPrintHeader  "VM Deployement Details"
	$dsVM = fnGetDataSet "Select * FROM NT_DRSERVERINFO WHERE RowId= '$RowID'"
	$Row = $dsVM.Tables[0].Rows[0]
	
	$R2 = If($Row[7] -eq "TRUE"){"R2"}
	$WarningMIP = If($Row[4] -eq "TRUE") {$TRUE} Else {$FALSE}
	Write-Host ""
#	Write-Host "*******************************************************************************" -foregroundcolor "White"
	Write-Host "VM: "$Row[1] -foregroundcolor "Blue"
	Write-Host "IP Configuation: " -foregroundcolor "White"
	Write-Host " -- Front Office: "$Row[2] 
	Write-Host " -- Back Office:  "$Row[5]
	If($WarningMIP) {Write-Host " ** WARNING: Multiple Front Office IPs detected." -foregroundcolor "Red" }
	Write-Host "OS Version: " -foregroundcolor "White"
	Write-Host " --"$Row[6].Replace("Microsoft(R) ","") $R2 $Row[9]
	Write-Host " -- Serivce Pack"$Row[8]
	Write-Host " -- Windows Install Directory:" $Row[10]
	Write-Host "Hardware:" -foregroundcolor "White"
	Write-Host " -- RAM: " $Row[11]"GB - "$Row[12]"MB"
	Write-Host " -- vCPUs:"$Row[13]
	
	$diskA = If($Row[14] -ne "-1"){"{0:D5}" -f [int]$Row[14]}else{"CDROM"}
	$diskB = If($Row[15] -ne "-1"){"{0:D5}" -f [int]$Row[15]}else{"CDROM"}
	$diskC = If($Row[16] -ne "-1"){"{0:D5}" -f [int]$Row[16]}else{"CDROM"}
	$diskD = If($Row[17] -ne "-1"){"{0:D5}" -f [int]$Row[17]}else{"CDROM"}
	$diskE = If($Row[18] -ne "-1"){"{0:D5}" -f [int]$Row[18]}else{"CDROM"}
	$diskF = If($Row[19] -ne "-1"){"{0:D5}" -f [int]$Row[19]}else{"CDROM"}
	$diskG = If($Row[20] -ne "-1"){"{0:D5}" -f [int]$Row[20]}else{"CDROM"}
	$diskH = If($Row[21] -ne "-1"){"{0:D5}" -f [int]$Row[21]}else{"CDROM"}
	$diskI = If($Row[22] -ne "-1"){"{0:D5}" -f [int]$Row[22]}else{"CDROM"}
	$diskJ = If($Row[23] -ne "-1"){"{0:D5}" -f [int]$Row[23]}else{"CDROM"}
	$diskK = If($Row[24] -ne "-1"){"{0:D5}" -f [int]$Row[24]}else{"CDROM"}
	$diskL = If($Row[25] -ne "-1"){"{0:D5}" -f [int]$Row[25]}else{"CDROM"}
	$diskM = If($Row[26] -ne "-1"){"{0:D5}" -f [int]$Row[26]}else{"CDROM"}
	$diskN = If($Row[27] -ne "-1"){"{0:D5}" -f [int]$Row[27]}else{"CDROM"}
	$diskO = If($Row[28] -ne "-1"){"{0:D5}" -f [int]$Row[28]}else{"CDROM"}
	$diskP = If($Row[29] -ne "-1"){"{0:D5}" -f [int]$Row[29]}else{"CDROM"}
	$diskQ = If($Row[30] -ne "-1"){"{0:D5}" -f [int]$Row[30]}else{"CDROM"}
	$diskR = If($Row[31] -ne "-1"){"{0:D5}" -f [int]$Row[31]}else{"CDROM"}
	$diskS = If($Row[32] -ne "-1"){"{0:D5}" -f [int]$Row[32]}else{"CDROM"}
	$diskT = If($Row[33] -ne "-1"){"{0:D5}" -f [int]$Row[33]}else{"CDROM"}
	$diskU = If($Row[34] -ne "-1"){"{0:D5}" -f [int]$Row[34]}else{"CDROM"}
	$diskV = If($Row[35] -ne "-1"){"{0:D5}" -f [int]$Row[35]}else{"CDROM"}
	$diskW = If($Row[36] -ne "-1"){"{0:D5}" -f [int]$Row[36]}else{"CDROM"}
	$diskX = If($Row[37] -ne "-1"){"{0:D5}" -f [int]$Row[37]}else{"CDROM"}
	$diskY = If($Row[38] -ne "-1"){"{0:D5}" -f [int]$Row[38]}else{"CDROM"}
	$diskZ = If($Row[39] -ne "-1"){"{0:D5}" -f [int]$Row[39]}else{"CDROM"}
	
	$DiskRow0 = [int]$Row[16]+[int]$Row[17]
	$DiskRow1 = [int]$Row[14]+[int]$Row[15]+[int]$Row[16]+[int]$Row[17]+[int]$Row[18]+[int]$Row[19]
	$DiskRow2 = [int]$Row[20]+[int]$Row[21]+[int]$Row[22]+[int]$Row[23]+[int]$Row[24]+[int]$Row[25]
	$DiskRow3 = [int]$Row[26]+[int]$Row[27]+[int]$Row[28]+[int]$Row[29]+[int]$Row[30]+[int]$Row[31]
	$DiskRow4 = [int]$Row[32]+[int]$Row[33]+[int]$Row[34]+[int]$Row[35]+[int]$Row[36]+[int]$Row[37]
	$DiskRow5 = [int]$Row[38]+[int]$Row[39]
	
	$DiskRows = $DiskRow1 + $DiskRow2 + $DiskRow3 + $DiskRow4 + $DiskRow5 - $DiskRow0
	$WarningDISK = If($DiskRows -gt 0) {$TRUE} Else {$FALSE}
	
	Write-Host "Disks:"-foregroundcolor "White"
	If($DiskRow1 -ne 0){Write-Host " -- A: "$diskA" -- B: "$diskB" -- C: "$diskC" -- D: "$diskD" -- E: "$diskE" -- F: "$diskF}
	If($DiskRow2 -ne 0){Write-Host " -- G: "$diskG" -- H: "$diskH" -- I: "$diskI" -- J: "$diskJ" -- K: "$diskK" -- L: "$diskL}
	If($DiskRow3 -ne 0){Write-Host " -- M: "$diskM" -- N: "$diskN" -- O: "$diskO" -- P: "$diskP" -- Q: "$diskQ" -- R: "$diskR}
	If($DiskRow4 -ne 0){Write-Host " -- S: "$diskS" -- T: "$diskT" -- U: "$diskU" -- V: "$diskV" -- W: "$diskW" -- X: "$diskX}
	If($DiskRow5 -ne 0){Write-Host " -- Y: "$diskY" -- Z: "$diskZ}
	If($WarningDISK) {Write-Host " ** WARNING: Disk Configuration IS NOT Standard" -foregroundcolor "Red" }
	Write-Host $Row[40]
	Write-Host "DR Information:"-foregroundcolor "White"
	Write-Host " -- Virtual Center Clone Task ID: "$Row[41]
	Write-Host " -- Recovery Priority: "$Row[43]
	Write-Host " -- DR Recovery Status: "$Row[42]
	Write-Host "*******************************************************************************" -foregroundcolor "White"
	$strResponse = “Z”
	do {$strResponse = Read-Host “Modify DR Recovery Status? [Y/N]”}
	until (($strResponse -eq “Y”) -or ($strResponse -eq “N”))
	If($strResponse -eq "Y") {
		fnModifyDRStatus $RowID
	} 
	else {
		$strResponse = “Z”
		do {$strResponse = Read-Host “Return to Previous List? [Y/N]”}
		until (($strResponse -eq “Y”) -or ($strResponse -eq “N”))
		If($strResponse -eq "Y") { fnListVMs $Row[42]}
	}
}
function fnListVMs([string]$DRStatus) {
fnPrintHeader "View VM in a Specific Status [$DRStatus]"
$dsVMs = fnGetDataSet "Select RowId, Server FROM NT_DRSERVERINFO WHERE DRStatus = '$DRStatus'"
Write-Host "The Following VMs are in Disaster Recovery Status "$DRStatus":" -foregroundcolor "White"
	ForEach($Row In $dsVMs.Tables[0].Rows)
	{
		$RC= [String]$Row[0]+". "+$Row[1]
		Write-Host $RC
	}
	
Write-Host ""
Write-Host "SysAdmin Interface" -foregroundcolor "White"
Write-Host "#. To Modify a VM, Enter the VM's Row ID"  -foregroundcolor "White"
Write-Host "Q. Return to the Main Menu"  -foregroundcolor "White"
Write-Host ""
$strResponse = “0”
do {$strResponse = Read-Host “Select an option: [#/Q]”}
until (($strResponse -eq “Q”) -or ([Microsoft.VisualBasic.Information]::isnumeric($strResponse)))

If($strResponse -ne "Q") { fnModifyVM $strResponse }
}

do {
fnPrintHeader "Main Menu"
Write-Host "SysAdmin Interface" -foregroundcolor "White"
Write-Host "1. List VMs Ready for Setup             (RDYSET)"  -foregroundcolor "White"
Write-Host "2. List VMs Ready for NetBackup Restore (RDYNBU)"  -foregroundcolor "White"
Write-Host "3. List VMs Restored by NetBackup       (NBUCMP)"  -foregroundcolor "White"
Write-Host "4. List VMs Requiring Manual Build      (MANUAL)"  -foregroundcolor "White"
Write-Host "5. List VMs with Errors                 (ERROR )"  -foregroundcolor "White"
Write-Host "6. List Recovered VMs                   (RECVRD)"  -foregroundcolor "White"
Write-Host "L. List VMs for Specified Status                "  -foregroundcolor "White"
Write-Host "S. Change Status for a Specified VM"  -foregroundcolor "White"
Write-Host "V. View Deployment Info for a Specified VM"  -foregroundcolor "White"
Write-Host "Q. Exit SysAdmin Interface" -foregroundcolor "White"
Write-Host ""
Write-Host ""
Write-Host "** For Best Use - Maximize This Window **" -foregroundcolor "Magenta"
Write-Host ""
$strResponse = “0”
do {$strResponse = Read-Host “Select an option: [1,2,3,4,5,6,L,S,V,Q]”}
until (($strResponse -eq “1”) -or ($strResponse -eq “2”) -or ($strResponse -eq “3”) -or ($strResponse -eq “4”) -or ($strResponse -eq “5”) -or ($strResponse -eq “6”) -or ($strResponse -eq “L”) -or  ($strResponse -eq “S”) -or ($strResponse -eq “V”) -or ($strResponse -eq “Q”))

If($strResponse -eq "1") { fnlistVMs 'RDYSET' }
If($strResponse -eq "2") { fnlistVMs 'RDYNBU' }
If($strResponse -eq "3") { fnlistVMs 'NBUCMP' }
If($strResponse -eq "4") { fnlistVMs 'MANUAL' }
If($strResponse -eq "5") { fnlistVMs 'ERROR' }
If($strResponse -eq "6") { fnlistVMs 'RECVRD' }
If($strResponse -eq "L") { fnlistVMsWrap }
If($strResponse -eq "S") { fnStatWrap }
If($strResponse -eq "V") { fnViewWrap }
}until ($strResponse -eq "Q")
#
