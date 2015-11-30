Connect-VIServer vcenter.conseco.ad

function StopServiceSSH {
 $VMHosts = Get-VMHost
 foreach ($VMHost in $VMHosts) {
   Get-VMHostService -VMHost $VMHost | where {$_.Key -eq "TSM-SSH"} | Stop-VMHostService -Confirm:$false
  }
}
StopServiceSSH

Disconnect-VIServer -Confirm:$false