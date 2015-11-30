$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr

Connect-VIServer vcenter.conseco.ad

Get-VM -Name "CCM4" | Move-VM -Datastore (Get-Datastore "ESXNA358")  
Get-VM -Name "CPLLX02" | Move-VM -Datastore (Get-Datastore "ESXNA358")  
Get-VM -Name "NTADCSP00" | Move-VM -Datastore (Get-Datastore "ESXNA358")  
Get-VM -Name "NTCSANSP01" | Move-VM -Datastore (Get-Datastore "ESXNA358")  
Get-VM -Name "NTDB2P01" | Move-VM -Datastore (Get-Datastore "ESXNA358")  
Get-VM -Name "NTRPSPROD" | Move-VM -Datastore (Get-Datastore "ESXNA358")  
Get-VM -Name "NTS5SSRSP01" | Move-VM -Datastore (Get-Datastore "ESXNA358")  
Get-VM -Name "NTTOOLS5" | Move-VM -Datastore (Get-Datastore "ESXNA358")  


#NTINTRWSUAT2		85
#NTUCTUAT		226


disconnect-VIServer vcenter.conseco.ad