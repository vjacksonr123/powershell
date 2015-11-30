$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr

Connect-VIServer viewvc.conseco.ad

Get-VM -Name "XPCSC027" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC028" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC029" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC030" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync
Get-VM -Name "XPCSC031" | Move-VM -Datastore (Get-Datastore "ESXNA410") -RunASync



disconnect-VIServer viewvc.conseco.ad