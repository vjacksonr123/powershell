Connect-VIServer vcenter.conseco.ad
$vmhosts = Get-Cluster "BETA" | Get-VMHost | Sort Name | Where-Object {$_.State -eq "Connected"} | Get-View
$MyCol = @()
foreach ($vmhost in $vmhosts){
 $ESXHost = $vmhost.Name
 Write "Collating information for $ESXHost"
 $networkSystem = Get-view $vmhost.ConfigManager.NetworkSystem
 foreach($pnic in $networkSystem.NetworkConfig.Pnic){
     $pnicInfo = $networkSystem.QueryNetworkHint($pnic.Device)
     foreach($Hint in $pnicInfo){
         $NetworkInfo = "" | select-Object Host, PNic, Speed, MAC, DeviceID, PortID
         $NetworkInfo.Host = $vmhost.Name
         $NetworkInfo.PNic = $Hint.Device
         $NetworkInfo.DeviceID = $Hint.connectedSwitchPort.DevId
         $NetworkInfo.PortID = $Hint.connectedSwitchPort.PortId
         $record = 0
         Do{
             If ($Hint.Device -eq $vmhost.Config.Network.Pnic[$record].Device){
                 $NetworkInfo.Speed = $vmhost.Config.Network.Pnic[$record].LinkSpeed.SpeedMb
                 $NetworkInfo.MAC = $vmhost.Config.Network.Pnic[$record].Mac
             }
             $record ++
         }
         Until ($record -eq ($vmhost.Config.Network.Pnic.Length))
         $MyCol += $NetworkInfo
     }
 }
}
$Mycol | Sort Host, PNic | Out-GridView 
