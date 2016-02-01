$Paths = GC "c:\path.lst"

$table = New-Object system.Data.DataTable "Server Info"
$col01 = New-Object system.Data.DataColumn Path,([string])
$col02 = New-Object system.Data.DataColumn SpaceUsed,([string])

$table.columns.add($col01)
$table.columns.add($col02)


ForEach ($Path in $Paths)
{
Write-Host "Checking Path: " $Path
$colItems = (Get-ChildItem $Path -recurse | Measure-Object -property length -sum)
$space = "{0:N2}" -f ($colItems.sum / 1MB)
$row = $table.NewRow()
$row.Path = $Path
$row.SpaceUsed = $space 
$table.Rows.Add($row)
}

$table
$table | Export-Csv C:\SpaceDrivesLH.csv