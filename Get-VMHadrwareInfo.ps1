Connect-VIServer vcenter.conseco.ad

Get-Cluster 'Beta' | Get-ResourcePool '4. UT' | Get-VM | ForEach-Object {
    $VM = $_
    $NetworkAdapter = $VM | Get-NetworkAdapter
    $HardDisk = $VM | Get-HardDisk
    $VM | `
      Select-Object -Property Name,
        @{N="IPAddress";E={[string]::Join(";",$_.Guest.IPAddress)}},
        NumCPU,
        MemoryMB,
        Guest,
        VMHost,
        @{N="NetworkAdapter";E={([string]::Join(";",$($NetworkAdapter | ForEach-Object {$_.Name})))}},
        @{N="MacAddress";E={([string]::Join(";",$($NetworkAdapter | ForEach-Object {$_.MacAddress})))}},
        @{N="PortGroup";E={([string]::Join(";",$($NetworkAdapter | ForEach-Object {$_.NetworkName})))}},
        @{N="HardDisk";E={([string]::Join(";",$($HardDisk | ForEach-Object {$_.Name})))}},
        @{N="FileName";E={([string]::Join(";",$($HardDisk | ForEach-Object {$_.FileName})))}},
        @{N="CapacityGB";E={([string]::Join(";",$($HardDisk | ForEach-Object {$_.CapacityKB/1MB})))}}
  } | Export-Csv "C:\report.csv" -NoTypeInformation -UseCulture

Disconnect-VIServer -Confirm:$false