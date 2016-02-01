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

function fnDeployVMgui()
{
	$vmfolder = $cbxVMFolder.SelectedItem
	$vmcluster = $cbxVMCluster.SelectedItem
	$vmresourcepool = $cbxVMRPool.SelectedItem
	$OS = $cbxVMOS.SelectedItem
	$vmname = $txtVMName.Text
	$OSver = $cbxVMOSVer.SelectedItem
	$vmIPaddress = $mtxtVMFOIP.Text
	$vmBOIPaddress = $mtxtVMBOIP.Text
	$vmvcpus = $nudVMvCPUs.Text
	$vmram = $nudVMRAM.Text
	$vmdisk = $nudVMDDrive.Text
	$vmhost = $cbxVMHost.SelectedItem
	$vmDatastore = $cbxVMDatastore.SelectedItem
	$gui = $true
    $dr = $false
	fnDeployVM $vmname $OS $OSver $vmIPaddress $vmBOIPaddress $vmvcpus $vmram $vmdisk $vmhost $vmdatastore $vmfolder $vmcluster $vmresourcepool $gui $true "None" $dr
	
}

function fnDeployVMfake([string]$vmname, [string]$OS, [string]$OSver, [string]$vmIPaddress, [string]$vmBOIPaddress, [string]$vmvcpus, [string]$vmram, [string]$vmdisk, [string]$vmhost, [string]$vmdatastore, [string]$vmfolder, [string]$vmcluster, [string]$vmresourcepool, $gui, $deploy, [string]$vmsource, $dr)
{
	#region VMInfo
	
	
	
	
	
	$vmIPgateway = $vmIPaddress.Substring(0, $vmIPaddress.IndexOf(".", $vmIPaddress.IndexOf(".", $vmIPaddress.IndexOf(".") + 1) + 1)) + ".1"
	
	$VLAN = $vmIPAddress.Substring(8, 3)
	if ($VLAN -eq "11.") { $VLAN = "11" }
	$VLAN = "VLAN_" + $VLAN
	$vmnetwork = $VLAN
	

	
	#endregion VMInfo
		
	
	Write-Host "VM Name: "$vmname
	Write-Host "VM Folder: " $vmfolder
	Write-Host "VM Cluster: " $vmcluster
	Write-Host "VM Resource Pool: "$vmresourcepool
	Write-Host "VM OS Type: "$OS
	Write-Host "VM OS Version: "$OSver
	Write-Host "VM FO IP: "$vmIPaddress
	Write-Host "VM FO Gateway: "$vmIPgateway
	Write-Host "VM FO VLAN: "$vmnetwork
	Write-Host "VM BO IP: "$vmBOIPaddress
	Write-Host "VM vCPUs: "$vmvcpus
	Write-Host "VM RAM: "$vmram
	Write-Host "VM 2nd Disk Size: "$vmdisk	
	Write-Host "VM Host: "$vmhost	
	Write-Host "VM Datastore: "$vmDatastore
	Write-Host "GUI: "$gui
	Write-Host "New Deploy?: "$deploy
	Write-Host "If Not New Deploy, Source VM: "$vmsource
    Write-Host "DR Mode?: "$dr
}

function fnCloneVM([string]$vmname, [string]$OS, [string]$OSver, [string]$vmIPaddress, [string]$vmBOIPaddress, [string]$vmvcpus, [string]$vmram, [string]$vmdisk, [string]$vmhost, [string]$vmdatastore, [string]$vmfolder, [string]$vmcluster, [string]$vmresourcepool, $gui, $deploy, [string]$vmsource, $dr)
{
	#region VMInfo
	
	
	$vmIPgateway = $vmIPaddress.Substring(0, $vmIPaddress.IndexOf(".", $vmIPaddress.IndexOf(".", $vmIPaddress.IndexOf(".") + 1) + 1)) + ".1"
	

	#endregion VMInfo
		
	Write-Host "VM Name: "$vmname
	Write-Host "VM Folder: " $vmfolder
	Write-Host "VM Cluster: " $vmcluster
	Write-Host "VM Resource Pool: "$vmresourcepool
	Write-Host "VM OS Type: "$OS
	Write-Host "VM OS Version: "$OSver
	Write-Host "VM FO IP: "$vmIPaddress
	Write-Host "VM FO Gateway: "$vmIPgateway
	Write-Host "VM FO VLAN: "$vmnetwork
	Write-Host "VM BO IP: "$vmBOIPaddress
	Write-Host "VM vCPUs: "$vmvcpus
	Write-Host "VM RAM: "$vmram
	Write-Host "VM 2nd Disk Size: "$vmdisk	
	Write-Host "VM Host: "$vmhost	
	Write-Host "VM Datastore: "$vmDatastore
	Write-Host "DR Mode?:" $dr
	
	if (1 -eq 1)
	{	
	
	### No changes beyond this point ###
	
	$Host.UI.RawUI.WindowTitle = "Deploying " + $vmname + "..."
	
	if ($OS -eq "DESK")
	{
		$vmtemplate = "XPUSER"
		$vmAdminPassword = "App317config"
		$vmOSkey = "DPFQJ-RVH2C-QHF3V-229X3-38QK8"
	}
	elseif ($OS -eq "SRV")
	{
	
		$vmAdminPassword = "ZaYbXc351+"
		$vmtemplate = $OSver
				
		if ($OSver -eq "Linux")
		{
			$vmOSkey = "*"
		}
		elseif ($OSver -eq "W2K3R2_Standard_x86")
		{
		$vmtemplate = "W2K3R2_Standard_x86"
		$vmOSkey = "F23CP-PBDP9-FM233-6QWG9-X4XWG"
		}
		elseif ($OSver -eq "W2K3R2-SP2-ENT-X64")
		{
			$vmOSkey = "GFCD9-BVK6B-TMCH6-8P3R3-9267Y"
		}
		elseif ($OSver -eq "W2K3R2-SP2-ENT-X86")
		{
			$vmOSkey = "FHT8G-2T4QP-PJJQ2-8Q7PG-XRCM8"
		}
		elseif ($OSver -eq "W2K3R2-SP2-STD-X86")
		{
			$vmOSkey = "F23CP-PBDP9-FM233-6QWG9-X4XWG"
		}
		elseif ($OSver -eq "W2K3-SP1-ENT-X86")
		{
			$vmOSkey = "P96J2-8DHB4-M8CG4-BQP98-JRG7M"	
		}
		elseif ($OSver -eq "W2K3-SP1-STD-X86")
		{
			$vmOSkey = "J676W-2GHW8-HWTWM-V722W-J22MB"	
		}
		elseif ($OSver -eq "W2K3-SP2-ENT-X64")
		{
			$vmOSkey = "DF9RY-GXKDD-VD39Q-G72XJ-YVQHM"
		}
		elseif ($OSver -eq "W2K3-SP2-ENT-X86")
		{
			$vmOSkey = "FHT8G-2T4QP-PJJQ2-8Q7PG-XRCM8"
		}
		elseif ($OSver -eq "W2K3-SP2-STD-X86")
		{
			$vmOSkey = "F23CP-PBDP9-FM233-6QWG9-X4XWG"
		}
		elseif ($OSver -eq "W2K-SP4-STD-X86")
		{
			$vmOSkey = "VF6JF-FCWW6-M2F3J-KDBDB-K24QG"
		} 
	}
	else
	{
		Write-Error "OS Definition is not valid."
					
	}
	Write-Host "OS Key: " $vmOSkey
	
	#Connect-VIServer -Server $viserver
	$tfld = Get-Folder -Name $vmfolder | Get-View
	
	
	# Create VirtualMachineCloneSpec object
	$vmclonespec = New-Object VMware.Vim.VirtualMachineCloneSpec
	    
	# Construct customization object
	$vmclonespec.Customization = New-Object VMware.Vim.CustomizationSpec
	
	# globalIPSettings
	$vmclonespec.Customization.GlobalIPSettings = New-Object VMware.Vim.CustomizationGlobalIPSettings
	
	# adaptermapping
	if ($OS -eq "SRV")
	{
		$vmclonespec.Customization.NicSettingMap = @((New-Object VMware.Vim.CustomizationAdapterMapping), ( New-Object VMware.Vim.CustomizationAdapterMapping ))
	}
	else
	{
		$vmclonespec.Customization.NicSettingMap = @(New-Object VMware.Vim.CustomizationAdapterMapping)
		$vmclonespec.Customization.NicSettingMap[1].Adapter.Ip = New-Object VMware.Vim.CustomizationDhcpIpGenerator
	}

	if ($OS -eq "SRV")
	{
		# Server Setup - FixedIP
		# Front Office
		$vmclonespec.Customization.NicSettingMap[0].Adapter = New-Object VMware.Vim.CustomizationIPSettings
		$vmclonespec.Customization.NicSettingMap[0].Adapter.Ip = New-Object VMware.Vim.CustomizationFixedIp
		$vmclonespec.Customization.NicSettingMap[0].Adapter.Ip.IpAddress = $vmIPaddress
		$vmclonespec.Customization.NicSettingMap[0].Adapter.SubnetMask = "255.255.255.0"
		$vmclonespec.Customization.NicSettingMap[0].Adapter.Gateway = $vmIPgateway
		$vmclonespec.Customization.NicSettingMap[0].Adapter.DnsServerList = "192.168.1.3", "192.168.83.8"
		$vmclonespec.Customization.NicSettingMap[0].Adapter.dnsDomain = "conseco.ad"
		# No longer supporting new WINS additions, using DNS instead.
		#$vmclonespec.Customization.NicSettingMap[0].Adapter.primaryWINS = "205.144.116.10"
		#$vmclonespec.Customization.NicSettingMap[0].Adapter.secondaryWINS = "205.144.115.10"
		
		# Back Office
		$vmclonespec.Customization.NicSettingMap[1].Adapter = New-Object VMware.Vim.CustomizationIPSettings
		$vmclonespec.Customization.NicSettingMap[1].Adapter.Ip = New-Object VMware.Vim.CustomizationFixedIp
		$vmclonespec.Customization.NicSettingMap[1].Adapter.Ip.IpAddress = $vmBOIPaddress
			
		if ($vmBOIPaddress -like "10.141.*")
		{
			$vmBOSubnet = "255.255.252.0"
			$vmBOVLAN = "VLAN_10"
		}
		elseif ($vmBOIPaddress -like "010.141.*")
		{
			$vmBOSubnet = "255.255.252.0"
			$vmBOVLAN = "VLAN_10"
		}	
		else
		{
			$vmBOSubnet = "255.255.254.0"
			$vmBOVLAN = "VLAN_141"
		}
		$vmclonespec.Customization.NicSettingMap[1].Adapter.SubnetMask = $vmBOSubnet
	}
	
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
	if ($DR)
    {
    $vmclonespec.Customization.Identity.Identification.joinWorkgroup = "CNODR"
    }
    else
    {
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
	if ($OS -eq "SRV")
	{
		$vmclonespec.Customization.Identity.LicenseFilePrintData.AutoMode = "perSeat"
	}
	$vmclonespec.Customization.Identity.GuiRunOnce = New-Object VMware.Vim.CustomizationGuiRunOnce
	$vmclonespec.Customization.Identity.GuiRunOnce.commandList = "c:\Progra~1\NTADMIN\PostTemplateDeployLocal.cmd"
	
	$vmclonespec.powerOn = $false
	$vmclonespec.Template = $false
	
	# Boot options
	$vmclonespec.config = New-Object VMware.Vim.VirtualMachineConfigSpec
	$vmclonespec.Config.bootOptions = New-Object VMware.Vim.VirtualMachineBootOptions
	$vmclonespec.Config.bootOptions.BootDelay = 0
	$vmclonespec.Config.bootOptions.EnterBIOSSetup = $false
	
	$vmclonespec.location = New-Object VMware.Vim.VirtualMachineRelocateSpec
	
	# Target resource pool
	$vmclonespec.location.pool = (get-cluster $vmcluster | Get-ResourcePool -Name $vmresourcepool | Get-View).MoRef
	
	# Target host
	# 	let DRS decide
	#	$vmclonespec.location.host = (Get-vmHost -Name $vmhost | Get-View).MoRef
	
	# Target datastore
	$vmclonespec.location.datastore = (Get-Datastore -Name $vmDatastore | Get-View).MoRef
	
	# Clone from this template
	If($deploy) 
	{ 
		$vm = Get-Template -Name $vmtemplate | Get-View
	}
	else
	{
		$vm = Get-VM -Name $vmsource | Get-View
	}

	
	$task = $vm.CloneVM_Task($tfld.moref, $vmname, $vmclonespec)
	if($dr)
	{
		Set-SQL "UPDATE dbo.NT_DRSERVERINFO SET DRTaskID = '$task.value', DRStatus = 'CLONING' WHERE Server = '$vmname'" "Server = VCENTER.CONSECO.AD; Database = VCENTER; User Id=VCAdmin; Password=vcadm6ev;"
	}
	
if(!$dr)
{
	# Wait till all tasks are finished
	$taskinfo = "Clone Task ID: " + "Task-" + $task.value
	Write-Output $taskinfo
			
if($gui) {	$frmVMDSp.Show()}
		
	$status = Get-Task -Status "running" | where { $_.id -eq "Task-" + $task.value } | select Id, PercentComplete 
	while ($status -ne $null)
	{
		$status = Get-Task -Status "running" | where { $_.id -eq "Task-" + $task.value } | select Id, PercentComplete 
		if ($status -ne $null)
		{
			Write-Progress -id 1 -activity("Deploying VM: " + $vmname) -status("Cloning Template - " + $status.PercentComplete + "% Complete") -percentComplete $status.PercentComplete
			if($gui) {	$prgb1.Value = $status.PercentComplete }
		}
		Start-Sleep 2
	}
	Write-Progress -id 1 -activity("Deploying VM: " + $vmname) -status("Cloning Template - " + $status.PercentComplete + "% Complete") -percentComplete 100
if($gui) {	$prgb1.Value = 100 }
		Start-Sleep 10
		if($gui) {	$frmVMDSp.Close() }
		
	Write-Host $vmname " cloned from template."
}
}
}

function fnVMConfig([string]$vmname, [string]$OS, [string]$OSver, [string]$vmIPaddress, [string]$vmBOIPaddress, [string]$vmvcpus, [string]$vmram, [string]$vmdisk, [string]$vmhost, [string]$vmdatastore, [string]$vmfolder, [string]$vmcluster, [string]$vmresourcepool, $gui, $deploy, [string]$vmsource, $dr)
{
	if($deploy)
	{
		if ($vmdisk -ne -1)
		{
			$vmdiskKB = [Int]$vmdisk * 1048576
			If($dr)
			{
				New-HardDisk -VM(Get-VM $vmname) -CapacityKB $vmdiskKB
				Write-Host $vmname "'s D: added."
			}
		}
	}	
	
		$VLAN = $vmIPAddress.Substring(8, 3)
		if ($VLAN -eq "11.") { $VLAN = "11" }
		if ($vmIPAddress.Substring(5,3) -eq ".2.") { $VLAN = "2" }
		if ($vmIPAddress.Substring(5,3) -eq ".3.") { $VLAN = "3" }
		$VLAN = "VLAN_" + $VLAN
		$vmnetwork = $VLAN
		
		if ($vmBOIPaddress -like "10.141.*")
		{
			$vmBOSubnet = "255.255.252.0"
			$vmBOVLAN = "VLAN_10"
		}
		elseif ($vmBOIPaddress -like "010.141.*")
		{
			$vmBOSubnet = "255.255.252.0"
			$vmBOVLAN = "VLAN_10"
		}	
		else
		{
			$vmBOSubnet = "255.255.254.0"
			$vmBOVLAN = "VLAN_141"
		}
	
		Get-NetworkAdapter -VM(Get-VM $vmname) | where { $_.Name -eq "Network Adapter 1" } | Set-NetworkAdapter -NetworkName $vmnetwork -confirm:$false
		Write-Host $vmname "'s NIC1 set."
		Get-NetworkAdapter -VM(Get-VM $vmname) | where { $_.Name -eq "Network Adapter 2" } | Set-NetworkAdapter -NetworkName $vmBOVLAN -confirm:$false
		Write-Host $vmname "'s NIC2 set."
	
	if($deploy)
	{
		Get-VM $vmname | Set-VM -MemoryMB $vmram -Confirm:$false
		Write-Host $vmname "'s RAM set."
		Get-VM $vmname | Set-VM -NumCPU $vmvcpus -Confirm:$false
		Write-Host $vmname "'s CPUs set."
	}
	
		Get-VM $vmname | Start-VM
	if($dr)
	{
		Write-Host $vmname "deployed in DR Mode."
	}
	else
	{
		Write-Host $vmname "deployed. Waiting 5 minutes to continue AD group & Computer object setup."
	
		Start-Sleep -Seconds 300
		
		new-qadGroup -ParentContainer 'OU=Server Groups,OU=UserGroups,DC=conseco,DC=ad' -name ("NTSrv - " + $vmname + " - Administrators") -samAccountName ("NTSrv - " + $vmname + " - Administrators") -grouptype 'Security' -groupscope 'Universal'
		new-qadGroup -ParentContainer 'OU=Server Groups,OU=UserGroups,DC=conseco,DC=ad' -name ("NTSrv - " + $vmname + " - Power Users") -samAccountName ("NTSrv - " + $vmname + " - Power Users") -grouptype 'Security' -groupscope 'Universal'
		new-qadGroup -ParentContainer 'OU=Server Groups,OU=UserGroups,DC=conseco,DC=ad' -name ("NTSrv - " + $vmname + " - RDP Users") -samAccountName ("NTSrv - " + $vmname + " - RDP Users") -grouptype 'Security' -groupscope 'Universal'
		
		move-qadobject ("CONSECO\" + $vmname +"$") -NewParentContainer 'CONSECO.AD/Windows Servers'	  
	
		Write-Host $vmname "setup."
	}
}

function fnDeployVM([string]$vmname, [string]$OS, [string]$OSver, [string]$vmIPaddress, [string]$vmBOIPaddress, [string]$vmvcpus, [string]$vmram, [string]$vmdisk, [string]$vmhost, [string]$vmdatastore, [string]$vmfolder, [string]$vmcluster, [string]$vmresourcepool, $gui, $deploy, [string]$vmsource, $dr)
{
	fnCloneVM $vmname $OS $OSver $vmIPaddress $vmBOIPaddress $vmvcpus $vmram $vmdisk $vmhost $vmdatastore $vmfolder $vmcluster $vmresourcepool $gui $deploy $vmsource $dr
	if(!$dr)
	{
	fnVMConfig $vmname $OS $OSver $vmIPaddress $vmBOIPaddress $vmvcpus $vmram $vmdisk $vmhost $vmdatastore $vmfolder $vmcluster $vmresourcepool $gui $deploy $vmsource $dr
	}
}

function fnVMClusterChange1($object)
{

	$cbxVMHost.DataSource = Get-Cluster -name $cbxVMCluster.SelectedValue | Get-VMHost | Sort-Object -property Name
	$cbxVMHost.SelectedIndex = -1
	$cbxVMHost.Enabled = 1
	$cbxVMRPool.Enabled = 0
	$cbxVMDataStore.Enabled = 0
}

function fnVMHostChange1($object)
{
	if ($cbxVMHost.Enabled -eq 1)
	{
		$cbxVMRPool.DataSource = Get-VMHost -name $cbxVMHost.SelectedValue | Get-ResourcePool | Sort-Object -property Name
		$cbxVMRPool.SelectedIndex = -1
		$cbxVMRPool.Enabled = 1	
		$cbxVMDatastore.DataSource = Get-VMHost -name $cbxVMHost.SelectedValue | Get-Datastore | Sort-Object -property Name
		$cbxVMDatastore.SelectedIndex = -1
		$cbxVMDataStore.Enabled = 1
	}
}


#  Test: is the VITK snapin available ?
#  Test: is the VITK snapin loaded ?
#  Test: is the installed VITK of the correct build

function load-VITK()
{
	& {
		$ErrorActionPreference = "silentlycontinue"
		Add-PSSnapin "Quest.ActiveRoles.ADManagement"
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

function fnInitial()
{
	load-VITK
	Connect-VIServer -Server "vcenter.conseco.ad"
	$cbxVMFolder.DataSource = Get-Folder | Sort-Object -property Name
	$cbxVMFolder.SelectedIndex = -1
	$cbxVMCluster.DataSource = Get-Cluster | Sort-Object -property Name
	$cbxVMCluster.SelectedIndex = -1
	$cbxVMHost.Enabled = 0
	$cbxVMRPool.Enabled = 0
	$cbxVMDatastore.Enabled = 0
	$frmVDSstart.Close()	
}
