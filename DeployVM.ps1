#region VMInfo
$OS = "WXP" # W2K3 or WXP
$vmname = "XPUSER05" 					
$vmIPaddress = "192.168.202.241"
$vmIPgateway = "192.168.202.1"
$vmBOIPaddress = "10.141.0.217"
$vmnetwork = "VLAN_202"
$vmvcpus = 1
$vmram = 1024
#endregion VMInfo

#region VMLocation -- For Servers
$vmfolder = "Standard Desktop" 		
$vmcluster = "Alpha" 											
$vmhost = "esxalpha07.conseco.com" 					
$vmDatastore = "AlphaProd1" 							
$vmresourcepool = "1. PROD" 							
#endregion VMLocation

##region VMLocation -- for Desktops
#$vmfolder = "User Desktops" 		
#$vmcluster = "Gamma" 											
#$vmhost = "esxgamma07.conseco.com" 					
#$vmDatastore = "PROD_VOL2" 							
#$vmresourcepool = "5. Desktops" 							
##endregion VMLocation

### No changes beyond this point ###

if ($OS -eq "WXP") {
$vmtemplate = "XPUSER"
$vmAdminPassword = "App317config"
$vmOSkey = "DPFQJ-RVH2C-QHF3V-229X3-38QK8"
} elseif ($OS -eq "W2K3") {
$vmtemplate = "W2K3R2_Standard_x86"
$vmAdminPassword = "ZaYbXc351+"
$vmOSkey = "F23CP-PBDP9-FM233-6QWG9-X4XWG"
} else {
Write-Error "OS Definition is not valid."
}

Connect-VIServer -Server "vcenter.conseco.ad"
$tfld = Get-Folder -Name $vmfolder | Get-View


# Create VirtualMachineCloneSpec object
$vmclonespec = New-Object VMware.Vim.VirtualMachineCloneSpec
    
# Construct customization object
$vmclonespec.Customization = New-Object VMware.Vim.CustomizationSpec

# globalIPSettings
$vmclonespec.Customization.GlobalIPSettings = New-Object VMware.Vim.CustomizationGlobalIPSettings

# adaptermapping
if ($OS -eq "W2K3") {
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
$vmclonespec.Customization.NicSettingMap[0].Adapter.DnsServerList = "192.168.83.8", "192.168.1.3"
$vmclonespec.Customization.NicSettingMap[0].Adapter.primaryWINS = "205.144.116.10"
$vmclonespec.Customization.NicSettingMap[0].Adapter.secondaryWINS = "205.144.115.10"
if ($OS -eq "W2K3") {
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
if ($OS -eq "W2K3") {
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

# New-HardDisk -VM (Get-VM $node.OSOption.ComputerName) -CapacityKB $KBvalue 

Get-NetworkAdapter -VM(Get-VM $vmname) | where { $_.Name -eq "Network Adapter 1" } | Set-NetworkAdapter -NetworkName $vmnetwork -confirm:$false
Get-VM $vmname | Set-VM -MemoryMB $vmram -Confirm:$false
Get-VM $vmname | Set-VM -NumCPU $vmvcpus -Confirm:$false
Get-VM $vmname | Start-VM
  
Disconnect-VIServer -Server $defaultviserver -Confirm:$false


