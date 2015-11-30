Connect-VIServer vcenter.conseco.ad

Get-VM | Where {$_.name -like "NTS8*"} | Select Name, @{N="Datastore";E={($_ | Get-Datastore)}} | Sort Name | Export-Csv C:\NTS8.csv

Disconnect-VIServer -Confirm:$false


