$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr

Connect-VIServer vcenter.conseco.ad

Get-VM -Name 'NTDCCMLP07' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD001') -RunAsync
Get-VM -Name 'NTDCCMLP08' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD001') -RunAsync
Get-VM -Name 'NTIA6CTXP02' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD001') -RunAsync
Get-VM -Name 'NTIA6CTXP03' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD001') -RunAsync
Get-VM -Name 'NTS8TFSP02' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD001') -RunAsync
Get-VM -Name 'NTIA6IISP01' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6IISP02' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6LP01' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6LP02' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6LP03' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP02' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP03' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP04' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP05' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP06' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP07' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP08' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP09' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP10' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP11' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP12' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP13' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP14' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP15' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP16' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP17' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP18' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP19' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP20' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTIA6MP21' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTS8R2P04' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD002') -RunAsync
Get-VM -Name 'NTBBHP01' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD003') -RunAsync
Get-VM -Name 'NTBBHP02' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD003') -RunAsync
Get-VM -Name 'NTCTXWIP01' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD003') -RunAsync
Get-VM -Name 'NTCTXWIP02' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD003') -RunAsync
Get-VM -Name 'NTCTXXAP01' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD003') -RunAsync
Get-VM -Name 'NTCTXXAP02' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD003') -RunAsync
Get-VM -Name 'NTDB2P02' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD003') -RunAsync
Get-VM -Name 'NTFNFSMP01' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD003') -RunAsync
Get-VM -Name 'NTFNICCP01' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD003') -RunAsync
Get-VM -Name 'NTFNICCP02' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD003') -RunAsync
Get-VM -Name 'NTFNICCP03' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD003') -RunAsync
Get-VM -Name 'NTFNICCP04' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD003') -RunAsync
Get-VM -Name 'NTFSAWDP01' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD003') -RunAsync
Get-VM -Name 'NTMSKMSP01' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD003') -RunAsync
Get-VM -Name 'NTMUTAREP01' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD003') -RunAsync
Get-VM -Name 'NTNBUVOCP01' | Move-VM -Datastore (Get-Datastore 'VMW2K8R2X64PROD003') -RunAsync


disconnect-VIServer vcenter.conseco.ad -Confirm:$false