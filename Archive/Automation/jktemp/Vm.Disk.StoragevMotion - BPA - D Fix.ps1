$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr

Connect-VIServer vcenter.conseco.ad

Get-VM -Name "NTIAFEXPP01" | Move-VM -Datastore (Get-Datastore "ESXNA2VMDISK") 
Get-VM -Name "NTIAFEXPP02" | Move-VM -Datastore (Get-Datastore "ESXNA2VMDISK") 
Get-VM -Name "NTIAFEXPP03" | Move-VM -Datastore (Get-Datastore "ESXNA2VMDISK") 
Get-VM -Name "NTIAFEXPP04" | Move-VM -Datastore (Get-Datastore "ESXNA2VMDISK") 
Get-VM -Name "NTIAFEXPP05" | Move-VM -Datastore (Get-Datastore "ESXNA2VMDISK") 
Get-VM -Name "NTIAFEXPP06" | Move-VM -Datastore (Get-Datastore "ESXNA2VMDISK") 
Get-VM -Name "NTTFCTXP01" | Move-VM -Datastore (Get-Datastore "ESXNA2VMDISK") 
Get-VM -Name "NTTFCTXP02" | Move-VM -Datastore (Get-Datastore "ESXNA2VMDISK") 
Get-VM -Name "NTTFCTXP03" | Move-VM -Datastore (Get-Datastore "ESXNA2VMDISK") 
Get-VM -Name "NTTFCTXUAT01" | Move-VM -Datastore (Get-Datastore "ESXNA2VMDISK") 
Get-VM -Name "NTTFCTXUT01" | Move-VM -Datastore (Get-Datastore "ESXNA2VMDISK") 

disconnect-VIServer vcenter.conseco.ad