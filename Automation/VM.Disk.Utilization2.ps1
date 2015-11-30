Connect-VIServer vcenter.conseco.ad 

$report = @()
Get-VM | %{
	$stats = Get-Stat -Entity $_ -Stat disk.usage.average,disk.read.average,disk.write.average -Start (Get-Date).adddays(-1) -ErrorAction SilentlyContinue
	if($stats){
		$statsGrouped = $stats | Group-Object -Property MetricId
		$row = "" | Select Name, UsageAvgKbps, ReadAvgKbps, WriteAvgKbps
		$row.Name = $_.Name
		$row.UsageAvgKbps = ($statsGrouped | where {$_.Name -eq "disk.usage.average"} | %{$_.Group | Measure-Object -Property Value -Average}).Average
		$row.ReadAvgKbps = ($statsGrouped | where {$_.Name -eq "disk.read.average"} | %{$_.Group | Measure-Object -Property Value -Average}).Average
		$row.WriteAvgKbps = ($statsGrouped | where {$_.Name -eq "disk.write.average"} | %{$_.Group | Measure-Object -Property Value -Average}).Average
		$report += $row
	}
}
#$report | Sort-Object -Property UsageAvgKbps -Descending | Select -First 10

$report | Sort-Object -Property UsageAvgKbps -Descending | Out-File c:\users\lanj6p\results3.txt
$report | Sort-Object -Property UsageAvgKbps -Descending | Export-CSV c:\users\lanj6p\results3.csv
$report | Sort-Object -Property UsageAvgKbps -Descending | Out-GridView
