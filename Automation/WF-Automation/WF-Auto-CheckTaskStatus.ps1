# CONSECO - Windows Server Administration 
# * Workflow Automation - Check vCenter Task Status *
# ** Last Modified: 2010/02/25 @ 16:19 by LANJ6P (Pawlak, Jakub P)
# ** Usage: Schedule to run continously as a user with access to 
# **        vCenter
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



#Connect to Virutal Center
load-VITK
Connect-VIServer -Server "vcenter.conseco.ad"
#Connect-VIServer -Server "view4vc.conseco.ad"
$PAZero = 0
$Host.UI.RawUI.WindowTitle = "CNO WF Automate - vCenter Running Tasks Check"
do{
	$CNO_Automate = fnGetDataSetVCENTER "Select * from CNO_Automate WHERE COstatus = 'W'"
	$PendingActions = $CNO_Automate.Tables[0].Rows.Count
	
	If($PendingActions -eq 0){
		If($PAZero%10 -eq 0){
			Write-EventLog -LogName "CNO_Automate" -Source "Check_vcTask" -EventID 2001 -Message "Polling Automation Database for Pending Actions with Running vCenter Tasks - Last Ten Polls Returned Zero Records" -EntryType Information
		}
		$PAZero++
	}else{
		Write-EventLog -LogName "CNO_Automate" -Source "Check_vcTask" -EventID 2001 -Message "Polling Automation Database for Pending Actions with Running vCenter Tasks - Actions Pending: $PendingActions" -EntryType Information
	}
	ForEach ($Row In $CNO_Automate.Tables[0].Rows)	{
		$TaskId = $Row['vcTaskId']
		$CONumber = $Row['COnumber']
		$Task = Get-Task | Where {$_.id -eq $TaskId }
		$vmname = $Row['vmname']
		$State = $Task.State
		$WF = "WF" + $CONumber
		Write-Host "$vmname [CO: $CONumber] - Task ID: $TaskID - Status: $State"

		If($TaskId -eq "Task-"){
		#Write-Host "Task Failed for VM $vmname"  -foregroundcolor "Red"
		$SQLReturn = fnSetSqlVCENTER "UPDATE CNO_Automate SET COstatus = 'E' WHERE vCTaskID = '$TaskId' AND VMNAME = '$vmname'" 		
		Write-EventLog -LogName "CNO_Automate" -Source $WF -EventID 2903 -Message "Pending Action Updated: VM Deployment - Clone Task FAILED `nCO Number: $COnumber `nServer Name: $vmname `nvCenter Task ID: $taskid" -EntryType Error
		#$SQLReturn = Set-SQL "UPDATE dbo.NT_DRSERVERINFO SET DRStatus = 'ERROR' WHERE Server = '$vmname'" "Server = VCENTER.CONSECO.AD; Database = NTDR; User Id=VCAdmin; Password=vcadm6ev;"
		}

		If($Task.State -eq "Success"){
		$SQLReturn = fnSetSqlVCENTER "UPDATE CNO_Automate SET COstatus = 'C' WHERE vCTaskID = '$TaskId' AND VMNAME = '$vmname'" 		
		Write-EventLog -LogName "CNO_Automate" -Source $WF -EventID 2902 -Message "Pending Action Updated: VM Deployment - Clone Task Complete `nCO Number: $COnumber `nServer Name: $vmname `nvCenter Task ID: $taskid" -EntryType Information
		#$SQLReturn = Set-SQL "UPDATE dbo.NT_DRSERVERINFO SET DRStatus = 'RDYCFG' WHERE Server = '$vmname'" "Server = VCENTER.CONSECO.AD; Database = NTDR; User Id=VCAdmin; Password=vcadm6ev;"
		}
		If($Task.State -eq "Error"){
		#Write-Host "Task Failed for VM $vmname"  -foregroundcolor "Red"
		$SQLReturn = fnSetSqlVCENTER "UPDATE CNO_Automate SET COstatus = 'E' WHERE vCTaskID = '$TaskId' AND VMNAME = '$vmname'" 		
		Write-EventLog -LogName "CNO_Automate" -Source $WF -EventID 2903 -Message "Pending Action Updated: VM Deployment - Clone Task FAILED `nCO Number: $COnumber `nServer Name: $vmname `nvCenter Task ID: $taskid" -EntryType Error
		#$SQLReturn = Set-SQL "UPDATE dbo.NT_DRSERVERINFO SET DRStatus = 'ERROR' WHERE Server = '$vmname'" "Server = VCENTER.CONSECO.AD; Database = NTDR; User Id=VCAdmin; Password=vcadm6ev;"
		}	
		If($Task.State -eq "Running"){
		$PercentComplete = $Task.PercentComplete
		#Write-Host "Task Running for VM $vmname ["$Task.PercentComplete"% Complete]" -foregroundcolor "Yellow"
		#$TPC = $Task.PercentComplete
		#$SQLReturn = Set-SQL "UPDATE dbo.NT_DRSERVERINFO SET DRStatus = 'CLORUN', DRClonePercent = $TPC WHERE Server = '$vmname'" "Server = VCENTER.CONSECO.AD; Database = NTDR; User Id=VCAdmin; Password=vcadm6ev;"
		Write-EventLog -LogName "CNO_Automate" -Source $WF -EventID 2902 -Message "Pending Action Updated: VM Deployment - Clone Task Running - $PercentComplete% Complete  `nCO Number: $COnumber `nServer Name: $vmname `nvCenter Task ID: $taskid" -EntryType Information
		}
		If($Task.State -eq "Queued"){
		#Write-Host "Task Queued for VM $vmname" -foregroundcolor "Cyan"
		#$SQLReturn = Set-SQL "UPDATE dbo.NT_DRSERVERINFO SET DRStatus = 'CLOQUE' WHERE Server = '$vmname'" "Server = VCENTER.CONSECO.AD; Database = NTDR; User Id=VCAdmin; Password=vcadm6ev;"
		}			
	}
	Start-Sleep 60
}while($true)

$SqlConnection.Close();
Disconnect-VIServer -Confirm:$false
