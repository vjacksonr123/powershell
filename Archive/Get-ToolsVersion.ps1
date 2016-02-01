Connect-VIServer vcenter.conseco.ad
get-vm | % { get-view $_.ID } | select Name, @{ Name="ToolsVersion"; Expression={$_.config.tools.toolsVersion}} | Export-Csv "H:\VMware\vcenterToolsVersion.csv"