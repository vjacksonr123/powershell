$Users = GC "c:\user.lst"

$table = New-Object system.Data.DataTable "Server Info"
$col01 = New-Object system.Data.DataColumn UserID,([string])
$col02 = New-Object system.Data.DataColumn SpaceUsed,([string])

$table.columns.add($col01)
$table.columns.add($col02)


ForEach ($User in $Users)
{
Write-Host "Checking User: " $User
$colItems = (Get-ChildItem \\ntfs-home\home\HOME\$User -recurse | Measure-Object -property length -sum)
$space = "{0:N2}" -f ($colItems.sum / 1MB)
$row = $table.NewRow()
$row.UserID = $User
$row.SpaceUsed = $space 
$table.Rows.Add($row)
}

$table
$table | Export-Csv C:\UserHomeDrives.csv