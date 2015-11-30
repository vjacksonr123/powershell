$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr

Connect-VIServer vcenter.conseco.ad

Get-VM -Name "NTINTRANET-T1" | Move-VM -Datastore (Get-Datastore "ESXNA441") -RunAsync 
Get-VM -Name "NTMWTOOLPROD1" | Move-VM -Datastore (Get-Datastore "ESXNA357") -RunAsync 
Get-VM -Name "NTITINFSUPP01" | Move-VM -Datastore (Get-Datastore "ESXNA357") -RunAsync 
Get-VM -Name "NTIACTXPROD" | Move-VM -Datastore (Get-Datastore "ESXNA357") -RunAsync 
Get-VM -Name "NTFNPRTP01" | Move-VM -Datastore (Get-Datastore "ESXNA357") -RunAsync 
Get-VM -Name "NTNCICP01" | Move-VM -Datastore (Get-Datastore "ESXNA357") -RunAsync 
Get-VM -Name "NTNCAPPP01" | Move-VM -Datastore (Get-Datastore "ESXNA357") -RunAsync 

disconnect-VIServer vcenter.conseco.ad