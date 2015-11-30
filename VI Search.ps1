Connect-VIServer -Server "vcenter.conseco.ad"
Get-VM | Where-Object { $_.powerstate -eq 'PoweredOn' }| Where-Object { $_.name -notlike 'XP*'} | Select Name, 
