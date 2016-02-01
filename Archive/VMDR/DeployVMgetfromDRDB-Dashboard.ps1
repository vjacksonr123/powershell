# CONSECO - Windows Server Administration - DR
# * VM Deployment Dashboard *

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
Write-Host " ** Disaster Recovery Script - VM Deployment Dashboard ** "  -foregroundcolor "Green"

$strResponse = “Quit”
$Excel = New-Object -comobject Excel.Application
$Excel.DisplayFullScreen = $True
$ExcelWrkBk = $Excel.Workbooks.Add()
$ExcelWrkBkItem = $ExcelWrkBk.Worksheets.Item(1)
for($i=0;$i -le 48;$i=$i+3)
{
	$ExcelWrkBkItem.Cells.Item(1,($i+1)) = "Server Name"
	$ExcelWrkBkItem.Cells.Item(1,($i+2)) = "OS"
	$ExcelWrkBkItem.Cells.Item(1,($i+3)) = "--"
}
$ExcelWrkBkItemUsedRange = $ExcelWrkBkItem.UsedRange
#$ExcelWrkBkItemUsedRange.Interior.ColorIndex = 19
#$ExcelWrkBkItemUsedRange.Font.ColorIndex = 11
$ExcelWrkBkItemUsedRange.Font.Bold = $True

#do 
#{
for($i=1; $i -le 1000; $i++)
{
	$Excel.visible = $True


	
	$ExcelRow = 2
	
	
	#$TaskName = "GetVMsForDeploy"
	$SqlServer = "VCENTER.CONSECO.AD";
	$SqlDatabase = "VCENTER";
	$SqlSecurity = "User Id=VCAdmin; Password=vcadm6ev;"
	
	# Get the T-SQL Query from .SQL file
	#$SqlQuery = Get-Content (".\" + $TaskName + ".sql")
	
	# Get the T-SQL 
	$SqlQuery = "Select * FROM NT_DRSERVERINFO_RESTORE WHERE Len(DRStatus) > 0 ORDER BY VMNAME"
	#$SqlQuery = "Select * FROM NT_DRSERVERINFO_RESTORE ORDER BY VMNAME"
	
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
	
	if ($nRecs -gt 0)
	{
	# Do Stuff
	ForEach ($Row In $DataSet.Tables[0].Rows)
	{
		$ExcelRowReal = $ExcelRow
		$ExcelColReal = 0
		$ExcelOffShift = 0
		
		#$ExcelColMarker = (($ExcelRow-2)/48)
		
		If($ExcelRow -ge 002) {$ExcelColMarker = 0}
		If($ExcelRow -ge 050) {$ExcelColMarker = 1}
		If($ExcelRow -ge 098) {$ExcelColMarker = 2}
		If($ExcelRow -ge 146) {$ExcelColMarker = 3}
		If($ExcelRow -ge 194) {$ExcelColMarker = 4}
		If($ExcelRow -ge 242) {$ExcelColMarker = 5}
		If($ExcelRow -ge 290) {$ExcelColMarker = 6}
		If($ExcelRow -ge 338) {$ExcelColMarker = 7}
		If($ExcelRow -ge 386) {$ExcelColMarker = 8}
		If($ExcelRow -ge 434) {$ExcelColMarker = 9}
		If($ExcelRow -ge 482) {$ExcelColMarker = 10}
		If($ExcelRow -ge 530) {$ExcelColMarker = 11}
		If($ExcelRow -ge 578) {$ExcelColMarker = 12}
		If($ExcelRow -ge 626) {$ExcelColMarker = 13}
		If($ExcelRow -ge 674) {$ExcelColMarker = 14}
		
		If($ExcelRow -ge 050) {$ExcelOffShift = 0}
		
		$ExcelRowReal = ($ExcelRow-(48*$ExcelColMarker)+$ExcelOffShift)
		$ExcelColReal = (3*$ExcelColMarker)
		
#		Write-Host "Row = $ExcelRow"
#		Write-Host "ColMark = $ExcelColMarker"
#		Write-Host "RowReal = $ExcelRowReal"
#		Write-Host "ColReal = $ExcelColReal"

		$ExcelWrkBkItem.Cells.Item($ExcelRowReal,($ExcelColReal + 1)) = $Row[0]
		$ExcelWrkBkItem.Cells.Item($ExcelRowReal,($ExcelColReal + 2)) = $Row[18]
#		$ExcelWrkBkItem.Cells.Item($ExcelRowReal,($ExcelColReal + 3)) = $ExcelRow
		$ExcelCellColor  = -4142
			If($Row[18] -eq "ERROR") {	$ExcelCellColor  = 3	}
			If($Row[18] -eq "CLOSUB") {	$ExcelCellColor  = 43 }
			If($Row[18] -eq "CLORUN") {	$ExcelCellColor  = 6 }
			If($Row[18] -eq "CLOQUE") {	$ExcelCellColor  = 42 }
			If($Row[18] -eq "RDYCFG") {	$ExcelCellColor  = 46 }
			If($Row[18] -eq "RESTORE") {$ExcelCellColor  = 33	}
			If($Row[18] -eq "RDYSET") {	$ExcelCellColor  = 7	}
			If($Row[18] -eq "RDYNBU") {	$ExcelCellColor  = 19	}
			If($Row[18] -eq "NBUACK") {	$ExcelCellColor  = 35	}
			If($Row[18] -eq "NBURUN") {	$ExcelCellColor  = 36	}
			If($Row[18] -eq "NBUCMP") {	$ExcelCellColor  = 10	}
			If($Row[18] -eq "RECVRD") {	$ExcelCellColor  = 4	}
			If($Row[18] -eq "MANUAL") {	$ExcelCellColor  = 38	}
			
			$ExcelWrkBkItem.Cells.Item($ExcelRowReal,($ExcelColReal + 1)).Interior.ColorIndex = $ExcelCellColor
			$ExcelWrkBkItem.Cells.Item($ExcelRowReal,($ExcelColReal + 2)).Interior.ColorIndex = $ExcelCellColor
							
		$ExcelRow++
	}
	}
	$ExcelWrkBkItemUsedRange = $ExcelWrkBkItem.UsedRange
	$ExcelWrkBkItemUsedRange.Font.Name = "Courier"
	$ExcelWrkBkItemUsedRange.EntireColumn.AutoFit()
	$Excel.visible = $True
	
	#$strResponse = Read-Host “Refresh Dashboard? (Y/N)”
	
	Start-Sleep 60
}
#} until ($strResponse -eq “N”)