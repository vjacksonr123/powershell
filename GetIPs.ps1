#region Vars
	$DebugPreference = "Continue"
	$debug = $true
	$table = New-Object system.Data.DataTable "Server Info"
	$col01 = New-Object system.Data.DataColumn Server,([string])
	$col02 = New-Object system.Data.DataColumn FOIP,([string])
	$col03 = New-Object system.Data.DataColumn FOIPGW,([string])
	$col04 = New-Object system.Data.DataColumn FOIPMany,([string])
	$col05 = New-Object system.Data.DataColumn BOIP,([string])
	$col06 = New-Object system.Data.DataColumn WinVer,([string])
	$col07 = New-Object system.Data.DataColumn WinVerR2,([string])
	$col08 = New-Object system.Data.DataColumn WinVerSP,([string])
	$col09 = New-Object system.Data.DataColumn WinOSArc,([string])
	$col10 = New-Object system.Data.DataColumn WinDir,([string])
	$col11 = New-Object system.Data.DataColumn RAMgb,([Int])
	$col12 = New-Object system.Data.DataColumn RAMmb,([Int])
	$col13 = New-Object system.Data.DataColumn NumOfProcs,([Int])
	$col14 = New-Object system.Data.DataColumn Model,([string])
	
	$col24 = New-Object system.Data.DataColumn DiskA,([decimal])
	$col25 = New-Object system.Data.DataColumn DiskB,([decimal])
	$col26 = New-Object system.Data.DataColumn DiskC,([decimal])
	$col27 = New-Object system.Data.DataColumn DiskD,([decimal])
	$col28 = New-Object system.Data.DataColumn DiskE,([decimal])
	$col29 = New-Object system.Data.DataColumn DiskF,([decimal])
	$col30 = New-Object system.Data.DataColumn DiskG,([decimal])
	$col31 = New-Object system.Data.DataColumn DiskH,([decimal])
	$col32 = New-Object system.Data.DataColumn DiskI,([decimal])
	$col33 = New-Object system.Data.DataColumn DiskJ,([decimal])
	$col34 = New-Object system.Data.DataColumn DiskK,([decimal])
	$col35 = New-Object system.Data.DataColumn DiskL,([decimal])
	$col36 = New-Object system.Data.DataColumn DiskM,([decimal])
	$col37 = New-Object system.Data.DataColumn DiskN,([decimal])
	$col38 = New-Object system.Data.DataColumn DiskO,([decimal])
	$col39 = New-Object system.Data.DataColumn DiskP,([decimal])
	$col40 = New-Object system.Data.DataColumn DiskQ,([decimal])
	$col41 = New-Object system.Data.DataColumn DiskR,([decimal])
	$col42 = New-Object system.Data.DataColumn DiskS,([decimal])
	$col43 = New-Object system.Data.DataColumn DiskT,([decimal])
	$col44 = New-Object system.Data.DataColumn DiskU,([decimal])
	$col45 = New-Object system.Data.DataColumn DiskV,([decimal])
	$col46 = New-Object system.Data.DataColumn DiskW,([decimal])
	$col47 = New-Object system.Data.DataColumn DiskX,([decimal])
	$col48 = New-Object system.Data.DataColumn DiskY,([decimal])
	$col49 = New-Object system.Data.DataColumn DiskZ,([decimal])
	$col50 = New-Object system.Data.DataColumn DiskCFree,([decimal])
	
	#Volume infomration is always last
	$col70 = New-Object system.Data.DataColumn Volumes,([string])
	$col71 = New-Object system.Data.DataColumn DRTaskId,([string])
	$col72 = New-Object system.Data.DataColumn DRStatus,([string])
	$col73 = New-Object system.Data.DataColumn DRPriority,([string])
	$col74 = New-Object system.Data.DataColumn DRClonePercent,([int])
	$col75 = New-Object system.Data.DataColumn DRError,([string])
	$col76 = New-Object system.Data.DataColumn DRCheckedOutUser,([string])
	$col77 = New-Object system.Data.DataColumn DRNotes,([string])
	$col78 = New-Object system.Data.DataColumn SystemType,([string])
	$col79 = New-Object system.Data.DataColumn IPList,([string])
	$col80 = New-Object system.Data.DataColumn NICs,([string])
	
	#Add the Columns
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
	$table.columns.add($col11)
	$table.columns.add($col12)
	$table.columns.add($col13)
	$table.columns.add($col14)
	#$table.columns.add($col15)
	#$table.columns.add($col16)
	#$table.columns.add($col17)
	#$table.columns.add($col18)
	#$table.columns.add($col19)
	#$table.columns.add($col20)
	#$table.columns.add($col21)
	#$table.columns.add($col22)
	#$table.columns.add($col23)
	$table.columns.add($col24)
	$table.columns.add($col25)
	$table.columns.add($col26)
	$table.columns.add($col27)
	$table.columns.add($col28)
	$table.columns.add($col29)
	$table.columns.add($col30)
	$table.columns.add($col31)
	$table.columns.add($col32)
	$table.columns.add($col33)
	$table.columns.add($col34)
	$table.columns.add($col35)
	$table.columns.add($col36)
	$table.columns.add($col37)
	$table.columns.add($col38)
	$table.columns.add($col39)
	$table.columns.add($col40)
	$table.columns.add($col41)
	$table.columns.add($col42)
	$table.columns.add($col43)
	$table.columns.add($col44)
	$table.columns.add($col45)
	$table.columns.add($col46)
	$table.columns.add($col47)
	$table.columns.add($col48)
	$table.columns.add($col49)
	$table.columns.add($col50)
	#$table.columns.add($col51)
	#$table.columns.add($col52)
	#$table.columns.add($col53)
	#$table.columns.add($col54)
	#$table.columns.add($col55)
	#$table.columns.add($col56)
	#$table.columns.add($col57)
	#$table.columns.add($col58)
	#$table.columns.add($col59)
	$table.columns.add($col70)
	$table.columns.add($col71)
	$table.columns.add($col72)
	$table.columns.add($col73)
	$table.columns.add($col74)
	$table.columns.add($col75)
	$table.columns.add($col76)
	$table.columns.add($col77)
	$table.columns.add($col78)
	$table.columns.add($col79)
	$table.columns.add($col80)
	
#endregion 


function Out-SQL ($SqlServer=$null,$Database=$null,$Table=$null,$DropExisting=$false,$RowId="RowID") {
  begin
  {
       $Line = 0
       [string]$CreateTable = ""
       if(-not $SqlServer) { throw 'Out-Sql expects $SqlServer parameter' }
       if(-not $Database) { throw 'Out-Sql expects $Database parameter' }
       if(-not $Table) { throw 'Out-Sql expects $Table parameter' }
       if($DropExisting) { write-debug "Note: If the table exists, it WILL be dropped and re-created."}
       $SqlConnectionString = "  Provider=sqloledb;" +
                           "  Data Source=$SqlServer;" +
                    "  Initial Catalog=$Database;" +
                    "  User Id=VCAdmin; Password=vcadm6ev;"
       write-debug "Will open connection to SQL server ""$SqlServer"" and will populate table ""$Table."""
       write-debug "Connection string: `n$SqlConnectionString"
       $SqlConnection = New-Object System.Data.OleDb.OleDbConnection $SqlConnectionString
       $SqlCommand = New-Object System.Data.OleDb.OleDbCommand "",$SqlConnection
       $SqlConnection.Open()
  }
  process
  {
      $Line ++
      $Properties = $_.PSObject.Properties
       if (-not $Properties)
       {
         throw "Out-Sql expects object to be passed on the pipeline. The object must have .PSObject.Properties collection."
       }
       #if we're at the first line, initialize the table
       if ($Line -eq 1)
       {
             #initialize SQL connection and create table
              if($DropExisting) { $CreateTable += "IF OBJECT_ID('$Table') IS NOT NULL DROP TABLE $Table;`n"}
              $CreateTable +="CREATE TABLE $Table ( `n"
              $col = 0
              if ($RowId)
              {
                    $col++;
                    $CreateTable +="$RowId INT NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED `n"
              }
              foreach($Property in $Properties)
              {
                     $col++;
                     if ($col -gt 1) { $CreateTable +="," }
                     # In below, why not use "if ($Property.Value -is [datetime])"?
                     # Because access can be denied to the value, but Property.TypeNameOfValue would still be accessible!
                     if ($Property.TypeNameOfValue -eq "System.DateTime")
                     {
                           $CreateTable +="[$($Property.Name)] DATETIME NULL `n"
                     }
                     else
                     {
                           $CreateTable +="[$($Property.Name)] NVARCHAR(MAX) NULL `n"
                     }
              }
              $CreateTable +=")"
              write-debug "Will execute SQL to create table: `n$CreateTable"
			  write-host "Will execute SQL to create table: `n$CreateTable"
              $SqlCommand.CommandText = $CreateTable
              $rows = $SqlCommand.ExecuteNonQuery()
       }
       #Prepare SQL insert statement and execute it
       $InsertStatement = "INSERT $Table VALUES("
       $col = 0
       foreach($Property in $Properties)
       {
              $col++;
              if ($col -gt 1) { $InsertStatement += "," }
              #In the INSERT statement, do speacial tratment for Nulls, Dates and XML. Other special cases can be added as needed.
              if (-not $Property.Value)
              {
                     $InsertStatement += "null `n"
              }
              elseif ($Property.Value -is [datetime])
              {
                     $InsertStatement += "'" + $Property.Value.ToString("yyyy-MM-dd HH:mm:ss.fff") + "'`n"
              }
              elseif ($Property.Value -is [System.Xml.XmlNode] -or $Property.Value -is [System.Xml.XmlElement])
              {
                     $InsertStatement += "'" + ([string]$($Property.Value.Get_OuterXml())).Replace("'","''") + "'`n"
              }
              else
              {
                     $InsertStatement += "'" + ([string]$($Property.Value)).Replace("'","''") + "'`n"
              }
       }
       $InsertStatement +=")"
       write-debug "Running insert statement: `n $InsertStatement"
       $SqlCommand.CommandText = $InsertStatement
       $rows = $SqlCommand.ExecuteNonQuery()
  }
  end
  {
       write-debug "closing SQL connection..."
       $SqlConnection.Close()
  }
}
function Get-SQL ([string]$Query,[string]$ConnString) {

if ($ConnString) {

	if($ConnString -match '"*"') {
		$ConnString = $ConnString.TrimStart('"')
		$ConnString = $ConnString.TrimEnd('"')
	}

} else {

	# Default Connection String
	$ConnString =
	"server=ServerName;database=DbName;trusted_connection=true;"

}

$Connection = New-Object System.Data.SQLClient.SQLConnection

$Connection.ConnectionString = $ConnString
$Connection.Open()

$Command = New-Object System.Data.SQLClient.SQLCommand
$Command.Connection = $Connection
$Command.CommandText = $Query

$Reader = $Command.ExecuteReader()
$Counter = $Reader.FieldCount
while ($Reader.Read()) {
	$SQLObject = @{}
	for ($i = 0; $i -lt $Counter; $i++) {
		$SQLObject.Add(
			$Reader.GetName($i),
			$Reader.GetValue($i));
	}
	$SQLObject
}

$Connection.Close()

}
function Set-SQL ([string]$Query,[string]$ConnString) {

if ($ConnString) {

	if($ConnString -match '"*"') {
		$ConnString = $ConnString.TrimStart('"')
		$ConnString = $ConnString.TrimEnd('"')
	}

} else {

	# Default ConnectionString
	$ConnString =
	"server=SQL;database=master;trusted_connection=true;"

}

$Connection = New-Object System.Data.SQLClient.SQLConnection

$Connection.ConnectionString = $ConnString
$Connection.Open()

$Command = New-Object System.Data.SQLClient.SQLCommand
$Command.Connection = $Connection
$Command.CommandText = $Query

return $Reader = $Command.ExecuteNonQuery()

$Connection.Close()

}


function getserverinfo([string]$strComputer){


Trap {
  # handle error here
  	$table.Rows.Add($row) 
      write-host
      write-error $("TRAPPED: " + $_.Exception.GetType().FullName);
      write-error $("TRAPPED: " + $_.Exception.Message);
  Continue
}

	$row = $table.NewRow()
	$row.Server = $strComputer
	
	$ComputerSystem = Gwmi Win32_ComputerSystem -ComputerName $strComputer
	
	If ($ComputerSystem.Caption -ne $Null)
	{
	$OS = Gwmi Win32_OperatingSystem -Comp $strComputer
	$Memory = Gwmi Win32_PhysicalMemory -ComputerName $strComputer
	$NetworkAdapters = GWMI -cl "Win32_NetworkAdapterConfiguration" -name "root\CimV2" -comp $strComputer -filter "IpEnabled = TRUE"
	$Disks = GWMI -cl "Win32_LogicalDisk" -name "root\CimV2" -comp $strComputer -Filter "DriveType = 3"
	$CDs = GWMI -cl "Win32_LogicalDisk" -name "root\CimV2" -comp $strComputer -Filter "DriveType = 5"
	$Volumes = GWMI -cl "Win32_Volume" -name "root\CimV2" -comp $strComputer -Filter "DriveType = 3"
	
	$myModel = $ComputerSystem.Model
	
	
	$myName = $OS.__SERVER
	$myWindowsVer = $OS.Caption
	If ($OS.OtherTypeDescription -eq "R2") 
	{
	$myWindowsR2 = $true
	}
	else 
	{
	$myWindowsR2 = $false
	}
	$myWindowsSP  = $OS.ServicePackMajorVersion
	$myWindowsDir = $OS.WindowsDirectory
	$myWindowsArch = $OS.OSArchitecture
	
	
	$mybo = $NetworkAdapters | Where {$_.IpAddress -ilike "10.141.*.*"}
	$myfo    = $NetworkAdapters | Where {$_.IpAddress -ne $mybo.IPAddress -and $_.IpAddress -notlike "10.5.*" -and $_.IpAddress -notlike "10.141.*" -and $_.IpAddress -notlike "10.2.*" -and $_.IpAddress -notlike "fe80::*"}
	If ($myfo.Length -ge 1)
	{
	$myfomany = $true
	$myfo = $myfo[0]
	}
	
	
	
	Foreach ($Disk in $Disks)
	{
		If ($Disk.DeviceID -eq "A:") { $myDiskA = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "B:") { $myDiskB = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "C:") { $myDiskC = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "D:") { $myDiskD = [math]::truncate($Disk.Size /1GB)+1}
#		If ($Disk.DeviceID -eq "D:") { $myDiskDfree = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "E:") { $myDiskE = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "F:") { $myDiskF = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "G:") { $myDiskG = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "H:") { $myDiskH = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "I:") { $myDiskI = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "J:") { $myDiskJ = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "K:") { $myDiskK = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "L:") { $myDiskL = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "M:") { $myDiskM = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "N:") { $myDiskN = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "O:") { $myDiskO = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "P:") { $myDiskP = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "Q:") { $myDiskQ = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "R:") { $myDiskR = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "S:") { $myDiskS = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "T:") { $myDiskT = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "U:") { $myDiskU = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "V:") { $myDiskV = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "W:") { $myDiskW = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "X:") { $myDiskX = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "Y:") { $myDiskY = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "Z:") { $myDiskZ = [math]::truncate($Disk.Size /1GB)+1}
		If ($Disk.DeviceID -eq "C:") { $myDiskCFree = [math]::truncate($Disk.FreeSpace /1GB)+1}
	}
	
	Foreach ($Disk in $CDs)
	{
		If ($Disk.DeviceID -eq "A:") { $myDiskA = -1}
		If ($Disk.DeviceID -eq "B:") { $myDiskB = -1}
		If ($Disk.DeviceID -eq "C:") { $myDiskC = -1}
		If ($Disk.DeviceID -eq "D:") { $myDiskD = -1}
		If ($Disk.DeviceID -eq "E:") { $myDiskE = -1}
		If ($Disk.DeviceID -eq "F:") { $myDiskF = -1}
		If ($Disk.DeviceID -eq "G:") { $myDiskG = -1}
		If ($Disk.DeviceID -eq "H:") { $myDiskH = -1}
		If ($Disk.DeviceID -eq "I:") { $myDiskI = -1}
		If ($Disk.DeviceID -eq "J:") { $myDiskJ = -1}
		If ($Disk.DeviceID -eq "K:") { $myDiskK = -1}
		If ($Disk.DeviceID -eq "L:") { $myDiskL = -1}
		If ($Disk.DeviceID -eq "M:") { $myDiskM = -1}
		If ($Disk.DeviceID -eq "N:") { $myDiskN = -1}
		If ($Disk.DeviceID -eq "O:") { $myDiskO = -1}
		If ($Disk.DeviceID -eq "P:") { $myDiskP = -1}
		If ($Disk.DeviceID -eq "Q:") { $myDiskQ = -1}
		If ($Disk.DeviceID -eq "R:") { $myDiskR = -1}
		If ($Disk.DeviceID -eq "S:") { $myDiskS = -1}
		If ($Disk.DeviceID -eq "T:") { $myDiskT = -1}
		If ($Disk.DeviceID -eq "U:") { $myDiskU = -1}
		If ($Disk.DeviceID -eq "V:") { $myDiskV = -1}
		If ($Disk.DeviceID -eq "W:") { $myDiskW = -1}
		If ($Disk.DeviceID -eq "X:") { $myDiskX = -1}
		If ($Disk.DeviceID -eq "Y:") { $myDiskY = -1}
		If ($Disk.DeviceID -eq "Z:") { $myDiskZ = -1}	
	}
	
	$IPList = ""
	ForEach ($NIC in $NetworkAdapters){
		ForEach ($IP in $NIC.IPAddress){
			$IPtxt = $IP
			$IPList += $IPtxt
			$IPList += "`n"
		}
	}

	
	$myRAM = $ComputerSystem.TotalPhysicalMemory
	$myRAMgb = [math]::truncate($ComputerSystem.TotalPhysicalMemory /1GB)+1
	$myRAMmb = [math]::truncate($ComputerSystem.TotalPhysicalMemory /1MB)+1
	$myNumOfProcs = $ComputerSystem.NumberOfProcessors
	$myWindowsVer = $myWindowsVer.Replace(",","")
	If ($myfo.IpAddress.Count -gt 0)
	{
	$myfoip = $myfo.IPAddress[0]
	$myfogw = $myfoip.Substring(0,$myfoip.LastIndexOf(".")+1)+"1"
	}
	If ($mybo.IpAddress.Count -gt 0)
	{
	$myboip = $mybo.IPAddress[0]
	}
	
	$myVols = ""
				
		ForEach ($Volume in $Volumes)
		{
			$SpaceUsed = [math]::round(([double]$Volume.Capacity - [double]$Volume.FreeSpace)/1gb,2)
			$SpaceFree = [math]::round(([double]$Volume.FreeSpace)/1gb,2)
			$SpaceTotal = [math]::round(([double]$Volume.Capacity)/1gb,2)
			$myVols = $myVols + $Volume.Name + " : " + $SpaceTotal + "GB Total :: " + $SpaceUsed + "GB Used :: " + $SpaceFree + "GB Free" + "`n"
		}
	
	If ($debug)
	{
		Write-Host "Server                  :" $myName
		Write-Host "FO IP                   :" $myfoip
		Write-Host "FO IP Gateway           :" $myfogw
		If ($myfomany) { Write-Host "FO ** Multiple IPs **" }
		Write-Host "BO IP                   :" $myboip
		Write-Host "Windows Version         :" $myWindowsVer
		Write-Host "Windows Version R2      :" $myWindowsR2
		Write-Host "Windows Service Pack    :" $myWindowsSP
		Write-Host "Windows OS Architecture :" $myWindowsArch
		Write-Host "Windows Directory       :" $myWindowsDir
		Write-Host "Number of Processors    :" $myNumOfProcs
		Write-Host "Total RAM  (GB)         :" $myRAMgb
		Write-Host "Total RAM  (MB)         :" $myRAMmb
		Write-Host "C: Drive                :" $myDiskC
		Write-Host "C: Drive (Available)    :" $myDiskCFree
		Write-Host "D: Drive                :" $myDiskD
		Write-Host "E: Drive                :" $myDiskE
		
		Write-Host "Volumes: `n" $myVols
		
		Write-Host "Additional IP Addresses:"
		Write-Host $IPList
	}
	
	
	$row.Server = $myName
	$row.FOIP = $myfoip
	$row.FOIPGW = $myfogw
	$row.FOIPMany = $myfomany
	$row.BOIP = $myboip
	$row.WinVer = $myWindowsVer
	$row.WinVerR2 = $myWindowsR2
	$row.WinVerSP = $myWindowsSP
	$row.WinOSArc = $myWindowsArch
	$row.WinDir = $myWindowsDir
	$row.RAMgb = $myRAMgb
	$row.RAMmb = $myRAMmb
	$row.Model = $myModel
	If($myDiskA -ne $Null) {$row.DiskA = $myDiskA}
	If($myDiskB -ne $Null) {$row.DiskB = $myDiskB}
	If($myDiskC -ne $Null) {$row.DiskC = $myDiskC}
	If($myDiskD -ne $Null) {$row.DiskD = $myDiskD}
	If($myDiskE -ne $Null) {$row.DiskE = $myDiskE}
	If($myDiskF -ne $Null) {$row.DiskF = $myDiskF}
	If($myDiskG -ne $Null) {$row.DiskG = $myDiskG}
	If($myDiskH -ne $Null) {$row.DiskH = $myDiskH}
	If($myDiskI -ne $Null) {$row.DiskI = $myDiskI}
	If($myDiskJ -ne $Null) {$row.DiskJ = $myDiskJ}
	If($myDiskK -ne $Null) {$row.DiskK = $myDiskK}
	If($myDiskL -ne $Null) {$row.DiskL = $myDiskL}
	If($myDiskM -ne $Null) {$row.DiskM = $myDiskM}
	If($myDiskN -ne $Null) {$row.DiskN = $myDiskN}
	If($myDiskO -ne $Null) {$row.DiskO = $myDiskO}
	If($myDiskP -ne $Null) {$row.DiskP = $myDiskP}
	If($myDiskQ -ne $Null) {$row.DiskQ = $myDiskQ}
	If($myDiskR -ne $Null) {$row.DiskR = $myDiskR}
	If($myDiskS -ne $Null) {$row.DiskS = $myDiskS}
	If($myDiskT -ne $Null) {$row.DiskT = $myDiskT}
	If($myDiskU -ne $Null) {$row.DiskU = $myDiskU}
	If($myDiskV -ne $Null) {$row.DiskV = $myDiskV}
	If($myDiskW -ne $Null) {$row.DiskW = $myDiskW}
	If($myDiskX -ne $Null) {$row.DiskX = $myDiskX}
	If($myDiskY -ne $Null) {$row.DiskY = $myDiskY}
	If($myDiskZ -ne $Null) {$row.DiskZ = $myDiskZ}
	If($myDiskCFree -ne $Null) {$row.DiskCFree = $myDiskCFree}
	$row.Volumes = $myVols
	$row.NumOfProcs = $myNumOfProcs
	$row.IPList = $IPList
	 
	
	#	$VM.MemoryMB
	#	$VM.NumCpu
	#	$VM.NetworkAdapters[0].NetworkName
	#	$VM.NetworkAdapters[1].NetworkName
	#	$VM.HardDisks[0].CapacityKB
	#	$VM.HardDisks[1].CapacityKB
	
	}
	$table.Rows.Add($row)
}

#Connect-VIServer -Server "vcenter.conseco.ad"
#$VMs = Get-VM | Where-Object { $_.powerstate -eq 'PoweredOn' } | Where-Object { $_.name -like 'NT*'} | Where-Object { $_.name -notlike 'NTFV*'}
#
#ForEach ($VM in $VMs)
#{
##	 Write-Host $VM.MemoryMB","$VM.NumCpu","$VM.NetworkAdapters[0].NetworkName","$VM.NetworkAdapters[1].NetworkName","$VM.HardDisks[0].CapacityKB","$VM.HardDisks[1].CapacityKB","$VM.HardDisks[2].CapacityKB","$VM.HardDisks[3].CapacityKB","$VM.HardDisks[4].CapacityKB","$VM.HardDisks[5].CapacityKB","$VM.HardDisks[6].CapacityKB"
#	clear
#	Write-Host "Processing System: " $VM.Name
#	getserverinfo($VM.Name)
#	$table | Export-Csv C:\Test.csv
#	#$table | out-sql -SqlServer NTVCENTERP01 -database "VCenter" -table "jkInfo" -dropexisting $true
#
#
#}

If($true)
{
$Catalog = GC "c:\jake\srv.lst" # File containing server list
#$Catalog = GC "c:\Jake\Srv.txt" # File containing server list
ForEach($Machine in $Catalog) # Loop through file, for each server
{
	If($Machine.substring(0,1) -ne "#")
	{
		Write-Host "Processing System: " $Machine
		getserverinfo($Machine)
		Write-Host "*********************************************"
	}
}
#$table | Export-Csv H:\TRX.csv
$table | Export-Csv H:\DRSystemInfo20111009.csv
#$table | Export-Csv "\\ntdrrepocml\DRREPO\Windows Server Adminstration\DRInfo\DRSystemInfo20101104.csv"
#$table | out-sql -sqlserver vcenter.conseco.ad -database NTDR -table NT_DRSERVERINFO_20101104 -dropexisting $true -RowId "RowID"
}
else
{
getserverinfo("NTRFBRDP04")
$table
}

