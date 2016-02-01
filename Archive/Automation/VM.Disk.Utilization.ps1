#Connect-VIServer vcenter.conseco.ad 
#
#$report = @()
#Get-VM | %{
#	$stats = Get-Stat -Entity $_ -Stat cpu.usagemhz.average -Start (Get-Date).adddays(-1) -ErrorAction SilentlyContinue
#	if($stats){
#		$statsGrouped = $stats | Group-Object -Property MetricId
#		$row = "" | Select Name, UsageAvgMhz
#		$row.Name = $_.Name
#		$row.UsageAvgMhz = ($statsGrouped | where {$_.Name -eq "cpu.usagemhz.average"} | %{$_.Group | Measure-Object -Property Value -Average}).Average
#		$report += $row
#	}
#}
##$report | Sort-Object -Property UsageAvgKbps -Descending | Select -First 10
#
#$report | Sort-Object -Property UsageAvgMhz -Descending | Out-File c:\users\lanj6p\resultscpu.txt
#$report | Sort-Object -Property UsageAvgMhz -Descending | Export-CSV c:\users\lanj6p\resultscpu.csv
#$report | Sort-Object -Property UsageAvgMhz -Descending | Out-GridView


Connect-VIServer vcenter.conseco.ad 

$report = @()
Get-VM | %{
	$stats = Get-Stat -Entity $_ -Stat cpu.ready.summation -Start (Get-Date).adddays(-1) -ErrorAction SilentlyContinue
	if($stats){
		$statsGrouped = $stats | Group-Object -Property MetricId
		$row = "" | Select Name, SumReady, AvgReady
		$row.Name = $_.Name
		$row.SumReady = ($statsGrouped | where {$_.Name -eq "cpu.ready.summation"} | %{$_.Group | Measure-Object -Property Value -Average}).Average
		$row.AvgReady = [math]::Round($row.SumReady/30)
		$row.SumReady = [Math]::Round($row.SumReady)
		$report += $row
	}
}
#$report | Sort-Object -Property UsageAvgKbps -Descending | Select -First 10

$report | Sort-Object -Property UsageAvgMhz -Descending | Out-File c:\users\lanj6p\resultscpuR-VC.txt
$report | Sort-Object -Property UsageAvgMhz -Descending | Export-CSV c:\users\lanj6p\resultscpuR-VC.csv
$report | Sort-Object -Property UsageAvgMhz -Descending | Out-GridView
