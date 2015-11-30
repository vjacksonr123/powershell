$vmwareSnapin = Add-PSSnapin "VMware.VimAutomation.Core" -ErrorVariable myErr

Connect-VIServer vcenter.conseco.ad

Get-VM -Name "LXTMLPP01" | Move-VM -Datastore (Get-Datastore "ESXNA120")  
Get-VM -Name "NTBPASIT01" | Move-VM -Datastore (Get-Datastore "ESXNA364")  
Get-VM -Name "NTCAMRATEST" | Move-VM -Datastore (Get-Datastore "ESXNA364")  
Get-VM -Name "NTCAWYCSIT02" | Move-VM -Datastore (Get-Datastore "ESXNA364")  
Get-VM -Name "NTENTVAULTSIT" | Move-VM -Datastore (Get-Datastore "ESXNA364")  
Get-VM -Name "NTHARTEST" | Move-VM -Datastore (Get-Datastore "ESXNA364")  
Get-VM -Name "NTINTRWSSIT1" | Move-VM -Datastore (Get-Datastore "ESXNA364")  
Get-VM -Name "NTINTRWSSIT2" | Move-VM -Datastore (Get-Datastore "ESXNA364")  
Get-VM -Name "NTOPUSSIT1" | Move-VM -Datastore (Get-Datastore "ESXNA364")  
Get-VM -Name "NTPPLUSSIT" | Move-VM -Datastore (Get-Datastore "ESXNA364")  
Get-VM -Name "NTSBXAPP1SIT" | Move-VM -Datastore (Get-Datastore "ESXNA364")  
Get-VM -Name "NTSBXAPP3SIT" | Move-VM -Datastore (Get-Datastore "ESXNA364")  
Get-VM -Name "NTSTPPRESIT" | Move-VM -Datastore (Get-Datastore "ESXNA364")  
Get-VM -Name "NTWSRRSIT01" | Move-VM -Datastore (Get-Datastore "ESXNA364")  
Get-VM -Name "NTCASDP01" | Move-VM -Datastore (Get-Datastore "ESXNA360")  
Get-VM -Name "NTCASDP02" | Move-VM -Datastore (Get-Datastore "ESXNA360")  
Get-VM -Name "NTCFWEBPROD1" | Move-VM -Datastore (Get-Datastore "ESXNA360")  
Get-VM -Name "NTFLSTATP01" | Move-VM -Datastore (Get-Datastore "ESXNA360")  
Get-VM -Name "NTINTRA1" | Move-VM -Datastore (Get-Datastore "ESXNA360")  
Get-VM -Name "NTNCMMLP01" | Move-VM -Datastore (Get-Datastore "ESXNA360")  
Get-VM -Name "NTTEAMSITEP2" | Move-VM -Datastore (Get-Datastore "ESXNA360")  
Get-VM -Name "NTTMP07" | Move-VM -Datastore (Get-Datastore "ESXNA360")  


disconnect-VIServer vcenter.conseco.ad