Connect-VIServer vcenter.conseco.ad,view4vc.conseco.ad

$VMHosts = Get-VMHost
Foreach ($VMHost in $VMHosts)
{
Set-VMHostAdvancedConfiguration -VMHost $VMHost -Name DataMover.HardwareAcceleratedMove -Value 0
Set-VMHostAdvancedConfiguration -VMHost $VMHost -Name DataMover.HardwareAcceleratedInit -Value 0
Set-VMHostAdvancedConfiguration -VMHost $VMHost -Name VMFS3.HardwareAcceleratedLocking -Value 0
}

Disconnect-VIServer * -Confirm:$false

