## Startup
Connect-VIServer vcenter.conseco.ad
$VMs = @('XPUSER35','XPUSER36','XPUSER40')
$DDriveSizeGB = 40
$DDriveSizeKB =  $DDriveSizeGB * 1024 * 1024

Foreach ($VM in $VMs)
{
	$disks = Get-HardDisk -vm $VM
	if($disks.GetType().Name -eq "FlatHardDiskImpl")
	{
		foreach ($disk in $disks) 
		{ 
			Write-Host "Expanding VM $VM"
			Set-HardDisk -HardDisk $disk -CapacityKB $DDriveSizeKB -HostUser 'root' -HostPassword 'delta347#' -GuestUser 'administrator' -GuestPassword 'dolphins2004' -HelperVM (Get-VM -Name "P2V_VI")
			Get-VM $vm | Start-VM
		}
	}else{
	Write-Error "VM $VM has more than one disk. This script cannot continue."
	}
}

