Connect-VIServer vcenter.conseco.ad

ForEach ($VM in Get-VM -Location 'Temp Desktops')
{
   ForEach ($NetworkAdapter in $VM.NetworkAdapters)
   {
      Write-Host "Set-NetworkAdapter -NetworkAdapter $NetworkAdapter -StartConnected $true" -ForegroundColor Blue
      Set-NetworkAdapter -NetworkAdapter $NetworkAdapter -StartConnected $true -Confirm:$false
   }
}
Disconnect-VIServer -Confirm:$false