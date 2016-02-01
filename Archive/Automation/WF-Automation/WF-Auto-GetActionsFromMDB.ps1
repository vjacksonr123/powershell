# CONSECO - Windows Server Administration 
# * Workflow Automation - Get Data From Service Desk *
# ** Last Modified: 2010/02/25 @ 16:19 by LANJ6P (Pawlak, Jakub P)
# ** Usage: Schedule to run every 15 minutes as a user with access
# **        to SQL Server 'S5PRD1' & Database 'MDB'
# ******************************************************************

$WFAutoFN = "DeployVMfunction.ps1"
$WFAutoIncludes = ($WFAutoFN)
$WFAutoIncludes | % {
	if (Test-Path $_)
	{
		. ./$_
		Write-Host $_ Loaded
	}
	else
	{
		Write-Host "Include file missing." -foregroundcolor "red"
		Write-Host "Make sure file '$_' is present in the current directory"
		exit
	}
}

fnEVcreate
do{
#Create generic event log entries
$PAZero = 0
#Get all of the pending workflows from Service Desk
$MDB = fnGetDataSetMDB ( Get-Content "\\ntadminp01\NTADMIN\PowerShell\DeployVM\GetVMsForDeploy.sql" )
$PendingWF = $MDB.Tables[0].Rows.Count
	
	If($PendingWF -eq 0){
		If($PAZero%10 -eq 0){
			Write-EventLog -LogName "CNO_Automate" -Source "MDB_Wrapper" -EventID 1001 -Message "Polling Service Desk for Pending Workflows - Last Ten Polls Returned Zero Records" -EntryType Information
		}
		$PAZero++
	}else{
		Write-EventLog -LogName "CNO_Automate" -Source "MDB_Wrapper" -EventID 1001 -Message "Polling Service Desk for Pending Workflows - Workflows Pending: $PendingWF" -EntryType Information
	}

#If there is at lease one pending workflow

if ($PendingWF -gt 0){
  #iterate thru the workflows
   ForEach ($Row In $MDB.Tables[0].Rows){
  	#Save the CO# into a variable
  	$CONumber		 = $Row['changeorder']
	$COAction 		 = $Row['coaction']
	$VMName			 = $Row['vmname']
	$VMName			 = $VMName.ToUpper()
	$OSVer			 = $Row['vmOSver']
	$VMFOIP			 = $Row['vmIPaddress']
	$VMBOIP			 = $Row['vmBOIPaddress']
	$VMVCPUS		 = $Row['vmvCPUs']
	$VMRAMmb		 = $Row['vmram']
	$VMDISKgb		 = $Row['vmdisk']
	$VMdatastore	 = $Row['vmdatastore']
	$VMfolder		 = $Row['vmfolder']
	$VMcluster	  	 = $Row['vmcluster']
	$VMresourcepool  = $Row['vmresourcepool']
	$VMsourceVM	 	 = $Row['vmsource']
	$VMdrmode 		 = 0
		
	#validate the CO# hasn't already been added into the automation database
	# if it has already been added, row count will be 1
	If((fnGetDataSetVCENTER "Select * from CNO_Automate WHERE COnumber = '$CONumber' AND COaction = '$COAction'").Tables[0].Rows.Count -eq 0){
		#since it's not already in the automation database, add it
		$SQLReturn = fnSetSQLVCENTER "INSERT INTO CNO_Automate(CONumber,COAction,VMName,OSVer,VMFOIP,VMBOIP,VMVCPUS,VMRAMmb,VMDISKgb,VMdatastore,VMfolder,VMcluster,VMresourcepool,VMsourceVM,VMdrmode) VALUES ('$CONumber','$COAction','$VMName','$OSVer','$VMFOIP','$VMBOIP','$VMVCPUS','$VMRAMmb','$VMDISKgb','$VMdatastore','$VMfolder','$VMcluster','$VMresourcepool','$VMsourceVM','$VMdrmode')"
		$WFCO = "WF"+$CONumber
		New-EventLog -LogName CNO_Automate -Source $WFCO
		If($SQLReturn -gt 0){
			Write-EventLog -LogName "CNO_Automate" -Source "MDB_Wrapper" -EventID 1002 -Message "Workflow CO#$CONumber for server $VMName has been added to the database." -EntryType Information
		}else{
			Write-EventLog -LogName "CNO_Automate" -Source "MDB_Wrapper" -EventID 1003 -Message "Workflow CO#$CONumber for server $VMName failed to be added to the database." -EntryType Error
		}	
	}else{
		#log a warning, too frequent polling could cause source system slowness
		Write-EventLog -LogName "CNO_Automate" -Source "MDB_Wrapper" -EventID 1004 -Message "Workflow CO#$CONumber for server $VMName has NOT been added to the database, it already exists in the database. If information needs to be refreshed for this workflow, change COaction to 'Z'" -EntryType Warning
	}
  }
}
sleep 900
}while($true)