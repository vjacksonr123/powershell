Connect-VIServer vcenter.conseco.ad

$vmcsv = Import-Csv \\ntadminp01\Public\VMware\VMServersIA6M.csv ### Imports VM deployment specs
$sourcevm = "NTIA6MP01"									  ### Sets source vm\template
															  ###$rspool = Get-VMHost 'esxalpha01.conseco.com' | Get-ResourcePool '5. Sandbox'

### Shutdown-VMGuest $sourcevm -Confirm:$false					  ### Shutdown source vm

foreach ($line in $vmcsv)									  ### For Loop to get each object in the CSV
{
New-VM -VM $sourcevm -VMHost $line.hostname -Name $line.name -ResourcePool $rspool -Location $line.location -Datastore $line.datastore -DiskStorageFormat $line.diskstorageformat -OSCustomizationSpec $line.oscustspec -RunAsync
}
### Deploys the virtual machines from the source vm with the paramaters specified in the CSV.

### Start-VM $sourcevm -Confirm:$false							  ### Poweron source vm

Disconnect-VIServer -Confirm:$false