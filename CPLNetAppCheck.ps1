$table = New-Object system.Data.DataTable "FileShares"
$col01 = New-Object system.Data.DataColumn NetApp,([string])
$col02 = New-Object system.Data.DataColumn Share,([string])
$col03 = New-Object system.Data.DataColumn AvailableSpace,([string])
$col04 = New-Object system.Data.DataColumn UsedSpace,([string])
$col05 = New-Object system.Data.DataColumn TotalSize,([string])
$table.columns.add($col01)
$table.columns.add($col02)
$table.columns.add($col03)
$table.columns.add($col04)
$table.columns.add($col05)



$row = $table.NewRow()
$row.NetApp = "NETAPPCPL1"
$row.Share= "CPLUSERDATA1"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NETAPPCPL2"
$row.Share= "CPLUSERDATA2"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NETAPPCPL1"
$row.Share= "CPLUSERAPPS1"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NETAPPCPL1"
$row.Share= "CPLUSERAPPS2"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NETAPPCPL1"
$row.Share= "CPLUSERPROFILES"
$table.Rows.Add($row)


While($true)
{
Clear-Host
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
ForEach($row in $table)
{
$Path = "\\" + $row.NetApp + "\" + $row.Share
$FSO = (new-object -com scripting.filesystemobject).getdrive("$Path")

$row.AvailableSpace = ([math]::round(($FSO.availablespace/1gb),2))
$row.UsedSpace = ([math]::round([long](($FSO.TotalSize)-($FSO.availablespace))/1gb,2))
$row.TotalSize = ([math]::round(($FSO.TotalSize/1gb),2))
}

$Percent = ((1 - ($table | Measure-Object AvailableSpace -sum).Sum / ($table | Measure-Object TotalSize -sum).Sum)*100)

#$Percent = ((($table | Measure-Object TotalSize -sum).Sum - ($table | Measure-Object AvailableSpace -sum).Sum)/500)*100

$table | Select Share, AvailableSpace, UsedSpace, TotalSize | Format-Table


Write-Progress -activity "Migrating CPL Data" -status "Percent Complete: " -percentComplete ([math]::round($Percent,2))
Write-Host ""
Write-Host "********************************************"
Write-Host "Migration Status: " ([math]::round($Percent,2)) "% Complete"
Write-Host "********************************************"
Sleep 60
}
