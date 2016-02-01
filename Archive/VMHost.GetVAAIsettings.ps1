Connect-viserver vcenter.conseco.ad

Get-VMHost esxalpha10.conseco.com | Get-VMHostAdvancedConfiguration -Name DataMover*, VMFS3.HardwareAcc*

Disconnect-VIServer -Confirm:$false

