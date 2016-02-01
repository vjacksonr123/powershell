Connect-VIServer vcenter.conseco.ad

$vmcsv = Import-Csv "\\ntadminp01\Public\Nframe-Move.csv"

Foreach ($line in $vmcsv) 
{
Move-VM -Datastore $line.datastore -VM $line.name -DiskStorageFormat Thin
}
Disconnect-VIServer -Confirm:$false