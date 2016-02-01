Connect-VIServer vcenter.conseco.ad
Get-Cluster | Set-Cluster -HAEnabled:$false -DrsEnabled:$false -Confirm:$false
Disconnect-VIServer -Confirm:$false