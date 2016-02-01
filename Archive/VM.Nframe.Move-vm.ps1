Connect-VIServer vcenter.conseco.ad

$vmcsv = Import-Csv "\\ntadminp01\Public\Nframe-Move.csv"

Foreach ($line in $vmcsv) 
{
Get-VM -Name $line.Name | Move-VM -Datastore (Get-Datastore $line.Datastore)
}

Disconnect-VIServer vcenter.conseco.ad