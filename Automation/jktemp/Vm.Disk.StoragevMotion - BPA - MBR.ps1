$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr

Connect-VIServer vcenter.conseco.ad

Get-VM -Name "BLCDCCMLP01" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "BLCDCCMLP02" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "BLCFNETP01" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "CPLDCCMLP01" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTADCSP00" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTADCSP01" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTADLOGP01" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTADLOGP02" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTADMINP02" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTCAEEMP01" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTCASDP01" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTCASDP02" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTDCCMLP03" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTDCCMLP04" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTFNICCP02" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTFNICCP04" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTFSAWDP01" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTFSDOIP01" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTFTPP01" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTIBMRAMP01" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTNBUVOCP01" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTNPSP01" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTNPSP02" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTSCCMP01" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTSCCMP02" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTWDSP01" | Move-VM -Datastore (Get-Datastore "ESXNA367")
Get-VM -Name "NTWSUSP01" | Move-VM -Datastore (Get-Datastore "ESXNA367")


disconnect-VIServer vcenter.conseco.ad