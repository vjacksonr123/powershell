# PowerShell cmdlet to display Logical Disk information
$Disk  = get-wmiobject -query "select * from Win32_LogicalDisk" -ComputerName NTLPS5DAT1 
$DiskToPart  = get-wmiobject -query "select * from Win32_LogicalDiskToPartition" -ComputerName NTLPS5DAT1 
$DriveToPart  = get-wmiobject -query "select * from Win32_DiskDriveToDiskPartition" -ComputerName NTLPS5DAT1 
$Drive = get-wmiobject -query "select * from Win32_DiskDrive" -ComputerName NTLPS5DAT1 

$Disk
$DiskToPart
$DriveToPart
$Drive