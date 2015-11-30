Connect-VIServer view4vc.conseco.ad
Get-VM | Get-VMResourceConfiguration | where {$_.MemLimitMB -ne '-1'} | Set-VMResourceConfiguration -MemLimitMB $null
Disconnect-VIServer -Confirm:$false
