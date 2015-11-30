$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr

Connect-VIServer vcenter.conseco.ad

Get-VM -Name "BLCIIS2" | Move-VM -Datastore (Get-Datastore "ESXNA359")  
Get-VM -Name "NTCNONETP2" | Move-VM -Datastore (Get-Datastore "ESXNA359")  
Get-VM -Name "NTIMCWEBPROD1" | Move-VM -Datastore (Get-Datastore "ESXNA359")  
Get-VM -Name "NTVASAMP01" | Move-VM -Datastore (Get-Datastore "ESXNA359")  
Get-VM -Name "NTVASLMP01" | Move-VM -Datastore (Get-Datastore "ESXNA359")  
Get-VM -Name "NTVASLTCP01" | Move-VM -Datastore (Get-Datastore "ESXNA359")  
Get-VM -Name "NTWALKERPROD" | Move-VM -Datastore (Get-Datastore "ESXNA359")  
Get-VM -Name "NTWEBMETRICS" | Move-VM -Datastore (Get-Datastore "ESXNA359")  
Get-VM -Name "NTWEBPORTALPRD1" | Move-VM -Datastore (Get-Datastore "ESXNA359")  


#NTINTRWSUAT2		85
#NTUCTUAT		226


disconnect-VIServer vcenter.conseco.ad