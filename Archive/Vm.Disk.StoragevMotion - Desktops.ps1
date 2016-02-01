#$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr

Connect-VIServer view4vc.conseco.ad


Get-VM -Name "XPONLY-1" | Move-VM -Datastore (Get-Datastore "VMWXPPROX86DESK008") -RunAsync
Get-VM -Name "XPUSERD0" | Move-VM -Datastore (Get-Datastore "VMWXPPROX86DESK008") -RunAsync
Get-VM -Name "XPUSERD2" | Move-VM -Datastore (Get-Datastore "VMWXPPROX86DESK008") -RunAsync
Get-VM -Name "XPUSERD3" | Move-VM -Datastore (Get-Datastore "VMWXPPROX86DESK008") -RunAsync
Get-VM -Name "XPUSERH2" | Move-VM -Datastore (Get-Datastore "VMWXPPROX86DESK008") -RunAsync
Get-VM -Name "XPUSERI0" | Move-VM -Datastore (Get-Datastore "VMWXPPROX86DESK008") -RunAsync



disconnect-VIServer view4vc.conseco.ad -Confirm:$false