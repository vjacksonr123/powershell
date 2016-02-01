$table = New-Object system.Data.DataTable "FileShares"
$col01 = New-Object system.Data.DataColumn NetApp,([string])
$col02 = New-Object system.Data.DataColumn Share,([string])
$col03 = New-Object system.Data.DataColumn AvailableSpace,([string])
$col04 = New-Object system.Data.DataColumn TotalSize,([string])
$col05 = New-Object system.Data.DataColumn PercentFree,([long])
$table.columns.add($col01)
$table.columns.add($col02)
$table.columns.add($col03)
$table.columns.add($col04)
$table.columns.add($col05)


$row = $table.NewRow()
$row.NetApp = "NetApp2"
$row.Share= "APPS"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp2"
$row.Share= "BI"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp2"
$row.Share= "CDROMS"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp2"
$row.Share= "CORP"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp2"
$row.Share= "INVA"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp2"
$row.Share= "LEGAL"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp2"
$row.Share= "LOTUS"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp2"
$row.Share= "LPRO"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp2"
$row.Share= "MARKET"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp2"
$row.Share= "PMA"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp2"
$row.Share= "PROCESS"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "ACTLTECH"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "CCM"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "HOME"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "HRFIN"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "IMAGING"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "IOPS"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "IT"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "PRICING"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "HLT_ACTL"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "HLT_ACTSYS"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "HLT_CFT"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "HLT_FINREP"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "HLT_PRGMGMT"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "HLT_PRODDEV"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "LAV_2004YE"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "LAV_ACTL"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "LAV_CLIC"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "LAV_TAS"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "LAV_TAS3"
$table.Rows.Add($row)

$row = $table.NewRow()
$row.NetApp = "NetApp1"
$row.Share= "LAV_WNIC"
$table.Rows.Add($row)

ForEach($row in $table)
{
$Path = "\\" + $row.NetApp + "\" + $row.Share
$FSO = (new-object -com scripting.filesystemobject).getdrive("$Path")

$row.AvailableSpace = [math]::round(([double]($FSO.availablespace/1gb)),2)
$row.TotalSize = [math]::round(([double]($FSO.TotalSize/1gb)),2)
$row.PercentFree = ([math]::round(([double]($FSO.availablespace/$FSO.TotalSize)),2)*100)
}

$table | Format-Table