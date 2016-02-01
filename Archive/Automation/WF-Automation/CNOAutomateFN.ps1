# CONSECO - Windows Server Administration 
# * CNO Automate - Powershell Functions File  *
# ** Last Modified: 2010/10/27 @ 22:51 by LANJ6P (Pawlak, Jakub P)

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
function fnGetDataSetCNOAutomate([string]$SQL){
	$SqlServer = "VCENTER.CONSECO.AD";
	$SqlDatabase = "CNO_Automate";
	$SqlSecurity = "Integrated Security=SSPI;"
	
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
function fnSetSqlCNOAutomate([string]$Query){
return Set-SQL $Query "Server = VCENTER.CONSECO.AD; Database = CNO_Automate; Integrated Security=SSPI;"
}

function fnUpdateStatus([string]$CNOAutomateID, [string]$Status){
return fnSetSQLCNOAutomate "exec sp_UpdateStatus '$CNOAutomateID','$Status'"
}

function fnLogEntry([string]$CNOAutomateID, [string]$WIAction, [string]$Log){
$strSQL = "exec sp_LogEntry '" + $CNOAutomateID +"','"+$WIAction+"','"+$Log+"'"
return fnSetSQLCNOAutomate $strSQL
}

function fnVMNetwork([string]$vmIPaddress){
	if ($vmIPaddress.Substring(0,5) -eq "10.11"){
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
function VMAddNIC($CNOAutomateID){
If($CNOAutomateID -ge 0){
	fnLogEntry $CNOAutomateID "A" "WI: VM: Add NIC Task Beginning <via PowerShell>"
	fnLogEntry $CNOAutomateID "A" "WI: VM: PS <VMAddNIC> [CNOAutomateFN.PS1]"
	$strSQL = "exec sp_GetWorkItem_VM '" + $CNOAutomateID +"'"
	Write-Host $strSQL
	$CNO_Automate = fnGetDataSetCNOAutomate $strSQL
	If($CNO_Automate.Tables[0].Rows.Count -gt 0){
		$Row = $CNO_Automate.Tables[0].Rows[0]
		$vmname = $Row['VMName']
		$vmBOIPaddress = $Row['VMBOIP']
		
		fnLogEntry $CNOAutomateID 'A' "WI: VM: Retrieved Server Info -> $vmname / $vmBOIPaddress  <via PowerShell>"
		New-NetworkAdapter -VM (Get-VM $vmname) -NetworkName "VLAN_10" -Type "vmxnet3" -StartConnected
		fnLogEntry $CNOAutomateID "A" "WI: VM: Added NIC <via PowerShell>"
		
	}
	fnLogEntry $CNOAutomateID "A" "WI: VM: Add NIC Task Complete <via PowerShell>"
	
	Trap {
	
	Write-Error $_.Exception.Message
	fnLogEntry $CNOAutomateID "A" "WI: VM: Error: $_.Exception.Message"
	fnUpdateStatus $CNOAutomateID "E"
	}
}
}
function VMChangeVLAN($CNOAutomateID){
If($CNOAutomateID -ge 0){
	fnLogEntry $CNOAutomateID "A" "WI: VM: Update VLANs Task Beginning <via PowerShell>"
	fnLogEntry $CNOAutomateID "A" "WI: VM: PS <VMChangeVLAN> [CNOAutomateFN.PS1]"
	$strSQL = "exec sp_GetWorkItem_VM '" + $CNOAutomateID +"'"
	Write-Host $strSQL
	$CNO_Automate = fnGetDataSetCNOAutomate $strSQL
	If($CNO_Automate.Tables[0].Rows.Count -gt 0){
		$Row = $CNO_Automate.Tables[0].Rows[0]
		$vmname = $Row['VMName']
		$vmIPaddress = $Row['VMFOIP']
		$OS = $Row['OSver']

	fnLogEntry $CNOAutomateID 'A' "WI: VM: Retrieved Server Info -> $vmname / $vmIPaddress / $OS <via PowerShell>"

		If($OSver -like 'WXP*'){
			$vmFOVLAN = "VLAN_210"
		}else{
			$vmBOSubnet = "255.255.252.0"
			$vmBOVLAN = "VLAN_10"
			$vmFOVLAN = fnVMNetwork $vmIPaddress
			Get-NetworkAdapter -VM(Get-VM $vmname) | where { $_.Name -eq "Network Adapter 2" } | Set-NetworkAdapter -NetworkName $vmBOVLAN -confirm:$false
		}
		Get-NetworkAdapter -VM(Get-VM $vmname) | where { $_.Name -eq "Network Adapter 1" } | Set-NetworkAdapter -NetworkName $vmFOVLAN -StartConnected:$true -confirm:$false
		
		fnLogEntry $CNOAutomateID "A" "WI: VM: VLANs Update FO -> $vmFOVLAN / BO -> $vmBOVLAN <via PowerShell>"
		
	}
	fnLogEntry $CNOAutomateID "A" "WI: VM: Update VLANs Task Complete <via PowerShell>"
	
	Trap {
	
	Write-Error $_.Exception.Message
	fnLogEntry $CNOAutomateID "A" "WI: VM: Error: $_.Exception.Message"
	fnUpdateStatus $CNOAutomateID "E"
	}
}
}
function AddVMDisk($CNOAutomateID){
If($CNOAutomateID -ge 0){
	fnLogEntry $CNOAutomateID "C" "WI: VM: Add VM Disk Task Beginning <via PowerShell>"
	fnLogEntry $CNOAutomateID "C" "WI: VM: PS <AddVMDisk> [CNOAutomateFN.PS1]"
	$strSQL = "exec sp_GetWorkItem_VM '" + $CNOAutomateID +"'"
	Write-Host $strSQL
	$CNO_Automate = fnGetDataSetCNOAutomate $strSQL
	If($CNO_Automate.Tables[0].Rows.Count -gt 0){
		$Row = $CNO_Automate.Tables[0].Rows[0]
		$vmname = $Row['VMName']
		$vmdiskgb = $Row['vmdiskgb']
		fnLogEntry $CNOAutomateID 'A' "WI: VM: Retrieved Server Info -> $vmname / $vmdiskgb GB <via PowerShell>"
		$vmdiskKB = [Int]$vmdiskgb * 1048576
		New-HardDisk -VM(Get-VM $vmname) -CapacityKB $vmdiskKB
		fnLogEntry $CNOAutomateID "C" "WI: VM: Added Disk <via PowerShell>"
	}
	fnLogEntry $CNOAutomateID "C" "WI: VM: Add VM Disk Task Complete <via PowerShell>"
	
	Trap {
	Write-Error $_.Exception.Message
	fnLogEntry $CNOAutomateID "C" "WI: VM: Error: $_.Exception.Message"
	fnUpdateStatus $CNOAutomateID "E"
	}
}
}
function PowerOn($CNOAutomateID){
If($CNOAutomateID -ge 0){
	fnLogEntry $CNOAutomateID "H" "WI: VM: Power On Task Beginning <via PowerShell>"
	fnLogEntry $CNOAutomateID "H" "WI: VM: PS <PowerOn> [CNOAutomateFN.PS1]"
	$strSQL = "exec sp_GetWorkItem_VM '" + $CNOAutomateID +"'"
	Write-Host $strSQL
	$CNO_Automate = fnGetDataSetCNOAutomate $strSQL
	If($CNO_Automate.Tables[0].Rows.Count -gt 0){
		$Row = $CNO_Automate.Tables[0].Rows[0]
		$vmname = $Row['VMName']
		fnLogEntry $CNOAutomateID "H" "WI: VM: Retrieved Server Info -> $vmname <via PowerShell>"
		$vmdiskKB = [Int]$vmdiskgb * 1048576
		$Task = Get-VM $vmname | Start-VM
		fnLogEntry $CNOAutomateID "H" "WI: VM: Powering On VM <via PowerShell>"
	}
	fnLogEntry $CNOAutomateID "H" "WI: VM: Power On Complete <via PowerShell>"
	
	Trap {
	Write-Error $_.Exception.Message
	fnLogEntry $CNOAutomateID "H" "WI: VM: Error: $_.Exception.Message"
	fnUpdateStatus $CNOAutomateID "E"
	}
}
}
function ExtendVMDisk($CNOAutomateID){
If($CNOAutomateID -ge 0){
	fnLogEntry $CNOAutomateID "C" "WI: VM: Extend VM Disk Task Beginning <via PowerShell>"
	fnLogEntry $CNOAutomateID "C" "WI: VM: PS <ExtendVMDisk> [CNOAutomateFN.PS1]"
	$strSQL = "exec sp_GetWorkItem_VM '" + $CNOAutomateID +"'"
	#Write-Host $strSQL
	$CNO_Automate = fnGetDataSetCNOAutomate $strSQL
	If($CNO_Automate.Tables[0].Rows.Count -gt 0){
		$Row = $CNO_Automate.Tables[0].Rows[0]
		$vmname = $Row['VMName']
		$vmdiskgb = $Row['vmdiskgb']
		$helperVM = $Row['helpervm']
		fnLogEntry $CNOAutomateID 'A' "WI: VM: Retrieved Server Info -> $vmname / $vmdiskgb GB / Helper: $helpervm <via PowerShell>"
		$vmdiskKB = [Int]$vmdiskgb * 1048576


		$disks = Get-HardDisk -vm (Get-VM $vmname)
		if($disks.count -eq 2)
		{
			fnLogEntry $CNOAutomateID 'A' "WI: VM: VM has two hard disks [VALID] <via PowerShell>"
			foreach ($disk in $disks) 
			{ 
				if($disk.CapacityKB -ne 25165824 -and $disk.CapacityKB -ne 33554432)
				{
					$disksize = $disk.CapacityKB / 1048567
					fnLogEntry $CNOAutomateID 'A' "WI: VM: Found non-system disk [VALID {Size:$disksize} ] <via PowerShell>"
					$Helper = Get-VM $helperVM 
					If($Helper.PowerState -ne "PoweredOff")
					{
						$Helper | Shutdown-VMGuest -Confirm:$false
						Sleep 120
					}
					$Result = Set-HardDisk -HardDisk $disk -CapacityKB $vmdiskKB -HostUser 'root' -HostPassword 'delta347#' -GuestUser 'administrator' -GuestPassword 'dolphins2004' -HelperVM (Get-VM -Name $helperVM)
					fnLogEntry $CNOAutomateID 'A' "WI: VM: Disk expanded. <via PowerShell>"
					fnLogEntry $CNOAutomateID 'A' "WI: VM: Log: " + $Result.ToString()
					}
				
			}
		}else{
			fnLogEntry $CNOAutomateID 'A' "WI: VM: VM does not have two hard disks [INVALID] <via PowerShell>"
			fnUpdateStatus $CNOAutomateID "E"
		}	
				
		fnLogEntry $CNOAutomateID "C" "WI: VM: Extend Disk <via PowerShell>"
	}
	fnLogEntry $CNOAutomateID "C" "WI: VM: Extend VM Disk Task Complete <via PowerShell>"
	
	Trap {
	Write-Error $_.Exception.Message
	fnLogEntry $CNOAutomateID "C" "WI: VM: Error: $_.Exception.Message"
	fnUpdateStatus $CNOAutomateID "E"
	}
}
}
function PostDeploy($CNOAutomateID){
If($CNOAutomateID -ge 0){
	fnLogEntry $CNOAutomateID "Q" "WI: VM: Post Deploy Task Beginning <via PowerShell>"
	fnLogEntry $CNOAutomateID "Q" "WI: VM: PS <PostDeploy> [CNOAutomateFN.PS1]"
	$strSQL = "exec sp_GetWorkItem_VM '" + $CNOAutomateID +"'"
	Write-Host $strSQL
	$CNO_Automate = fnGetDataSetCNOAutomate $strSQL
	If($CNO_Automate.Tables[0].Rows.Count -gt 0){
		$Row = $CNO_Automate.Tables[0].Rows[0]
		$vmname = $Row['VMName']
		$OSver = $Row['OSver']
		$vmBOIPaddress = $Row['VMBOIP']
		if($Row['VMdrmode'] -eq 0) {
			$DR = $false
		}else{
			$DR = $true
		}
		
		$vm = Get-VM $vmname
		fnLogEntry $CNOAutomateID "Q" "WI: VM: Retrieved Server Info -> $vmname / $OSver <via PowerShell>"
		$NIC1 = Get-NetworkAdapter $vm | Where {$_.NetworkName -ne "VLAN_10"}
		$VMNIC1MAC = $NIC1.MacAddress
		fnLogEntry $CNOAutomateID "Q" "WI: VM: Retrieved Server Info -> Front Office NIC Mac Address: $VMNIC1MAC <via PowerShell>"
		$NIC2 = Get-NetworkAdapter $vm | Where {$_.NetworkName -eq "VLAN_10"}
		$VMNIC2MAC = $NIC2.MacAddress
		fnLogEntry $CNOAutomateID "Q" "WI: VM: Retrieved Server Info -> Back Office NIC Mac Address: $VMNIC2MAC <via PowerShell>"

		$OSverX = "XP"
		If($OSver -contains "W2K8"){
			If($OSver -contains "X64") { $OSverX = "X64" }
			If($OSver -contains "X86") { $OSverX = "X86" }
		}
		
		If(!$DR){
			#Standard Mode -- Running at Conseco Live
			$FCPS = Copy-VMGuestFile -Source "\\NTADMINP01.CONSECO.AD\NTADMIN\POWERSHELL\AUTOMATION\VM.PostDeploySetupOnVM.ps1" -Destination c:\windows\temp\ -VM $VM -LocalToGuest -HostUser root -HostPassword "delta347#" -GuestUser "conseco\synt_service_account" -GuestPassword "autoup"
			fnLogEntry $CNOAutomateID "Q" "WI: VM: Copied PostConfig Setup File $FCPS <via PowerShell>"
			$FCNV = Copy-VMGuestFile -Source "\\NTADMINP01.CONSECO.AD\SOFTWARE\Microsoft\NVSPBIND\$OSverX\nvspbind.exe" -Destination c:\windows\temp\ -VM $VM -LocalToGuest -HostUser root -HostPassword "delta347#" -GuestUser "conseco\synt_service_account" -GuestPassword "autoup"
			fnLogEntry $CNOAutomateID "Q" "WI: VM: Copied NVSPBIND File $FCNV <via PowerShell>"
			fnLogEntry $CNOAutomateID "Q" "WI: VM: Will Execute: c:\windows\temp\VM.PostDeploySetupOnVM.ps1 $vmBOIPaddress $VMNIC1MAC $VMNIC2MAC $OSVER"
			$VSPC = Invoke-VMScript -VM $VM -HostUser root -HostPassword "delta347#" -GuestUser 'CONSECO\SyNT_Service_Account' -GuestPassword 'autoup' -ScriptType Powershell  -ScriptText "c:\windows\temp\VM.PostDeploySetupOnVM.ps1 $vmBOIPaddress $VMNIC1MAC $VMNIC2MAC $OSVER"
			fnLogEntry $CNOAutomateID "Q" "WI: VM: Executed PostConfig Setup File $FCPS <via PowerShell>"
			
		}else{
			#DR Mode -- Running in Recovery Mode -- No Domain Connectivity.
			$FilePathDR = "c:\CNO_Automate_DR"
					
			$FCPS = Copy-VMGuestFile -Source "$FilePathDR\VM.PostDeploySetupOnVM.ps1" -Destination c:\windows\temp\ -VM $VM -LocalToGuest -HostUser root -HostPassword "delta347#" -GuestUser 'administrator' -GuestPassword 'ZaYbXc351+'
			fnLogEntry $CNOAutomateID "Q" "WI: VM: Copied PostConfig Setup File $FCPS <via PowerShell>"
			$FCNV = Copy-VMGuestFile -Source "$FilePathDR\NVSPBIND\$OSverX\nvspbind.exe" -Destination c:\windows\temp\ -VM $VM -LocalToGuest -HostUser root -HostPassword "delta347#" -GuestUser 'administrator' -GuestPassword 'ZaYbXc351+'
			fnLogEntry $CNOAutomateID "Q" "WI: VM: Copied NVSPBIND File $FCNV <via PowerShell>"
			$VSPC = Invoke-VMScript -VM $VM -HostUser root -HostPassword "delta347#" -GuestUser 'administrator' -GuestPassword 'ZaYbXc351+' -ScriptType Powershell  -ScriptText "c:\windows\temp\VM.PostDeploySetupOnVM.ps1 $vmBOIPaddress $VMNIC1MAC $VMNIC2MAC $OSVER"
			fnLogEntry $CNOAutomateID "Q" "WI: VM: Executed PostConfig Setup File $FCPS <via PowerShell>"
		}
	}
	fnLogEntry $CNOAutomateID "Q" "WI: VM: Post Deploy Task Complete <via PowerShell>"
	
	Trap {
	Write-Error $_.Exception.Message
	fnLogEntry $CNOAutomateID "Q" "WI: VM: Error: $_.Exception.Message"
	fnUpdateStatus $CNOAutomateID "E"
	}
}
}

