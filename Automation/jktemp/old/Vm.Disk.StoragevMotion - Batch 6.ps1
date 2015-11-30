$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr

Connect-VIServer vcenter.conseco.ad


Get-VM -Name "XPDPPROD3" | Move-VM -Datastore (Get-Datastore "ESXNA411")  -RunAsync
Get-VM -Name "XPDPPROD8" | Move-VM -Datastore (Get-Datastore "ESXNA411")  -RunAsync
Get-VM -Name "XPDPPROD9" | Move-VM -Datastore (Get-Datastore "ESXNA411")  -RunAsync
Get-VM -Name "NTWEBPORTALPRD2" | Move-VM -Datastore (Get-Datastore "ESXNA421")  -RunAsync


disconnect-VIServer vcenter.conseco.ad