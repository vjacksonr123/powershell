Connect-VIServer -Server "vcenter.conseco.ad"
#$Cluster = Get-Cluster "Beta" 
#$VMs = $Cluster | Get-VM | where-object { $_.PowerState -eq "PoweredOn" } | sort $_.Name
$VMs = Get-VM | where-object { $_.PowerState -eq "PoweredOn" } | sort $_.Name


$table = New-Object system.Data.DataTable "Server Info"
$col01 = New-Object system.Data.DataColumn Server,([string])
$col02 = New-Object system.Data.DataColumn Disk0,([decimal])
$col03 = New-Object system.Data.DataColumn Disk1,([decimal])
$col04 = New-Object system.Data.DataColumn Disk2,([decimal])
$col05 = New-Object system.Data.DataColumn Disk3,([decimal])
$col06 = New-Object system.Data.DataColumn Disk4,([decimal])
$col07 = New-Object system.Data.DataColumn Disk5,([decimal])
$col08 = New-Object system.Data.DataColumn Disk6,([decimal])
$col09 = New-Object system.Data.DataColumn Network1,([string])
$col10 = New-Object system.Data.DataColumn Network2,([string])


$table.columns.add($col01)
$table.columns.add($col02)
$table.columns.add($col03)
$table.columns.add($col04)
$table.columns.add($col05)
$table.columns.add($col06)
$table.columns.add($col07)
$table.columns.add($col08)
$table.columns.add($col09)
$table.columns.add($col10)


Select
ForEach ($VM in $VMs)
{
#	 Write-Host $VM.MemoryMB","$VM.NumCpu","$VM.NetworkAdapters[0].NetworkName","$VM.NetworkAdapters[1].NetworkName","$VM.HardDisks[0].CapacityKB","$VM.HardDisks[1].CapacityKB","$VM.HardDisks[2].CapacityKB","$VM.HardDisks[3].CapacityKB","$VM.HardDisks[4].CapacityKB","$VM.HardDisks[5].CapacityKB","$VM.HardDisks[6].CapacityKB
#	 Write-Host $VM.Name, $VM.HardDisks[0].CapacityKB, $VM.HardDisks[1].CapacityKB, $VM.HardDisks[2].CapacityKB, $VM.HardDisks[3].CapacityKB, $VM.HardDisks[4].CapacityKB, $VM.HardDisks[5].CapacityKB, $VM.HardDisks[6].CapacityKB
	 
	$row = $table.NewRow()
	$row.Server = $VM.Name
	If($VM.HardDisks[0].CapacityKB -ne $Null) {$row.Disk0 = ($VM.HardDisks[0].CapacityKB/1024)}
	If($VM.HardDisks[1].CapacityKB -ne $Null) {$row.Disk1 = ($VM.HardDisks[1].CapacityKB/1024)}
	If($VM.HardDisks[2].CapacityKB -ne $Null) {$row.Disk2 = ($VM.HardDisks[2].CapacityKB/1024)}
	If($VM.HardDisks[3].CapacityKB -ne $Null) {$row.Disk3 = ($VM.HardDisks[3].CapacityKB/1024)}
	If($VM.HardDisks[4].CapacityKB -ne $Null) {$row.Disk4 = ($VM.HardDisks[4].CapacityKB/1024)}
	If($VM.HardDisks[5].CapacityKB -ne $Null) {$row.Disk5 = ($VM.HardDisks[5].CapacityKB/1024)}
	If($VM.HardDisks[6].CapacityKB -ne $Null) {$row.Disk6 = ($VM.HardDisks[6].CapacityKB/1024)}
	If($VM.NetworkAdapters[0].NetworkName -ne $Null) {$row.Network1 =  ($VM.NetworkAdapters[0].NetworkName)}
	If($VM.NetworkAdapters[1].NetworkName -ne $Null) {$row.Network2 =  ($VM.NetworkAdapters[1].NetworkName)}
	
	$table.Rows.Add($row) 
}


$table | Export-Csv C:\VMINFO.CSV