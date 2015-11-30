connect-viserver -server vcenter.conseco.ad
Get-VM | Get-Snapshot | Select created,quiesced,powerstate,vm 


#$a = "<style>"
#$a = $a + "body {margin: 10px; width: 600px; font-family:arial; font-size: 11px;}"
#$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
#$a = $a + "TH{border-width: 1px;padding: 2px;border-style: solid;border-color: black;background-color: rgb(179,179,179);align='left';}"
#$a = $a + "TD{border-width: 1px;padding: 2px;border-style: solid;border-color: black;background-color: white;}"
#$a = $a + "</style>"
#
#get-vm | % { get-view $_.ID } | select Name, @{ Name="hostName"; Expression={$_.guest.hostName}}, @{ Name="ToolsStatus"; Expression={$_.guest.toolsstatus}}, @{ Name="ToolsVersion"; Expression={$_.config.tools.toolsVersion}} | sort-object name | ConvertTo-HTML -head $a | Set-Content C:\export-tools.htm
#
#connect-viserver -server vcenter.conseco.ad
#
#ForEach($Cluster in Get-Cluster)
#{
#	$Cluster | Get-VM | Select $Cluster.Name, Name 
#}