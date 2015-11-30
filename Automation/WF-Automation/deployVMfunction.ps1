# CONSECO - Windows Server Administration 
# * VM Deployment Primary Functions Files *
# ** Last Modified: 2009/09/08 @ 22:51 by LANJ6P (Pawlak, Jakub P)

#region Script Settings
#<ScriptSettings xmlns="http://tempuri.org/ScriptSettings.xsd">
#  <ScriptPackager>
#    <process>powershell.exe</process>
#    <arguments />
#    <extractdir>%TEMP%</extractdir>
#    <files />
#    <usedefaulticon>true</usedefaulticon>
#    <showinsystray>false</showinsystray>
#    <altcreds>false</altcreds>
#    <efs>true</efs>
#    <ntfs>true</ntfs>
#    <local>false</local>
#    <abortonfail>true</abortonfail>
#    <product />
#    <version>1.0.0.1</version>
#    <versionstring />
#    <comments />
#    <includeinterpreter>false</includeinterpreter>
#    <forcecomregistration>false</forcecomregistration>
#    <consolemode>false</consolemode>
#    <EnableChangelog>false</EnableChangelog>
#    <AutoBackup>false</AutoBackup>
#    <snapinforce>false</snapinforce>
#    <snapinshowprogress>false</snapinshowprogress>
#    <snapinautoadd>0</snapinautoadd>
#    <snapinpermanentpath />
#  </ScriptPackager>
#</ScriptSettings>
#endregion

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
function fnGetDataSetVCENTER([string]$SQL){
	$SqlServer = "VCENTER.CONSECO.AD";
	$SqlDatabase = "VCENTER";
	$SqlSecurity = "User Id=VCAdmin; Password=vcadm6ev;"
	
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
function fnGetDataSetMDB([string]$SQL){
	$SqlServer = "S5PRD1.CONSECO.AD";
	$SqlDatabase = "MDB";
	
	# Get the T-SQL 
	$SqlQuery = $SQL
	
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
	
	
	#Execute and Get Row Count
	
	$DataSet = New-Object System.Data.DataSet
	$nRecs = $SqlAdapter.Fill($DataSet)
	Return $DataSet
}
function fnGetDataSetNTDR([string]$SQL){
	$SqlServer = "VCENTER.CONSECO.AD";
	$SqlDatabase = "NTDR";
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
function fnSetSQLVCENTER([string]$Query){
return Set-SQL $Query "Server = VCENTER.CONSECO.AD; Database = VCENTER; User Id=VCAdmin; Password=vcadm6ev;"
}
function fnSetSqlNTDR([string]$Query){
return Set-SQL $Query "Server = VCENTER.CONSECO.AD; Database = NTDR; User Id=VCAdmin; Password=vcadm6ev;"
}
function fnEVcreate{
	New-EventLog -LogName CNO_Automate -Source ('MDB_Wrapper','Deploy_VM','Check_vcTask')
}
function fnPrintHeader([string]$Title,[string]$SubTitle){
	
#	Write-Host  "..######...#######..##....##..######..########..######...#######......" -foregroundcolor "DarkGreen"
#	Write-Host  ".##....##.##.....##.###...##.##....##.##.......##....##.##.....##..D.."	-foregroundcolor "DarkGreen"
#	Write-Host  ".##.......##.....##.####..##.##.......##.......##.......##.....##..R.." -foregroundcolor "DarkGreen"
#	Write-Host  ".##.......##.....##.##.##.##..######..######...##.......##.....##..S.." -foregroundcolor "DarkGreen"
#	Write-Host  ".##.......##.....##.##..####.......##.##.......##.......##.....##..M.." -foregroundcolor "DarkGreen"
#	Write-Host  ".##....##.##.....##.##...###.##....##.##.......##....##.##.....##..S.." -foregroundcolor "DarkGreen"
#	Write-Host  "..######...#######..##....##..######..########..######...#######......" -foregroundcolor "DarkGreen"
	
	$CS = Gwmi Win32_ComputerSystem -Comp "."
	$UserID = [system.security.principal.windowsidentity]::getcurrent().Name
	Clear-Host
	Write-Host  ""
	Write-Host " ** The Conseco Companies -- Logged in as $UserID **"  -foregroundcolor "Green"
	Write-Host ""
	Write-Host  "..######..##....##..#######.....########..########..##.....##..######." -foregroundcolor "DarkGreen"
	Write-Host  ".##....##.###...##.##.....##....##.....##.##.....##.###...###.##....##" -foregroundcolor "DarkGreen"
	Write-Host  ".##.......####..##.##.....##....##.....##.##.....##.####.####.##......" -foregroundcolor "DarkGreen"
	Write-Host  ".##.......##.##.##.##.....##....##.....##.########..##.###.##..######." -foregroundcolor "DarkGreen"
	Write-Host  ".##.......##..####.##.....##....##.....##.##...##...##.....##.......##" -foregroundcolor "DarkGreen"
	Write-Host  ".##....##.##...###.##.....##....##.....##.##....##..##.....##.##....##" -foregroundcolor "DarkGreen"
	Write-Host  "..######..##....##..#######.....########..##.....##.##.....##..######." -foregroundcolor "DarkGreen"
	Write-Host ""
	Write-Host " ** Disaster Recovery Management System - $SubTitle ** "  -foregroundcolor "Green"
	Write-Host " ===> $Title <===" -foregroundcolor "Yellow"
	Write-Host ""
}
function fnModifyDRStatus([int]$RowID,[string]$usertype) {

	If($usertype -eq "SysAdmin"){
		$dsDS = fnGetDataSetNTDR "Select * FROM NT_DRSERVERINFO_DRSTATUSXREF ORDER BY RowID"
	}else{
		$dsDS = fnGetDataSetNTDR "Select * FROM NT_DRSERVERINFO_DRSTATUSXREF WHERE DRSTATUS LIKE '%NBU%' ORDER BY RowID"
	}
	$dsVM = fnGetDataSetNTDR "Select * FROM NT_DRSERVERINFO WHERE RowId= '$RowID'"
	$VMcol = $dsVM.Tables[0].Rows[0]
	$DRStatusDescript = ""
	$DRStatusOptions = ""
	$VMDRStatusCurrent = $VMcol['DRStatus']
	ForEach($Row In $dsDS.Tables[0].Rows)
	{
		$RC= [String]$Row[0]+". "+"["+$Row[1]+"] "+$Row[2]+"`n"
		$DRStatusOptions = $DRStatusOptions + $RC
		If($Row[1] -eq $VMcol['DRStatus']){$DRStatusDescript = $Row[2]}
	}

	
	fnPrintHeader "Modify System DR Recovery Status" $usertype
	Write-Host ""
	Write-Host "*******************************************************************************" -foregroundcolor "White"
	Write-Host "System: "$VMcol[1] -foregroundcolor "Blue"
	Write-Host "Current DR Recovery Status: "
	Write-Host " -- Code: ["$VMDRStatusCurrent" ]"
	Write-Host " -- Description: "$DRStatusDescript
	Write-Host "*******************************************************************************" -foregroundcolor "White"
	Write-Host ""
	Write-Host "Available DR Status Options:" -foregroundcolor "White"
	If($usertype -eq "SysAdmin"){ Write-Host " ** Using Option Codes >90 May Result In Errors!" -foregroundcolor "Magenta"}
	Write-Host $DRStatusOptions -foregroundcolor "White"
	If($usertype -eq "SysAdmin"){ Write-Host "P. Return to Previous List"  -foregroundcolor "White"}
	If($usertype -eq "SysAdmin"){ Write-Host "X. To Change Restore Priority"  -foregroundcolor "White"}
	Write-Host "Q. Return to the Main Menu"  -foregroundcolor "White"
	$strResponse = “0”
	do {If($usertype -eq "SysAdmin"){$strResponse = Read-Host “Select an option: [#/P/X/Q]”} else {$strResponse = Read-Host “Select an option: [#/Q]”}}
	until (($strResponse -eq “Q”) -or ($strResponse -eq "P") -or ($strResponse -eq "X") -or ([Microsoft.VisualBasic.Information]::isnumeric($strResponse)))
		
	If($strResponse -ne "Q" -and $strResponse -ne "P" -and $strResponse -ne "X")
	{
		$SQLReturn = fnSetSqlNTDR "UPDATE dbo.NT_DRSERVERINFO SET DRStatus = DRSX.DRStatus FROM dbo.NT_DRSERVERINFO DRSI, NT_DRSERVERINFO_DRSTATUSXREF DRSX WHERE DRSI.RowID =  '$RowID' AND DRSX.RowID = '$strResponse'" 

		$dsVM = fnGetDataSetNTDR "Select * FROM NT_DRSERVERINFO WHERE RowId= '$RowID'"
		$VMcol = $dsVM.Tables[0].Rows[0]
		$DRStatusDescript = ""
		$DRStatusOptions = ""
		ForEach($Row In $dsDS.Tables[0].Rows)
		{
			$RC= [String]$Row[0]+". "+"["+$Row[1]+"] "+$Row[2]+"`n"
			$DRStatusOptions = $DRStatusOptions + $RC
			If($Row[1] -eq $VMcol['DRStatus']){$DRStatusDescript = $Row[2]}
		}

		
		fnPrintHeader "Modify System DR Recovery Status" $usertype
		Write-Host ""
		Write-Host "*******************************************************************************" -foregroundcolor "White"
		Write-Host "System: "$VMcol[1] -foregroundcolor "Blue"
		Write-Host "Current DR Recovery Status: "
		Write-Host " -- Code: ["$VMcol['DRStatus']"]"
		Write-Host " -- Description: "$DRStatusDescript
		Write-Host "*******************************************************************************" -foregroundcolor "White"
		Write-Host ""

		
		If($SQLReturn -gt 0)
		{
			Write-Host "System DR Recovery Status Updated Sucessfully." -foregroundcolor "Green"
		}
		else
		{
			Write-Host "System DR Recovery Status Failed to Update." -foregroundcolor "Red"
		}
		$strResponse = "0"
		
		If($usertype -eq "SysAdmin")
		{
			do {$strResponse = Read-Host "Return to [P]revious Menu or [Q]uit: [P/Q]"}
			until (($strResponse -eq “Q”) -or ($strResponse -eq "P") )		
		}
		else
		{
		Read-Host "Press Any Key To Continue"
		}
		fnCheckIn $RowID
	}
	
	If($strResponse -eq "P" -and $usertype -eq "SysAdmin")
	{
		fnCheckIn $RowID
		fnListVMs $VMDRStatusCurrent
	}
	
	If($strResponse -eq "X" -and $usertype -eq "SysAdmin")
	{
		fnModifyPriority $RowID
	}
}	
function fnStatWrap() {
	do {
	fnPrintHeader "Change Disaster Recovery Status for a Specified System" "SysAdmin"
	Write-Host ""
	Write-Host "Enter the name of the System for which to modify Disaster Recovery Status" -foregroundcolor "White"
	Write-Host ""
	$strResponse = Read-Host "Enter System Name”
	$dsVM = fnGetDataSetNTDR "Select * FROM NT_DRSERVERINFO WHERE Server = '$strResponse'"
	If($dsVM.Tables[0].Rows.Count -gt 0)
	{
		$dsVMrow = $dsVM.Tables[0].Rows[0]
		Write-Host "System Name:"$dsVMrow.Server
		Write-Host "System ID  :"$dsVMrow.RowID
	}
	$strResponse = “Z”
	$strResponse = Read-Host “System Correctly Identified? [Y/N/Q]”
	}
	until (($strResponse -eq “Y”) -or ($strResponse -eq “Q”))
	If($strResponse -eq "Y") {
		fnModifyDRStatus $dsVMrow.RowID "SysAdmin"
	} 
}
function fnViewWrap() {
	do {
	fnPrintHeader "View System Information for a Specified System" "SysAdmin"
	Write-Host ""
	Write-Host "Enter the name of the System for which you wish to view information" -foregroundcolor "White"
	Write-Host ""
	$strResponse = Read-Host "Enter System Name”
	$dsVM = fnGetDataSetNTDR "Select * FROM NT_DRSERVERINFO WHERE Server = '$strResponse'"
	If($dsVM.Tables[0].Rows.Count -gt 0)
	{
		$dsVMrow = $dsVM.Tables[0].Rows[0]
		Write-Host "System Name :"$dsVMrow.Server
		Write-Host "System ID   :"$dsVMrow.RowID
		Write-Host "System Type :"$dsVMrow.SystemType
	}
	$strResponse = “Z”
	$strResponse = Read-Host “System Correctly Identified? [Y/N/Q]”
	}
	until (($strResponse -eq “Y”) -or ($strResponse -eq “Q”))
	If($strResponse -eq "Y") {
		fnModifySystem $dsVMrow.RowID
	} 
}
function fnlistVMsWrap() {
	do {
	fnPrintHeader "List Systems in a Specified Disaster Recovery Status" "SysAdmin"
	Write-Host ""
	Write-Host "Enter the CODE of the Disaster Recovery Status" -foregroundcolor "White"
	Write-Host ""
	$strResponse = Read-Host "DRStatus"
	$dsVM = fnGetDataSetNTDR "Select * FROM NT_DRSERVERINFO_DRSTATUSXREF WHERE DRStatus = '$strResponse'"
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
function fnModifyVM([int]$RowID) {
	fnPrintHeader  "Windows Server Details" "SysAdmin"
	$dsVM = fnGetDataSetNTDR "Select * FROM NT_DRSERVERINFO WHERE RowId= '$RowID'"
	$Row = $dsVM.Tables[0].Rows[0]
	
	If($Row[7] -eq "TRUE"){ $R2 = "R2"} Else { $R2 = "" }
	If($Row[4] -eq "TRUE"){ $WarningMIP = $TRUE} Else {$WarningMIP = $FALSE}
	Write-Host ""
	Write-Host "VM: "$Row[1] -foregroundcolor "Blue" -BackgroundColor "White"
	Write-Host ""
	Write-Host "IP Configuration: " -foregroundcolor "White"
	Write-Host " -- Front Office: "$Row[2] 
	Write-Host " -- Back Office:  "$Row[5]
	If($WarningMIP) {Write-Host " ** WARNING: Multiple Front Office IPs detected." -foregroundcolor "Red" }
	Write-Host ""
	Write-Host "OS Version: " -foregroundcolor "White"
	Write-Host " --"$Row[6].Replace("Microsoft(R) ","") $R2 $Row[9]
	Write-Host " -- Serivce Pack"$Row[8]
	Write-Host " -- Windows Install Directory:" $Row[10]
	Write-Host ""
	Write-Host "Hardware:" -foregroundcolor "White"
	Write-Host " -- RAM: " $Row[11]"GB - "$Row[12]"MB"
	Write-Host " -- vCPUs:"$Row[13]
	Write-Host " -- Model:"$Row[14]
	Write-Host ""
	If($Row[15] -ne "-1"){ $diskA = "{0:D5}" -f [int]$Row[15]}else{ $diskA = "CDROM"}
	If($Row[16] -ne "-1"){ $diskB = "{0:D5}" -f [int]$Row[16]}else{ $diskB = "CDROM"}
	If($Row[17] -ne "-1"){ $diskC = "{0:D5}" -f [int]$Row[17]}else{ $diskC = "CDROM"}
	If($Row[18] -ne "-1"){ $diskD = "{0:D5}" -f [int]$Row[18]}else{ $diskD = "CDROM"}
	If($Row[19] -ne "-1"){ $diskE = "{0:D5}" -f [int]$Row[19]}else{ $diskE = "CDROM"}
	If($Row[20] -ne "-1"){ $diskF = "{0:D5}" -f [int]$Row[20]}else{ $diskF = "CDROM"}
	If($Row[21] -ne "-1"){ $diskG = "{0:D5}" -f [int]$Row[21]}else{ $diskG = "CDROM"}
	If($Row[22] -ne "-1"){ $diskH = "{0:D5}" -f [int]$Row[22]}else{ $diskH = "CDROM"}
	If($Row[23] -ne "-1"){ $diskI = "{0:D5}" -f [int]$Row[23]}else{ $diskI = "CDROM"}
	If($Row[24] -ne "-1"){ $diskJ = "{0:D5}" -f [int]$Row[24]}else{ $diskJ = "CDROM"}
	If($Row[25] -ne "-1"){ $diskK = "{0:D5}" -f [int]$Row[25]}else{ $diskK = "CDROM"}
	If($Row[26] -ne "-1"){ $diskL = "{0:D5}" -f [int]$Row[26]}else{ $diskL = "CDROM"}
	If($Row[27] -ne "-1"){ $diskM = "{0:D5}" -f [int]$Row[27]}else{ $diskM = "CDROM"}
	If($Row[28] -ne "-1"){ $diskN = "{0:D5}" -f [int]$Row[28]}else{ $diskN = "CDROM"}
	If($Row[29] -ne "-1"){ $diskO = "{0:D5}" -f [int]$Row[29]}else{ $diskO = "CDROM"}
	If($Row[30] -ne "-1"){ $diskP = "{0:D5}" -f [int]$Row[30]}else{ $diskP = "CDROM"}
	If($Row[31] -ne "-1"){ $diskQ = "{0:D5}" -f [int]$Row[31]}else{ $diskQ = "CDROM"}
	If($Row[32] -ne "-1"){ $diskR = "{0:D5}" -f [int]$Row[32]}else{ $diskR = "CDROM"}
	If($Row[33] -ne "-1"){ $diskS = "{0:D5}" -f [int]$Row[33]}else{ $diskS = "CDROM"}
	If($Row[34] -ne "-1"){ $diskT = "{0:D5}" -f [int]$Row[34]}else{ $diskT = "CDROM"}
	If($Row[35] -ne "-1"){ $diskU = "{0:D5}" -f [int]$Row[35]}else{ $diskU = "CDROM"}
	If($Row[36] -ne "-1"){ $diskV = "{0:D5}" -f [int]$Row[36]}else{ $diskV = "CDROM"}
	If($Row[37] -ne "-1"){ $diskW = "{0:D5}" -f [int]$Row[37]}else{ $diskW = "CDROM"}
	If($Row[38] -ne "-1"){ $diskX = "{0:D5}" -f [int]$Row[38]}else{ $diskX = "CDROM"}
	If($Row[39] -ne "-1"){ $diskY = "{0:D5}" -f [int]$Row[39]}else{ $diskY = "CDROM"}
	If($Row[40] -ne "-1"){ $diskZ = "{0:D5}" -f [int]$Row[40]}else{ $diskZ = "CDROM"}
	
	
	
		
	$DiskRow0 = ([int]$Row[17]+[int]$Row[18])
	$DiskRow1 = ([int]$Row[15]+[int]$Row[16]+[int]$Row[17]+[int]$Row[18]+[int]$Row[19]+[int]$Row[20])
	$DiskRow2 = ([int]$Row[21]+[int]$Row[22]+[int]$Row[23]+[int]$Row[24]+[int]$Row[25]+[int]$Row[26])
	$DiskRow3 = ([int]$Row[27]+[int]$Row[28]+[int]$Row[29]+[int]$Row[30]+[int]$Row[31]+[int]$Row[32])
	$DiskRow4 = ([int]$Row[33]+[int]$Row[34]+[int]$Row[35]+[int]$Row[36]+[int]$Row[37]+[int]$Row[38])
	$DiskRow5 = ([int]$Row[39]+[int]$Row[40])
	
	$DiskRows = [int]$DiskRow1+[int]$DiskRow2+[int]$DiskRow3+[int]$DiskRow4+[int]$DiskRow5-[int]$DiskRow0
	If($DiskRows -gt 0){$WarningDISK = $TRUE} Else { $WarningDISK  = $FALSE}
	
	Write-Host "Disks:"-foregroundcolor "White"
	If($DiskRow1 -ne 0){Write-Host " -- A: "$diskA" -- B: "$diskB" -- C: "$diskC" -- D: "$diskD" -- E: "$diskE" -- F: "$diskF}
	If($DiskRow2 -ne 0){Write-Host " -- G: "$diskG" -- H: "$diskH" -- I: "$diskI" -- J: "$diskJ" -- K: "$diskK" -- L: "$diskL}
	If($DiskRow3 -ne 0){Write-Host " -- M: "$diskM" -- N: "$diskN" -- O: "$diskO" -- P: "$diskP" -- Q: "$diskQ" -- R: "$diskR}
	If($DiskRow4 -ne 0){Write-Host " -- S: "$diskS" -- T: "$diskT" -- U: "$diskU" -- V: "$diskV" -- W: "$diskW" -- X: "$diskX}
	If($DiskRow5 -ne 0){Write-Host " -- Y: "$diskY" -- Z: "$diskZ}
	If($WarningDISK) {Write-Host " ** WARNING: Disk Configuration IS NOT Standard" -foregroundcolor "Red" }
	Write-Host $Row[41]
	Write-Host ""
	Write-Host "vCenter:"-foregroundcolor "White"
	Write-Host " -- Virtual Center Clone Task ID: "$Row['DRTaskId']
	If($Row['DRStatus'] -eq 'CLORUN') {Write-Host " -- DR Clone Progress: "$Row['DRClonePercent']"%"}

	fnModifyAll $RowID $Row
}
function fnModifyAll([int]$RowID, $Row){
	Write-Host ""
	Write-Host "DR Information:"-foregroundcolor "White"
	Write-Host " -- Recovery Priority: "$Row['DRPriority']
	Write-Host " -- DR Recovery Status: "$Row['DRStatus']
	If($Row['DRStatus'] -eq 'ERRCFG') {Write-Host ""}
	If($Row['DRStatus'] -eq 'ERRCFG') {Write-Host "DR Error Results: " -foregroundcolor "White"}
	If($Row['DRStatus'] -eq 'ERRCFG') {Write-Host $Row['DRError']}
	Write-Host "*******************************************************************************" -foregroundcolor "White"
	$strResponse = “Z”
	do {$strResponse = Read-Host “Modify DR Recovery Status? [Y/N]”}
	until (($strResponse -eq “Y”) -or ($strResponse -eq “N”))
	If($strResponse -eq "Y") {
		fnModifyDRStatus $RowID "SysAdmin"
	} 
	else {
		$strResponse = “Z”
		do {$strResponse = Read-Host “Return to Previous List? [Y/N]”}
		until (($strResponse -eq “Y”) -or ($strResponse -eq “N”))
		If($strResponse -eq "Y") 
		{ 
			fnCheckIn $RowID
			fnListVMs $Row['DRStatus']
		}
	}
	fnCheckIn $RowID
}
function fnModifyAP([int]$RowID) {
	fnPrintHeader  "Application Details" "SysAdmin"
	$dsVM = fnGetDataSetNTDR "Select * FROM NT_DRSERVERINFO WHERE RowId= '$RowID'"
	$Row = $dsVM.Tables[0].Rows[0]
	
	Write-Host ""
	Write-Host "Application Name: "$Row[1] -foregroundcolor "Blue"

	fnModifyAll $RowID $Row
}
function fnModifyLX([int]$RowID) {
	fnPrintHeader  "Linux Server Details" "SysAdmin"
	$dsVM = fnGetDataSetNTDR "Select * FROM NT_DRSERVERINFO WHERE RowId= '$RowID'"
	$Row = $dsVM.Tables[0].Rows[0]
	
	Write-Host ""
	Write-Host "Linux Server: "$Row[1] -foregroundcolor "Blue"
	Write-Host " -- Front Office IP Address: "$Row[2] 
	Write-Host " -- Back Office IP Address:  "$Row[5]
	Write-Host ""
	Write-Host "DR Information:"-foregroundcolor "White"
	Write-Host " -- Recovery Priority: "$Row['DRPriority']
	Write-Host " -- DR Recovery Status: "$Row['DRStatus']
	If($Row['DRStatus'] -eq 'CLORUN') {Write-Host " -- DR Clone Progress: "$Row['DRClonePercent']"%"}
	If($Row['DRStatus'] -eq 'ERRCFG') {Write-Host ""}
	If($Row['DRStatus'] -eq 'ERRCFG') {Write-Host "DR Error Results: " -foregroundcolor "White"}
	If($Row['DRStatus'] -eq 'ERRCFG') {Write-Host $Row['DRError']}
	
	Write-Host "*******************************************************************************" -foregroundcolor "White"
	$strResponse = “Z”
	do {$strResponse = Read-Host “Modify DR Recovery Status? [Y/N]”}
	until (($strResponse -eq “Y”) -or ($strResponse -eq “N”))
	If($strResponse -eq "Y") {
		fnModifyDRStatus $RowID "SysAdmin"
	} 
	else {
		$strResponse = “Z”
		do {$strResponse = Read-Host “Return to Previous List? [Y/N]”}
		until (($strResponse -eq “Y”) -or ($strResponse -eq “N”))
		If($strResponse -eq "Y") { fnListVMs $Row[43]}
	}
}
function fnModifyUX([int]$RowID) {
	fnPrintHeader  "Unix Server Details" "SysAdmin"
	$dsVM = fnGetDataSetNTDR "Select * FROM NT_DRSERVERINFO WHERE RowId= '$RowID'"
	$Row = $dsVM.Tables[0].Rows[0]
	

	Write-Host ""
	Write-Host "Unix Server: "$Row['Server'] -foregroundcolor "Blue" -BackgroundColor "White"
	Write-Host ""
	Write-Host "IP Configuration: " -foregroundcolor "White"
	Write-Host " -- Front Office IP Address: "$Row['FOIP'] 
	Write-Host " -- Back Office IP Address:  "$Row['BOIP']
	Write-Host " -- Other IPs:"
	Write-Host $Row['IPList']
	Write-Host ""
	Write-Host "OS Version: " -foregroundcolor "White"
	Write-Host " --"$Row['WinVer']
	Write-Host ""
	Write-Host "Hardware:" -foregroundcolor "White"
	Write-Host " -- RAM: " $Row['RAMgb']"GB" 
	Write-Host " -- Procesors:"$Row['NumOfProcs']
	Write-Host " -- HBA Type and Quantity: " $Row['DiskC'] 
	Write-Host " -- NIC Type and Quantity: " $Row['NICs'] 
	Write-Host " -- BCRS System Name:"$Row['Model']
	Write-Host ""
	Write-Host "Disks:"-foregroundcolor "White"
	Write-Host " -- Internal Disks: " $Row['DiskA'] 
	Write-Host " -- SAN Disks: " $Row['DiskB'] 
	Write-Host ""
	Write-Host "HMC:"-foregroundcolor "White"
	Write-Host $Row['Volumes'] 
	fnModifyAll $RowID $Row
}
function fnModifyFS([int]$RowID) {
	fnPrintHeader  "File Share Details" "SysAdmin"
	$dsVM = fnGetDataSetNTDR "Select * FROM NT_DRSERVERINFO WHERE RowId= '$RowID'"
	$Row = $dsVM.Tables[0].Rows[0]
	
	Write-Host ""
	Write-Host "File Share: "$Row[1] -foregroundcolor "Blue"
	Write-Host ""
	Write-Host "DR Information:"-foregroundcolor "White"
	Write-Host " -- Recovery Priority: "$Row['DRPriority']
	Write-Host " -- DR Recovery Status: "$Row['DRStatus']
	If($Row['DRStatus'] -eq 'CLORUN') {Write-Host " -- DR Clone Progress: "$Row['DRClonePercent']"%"}
	If($Row['DRStatus'] -eq 'ERRCFG') {Write-Host ""}
	If($Row['DRStatus'] -eq 'ERRCFG') {Write-Host "DR Error Results: " -foregroundcolor "White"}
	If($Row['DRStatus'] -eq 'ERRCFG') {Write-Host $Row['DRError']}
	
	Write-Host "*******************************************************************************" -foregroundcolor "White"
	$strResponse = “Z”
	do {$strResponse = Read-Host “Modify DR Recovery Status? [Y/N]”}
	until (($strResponse -eq “Y”) -or ($strResponse -eq “N”))
	If($strResponse -eq "Y") {
		fnModifyDRStatus $RowID "SysAdmin"
	} 
	else {
		$strResponse = “Z”
		do {$strResponse = Read-Host “Return to Previous List? [Y/N]”}
		until (($strResponse -eq “Y”) -or ($strResponse -eq “N”))
		If($strResponse -eq "Y") { fnListVMs $Row[43]}
	}
}
function fnModifyORA([int]$RowID) {
	fnPrintHeader  "Oracle Database Details" "SysAdmin"
	$dsVM = fnGetDataSetNTDR "Select * FROM NT_DRSERVERINFO WHERE RowId= '$RowID'"
	$Row = $dsVM.Tables[0].Rows[0]
	
	Write-Host ""
	Write-Host "Database Name: "$Row[1] -foregroundcolor "Blue"
	Write-Host " -- Assigned IP Address: "$Row[2] 
	Write-Host ""
	Write-Host "DR Information:"-foregroundcolor "White"
	Write-Host " -- Recovery Priority: "$Row['DRPriority']
	Write-Host " -- DR Recovery Status: "$Row['DRStatus']
	If($Row['DRStatus'] -eq 'CLORUN') {Write-Host " -- DR Clone Progress: "$Row['DRClonePercent']"%"}
	If($Row['DRStatus'] -eq 'ERRCFG') {Write-Host ""}
	If($Row['DRStatus'] -eq 'ERRCFG') {Write-Host "DR Error Results: " -foregroundcolor "White"}
	If($Row['DRStatus'] -eq 'ERRCFG') {Write-Host $Row['DRError']}
	
	Write-Host "*******************************************************************************" -foregroundcolor "White"
	$strResponse = “Z”
	do {$strResponse = Read-Host “Modify DR Recovery Status? [Y/N]”}
	until (($strResponse -eq “Y”) -or ($strResponse -eq “N”))
	If($strResponse -eq "Y") {
		fnModifyDRStatus $RowID "SysAdmin"
	} 
	else {
		$strResponse = “Z”
		do {$strResponse = Read-Host “Return to Previous List? [Y/N]”}
		until (($strResponse -eq “Y”) -or ($strResponse -eq “N”))
		If($strResponse -eq "Y") { fnListVMs $Row[43]}
	}
}
function fnUpdateCheckedOut([int]$RowID, [string]$UserID){
fnSetSqlNTDR "UPDATE dbo.NT_DRSERVERINFO SET DRCheckedOutUser= '$UserID' WHERE RowID = '$RowID'" 
}
function fnCheckIn([int]$RowID){
fnSetSqlNTDR "UPDATE dbo.NT_DRSERVERINFO SET DRCheckedOutUser='' WHERE RowID = '$RowID'" 
}
function fnCheckedOut(){

	$Override = ""
	$dsVM = fnGetDataSetNTDR "Select * FROM vw_SysType WHERE RowId= '$RowID'"
	$Row = $dsVM.Tables[0].Rows[0]
	$UserID = [system.security.principal.windowsidentity]::getcurrent().Name
	
	If(($Row['DRCheckedOutUser'] -ne $UserID) -and ($Row['DRCheckedOutUser'] -ne "") -and ($Row['DRCheckedOutUser'] -ne [DBNull]::Value))
	{
		fnPrintHeader  "System Checked Out" "SysAdmin"
		
		$SystemCO = $Row['Server']
		$UserIDCO = $Row['DRCheckedOutUser']
		
		Write-Host "*******************************************************************************" -foregroundcolor "Red"
		Write-Host ".........................................                         " -foregroundcolor "Red"
		Write-Host ".........................................                         " -foregroundcolor "Red"
		Write-Host "....................#.................... *** W A R N I N G ***   " -foregroundcolor "Red"
		Write-Host "...................###...................                         " -foregroundcolor "Red"
		Write-Host "..................#####.................. System $SystemCO" -foregroundcolor "Red"
		Write-Host ".................##...##................. is checked out to user  " -foregroundcolor "Red"
		Write-Host "................##.....##................ $UserIDCO " -foregroundcolor "Red"
		Write-Host "...............##.......##...............              " -foregroundcolor "Red"
		Write-Host "..............##..#####..##..............         " -foregroundcolor "Red"
		Write-Host ".............##...#####...##.............                                " -foregroundcolor "Red"
		Write-Host "............##....#####....##............ To override lock, hit 'O'      " -foregroundcolor "Red"
		Write-Host "...........##.....#####... .##........... To cancel and return to the    " -foregroundcolor "Red"
		Write-Host "..........##.......###.......##.......... main menu, hit 'M'             " -foregroundcolor "Red"
		Write-Host ".........##........###........## ........                                " -foregroundcolor "Red"
		Write-Host "........##..........#..........## .......                                " -foregroundcolor "Red"
		Write-Host ".......##.......................##.......                                " -foregroundcolor "Red"
		Write-Host "......##...........###...........##......                                " -foregroundcolor "Red"
		Write-Host ".....##...........#####...........##.....                                " -foregroundcolor "Red"
		Write-Host "....##............#####............##....                                " -foregroundcolor "Red"
		Write-Host "...##..............###..............##...                                " -foregroundcolor "Red"
		Write-Host "..##..............,.......,..........##..                                " -foregroundcolor "Red"
		Write-Host ".#######################################.                                " -foregroundcolor "Red"
		Write-Host ".........................................                                " -foregroundcolor "Red"
		Write-Host ".........................................                                " -foregroundcolor "Red"
		Write-Host "*******************************************************************************" -foregroundcolor "Red"
		Write-Host ""

		$Override = "No"
		
		do {$strResponse = Read-Host “[O]verride Checked Out or return to [M]ain Menu? [O/M]”}
		until (($strResponse -eq "O") -or ($strResponse -eq "M"))
		If($strResponse -eq "O") 
		{  
			$Override = "Yes"
			fnUpdateCheckedOut $RowID $UserID
		}
	}else{
		$Override = "NA"
		fnUpdateCheckedOut $RowID $UserID
	}
	
	return $Override
	
	

}
function fnModifySystem([int]$RowID) {
# fnModifySystem
# Pass-thu function that queries the database to determine system type being modified
# then routes the user to the correct modification interface function

	$dsVM = fnGetDataSetNTDR "Select * FROM vw_SysType WHERE RowId= '$RowID'"
	$Row = $dsVM.Tables[0].Rows[0]
	$UserID = [system.security.principal.windowsidentity]::getcurrent().Name
	

#	Write-Host "RowID: "$Row['RowID'] -foregroundcolor "Blue"
#	Write-Host "Modify Function: "$Row['SystemModifyFn'] -foregroundcolor "Blue"
#   $strResponse = Read-Host "Press Any Key to Continue"	
	$RunFN = $Row['SystemModifyFn'] + " " + $RowID
	
	$Override = fnCheckedOut
	
	If($Override -ne "No")
	{	
		invoke-expression $RunFN 
	}
}
function fnListVMs([string]$DRStatus) {
fnPrintHeader "View Systems in a Specific Status [$DRStatus]" "SysAdmin"
$dsVMs = fnGetDataSetNTDR "Select TOP 20 RowId, Server FROM NT_DRSERVERINFO WHERE DRStatus = '$DRStatus' ORDER BY [DRPriority]"
Write-Host "The Following Systems are in Disaster Recovery Status "$DRStatus":" -foregroundcolor "White"
	ForEach($Row In $dsVMs.Tables[0].Rows)
	{
		$VMID = "{0:D3}" -f [int]$Row[0]
		$RC= [String]$VMID+". "+$Row[1]
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

If($strResponse -ne "Q") { fnModifySystem $strResponse }
}
function fnListSystems([string]$DRStatus) {
fnPrintHeader "View Systems in a Specific Status [$DRStatus]" "SysAdmin"
$dsVMs = fnGetDataSetNTDR "Select TOP 20 RowId, Server, SystemType FROM NT_DRSERVERINFO WHERE DRStatus = '$DRStatus' ORDER BY [DRPriority]"
Write-Host "The Following Systems are in Disaster Recovery Status "$DRStatus":" -foregroundcolor "White"
	ForEach($Row In $dsVMs.Tables[0].Rows)
	{
		$VMID = "{0:D3}" -f [int]$Row[0]
		$RC= [String]$VMID+". "+$Row[1]+" ["+$Row['SystemType']+"]"
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

If($strResponse -ne "Q") { fnModifySystem $strResponse }
}
function fnVMNetwork([string]$vmIPaddress){
	if ($vmIPaddress.Substring(0,5) -eq "10.11"){
		$VLAN = $vmIPAddress.Substring(6, 3)
		$VLAN = $VLAN.Replace(".","")
	}elseif($vmIPaddress.Substring(0,6) -eq "10.11.2"){
		$VLAN = '25'+$vmIPAddress.Substring(6,1)
	}elseif($vmIPaddress.Substring(0,6) -eq "10.11.3"){
		$VLAN = '25'+$vmIPAddress.Substring(6,1)		
	}elseif($vmIPaddress.Substring(0,7) -eq "172.23."){
		$VLAN = '30'+$vmIPAddress.Substring(7,1)
	}elseif($vmIPaddress.Substring(0,10) -eq "192.168.1."){
		$VLAN = "1"
	}else{
		$VLAN = $vmIPAddress.Substring(8, 3)
		$VLAN = $VLAN.Replace(".","")
		if ($VLAN -eq "11.") { $VLAN = "11" }
		if ($VLAN -eq "28.") { $VLAN = "28" }
		if ($VLAN -eq "77.") { $VLAN = "77" }
		if ($VLAN -eq "83.") { $VLAN = "83" }
		if ($VLAN -eq "94.") { $VLAN = "94" }
		if ($VLAN -eq "99.") { $VLAN = "99" }
	}
	
	$VLAN = "VLAN_" + $VLAN
	return $VLAN
}
function fnCloneVM([string]$vmname, [string]$OSver, [string]$vmIPaddress, [string]$vmBOIPaddress, [string]$vmdatastore, [string]$vmfolder, [string]$vmcluster, [string]$vmresourcepool, $deploy, [string]$vmsource, $dr, [string]$COnumber, [string]$COaction){
	
	Write-EventLog -LogName "CNO_Automate" -Source "WF$CONumber" -EventID 1001 -Message "Beginning VM Deployment for Workflow CO#$CONumber for server $VMName." -EntryType Information
	#Defaults.. adjusted as needed based on other criteria
	$Linux = $false
	$OS = "SRV"
	
	$vmAdminPassword = "ZaYbXc351+"
	$vmtemplate = $OSver
					
	if ($OSver -eq "RHEL-5403-x86"){
		$vmOSkey = "*"
		$Linux = $true
	}elseif($OSver -eq "RHEL-5403-x64"){
		$vmOSkey = "*"
		$Linux = $true
	}elseif($OSver -eq "WXP-SP3-X86"){
		$vmAdminPassword = "App317config"
		$vmOSkey = "DPFQJ-RVH2C-QHF3V-229X3-38QK8"
		$OS = "DESK"
	}elseif ($OSver -eq "W2K3-R2-SP2-ENT-X64"){
		$vmOSkey = "GFCD9-BVK6B-TMCH6-8P3R3-9267Y"
	}elseif ($OSver -eq "W2K3-R2-SP2-STD-X64"){
		$vmOSkey = "GFCD9-BVK6B-TMCH6-8P3R3-9267Y"
	}elseif ($OSver -eq "W2K3-R2-SP2-ENT-X86"){
		$vmOSkey = "FHT8G-2T4QP-PJJQ2-8Q7PG-XRCM8"
	}elseif ($OSver -eq "W2K3-R2-SP2-STD-X86"){
		$vmOSkey = "F23CP-PBDP9-FM233-6QWG9-X4XWG"
	}elseif ($OSver -eq "W2K3-SP1-ENT-X86"){
		$vmOSkey = "P96J2-8DHB4-M8CG4-BQP98-JRG7M"	
	}elseif ($OSver -eq "W2K3-SP1-STD-X86"){
		$vmOSkey = "J676W-2GHW8-HWTWM-V722W-J22MB"	
	}elseif ($OSver -eq "W2K3-SP2-ENT-X64"){
		$vmOSkey = "DF9RY-GXKDD-VD39Q-G72XJ-YVQHM"
	}elseif ($OSver -eq "W2K3-SP2-ENT-X86"){
		$vmOSkey = "FHT8G-2T4QP-PJJQ2-8Q7PG-XRCM8"
	}elseif ($OSver -eq "W2K3-SP2-ENT-X86-NT"){
		$vmOSkey = "FHT8G-2T4QP-PJJQ2-8Q7PG-XRCM8"
	}elseif ($OSver -eq "W2K3-SP2-STD-X86"){
		$vmOSkey = "F23CP-PBDP9-FM233-6QWG9-X4XWG"
	}elseif ($OSver -eq "W2K3-SP2-STD-X86-NT"){
		$vmOSkey = "F23CP-PBDP9-FM233-6QWG9-X4XWG"
	}elseif ($OSver -eq "W2K-SP4-STD-X86"){
		$vmOSkey = "VF6JF-FCWW6-M2F3J-KDBDB-K24QG"
	}elseif ($OSver -eq "W2K-SP4-ADV-X86"){
		$vmOSkey = "M62W4-9JTT6-HT28K-MTD3Q-GRMK3"
	}elseif ($OSver -eq "W2K8-SP1-ENT-X64"){
		$vmOSkey = ""
	}elseif ($OSver -eq "W2K8-SP1-STD-X64"){
		$vmOSkey = ""
	}elseif ($OSver -eq "W2K8-SP2-ENT-X64"){
		$vmOSkey = ""
	}elseif ($OSver -eq "W2K8-SP2-ENT-X86"){
		$vmOSkey = ""		
	}elseif ($OSver -eq "W2K8-SP2-STD-X64"){
		$vmOSkey = ""
	}elseif ($OSver -eq "W2K8-SP2-STD-X86"){
		$vmOSkey = ""
	}elseif ($OSver -eq "W2K8-R2-SP0-ENT-X64"){
		$vmOSkey = ""
	}elseif ($OSver -eq "W2K8-R2-SP0-STD-X64"){
		$vmOSkey = ""
	}elseif ($OSver -eq "W2K8-R2-SP1-STD-X64"){
		$vmOSkey = ""
	}elseif ($OSver -eq "W2K8-R2-SP1-ENT-X64"){	
	$vmOSkey = ""
	}else{
		Write-EventLog -LogName "CNO_Automate" -Source "WF$CONumber" -EventID 1002 -Message "VM Deployment for Workflow CO#$CONumber for server $VMName`n Error: OS Definition is not valid." -EntryType Error
		Write-Error "OS Definition is not valid."
	}
	
	If($OS -eq "SRV")
	{
		#Figure out what the Front Office gateway will be based on the provided Front Office IP
		$vmIPgateway = $vmIPaddress.Substring(0, $vmIPaddress.IndexOf(".", $vmIPaddress.IndexOf(".", $vmIPaddress.IndexOf(".") + 1) + 1)) + ".1"
		If($vmIPaddress -contains "192.168.11.*"){
			# exception to the rule, nFrame gateway is .200
			$vmIPgateway = "192.168.11.200"
		}
	}
	
	Write-EventLog -LogName "CNO_Automate" -Source "WF$CONumber" -EventID 1002 -Message "
VM Deployment for Workflow CO#$CONumber 
 - Server Name     : $vmname 
 - Action          : $COaction 
 - FO IP Address   : $vmIPaddress
 - FO IP Gateway   : $vmIPgateway 
 - BO IP Address   : $vmBOIPaddress 
 - VM Datastore    : $vmdatastore 
 - VM Folder       : $vmfolder 		
 - VM Cluster      : $vmcluster 
 - VM Resource Pool: $vmresourcepool
 - VM OS Type      : $OS 		
 - VM OS Key      : $vmOSkey 		
 - VM Linux?       : $Linux 
 " -EntryType Information

	Write-Host "OS Key: " $vmOSkey
	
	#Get the VC Folder to put the VM in
	$tfld = Get-Folder -Name $vmfolder | Get-View
		
	# Create VirtualMachineCloneSpec object
	$vmclonespec = New-Object VMware.Vim.VirtualMachineCloneSpec
	    
	# Construct customization object
	$vmclonespec.Customization = New-Object VMware.Vim.CustomizationSpec
	
	# globalIPSettings
	$vmclonespec.Customization.GlobalIPSettings = New-Object VMware.Vim.CustomizationGlobalIPSettings
	#Conseco's DNS Suffix List
	$vmclonespec.Customization.GlobalIPSettings.dnsSuffixList = "conseco.ad", "conseco.com", "bankerslife.internal", "banklife.com", "colpenn.internal", "colpenn.com", "extvendor.ad"
	
	# adaptermapping
	if ($OS -eq "SRV"){
		$vmBOVLAN = "VLAN_10"
		if($Linux -or $COaction -eq "C"){
			$vmclonespec.Customization.NicSettingMap = @((New-Object VMware.Vim.CustomizationAdapterMapping), ( New-Object VMware.Vim.CustomizationAdapterMapping ))
			$vmclonespec.Customization.NicSettingMap[0].Adapter = New-Object VMware.Vim.CustomizationIPSettings
			$vmclonespec.Customization.NicSettingMap[0].Adapter.Ip = New-Object VMware.Vim.CustomizationFixedIp
			$vmclonespec.Customization.NicSettingMap[0].Adapter.Ip.IpAddress = $vmIPaddress
			$vmclonespec.Customization.NicSettingMap[0].Adapter.SubnetMask = "255.255.255.0"
			$vmclonespec.Customization.NicSettingMap[0].Adapter.gateway = $vmIPgateway
			$vmclonespec.Customization.NicSettingMap[0].Adapter.dnsServerList = "192.168.1.3", "192.168.83.8"
			$vmclonespec.Customization.NicSettingMap[0].Adapter.dnsDomain = "conseco.com"
		
			$vmclonespec.Customization.NicSettingMap[1].Adapter = New-Object VMware.Vim.CustomizationIPSettings
			$vmclonespec.Customization.NicSettingMap[1].Adapter.Ip = New-Object VMware.Vim.CustomizationFixedIp
			$vmclonespec.Customization.NicSettingMap[1].Adapter.Ip.IpAddress = $vmBOIPaddress
			$vmclonespec.Customization.NicSettingMap[1].Adapter.SubnetMask = "255.255.0.0"
		}else{
			# Windows Servers
			$vmclonespec.Customization.NicSettingMap = @(New-Object VMware.Vim.CustomizationAdapterMapping)
			# Front Office
			$vmclonespec.Customization.NicSettingMap[0].Adapter = New-Object VMware.Vim.CustomizationIPSettings
			$vmclonespec.Customization.NicSettingMap[0].Adapter.Ip = New-Object VMware.Vim.CustomizationFixedIp
			$vmclonespec.Customization.NicSettingMap[0].Adapter.Ip.IpAddress = $vmIPaddress
			$vmclonespec.Customization.NicSettingMap[0].Adapter.SubnetMask = "255.255.255.0"
			$vmclonespec.Customization.NicSettingMap[0].Adapter.gateway = $vmIPgateway
			$vmclonespec.Customization.NicSettingMap[0].Adapter.dnsServerList = "192.168.1.3", "192.168.83.8"
			$vmclonespec.Customization.NicSettingMap[0].Adapter.dnsDomain = "conseco.ad"
		}
	}elseif($OS -eq "DESK"){
		$vmclonespec.Customization.NicSettingMap = @(New-Object VMware.Vim.CustomizationAdapterMapping)
		$vmclonespec.Customization.NicSettingMap[0].Adapter = New-Object VMware.Vim.CustomizationIPSettings
		$vmclonespec.Customization.NicSettingMap[0].Adapter.Ip = New-Object VMware.Vim.CustomizationDhcpIpGenerator
		$vmclonespec.Customization.NicSettingMap[0].Adapter.dnsDomain = "conseco.ad"
	}

	if ($Linux){
		$vmclonespec.Customization.Identity = New-Object VMware.Vim.CustomizationLinuxPrep
		$vmclonespec.Customization.Identity.domain = "conseco.com"
		$vmclonespec.Customization.Identity.hostName = New-Object VMware.Vim.CustomizationFixedName
		$vmclonespec.Customization.Identity.hostName.name = $vmname.ToLower()	
	}else{	
		# WinOptions
		$vmclonespec.Customization.Options = New-Object VMware.Vim.CustomizationWinOptions
		$vmclonespec.Customization.Options.ChangeSID = 1
		
		# Sysprep
		$vmclonespec.Customization.Identity = New-Object VMware.Vim.CustomizationSysprep
		
		# GUIUnattended
		$vmclonespec.Customization.Identity.GuiUnattended = New-Object VMware.Vim.CustomizationGuiUnattended
		$vmclonespec.Customization.Identity.GuiUnattended.AutoLogon = 1
		$vmclonespec.Customization.Identity.GuiUnattended.AutoLogonCount = 1
		$vmclonespec.Customization.Identity.GuiUnattended.TimeZone = "035"
		
		# Unattended Password
		$vmclonespec.Customization.Identity.GuiUnattended.Password = New-Object VMware.Vim.CustomizationPassword
		$vmclonespec.Customization.Identity.GuiUnattended.Password.PlainText = 1
		$vmclonespec.Customization.Identity.GuiUnattended.Password.Value = $vmAdminPassword
		
		# Identification
		$vmclonespec.Customization.Identity.Identification = New-Object VMware.Vim.CustomizationIdentification
		
		# Domain join
		if ($DR){
		$vmclonespec.Customization.Identity.Identification.joinWorkgroup = "CNODR"
		}else{
		$vmclonespec.Customization.Identity.Identification.DomainAdminPassword = New-Object VMware.Vim.CustomizationPassword
		$vmclonespec.Customization.Identity.Identification.DomainAdminPassword.PlainText = 1
		$vmclonespec.Customization.Identity.Identification.DomainAdminPassword.Value = "autoup"
		$vmclonespec.Customization.Identity.Identification.DomainAdmin = "synt_service_account"
		$vmclonespec.Customization.Identity.Identification.joinDomain = "conseco.ad"
		}
		
		# Userdata
		$vmclonespec.Customization.Identity.UserData = New-Object VMware.Vim.CustomizationUserData
		$vmclonespec.Customization.Identity.UserData.ComputerName = New-Object VMware.Vim.CustomizationFixedName
		$vmclonespec.Customization.Identity.UserData.ComputerName.Name = $vmname
		$vmclonespec.Customization.Identity.UserData.FullName = "Conseco Services, LLC"
		$vmclonespec.Customization.Identity.UserData.OrgName = "Conseco Services, LLC"
		$vmclonespec.Customization.Identity.UserData.ProductId = $vmOSkey
		
		$vmclonespec.Customization.Identity.LicenseFilePrintData = New-Object VMware.Vim.CustomizationLicenseFilePrintData
		$vmclonespec.Customization.Identity.LicenseFilePrintData.AutoMode = New-Object VMware.Vim.CustomizationLicenseDataMode
		$vmclonespec.Customization.Identity.GuiRunOnce = New-Object VMware.Vim.CustomizationGuiRunOnce
		
		if ($OS -eq "SRV"){
			$vmclonespec.Customization.Identity.LicenseFilePrintData.AutoMode = "perSeat"
			$vmclonespec.Customization.Identity.GuiRunOnce.commandList = "c:\Progra~1\NTADMIN\PostTemplateDeployLocal.cmd"
		}else{
			$vmclonespec.Customization.Identity.GuiRunOnce.commandList = "C:\PROGRA~1\NTADMIN\PostTemplateDeployLocalDesktop.cmd"
		}	
	}
	
	$vmclonespec.powerOn = $false
	$vmclonespec.Template = $false
	
	# Boot options
	$vmclonespec.config = New-Object VMware.Vim.VirtualMachineConfigSpec
	$vmclonespec.Config.bootOptions = New-Object VMware.Vim.VirtualMachineBootOptions
	$vmclonespec.Config.bootOptions.BootDelay = 0
	$vmclonespec.Config.bootOptions.EnterBIOSSetup = $false
	
	$vmclonespec.location = New-Object VMware.Vim.VirtualMachineRelocateSpec
	
	# Target resource pool
	If($vmcluster -eq "phi" -or $vmcluster -eq "chi"){
		$vmclonespec.location.pool = (get-cluster $vmcluster | Get-ResourcePool | Get-View).MoRef
	}else{
		$vmclonespec.location.pool = (get-cluster $vmcluster | Get-ResourcePool -Name $vmresourcepool | Get-View).MoRef
	}

	# Target datastore
	$vmclonespec.location.datastore = (Get-Datastore -Name $vmDatastore | Get-View).MoRef
	
	#Is this a new server (true) or clone (false)	
	If($deploy){ 
		$vm = Get-Template -Name $vmtemplate | Get-View
	}else{
		$vm = Get-VM -Name $vmsource | Get-View
	}

	
	$task = $vm.CloneVM_Task($tfld.moref, $vmname, $vmclonespec)
	$taskid = 'Task-' + $task.Value
	if($dr){
		fnSetSqlNTDR "UPDATE dbo.NT_DRSERVERINFO SET DRTaskID = '$taskid', DRStatus = 'CLOSUB' WHERE Server = '$vmname'" 
	}else{
		Write-EventLog -LogName "CNO_Automate" -Source "WF$CONumber" -EventID 1003 -Message "vCenter Clone Task for Workflow CO#$CONumber for server $VMName has been submitted. vCenter Task ID: $taskid" -EntryType Information		
		$SQLReturn = fnSetSqlVCENTER "UPDATE CNO_Automate SET COstatus = 'W', vCTaskID = '$taskid' WHERE VMName = '$vmname' AND COnumber = '$COnumber' AND COaction = '$COaction'" 		
		
	}
	return $taskid
}
function fnVMConfig([string]$vmname, [string]$OSver, [string]$vmIPaddress, [string]$vmBOIPaddress, [string]$vmvcpus, [string]$vmram, [string]$vmdisk, $deploy, $dr, [string]$COnumber, [string]$COaction){
	
	if(!$dr){ 
	fnSetSqlVCENTER "UPDATE CNO_Automate SET COstatus = 'R', vCTaskID = '' WHERE VMName = '$vmname' AND coAction = '$coaction' AND COnumber = '$conumber'" 	
	}
	Write-EventLog -LogName "CNO_Automate" -Source "WF$CONumber" -EventID 1004 -Message "VM Configuration for Workflow CO#$CONumber for server $VMName beginning." -EntryType Information		
	if($deploy)
	{
		if ($vmdisk -ne -1 -and $vmdisk -ne '' -and $vmdisk -ne 0){
			$vmdiskKB = [Int]$vmdisk * 1048576
			
			If($vmname -like 'LX*')
			{
				New-HardDisk -VM(Get-VM $vmname) -CapacityKB $vmdiskKB
			}else{	
				$disks = Get-HardDisk -vm (Get-VM $vmname)
				if($disks.count -eq 2)
				{
				foreach ($disk in $disks) 
				{ 
					if($disk.CapacityKB -ne 25165824 -and $disk.CapacityKB -ne 33554432)
					{
						if($vmIPaddress.Substring(0,5) -eq "10.11")
						{
							Write-EventLog -LogName "CNO_Automate" -Source "WF$CONumber" -EventID 1004 -Message "VM Disk Config Using P2V_VI_BLC" -EntryType Information		
							Get-VM 'P2V_VI_BLC' | Shutdown-VMGuest -Confirm:$false
							Sleep 100
							Set-HardDisk -HardDisk $disk -CapacityKB $vmdiskKB -HostUser 'root' -HostPassword 'delta347#' -GuestUser 'administrator' -GuestPassword 'dolphins2004' -HelperVM (Get-VM -Name "P2V_VI")
							#Write-EventLog -LogName "CNO_Automate" -Source "WF$CONumber" -EventID 1005 -Message "VM Configuration for Workflow CO#$CONumber for server $VMName beginning." -EntryType Information		
						}else{
							Write-EventLog -LogName "CNO_Automate" -Source "WF$CONumber" -EventID 1004 -Message "VM Disk Config Using P2V_VI" -EntryType Information		
							Get-VM 'P2V_VI' | Shutdown-VMGuest -Confirm:$false
							Sleep 100
							Set-HardDisk -HardDisk $disk -CapacityKB $vmdiskKB -HostUser 'root' -HostPassword 'delta347#' -GuestUser 'administrator' -GuestPassword 'dolphins2004' -HelperVM (Get-VM -Name "P2V_VI")
							#Write-EventLog -LogName "CNO_Automate" -Source "WF$CONumber" -EventID 1005 -Message "VM Configuration for Workflow CO#$CONumber for server $VMName beginning." -EntryType Information								
						}
					}
				
				}
				}else{
				Write-Error "VM has more than two disks. Operation cannot continue."
				Write-EventLog -LogName "CNO_Automate" -Source "WF$CONumber" -EventID 1006 -Message "VM Configuration for Workflow CO#$CONumber for server $VMName has errored. An attempt was made to process disk extensions on a VM with more than two hard disks." -EntryType error
				}
			}
		}
	}	
	
	If($OSver -like 'WXP*'){
		$vmFOVLAN = "VLAN_210"
	}else{
		$vmBOSubnet = "255.255.0.0"
		$vmBOVLAN = "VLAN_10"
		$vmFOVLAN = fnVMNetwork $vmIPaddress
		Get-NetworkAdapter -VM(Get-VM $vmname) | where { $_.Name -eq "Network Adapter 2" } | Set-NetworkAdapter -NetworkName $vmBOVLAN -confirm:$false
	}
	Get-NetworkAdapter -VM(Get-VM $vmname) | where { $_.Name -eq "Network Adapter 1" } | Set-NetworkAdapter -NetworkName $vmFOVLAN -StartConnected:$true -confirm:$false
	
		
	if($deploy)
	{
		Get-VM $vmname | Set-VM -MemoryMB $vmram -Confirm:$false
		Get-VM $vmname | Set-VM -NumCPU $vmvcpus -Confirm:$false
		Write-EventLog -LogName "CNO_Automate" -Source "WF$CONumber" -EventID 1007 -Message "VM Configuration for Workflow CO#$CONumber for server $VMName `nSystem Configuration is being updated. `nvCPUs: $vmvcpus `nRAM: $vmram MB" -EntryType Information		
	}
		Get-VM $vmname | Start-VM

	If($vmname -notlike 'LX*' -and $vmname -notlike 'XP*'){
		if(!$dr){
			new-qadGroup -ParentContainer 'OU=Server Groups,OU=UserGroups,DC=conseco,DC=ad' -name ("NTSrv - " + $vmname + " - Administrators") -samAccountName ("NTSrv - " + $vmname + " - Administrators") -grouptype 'Security' -groupscope 'Universal'
			new-qadGroup -ParentContainer 'OU=Server Groups,OU=UserGroups,DC=conseco,DC=ad' -name ("NTSrv - " + $vmname + " - Power Users") -samAccountName ("NTSrv - " + $vmname + " - Power Users") -grouptype 'Security' -groupscope 'Universal'
			new-qadGroup -ParentContainer 'OU=Server Groups,OU=UserGroups,DC=conseco,DC=ad' -name ("NTSrv - " + $vmname + " - RDP Users") -samAccountName ("NTSrv - " + $vmname + " - RDP Users") -grouptype 'Security' -groupscope 'Universal'
			Write-EventLog -LogName "CNO_Automate" -Source "WF$CONumber" -EventID 1008 -Message "VM Configuration for Workflow CO#$CONumber for server $VMName `nSystem is being customized. AD security groups created." -EntryType Information		
			Start-Sleep -Seconds 900
			$moveworkstation = move-qadobject ("CONSECO\" + $vmname +"$") -NewParentContainer 'CONSECO.AD/Windows Servers'	  
			Write-EventLog -LogName "CNO_Automate" -Source "WF$CONumber" -EventID 1009 -Message "VM Configuration for Workflow CO#$CONumber for server $VMName `nAD object moved.`n$moveworkstation" -EntryType Information		
			Start-Sleep -Seconds 300
		}else{
			Start-Sleep -Seconds 900			
		}
		$VM = Get-VM $vmname
		if($coaction -eq 'C')
		{
			$NIC1 = Get-NetworkAdapter $vm | Where {$_.NetworkName -ne "VLAN_10"}
			$VMNIC1MAC = $NIC1.MacAddress
			$NIC2 = Get-NetworkAdapter $vm | Where {$_.NetworkName -eq "VLAN_10"}
			$VMNIC2MAC = $NIC2.MacAddress
		}else{
			$NIC1 = Get-NetworkAdapter $VM
			$VMNIC1MAC = $NIC1.MacAddress
			$NIC2 = New-NetworkAdapter -VM $vm -NetworkName "VLAN_10" -Type "vmxnet3" -StartConnected
			$VMNIC2MAC = $NIC2.MacAddress
		}
			$NICs = Get-NetworkAdapter $vm
		
		Write-EventLog -LogName "CNO_Automate" -Source "WF$CONumber" -EventID 1010 -Message "VM Configuration for Workflow CO#$CONumber for server $VMName `nNetwork Cards Added.`nNIC1 VLAN: $vmFOVLAN `nNIC2 VLAN: $vmBOVLAN`nNIC Config:`n$NICs" -EntryType Information		
		
		$OSverX = "XP"
		If($OSver -contains "W2K8"){
			If($OSver -contains "X64") { $OSverX = "X64" }
			If($OSver -contains "X86") { $OSverX = "X86" }
		}
		
		$FCPS = Copy-VMGuestFile -Source "\\NTADMINP01.CONSECO.AD\NTADMIN\POWERSHELL\AUTOMATION\VM.PostDeploySetupOnVM.ps1" -Destination c:\windows\temp\ -VM $VM -LocalToGuest -HostUser root -HostPassword "delta347#" -GuestUser "conseco\synt_service_account" -GuestPassword "autoup"
		$FCNV = Copy-VMGuestFile -Source "\\NTADMINP01.CONSECO.AD\SOFTWARE\Microsoft\NVSPBIND\$OSverX\nvspbind.exe" -Destination c:\windows\temp\ -VM $VM -LocalToGuest -HostUser root -HostPassword "delta347#" -GuestUser "conseco\synt_service_account" -GuestPassword "autoup"
		
		Write-EventLog -LogName "CNO_Automate" -Source "WF$CONumber" -EventID 1011 -Message "VM Configuration for Workflow CO#$CONumber for server $VMName `nFile Copy (Post Deploy PowerShell)`n$FCPS`n`nFile Copy (nvspbind)`n$FCNV `nNVSPBIND Version: $OSverX" -EntryType Information		
		
		$VSPS = Invoke-VMScript -VM $VM -HostUser root -HostPassword "delta347#" -GuestUser 'CONSECO\SyNT_Service_Account' -GuestPassword 'autoup' -ScriptType Powershell  -ScriptText "Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force" 
		$VSPC = Invoke-VMScript -VM $VM -HostUser root -HostPassword "delta347#" -GuestUser 'CONSECO\SyNT_Service_Account' -GuestPassword 'autoup' -ScriptType Powershell  -ScriptText "c:\windows\temp\VM.PostDeploySetupOnVM.ps1 $vmBOIPaddress $VMNIC1MAC $VMNIC2MAC $OSVER"
		
		Write-EventLog -LogName "CNO_Automate" -Source "WF$CONumber" -EventID 1012 -Message "VM Configuration for Workflow CO#$CONumber for server $VMName `n PowerShell Setup`n$VSPS`n`nPost Config Script:`n$VSPC" -EntryType Information		
		
		Start-Sleep -Seconds 300
		$VM | Restart-VMGuest
	}elseif($vmname -like 'LX*'){
		Start-Sleep -Seconds 300
		Get-VM -Name $vmname | Restart-VMGuest
	}elseif($vmname -like 'XP*'){
		Start-Sleep -Seconds 900
		$VM = Get-VM $vmname
		$VSDK = Invoke-VMScript -VM $VM -HostUser root -HostPassword "delta347#" -GuestUser 'Administrator' -GuestPassword 'App317config' -ScriptType Bat -ScriptText "C:\PROGRA~1\NTADMIN\PostTemplateDeployLocalDesktop.cmd"
		Write-EventLog -LogName "CNO_Automate" -Source "WF$CONumber" -EventID 1012 -Message "VM Configuration for Workflow CO#$CONumber for server $VMName `n Desktop Deployment Script`n$VSDK" -EntryType Information		
	}
	if(!$dr){ 
		fnSetSqlVCENTER "UPDATE CNO_Automate SET COstatus = 'V', vCTaskID = '' WHERE VMName = '$vmname' AND coAction = '$coaction' AND COnumber = '$conumber'"
		Write-EventLog -LogName "CNO_Automate" -Source "WF$CONumber" -EventID 1999 -Message "VM Configuration for Workflow CO#$CONumber for server $VMName complete." -EntryType Information		
	}
}
function fnModifyPriority([int]$RowID) {

	$dsVM = fnGetDataSetNTDR "Select * FROM NT_DRSERVERINFO WHERE RowId= '$RowID'"
	$VMcol = $dsVM.Tables[0].Rows[0]
	
	fnPrintHeader "Modify System DR Recovery Priority" "SysAdmin"
	Write-Host ""
	Write-Host "*******************************************************************************" -foregroundcolor "White"
	Write-Host "System: "$VMcol[1] -foregroundcolor "Blue"
	Write-Host "Current DR Recovery Status: "
	Write-Host " -- Status: ["$VMcol['DRStatus']" ]"
	Write-Host " -- Priority: "$VMcol['DRPriority']
	Write-Host "*******************************************************************************" -foregroundcolor "White"
	Write-Host ""
	Write-Host "SysAdmin Interface" -foregroundcolor "White"
	Write-Host "#. To Modify a DR Priority, Enter the Priority Number"  -foregroundcolor "White"
	Write-Host "Q. Return to the Main Menu"  -foregroundcolor "White"
	Write-Host ""
	$strResponse = “0”
	do {$strResponse = Read-Host “Select an option: [#/Q]”}
	until (($strResponse -eq “Q”) -or ([Microsoft.VisualBasic.Information]::isnumeric($strResponse)))

	If($strResponse -eq "Q") { fnModifySystem $strResponse }

	If($strResponse -ne "Q" -and $strResponse -ne "P" -and $strResponse -ne "X")
	{
		$SQLReturn = fnSetSqlNTDR "UPDATE dbo.NT_DRSERVERINFO SET DRPriority = $strResponse FROM dbo.NT_DRSERVERINFO WHERE RowID =  '$RowID'"

		$dsVM = fnGetDataSetNTDR "Select * FROM NT_DRSERVERINFO WHERE RowId= '$RowID'"
		$VMcol = $dsVM.Tables[0].Rows[0]
		$DRStatusDescript = ""
		$DRStatusOptions = ""
		
		fnPrintHeader "Modify System DR Recovery Status" $usertype
		Write-Host ""
		Write-Host "*******************************************************************************" -foregroundcolor "White"
		Write-Host "System: "$VMcol[1] -foregroundcolor "Blue"
		Write-Host "Current DR Recovery Status: "
		Write-Host " -- Status: ["$VMcol['DRStatus']" ]"
		Write-Host " -- Priority: "$VMcol['DRPriority']
		Write-Host "*******************************************************************************" -foregroundcolor "White"
		Write-Host ""

		
		If($SQLReturn -gt 0)
		{
			Write-Host "System DR Recovery Status Updated Sucessfully." -foregroundcolor "Green"
		}
		else
		{
			Write-Host "System DR Recovery Status Failed to Update." -foregroundcolor "Red"
		}
		$strResponse = "0"
				
		Read-Host "Press Any Key To Continue"
		fnCheckIn $RowID
	}
}
function fnListAppGrp() {
fnPrintHeader "List Application Groups" "SysAdmin"
$dsVMs = fnGetDataSetNTDR "Select RowId, AppName, AppID FROM NT_DRSERVERINFO_APP ORDER BY [RowID]"
#Write-Host "The Following Systems are in Disaster Recovery Status "$DRStatus":" -foregroundcolor "White"
	ForEach($Row In $dsVMs.Tables[0].Rows)
	{
		$VMID = "{0:D3}" -f [int]$Row[0]
		$RC= [String]$VMID+". "+$Row[1]+" ["+$Row[2]+"]"
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

If($strResponse -ne "Q") { fnModifyAppGrpWrap $strResponse }
}
function fnModifyAppGrpWrap([int]$AppGrpRowID) {
$dsVM = fnGetDataSetNTDR "Select * FROM NT_DRSERVERINFO_APP WHERE RowID= '$AppGrpRowID'"
$Row = $dsVM.Tables[0].Rows[0]
fnModifyAppGrp $Row['AppID']
}
function fnModifyAppGrp([string]$AppGrpID) {
	fnPrintHeader  "Application Group Details" "SysAdmin"
	$dsApp = fnGetDataSetNTDR "Select * FROM NT_DRSERVERINFO_APP WHERE AppID= '$AppGrpID'"
	$dsAppReq = fnGetDataSetNTDR "Select * FROM vw_AppGroups_Requirements WHERE AppID= '$AppGrpID' ORDER BY SystemName"
	$Row = $dsApp.Tables[0].Rows[0]
	
	Write-Host ""
	Write-Host "Application Group: "$Row['AppName'] -foregroundcolor "Green"
	Write-Host "Application Group ID: "$Row['AppID'] -foregroundcolor "DarkGreen"
	Write-Host ""
	Write-Host "System Required for Application Group: " -foregroundcolor "White"
	$CountOfSystems = $dsAppReq.Tables[0].Rows.Count
	$CountOfSystemsRecovered = 0
	ForEach($RowReq in $dsAppReq.Tables[0].Rows)
	{
	$DRStatus = $RowReq['DRStatus']
	If( $RowReq['DRStatusColor'] -eq [DBNull]::Value )
	{
		$DRStatusColor = 'White'
	}else{
	$DRStatusColor = $RowReq['DRStatusColor']
	}
	Write-Host " -- " $RowReq['SystemName'] `t $RowReq['System'] [$DRStatus] -foregroundcolor $DRStatusColor 
	If($DRStatus -eq 'RECVRD'){$CountOfSystemsRecovered++}
	}
	$PercentRecovered = $SpaceUsed = [math]::round((([int]$CountOfSystemsRecovered/[int]$CountOfSystems)*100),2)
	If($PercentRecovered -eq 100)	{ 
			$AppGrpRecStatus = "Complete" 
			$AppGrpRecStatusColor = "Green"
	}
	If($PercentRecovered -lt 100){
		$AppGrpRecStatus = "INCOMPLETE" 
		$AppGrpRecStatusColor = "Yellow"
	}
	Write-Host ""
	Write-Host "Overal Recovery: $PercentRecovered% Complete" -foregroundcolor $AppGrpRecStatusColor
	Write-Host "Overal Recovery Status: $AppGrpRecStatus" -foregroundcolor $AppGrpRecStatusColor
	Write-Host "*******************************************************************************" -foregroundcolor "White"
	
	$strResponse = Read-Host "Press Any Key to Continue"	
#	$strResponse = “Z”
#	do {$strResponse = Read-Host “Modify DR Recovery Status? [Y/N]”}
#	until (($strResponse -eq “Y”) -or ($strResponse -eq “N”))
#	If($strResponse -eq "Y") {
#		fnModifyDRStatus $RowID "SysAdmin"
#	} 
#	else {
#		$strResponse = “Z”
#		do {$strResponse = Read-Host “Return to Previous List? [Y/N]”}
#		until (($strResponse -eq “Y”) -or ($strResponse -eq “N”))
#		If($strResponse -eq "Y") { fnListVMs $Row[43]}
#	}
}
function load-VITK(){
	& {
		$ErrorActionPreference = "silentlycontinue"
		$questSnapin = Add-PSSnapin "Quest.ActiveRoles.ADManagement"
		$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr
		
		switch -regex ($myErr[0].Exception.ErrorRecord)
		{
			"VMware.VimAutomation.Core is not installed" {
				"VMware.VimAutomation.Core is not installed" | Write-Log
				Write-Host "Please install the VI Toolkit"
				Write-Host "See http://vmware.com/go/powershell"
				"*** Application stopped ***" | Write-Log
				exit
			}
			"No Windows PowerShell snap-in matches criteria vmware.vimautomation.core." {
				"No Windows PowerShell snap-in matches criteria vmware.vimautomation.core." | Write-Log
				Add-PSSnapin "VMware.VimAutomation.Core"
			}
		}
		if ((Get-VIToolkitVersion).Build -lt $VITKMinimumVersion)
		{
			"VITK version incorrect : " + ( Get-VIToolkitVersion ).Build | Write-Log
			Write-Host "Install the latest version of the VI Toolkit" -foregroundcolor "red"
			Write-Host "See http://vmware.com/go/powershell"
			"*** Application stopped ***" | Write-Log
			exit
		}
	}
}
function fnSysAdminMenu(){
do {
fnPrintHeader "Main Menu" "SysAdmin"
Write-Host "SysAdmin Interface" -foregroundcolor "White"
Write-Host "1. List Systems Ready for Setup             (RDYSET)"  -foregroundcolor "White"
Write-Host "2. List Systems Ready for NetBackup Restore (RDYNBU)"  -foregroundcolor "White"
Write-Host "3. List Systems Restored by NetBackup       (NBUCMP)"  -foregroundcolor "White"
Write-Host "4. List Systems Requiring Manual Build      (MANUAL)"  -foregroundcolor "White"
Write-Host "5. List Systems with Errors                 (ERROR )"  -foregroundcolor "White"
Write-Host "6. List Recovered Systems                   (RECVRD)"  -foregroundcolor "White"
Write-Host "L. List Systems for Specified Status                "  -foregroundcolor "White"
Write-Host "S. Change Status for a Specified Systems"  -foregroundcolor "White"
Write-Host "V. View Info for a Specified System"  -foregroundcolor "White"
Write-Host "A. View Application Groups"  -foregroundcolor "White"
Write-Host "Q. Exit SysAdmin Interface" -foregroundcolor "White"
Write-Host ""
Write-Host ""
Write-Host "** For Best Use - Maximize This Window **" -foregroundcolor "Magenta"
Write-Host ""
$strResponse = “0”
do {$strResponse = Read-Host “Select an option: [1,2,3,4,5,6,L,S,V,Q]”}
until (($strResponse -eq “1”) -or ($strResponse -eq “2”) -or ($strResponse -eq “3”) -or ($strResponse -eq “4”) -or ($strResponse -eq “5”) -or ($strResponse -eq “6”) -or ($strResponse -eq “L”) -or  ($strResponse -eq “S”) -or ($strResponse -eq “V”) -or ($strResponse -eq “Q”)-or ($strResponse -eq "A"))

If($strResponse -eq "1") { fnListSystems 'RDYSET' }
If($strResponse -eq "2") { fnListSystems 'RDYNBU' }
If($strResponse -eq "3") { fnListSystems 'NBUCMP' }
If($strResponse -eq "4") { fnListSystems 'MANUAL' }
If($strResponse -eq "5") { fnListSystems 'ERROR' }
If($strResponse -eq "6") { fnListSystems 'RECVRD' }
If($strResponse -eq "L") { fnlistVMsWrap }
If($strResponse -eq "S") { fnStatWrap }
If($strResponse -eq "V") { fnViewWrap }
If($strResponse -eq "A") { fnListAppGrp }
#If($strResponse -eq "Q") { Exit }
}until ($strResponse -eq "Q")
}
function fnCheckDBup(){
	$Servers = fnGetDataSetNTDR "Select Server FROM NT_DRSERVERINFO"
	If ($Servers.Tables[0].Rows.Count -gt 0){
		return $true
	}else{
		return $false
	}
}