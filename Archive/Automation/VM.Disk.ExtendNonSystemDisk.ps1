# Extends the non-system

$Name = "NTECORAP01"	## Name of the VM
$DDriveSizeGB = 114 ## Total Disk Space for D: drive in GB


Connect-VIServer vcenter.conseco.ad

$VM = Get-VM $Name
$DDriveSizeKB =  $DDriveSizeGB * 1024 * 1024

Write-Host "VM:" $VM
$disks = Get-HardDisk -vm $VM
Write-Host "VM has " $disks.count "disk(s)"
if($disks.count -eq 2)
{
	foreach ($disk in $disks){ 
		if($disk.CapacityKB -ne 25165824){
			Set-HardDisk -HardDisk $disk -CapacityKB $DDriveSizeKB -HostUser 'root' -HostPassword 'delta347#' -GuestUser 'CONSECO\SyNT_Service_Account' -GuestPassword 'autoup'
		}
	}
}else{
	Write-Error "VM has more than two disks. Operation cannot continue."
}