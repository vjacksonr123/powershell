$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr

Connect-VIServer vcenter.conseco.ad

Get-VM -Name "NTTFCTXP03" | Move-VM -Datastore (Get-Datastore "ESXNA352")  
Get-VM -Name "NTEXGMMP01" | Move-VM -Datastore (Get-Datastore "ESXNA352")  
Get-VM -Name "NTAWDSTP03" | Move-VM -Datastore (Get-Datastore "ESXNA352")  
Get-VM -Name "NTOPUSPROD1" | Move-VM -Datastore (Get-Datastore "ESXNA352")  
Get-VM -Name "NTRFAPPP01" | Move-VM -Datastore (Get-Datastore "ESXNA352")  
Get-VM -Name "NTBPAP03" | Move-VM -Datastore (Get-Datastore "ESXNA352")  
Get-VM -Name "NTBPAP04" | Move-VM -Datastore (Get-Datastore "ESXNA352")  
Get-VM -Name "NTRFAPPP03" | Move-VM -Datastore (Get-Datastore "ESXNA352")  
Get-VM -Name "BLCUTIL01" | Move-VM -Datastore (Get-Datastore "ESXNA352")  
Get-VM -Name "NTNICECLS" | Move-VM -Datastore (Get-Datastore "ESXNA352")  


disconnect-VIServer vcenter.conseco.ad