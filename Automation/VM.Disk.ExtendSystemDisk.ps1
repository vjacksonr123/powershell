# Extends the non-system

$VMs = @('NTPPLUSMODL')	## Name of the VM
$CDriveSizeGB = 24 ## Total Disk Space for C: drive in GB


Connect-VIServer vcenter.conseco.ad

Foreach ($VMn in $VMs)
{
	$VM = Get-VM $VMn
	$VM | Shutdown-VMGuest -Confirm:$false
	Sleep 100
	$CDriveSizeKB =  $CDriveSizeGB * 1024 * 1024
	
	Write-Host "VM:" $VM
	$disks = Get-HardDisk -vm $VM
	Write-Host "VM has " $disks.count "disk(s)"
	foreach ($disk in $disks){ 
		if($disk.name -eq "Hard disk 1"){
				Set-HardDisk -HardDisk $disk -CapacityKB $CDriveSizeKB -HostUser 'root' -HostPassword 'delta347#' -GuestUser 'administrator' -GuestPassword 'dolphins2004' -HelperVM (Get-VM -Name "P2V_VI")
	}
}
	$VM | Start-VM
}	