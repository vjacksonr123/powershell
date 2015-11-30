$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr

Connect-VIServer vcenter.conseco.ad

Get-VM -Name "NTBDVIEW2" | Move-VM -Datastore (Get-Datastore "ESXNA353")  
Get-VM -Name "NTCNCWEB04" | Move-VM -Datastore (Get-Datastore "ESXNA353")  
Get-VM -Name "NTCTXLICP01" | Move-VM -Datastore (Get-Datastore "ESXNA353")  
Get-VM -Name "NTFINAUDITP01" | Move-VM -Datastore (Get-Datastore "ESXNA353")  
Get-VM -Name "NTINFOWEBP01" | Move-VM -Datastore (Get-Datastore "ESXNA353")  
Get-VM -Name "NTTREASURYP01" | Move-VM -Datastore (Get-Datastore "ESXNA353")  
Get-VM -Name "NTTRNPRTNRP01" | Move-VM -Datastore (Get-Datastore "ESXNA353")  
Get-VM -Name "NTVASULP02" | Move-VM -Datastore (Get-Datastore "ESXNA353")  
Get-VM -Name "NTVASULP03" | Move-VM -Datastore (Get-Datastore "ESXNA353")  



disconnect-VIServer vcenter.conseco.ad