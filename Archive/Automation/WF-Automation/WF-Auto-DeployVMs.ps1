# CONSECO - Windows Server Administration 
# * Workflow Automation - Deploy VMs *
# ** Last Modified: 2010/02/25 @ 16:19 by LANJ6P (Pawlak, Jakub P)
# ** Usage: Schedule to run continously as a domain admin
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

load-VITK
Connect-VIServer vcenter.conseco.ad
#Connect-VIServer view4vc.conseco.ad
$PAZero = 0
$Host.UI.RawUI.WindowTitle = "CNO WF Automate - VM Deployment"
do{
	$CNO_Automate = fnGetDataSetVCENTER "Select * from CNO_Automate WHERE COstatus IN ('B','C','X','V')"
	$PendingActions = $CNO_Automate.Tables[0].Rows.Count
	
	If($PendingActions -eq 0){
		If($PAZero%10 -eq 0){
			Write-EventLog -LogName "CNO_Automate" -Source "Deploy_VM" -EventID 2001 -Message "Polling Automation Database for Pending Actions - Last Ten Polls Returned Zero Records" -EntryType Information
		}
		$PAZero++
	}else{
		Write-EventLog -LogName "CNO_Automate" -Source "Deploy_VM" -EventID 2001 -Message "Polling Automation Database for Pending Actions - Actions Pending: $PendingActions" -EntryType Information
	}

	$CNO_Automate = fnGetDataSetVCENTER "Select * from CNO_Automate WHERE COstatus = 'B'"
	ForEach ($Row In $CNO_Automate.Tables[0].Rows){
		#Save the CO# into a variable
		$CONumber		 = $Row['COnumber']
		$COAction 		 = $Row['COaction']
		$VMName			 = $Row['VMName']
		$OSVer			 = $Row['OSver']
		$VMFOIP			 = $Row['VMFOIP']
		$VMBOIP			 = $Row['VMBOIP']
		$VMVCPUS		 = $Row['vmvCPUs']
		$VMRAMmb		 = $Row['vmrammb']
		$VMDISKgb		 = $Row['vmdiskgb']
		$VMdatastore	 = $Row['vmdatastore']
		$VMfolder		 = $Row['vmfolder']
		$VMcluster	  	 = $Row['vmcluster']
		$VMresourcepool  = $Row['vmresourcepool']
		$VMsource	 	 = $Row['vmsourcevm']
		$VMdrmode 		 = $Row['vmdrmode']
		
		If($COAction -eq 'C'){ $deploy = $false}
		If($COAction -eq 'D'){ $deploy = $true}
		Write-Host $vmname $OSver $VMFOIP $VMBOIP $VMdatastore $VMfolder $VMcluster $VMresourcepool $deploy $vmsource $VMdrmode $conumber $coaction
		Write-EventLog -LogName "CNO_Automate" -Source "Deploy_VM" -EventID 2101 -Message "Executing Pending Action: VM Deployment ($COAction) `nCO Number: $COnumber `nServer Name: $vmname" -EntryType Information
		$taskid = fnCloneVM $vmname $OSver $VMFOIP $VMBOIP $VMdatastore $VMfolder $VMcluster $VMresourcepool $deploy $vmsource $VMdrmode $conumber $coaction
		Write-EventLog -LogName "CNO_Automate" -Source "Deploy_VM" -EventID 2102 -Message "Executed Pending Action: VM Deployment ($COAction) `nCO Number: $COnumber `nServer Name: $vmname `nvCenter Task ID: $taskid" -EntryType Information
	}
	
	$CNO_Automate = fnGetDataSetVCENTER "Select * from CNO_Automate WHERE COstatus = 'C'"
	ForEach ($Row In $CNO_Automate.Tables[0].Rows){
		#Save the CO# into a variable
		$CONumber		 = $Row['COnumber']
		$COAction 		 = $Row['COaction']
		$VMName			 = $Row['VMName']
		$OSVer			 = $Row['OSver']
		$VMFOIP			 = $Row['VMFOIP']
		$VMBOIP			 = $Row['VMBOIP']
		$VMVCPUS		 = $Row['vmvCPUs']
		$VMRAMmb		 = $Row['vmrammb']
		$VMDISKgb		 = $Row['vmdiskgb']
		$VMdatastore	 = $Row['vmdatastore']
		$VMfolder		 = $Row['vmfolder']
		$VMcluster	  	 = $Row['vmcluster']
		$VMresourcepool  = $Row['vmresourcepool']
		$VMsource	 	 = $Row['vmsourcevm']
		$VMdrmode 		 = $Row['vmdrmode']
		
		If($COAction -eq 'C'){ $deploy = $false}
		If($COAction -eq 'D'){ $deploy = $true}
		Write-EventLog -LogName "CNO_Automate" -Source "Deploy_VM" -EventID 2201 -Message "Executing Pending Action: VM Configuration `nCO Number: $COnumber `nServer Name: $vmname" -EntryType Information
		fnVMConfig $vmname $OSver $VMFOIP $VMBOIP $VMVCPUS $VMRAMmb $VMDISKgb $deploy $VMdrmode $CONumber $COAction
		Write-EventLog -LogName "CNO_Automate" -Source "Deploy_VM" -EventID 2202 -Message "Executed Pending Action: VM Configuration `nCO Number: $COnumber `nServer Name: $vmname" -EntryType Information
	}

	$CNO_Automate = fnGetDataSetVCENTER "Select * from CNO_Automate WHERE COstatus = 'X'"
	ForEach ($Row In $CNO_Automate.Tables[0].Rows){
		#Save the CO# into a variable
		$CONumber		 = $Row['COnumber']
		$COAction 		 = $Row['COaction']
		$VMName			 = $Row['VMName']
		$OSVer			 = $Row['OSver']
		$VMFOIP			 = $Row['VMFOIP']
		$VMBOIP			 = $Row['VMBOIP']
		$VMVCPUS		 = $Row['vmvCPUs']
		$VMRAMmb		 = $Row['vmrammb']
		$VMDISKgb		 = $Row['vmdiskgb']
		$VMdatastore	 = $Row['vmdatastore']
		$VMfolder		 = $Row['vmfolder']
		$VMcluster	  	 = $Row['vmcluster']
		$VMresourcepool  = $Row['vmresourcepool']
		$VMsource	 	 = $Row['vmsourcevm']
		$VMdrmode 		 = $Row['vmdrmode']
		
		$WFCO = "WF"+$CONumber
		New-EventLog -LogName CNO_Automate -Source $WFCO
		
		$SQLReturn = fnSetSqlVCENTER "UPDATE CNO_Automate SET COstatus = 'B', vCTaskID = '' WHERE VMName = '$vmname' AND coAction = '$coaction' AND COnumber = '$conumber'"
	}

	$CNO_Automate = fnGetDataSetVCENTER "Select * from CNO_Automate WHERE COstatus = 'V'"
	ForEach ($Row In $CNO_Automate.Tables[0].Rows){
		#Save the CO# into a variable
		$CONumber		 = $Row['COnumber']
		$COAction 		 = $Row['COaction']
		$VMName			 = $Row['VMName']
		$OSVer			 = $Row['OSver']
		$VMFOIP			 = $Row['VMFOIP']
		$VMBOIP			 = $Row['VMBOIP']
		$VMVCPUS		 = $Row['vmvCPUs']
		$VMRAMmb		 = $Row['vmrammb']
		$VMDISKgb		 = $Row['vmdiskgb']
		$VMdatastore	 = $Row['vmdatastore']
		$VMfolder		 = $Row['vmfolder']
		$VMcluster	  	 = $Row['vmcluster']
		$VMresourcepool  = $Row['vmresourcepool']
		$VMsource	 	 = $Row['vmsourcevm']
		$VMdrmode 		 = $Row['vmdrmode']
		
		$COActionTXT = ""
		
		If($COAction -eq 'C'){
			$deploy = $false
			$COActionTXT  = "Clone from Existing VM"
		}
		If($COAction -eq 'D'){
			$deploy = $true
			$COActionTXT = "New Deploy From Template"
		}
		Write-EventLog -LogName "CNO_Automate" -Source "Deploy_VM" -EventID 2201 -Message "VM Deployment Action Completed `nCO Number: $COnumber `nServer Name: $vmname" -EntryType Information
		
		$mailbody = "
Processing of WF <B>CO#$CONumber</B> has been completed. <BR>
Please validate that the task was executed successfully and advance the workflow.<BR>
<BR>
<BR>
<FONT FACE =""Courier New"">
-- Server: $vmname<BR>
--- Action: $COActionTXT<BR>
--- FO IP: $VMFOIP<BR>
--- BO IP: $VMBOIP<BR>
--- vCPUs: $VMVCPUS<BR>
--- RAM: $VMRAMmb MB<BR>
--- 2nd Disk: $VMDISKgb GB<BR>
--- VMware Info:<BR>
----- Datastore: $VMdatastore<BR>
----- Cluster: $VMcluster<BR>
----- Resource Pool: $VMresourcepool<BR>
----- Clone Source: $VMsource<BR>
----- Template: $OSVer<BR>
</FONT>"

		$smtpServer = "smtp.conseco.com"
		$mailfrom = "WF-Automate <WF-Automate@CNOinc.com>"
		$mailto = "ntadmin@conseco.com"
		$msg = new-object Net.Mail.MailMessage
		$smtp = new-object Net.Mail.SmtpClient($smtpServer) 
		$msg.From = $mailfrom
		$msg.To.Add($mailto) 
		$msg.Subject = "WF Processing Completed - WF#$CONumber"
		$msg.Body = $mailbody
		$msg.IsBodyHTML = $true 
		$smtp.Send($msg)
		$SQLReturn = fnSetSqlVCENTER "UPDATE CNO_Automate SET COstatus = 'Z', vCTaskID = '' WHERE VMName = '$vmname' AND coAction = '$coaction' AND COnumber = '$conumber'"
	}

	
	Start-Sleep 60
}while($true)

Disconnect-VIServer -Confirm:$false
