Connect-VIServer view4vc.conseco.ad

$vmcsv = Import-Csv \\ntadminp01\Public\VMware\VMDesktops.csv ### Imports VM deployment specs
$sourcevm = "W7-SP1-X86"									  ### Sets source vm\template
$rspool = Get-VMHost 'esxtheta01.conseco.com' | Get-ResourcePool '6. Desktops'

#Shutdown-VMGuest $sourcevm -Confirm:$false					  ### Shutdown source vm

foreach ($line in $vmcsv)									  ### For Loop to get each object in the CSV
{
New-VM -VM $sourcevm -VMHost $line.hostname -Name $line.name -ResourcePool $rspool -Location $line.location -Datastore $line.datastore -DiskStorageFormat $line.diskstorageformat -RunAsync
}
### Deploys the virtual machines from the source vm with the paramaters specified in the CSV.

#Start-VM $sourcevm -Confirm:$false							  ### Poweron source vm

Disconnect-VIServer -Confirm:$false