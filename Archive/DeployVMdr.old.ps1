#deploy [vmname] [osver] [foip] [fogw] [boip] [vcpus] [rammb] [ddrvgb] [vmhost] [vmdatastore]





#region VMInfo
$vmfolder = "DR" 		
$vmcluster = "phi" 		
$vmresourcepool = "1. PROD" 	
$viserver = "172.31.9.100"

$OS = "SRV" # SRV or DESK [OS Type]
$vmname = $args[0]
$OSver =  $args[1] # OS version - W2K, W2K3, W2K3R2
$vmIPaddress = $args[2]
$vmIPgateway = $args[3]
$vmBOIPaddress = $args[4]
$vmvcpus = $args[5]
$vmram = $args[6]
$vmdisk = $args[7] # 2nd Disk in GB
$vmhost = $args[8]
$vmDatastore = $args[9]

$VLAN = $vmIPAddress.Substring(8,3)
If($VLAN -eq "11.") { $VLAN = "11" }
$VLAN = "VLAN_" + $VLAN
$vmnetwork = $VLAN

#endregion VMInfo

##region VMInfo
#$OS = "SRV" # SRV or DESK [OS Type]
#$OSver = "W2K-SP1-STD-X86" # OS version - W2K, W2K3, W2K3R2
#$vmname = "NTEXBESP01" 					
#$vmIPaddress = "192.168.200.168"
#$vmIPgateway = "192.168.200.1"
#$vmBOIPaddress = "10.141.0.182"
#$vmnetwork = "VLAN_200"
#$vmvcpus = 1
#$vmram = 2048
#$vmdisk = 10240 # 2nd Disk in MB
##endregion VMInfo

##region VMLocation
#$vmfolder = "DR" 		
#$vmcluster = "phi" 											
#$vmhost = "esx04" 					
#$vmDatastore = "VMwareProd1" 							
#$vmresourcepool = "DR" 							
##endregion VMLocation

### No changes beyond this point ###

if ($OS -eq "DESK") 
{
	$vmtemplate = "XPUSER02"
	$vmAdminPassword = "App317config"
	$vmOSkey = "DPFQJ-RVH2C-QHF3V-229X3-38QK8"
} 
elseif ($OS -eq "SRV") 
{
#W2K3R2-SP2-ENT-X86
#W2K3R2-SP2-STD-X86	#Match
#W2K3-SP1-ENT-X86
#W2K3-SP1-STD-X86
#W2K3-SP2-ENT-X64	#Match
#W2K3-SP2-ENT-X86	#Match
#W2K3-SP2-STD-X86	#Match
#W2K8-SP1-STD-X64	#No VM Templates
#W2K-SP4-STD-X86	#Match

	
	
	$vmAdminPassword = "ZaYbXc351+"
	$vmtemplate = $OSver

	if ($OSver -eq "Linux") 
	{
		$vmOSkey = "*"
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

Connect-VIServer -Server $viserver
$tfld = Get-Folder -Name $vmfolder | Get-View


# Create VirtualMachineCloneSpec object
$vmclonespec = New-Object VMware.Vim.VirtualMachineCloneSpec
    
# Construct customization object
$vmclonespec.Customization = New-Object VMware.Vim.CustomizationSpec

# globalIPSettings
$vmclonespec.Customization.GlobalIPSettings = New-Object VMware.Vim.CustomizationGlobalIPSettings

# adaptermapping
if ($OS -eq "SRV") {
$vmclonespec.Customization.NicSettingMap = @((New-Object VMware.Vim.CustomizationAdapterMapping), ( New-Object VMware.Vim.CustomizationAdapterMapping ))
} else {
$vmclonespec.Customization.NicSettingMap = @(New-Object VMware.Vim.CustomizationAdapterMapping)
}
# Front Office - FixedIP
$vmclonespec.Customization.NicSettingMap[0].Adapter = New-Object VMware.Vim.CustomizationIPSettings
$vmclonespec.Customization.NicSettingMap[0].Adapter.Ip = New-Object VMware.Vim.CustomizationFixedIp
$vmclonespec.Customization.NicSettingMap[0].Adapter.Ip.IpAddress = $vmIPaddress
$vmclonespec.Customization.NicSettingMap[0].Adapter.SubnetMask = "255.255.255.0"
$vmclonespec.Customization.NicSettingMap[0].Adapter.Gateway = $vmIPgateway
$vmclonespec.Customization.NicSettingMap[0].Adapter.DnsServerList = "192.168.202.152", "192.168.83.8", "192.168.1.3"
$vmclonespec.Customization.NicSettingMap[0].Adapter.primaryWINS = "205.144.116.10"
$vmclonespec.Customization.NicSettingMap[0].Adapter.secondaryWINS = "205.144.115.10"
if ($OS -eq "SRV") {
# Back Office - DHCP IP
# $vmclonespec.Customization.NicSettingMap[1].Adapter.Ip = New-Object VMware.Vim.CustomizationDhcpIpGenerator
# Back Office - FixedIP
$vmclonespec.Customization.NicSettingMap[1].Adapter = New-Object VMware.Vim.CustomizationIPSettings
$vmclonespec.Customization.NicSettingMap[1].Adapter.Ip = New-Object VMware.Vim.CustomizationFixedIp
$vmclonespec.Customization.NicSettingMap[1].Adapter.Ip.IpAddress = $vmBOIPaddress
$vmclonespec.Customization.NicSettingMap[1].Adapter.SubnetMask = "255.255.252.0"
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
$vmclonespec.Customization.Identity.Identification.DomainAdminPassword = New-Object VMware.Vim.CustomizationPassword
$vmclonespec.Customization.Identity.Identification.DomainAdminPassword.PlainText = 1
$vmclonespec.Customization.Identity.Identification.DomainAdminPassword.Value = "autoup"
$vmclonespec.Customization.Identity.Identification.DomainAdmin = "synt_service_account"
$vmclonespec.Customization.Identity.Identification.joinDomain = "conseco.ad"

# Userdata
$vmclonespec.Customization.Identity.UserData = New-Object VMware.Vim.CustomizationUserData
$vmclonespec.Customization.Identity.UserData.ComputerName = New-Object VMware.Vim.CustomizationFixedName
$vmclonespec.Customization.Identity.UserData.ComputerName.Name = $vmname
$vmclonespec.Customization.Identity.UserData.FullName = "Conseco Services, LLC"
$vmclonespec.Customization.Identity.UserData.OrgName = "Conseco Services, LLC"
$vmclonespec.Customization.Identity.UserData.ProductId = $vmOSkey

$vmclonespec.Customization.Identity.LicenseFilePrintData = New-Object VMware.Vim.CustomizationLicenseFilePrintData
$vmclonespec.Customization.Identity.LicenseFilePrintData.AutoMode = New-Object VMware.Vim.CustomizationLicenseDataMode
if ($OS -eq "SRV") {
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
$vmclonespec.location.host = (Get-vmHost -Name $vmhost | Get-View).MoRef

# Target datastore
$vmclonespec.location.datastore = (Get-Datastore -Name $vmDatastore | Get-View).MoRef

# Clone from this template
$vm = Get-Template -Name $vmtemplate | Get-View

$task = $vm.CloneVM_Task($tfld.moref, $vmname, $vmclonespec)

# Wait till all tasks are finished
$taskinfo = "Clone Task ID: "+"Task-"+$task.value
Write-Output $taskinfo

$status = Get-Task -Status "running" | Where {$_.id -eq "Task-"+$task.value} | select Id, PercentComplete 
while ($status -ne $null)
{
	$status = Get-Task -Status "running" | Where {$_.id -eq "Task-"+$task.value} | select Id, PercentComplete 
	if ($status -ne $null) {	
	write-progress -id 1 -activity ("Deploying VM: "+$vmname) -status ("Cloning Template - "+$status.PercentComplete+"% Complete") -percentComplete $status.PercentComplete
	}
	Start-Sleep 5
}
write-progress -id 1 -activity ("Deploying VM: "+$vmname) -status ("Cloning Template - "+$status.PercentComplete+"% Complete") -percentComplete 100


If($vmdisk -ne -1)
{
$vmdiskKB = $vmdisk * 1024 * 1024
New-HardDisk -VM (Get-VM $vmname) -CapacityKB $vmdiskKB
}

Get-NetworkAdapter -VM(Get-VM $vmname) | where { $_.Name -eq "Network Adapter 1" } | Set-NetworkAdapter -NetworkName $vmnetwork -confirm:$false
Get-NetworkAdapter -VM(Get-VM $vmname) | where { $_.Name -eq "Network Adapter 2" } | Set-NetworkAdapter -NetworkName "VLAN_141" -confirm:$false
Get-VM $vmname | Set-VM -MemoryMB $vmram -Confirm:$false
Get-VM $vmname | Set-VM -NumCPU $vmvcpus -Confirm:$false
Get-VM $vmname | Start-VM
  
Disconnect-VIServer -Server $defaultviserver -Confirm:$false


