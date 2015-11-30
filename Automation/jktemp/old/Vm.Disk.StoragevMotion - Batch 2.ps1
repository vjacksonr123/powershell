$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr

Connect-VIServer vcenter.conseco.ad

Get-VM -Name "NTTMP05" | Move-VM -Datastore (Get-Datastore "ESXNA354")  
Get-VM -Name "NTBBHPROD2" | Move-VM -Datastore (Get-Datastore "ESXNA354")  
Get-VM -Name "NTNPSP02" | Move-VM -Datastore (Get-Datastore "ESXNA354")  
Get-VM -Name "BLCFNET1" | Move-VM -Datastore (Get-Datastore "ESXNA354")  



disconnect-VIServer vcenter.conseco.ad