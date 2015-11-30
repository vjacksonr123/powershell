# vCheck - Daily Error Report 
# 
# Changes:
# Version 3.0 - Added VMs in mis-matched Folder names
# Version 2.9 - Added counts to each titlebar and output to screen whilst running for interactive mode
# Version 2.8 - Changed VC Services to show only unexpected status
# Version 2.7 - Added VMs with outdated Hardware - vSphere Only
# Version 2.6 - Added Slot size check - vSphere Only
# version 2.5 - Added report on Hosts in a HA cluster where the swapfile location is set, check the hosts - Thanks Raphaël SCHITZ (http://www.hypervisor.fr/)
# Version 2.4 - Added VM/Host/Cluster Alerts - Thanks Raphaël SCHITZ (http://www.hypervisor.fr/)
# Version 2.3 - Added VMs with over x amount of vCPUs
# Version 2.2 - Added Dead SCSILuns - Thanks Raphaël SCHITZ (http://www.hypervisor.fr/)
# Version 2.1 - Now checks for VMs stored on storage available to only one host rather than local storage
# Version 2.0 - CPU Ready
# Version 1.17 - vmkernel host log file check for warnings
# Version 1.16 - NTP Server and service check
# Version 1.15 - DRSMigrations & Local Stored VMs
# Version 1.14 - Active/Inactive VMs
# Version 1.13 - Bug Fixes
# Version 1.12 - Added Hosts in Maintenance Mode and not responding + Bug Fixes
# Version 1.11 - Simplified mail function.
# Version 1.10 - Added How many days old the snapshots are
# Version 1.9 - Added ability to change user account which makes the WMI calls
# Version 1.8 - Added Real name resolution via AD and sorted disk space by PerfFree
# Version 1.7 - Added Event Logs for VMware warnings and errors for past day
# Version 1.6 - Add details to service state to see if it is expected or not
# Version 1.5 - Check for objects to see if they exist before sending the email + add VMs with No VMTools 
param( [string] $VISRV)

# You can change the following defaults by altering the below settings:
#
# Set the SMTP Server address
$SMTPSRV = "smtp.conseco.com"
# Set the Email address to recieve from
$EmailFrom = "VIHealthCheck@conseco.com"
# Set the Email address to send the email to
$EmailTo = "jpp@conseco.com"

#### Detail Settings ####
# Set the username of the account with permissions to access the VI Server 
# for event logs and service details - you will be asked for the same username and password
# only the first time this runs after setting the below username.
# If it is left blank it will use the credentials of the user who runs the script
$SetUsername = ""
# Set the location to store the credentials in a secure manner
$CredFile = ".\mycred.crd"
# Set the warning threshold for Datastore % Free Space
$DatastoreSpace = "5"
# Set the warning threshold for snapshots in days old
$SnapshotAge = 14
# Set the number of days to show VMs created & removed for
$VMsNewRemovedAge = 5
# Set the number of days of VC Events to check for errors
$VCEventAge = 1
# Set the number of days of VC Event Logs to check for warnings and errors
$VCEvntlgAge = 1
# Set the number of days of DRS Migrations to report and count on
$DRSMigrateAge = 1
# Local Stored VMs, do not report on any VMs who are defined below
$LVMDoNotInclude = "Template_*|Local_*"
# The NTP server to check
$ntpserver = "ldapcml.conseco.ad"
# vmkernel log file checks - set the number of days to check before today
$vmkernelchk = 1
# CPU ready on VMs - To learn more read here: http://communities.vmware.com/docs/DOC-7390
$PercCPUReady = 10.0
# Change the next line to the maximum amount of vCPUs your VMs are allowed
$vCpu = 4
# Number of slots available in a cluster
$numslots = 10

# This section can be used to turn off certain areas of the report which may not be relevent to your installation
# Set them to $False if you do not want them in your output.
#
# General Summary Info
$ShowGenSum = $true
# Snapshot Information
$ShowSnap = $true
# Datastore Information
$Showdata = $true
# Hosts in Maintenance mode
$ShowMaint = $true
# Hosts not responding or Disconnected
$ShowResDis = $true
# Dead LunPath
$ShowLunPath = $true
# VMs Created or cloned
$ShowCreated = $true
# VMs vCPU
$Showvcpu = $true
# VMs Removed
$ShowRemoved = $true
# Host Swapfile datastores
$ShowSwapFile = $true
# DRS Migrations
$ShowDRSMig = $true
# Cluster Slot Sizes
$ShowSlot = $true
# VM Hardware Version
$ShowHWVer = $true
# VI Events
$ShowVIevents = $true
# VMs in inconsistent folders
$ShowFolders = $true
# VM Tools
$Showtools = $true
# Connected CDRoms
$ShowCDRom = $true
# ConnectedFloppy Drives
$ShowFloppy = $true
# NTP Issues
$ShowNTP = $true
# Single storage VMs
$ShowSingle = $true
# VM CPU Ready
$ShowCPURDY = $true
# Host Alarms
$ShowHostAlarm = $true
# VM Alarms
$ShowVMAlarm = $true
# Cluster Alarms
$ShowCLUAlarm = $true
# VC Service Details
$ShowVCDetails = $true
# VC Event Log Errors
$ShowVCError = $true
# VC Event Log Warnings
$ShowVCWarn = $true
# VMKernel Warning entries
$ShowVMKernel = $true

#######################################
# Start of script
if ($VISRV -eq ""){
	Write-Host
	Write-Host "Please specify a VI Server name eg...."
	Write-Host "      powershell.exe DailyReport.ps1 MYVISERVER"
	Write-Host
	Write-Host
	exit
}

function Write-CustomOut ($Details){
	$LogDate = Get-Date
	Write-Host "$($LogDate.TimeofDay.Hours):$($LogDate.TimeofDay.Minutes) $Details"
}
function Send-SMTPmail($to, $from, $subject, $smtpserver, $body) {
	$mailer = new-object Net.Mail.SMTPclient($smtpserver)
	$msg = new-object Net.Mail.MailMessage($from,$to,$subject,$body)
	$msg.IsBodyHTML = $true
	$mailer.send($msg)
}

Function Get-CustomHTML ($Header){
$Report = @"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html><head><title>$($Header)</title>
<META http-equiv=Content-Type content='text/html; charset=windows-1252'>

<meta name="save" content="history">

<style type="text/css">
DIV .expando {DISPLAY: block; FONT-WEIGHT: normal; FONT-SIZE: 10pt; RIGHT: 8px; COLOR: #ffffff; FONT-FAMILY: Tahoma; POSITION: absolute; TEXT-DECORATION: underline}
TABLE {TABLE-LAYOUT: fixed; FONT-SIZE: 100%; WIDTH: 100%}
*{margin:0}
.dspcont { BORDER-RIGHT: #bbbbbb 1px solid; BORDER-TOP: #bbbbbb 1px solid; PADDING-LEFT: 16px; FONT-SIZE: 8pt;MARGIN-BOTTOM: -1px; PADDING-BOTTOM: 5px; MARGIN-LEFT: 0px; BORDER-LEFT: #bbbbbb 1px solid; WIDTH: 95%; COLOR: #000000; MARGIN-RIGHT: 0px; PADDING-TOP: 4px; BORDER-BOTTOM: #bbbbbb 1px solid; FONT-FAMILY: Tahoma; POSITION: relative; BACKGROUND-COLOR: #f9f9f9}
.filler {BORDER-RIGHT: medium none; BORDER-TOP: medium none; DISPLAY: block; BACKGROUND: none transparent scroll repeat 0% 0%; MARGIN-BOTTOM: -1px; FONT: 100%/8px Tahoma; MARGIN-LEFT: 43px; BORDER-LEFT: medium none; COLOR: #ffffff; MARGIN-RIGHT: 0px; PADDING-TOP: 4px; BORDER-BOTTOM: medium none; POSITION: relative}
.save{behavior:url(#default#savehistory);}
.dspcont1{ display:none}
a.dsphead0 {BORDER-RIGHT: #bbbbbb 1px solid; PADDING-RIGHT: 5em; BORDER-TOP: #bbbbbb 1px solid; DISPLAY: block; PADDING-LEFT: 5px; FONT-WEIGHT: bold; FONT-SIZE: 8pt; MARGIN-BOTTOM: -1px; MARGIN-LEFT: 0px; BORDER-LEFT: #bbbbbb 1px solid; CURSOR: hand; COLOR: #FFFFFF; MARGIN-RIGHT: 0px; PADDING-TOP: 4px; BORDER-BOTTOM: #bbbbbb 1px solid; FONT-FAMILY: Tahoma; POSITION: relative; HEIGHT: 2.25em; WIDTH: 95%; BACKGROUND-COLOR: #cc0000}
a.dsphead1 {BORDER-RIGHT: #bbbbbb 1px solid; PADDING-RIGHT: 5em; BORDER-TOP: #bbbbbb 1px solid; DISPLAY: block; PADDING-LEFT: 5px; FONT-WEIGHT: bold; FONT-SIZE: 8pt; MARGIN-BOTTOM: -1px; MARGIN-LEFT: 0px; BORDER-LEFT: #bbbbbb 1px solid; CURSOR: hand; COLOR: #ffffff; MARGIN-RIGHT: 0px; PADDING-TOP: 4px; BORDER-BOTTOM: #bbbbbb 1px solid; FONT-FAMILY: Tahoma; POSITION: relative; HEIGHT: 2.25em; WIDTH: 95%; BACKGROUND-COLOR: #7BA7C7}
a.dsphead2 {BORDER-RIGHT: #bbbbbb 1px solid; PADDING-RIGHT: 5em; BORDER-TOP: #bbbbbb 1px solid; DISPLAY: block; PADDING-LEFT: 5px; FONT-WEIGHT: bold; FONT-SIZE: 8pt; MARGIN-BOTTOM: -1px; MARGIN-LEFT: 0px; BORDER-LEFT: #bbbbbb 1px solid; CURSOR: hand; COLOR: #ffffff; MARGIN-RIGHT: 0px; PADDING-TOP: 4px; BORDER-BOTTOM: #bbbbbb 1px solid; FONT-FAMILY: Tahoma; POSITION: relative; HEIGHT: 2.25em; WIDTH: 95%; BACKGROUND-COLOR: #A5A5A5}
a.dsphead1 span.dspchar{font-family:monospace;font-weight:normal;}
td {VERTICAL-ALIGN: TOP; FONT-FAMILY: Tahoma}
th {VERTICAL-ALIGN: TOP; COLOR: #cc0000; TEXT-ALIGN: left}
BODY {margin-left: 4pt} 
BODY {margin-right: 4pt} 
BODY {margin-top: 6pt} 
</style>
</head>
<body>
<b><font face="Arial" size="5">$($Header)</font></b><hr size="8" color="#cc0000">
<font face="Arial" size="1"><b>Generated on $($ENV:Computername) - Visit http://virtu-al.net for more great scripts !</b></font><br>
<font face="Arial" size="1">Report created on $(Get-Date)</font>
<div class="filler"></div>
<div class="filler"></div>
<div class="filler"></div>
<div class="save">
"@
Return $Report
}

Function Get-CustomHeader0 ($Title){
$Report = @"
		<h1><a class="dsphead0">$($Title)</a></h1>
	<div class="filler"></div>
"@
Return $Report
}

Function Get-CustomHeader ($Num, $Title){
$Report = @"
	<h2><a class="dsphead$($Num)">
	$($Title)</a></h2>
	<div class="dspcont">
"@
Return $Report
}

Function Get-CustomHeaderClose{

	$Report = @"
		</DIV>
		<div class="filler"></div>
"@
Return $Report
}

Function Get-CustomHeader0Close{

	$Report = @"
</DIV>
"@
Return $Report
}

Function Get-CustomHTMLClose{

	$Report = @"
</div>

</body>
</html>
"@
Return $Report
}

Function Get-HTMLTable {
	param([array]$Content)
	$HTMLTable = $Content | ConvertTo-Html
	$HTMLTable = $HTMLTable -replace '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">', ""
	$HTMLTable = $HTMLTable -replace '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"  "http://www.w3.org/TR/html4/strict.dtd">', ""
	$HTMLTable = $HTMLTable -replace '<html xmlns="http://www.w3.org/1999/xhtml">', ""
	$HTMLTable = $HTMLTable -replace '<html>', ""
	$HTMLTable = $HTMLTable -replace '<head>', ""
	$HTMLTable = $HTMLTable -replace '<title>HTML TABLE</title>', ""
	$HTMLTable = $HTMLTable -replace '</head><body>', ""
	$HTMLTable = $HTMLTable -replace '</body></html>', ""
	Return $HTMLTable
}

Function Get-HTMLDetail ($Heading, $Detail){
$Report = @"
<TABLE>
	<tr>
	<th width='50%'><b>$Heading</b></font></th>
	<td width='50%'>$($Detail)</td>
	</tr>
</TABLE>
"@
Return $Report
}

function Find-Username ($username){
	if ($username -ne $null)
	{
		$root = [ADSI]""
		$filter = ("(&(objectCategory=user)(samAccountName=$Username))")
		$ds = new-object  system.DirectoryServices.DirectorySearcher($root,$filter)
		$ds.PageSize = 1000
		$ds.FindOne()
	}
}

function Get-VIServices
{
	If ($SetUsername -ne ""){
		$Services = get-wmiobject win32_service -Credential $creds -ComputerName $VISRV | Where {$_.DisplayName -like "VMware*" }
	} Else {
		$Services = get-wmiobject win32_service -ComputerName $VISRV | Where {$_.DisplayName -like "VMware*" }
	}
	
	$myCol = @()
	Foreach ($service in $Services){
		$MyDetails = "" | select-Object Name, State, StartMode, Health
		If ($service.StartMode -eq "Auto")
		{
			if ($service.State -eq "Stopped")
			{
				$MyDetails.Name = $service.Displayname
				$MyDetails.State = $service.State
				$MyDetails.StartMode = $service.StartMode
				$MyDetails.Health = "Unexpected State"
			}
		}
		If ($service.StartMode -eq "Auto")
		{
			if ($service.State -eq "Running")
			{
				$MyDetails.Name = $service.Displayname
				$MyDetails.State = $service.State
				$MyDetails.StartMode = $service.StartMode
				$MyDetails.Health = "OK"
			}
		}
		If ($service.StartMode -eq "Disabled")
		{
			If ($service.State -eq "Running")
			{
				$MyDetails.Name = $service.Displayname
				$MyDetails.State = $service.State
				$MyDetails.StartMode = $service.StartMode
				$MyDetails.Health = "Unexpected State"
			}
		}
		If ($service.StartMode -eq "Disabled")
		{
			if ($service.State -eq "Stopped")
			{
				$MyDetails.Name = $service.Displayname
				$MyDetails.State = $service.State
				$MyDetails.StartMode = $service.StartMode
				$MyDetails.Health = "OK"
			}
		}
		$myCol += $MyDetails
	}
	Write-Output $myCol
}

function Get-DatastoreSummary {
	param(
		$InputObject = $null
	)
	process {
		if ($InputObject -and $_) {
			throw 'The input object cannot be bound to any parameters for the command either because the command does not take pipeline input or the input and its properties do not match any of the parameters that take pipeline input.'
			return
		}
		$processObject = $(if ($InputObject) {$InputObject} else {$_})
		if ($processObject) {
			$myCol = @()
			foreach ($ds in $_)
			{
				$MyDetails = "" | select-Object Name, Type, CapacityMB, FreeSpaceMB, PercFreeSpace
				$MyDetails.Name = $ds.Name
				$MyDetails.Type = $ds.Type
				$MyDetails.CapacityMB = $ds.CapacityMB
				$MyDetails.FreeSpaceMB = $ds.FreeSpaceMB
				$MyDetails.PercFreeSpace = [math]::Round(((100 * ($ds.FreeSpaceMB)) / ($ds.CapacityMB)),0)
				$myCol += $MyDetails
			}
			$myCol | Where { $_.PercFreeSpace -lt $DatastoreSpace }
		}
	}
	end {
	}
}

function Get-SnapshotSummary {
	param(
		$InputObject = $null
	)

	PROCESS {
		if ($InputObject -and $_) {
			throw 'ParameterBinderStrings\AmbiguousParameterSet'
			break
		} elseif ($InputObject) {
			$InputObject
		} elseif ($_) {
			
			$mySnaps = @()
			foreach ($snap in $_){
				$SnapshotInfo = Get-SnapshotExtra $snap
				$mySnaps += $SnapshotInfo
			}

			$mySnaps | Select VM, Name, @{N="DaysOld";E={((Get-Date) - $_.Created).Days}}, @{N="Creator";E={(Find-Username (($_.Creator.split("\"))[1])).Properties.displayname}}, Created, Description -ErrorAction SilentlyContinue | Sort DaysOld

		} else {
			throw 'ParameterBinderStrings\InputObjectNotBound'
		}
	}
}

function Get-SnapshotTree{
	param($tree, $target)
	
	$found = $null
	foreach($elem in $tree){
		if($elem.Snapshot.Value -eq $target.Value){
			$found = $elem
			continue
		}
	}
	if($found -eq $null -and $elem.ChildSnapshotList -ne $null){
		$found = Get-SnapshotTree $elem.ChildSnapshotList $target
	}
	
	return $found
}

function Get-SnapshotExtra ($snap){
	$guestName = $snap.VM	# The name of the guest
	$tasknumber = 999		# Windowsize of the Task collector
	$taskMgr = Get-View TaskManager
	
	# Create hash table. Each entry is a create snapshot task
	$report = @{}
	
	$filter = New-Object VMware.Vim.TaskFilterSpec
	$filter.Time = New-Object VMware.Vim.TaskFilterSpecByTime
	$filter.Time.beginTime = (($snap.Created).AddDays(-5))
	$filter.Time.timeType = "startedTime"
	
	$collectionImpl = Get-View ($taskMgr.CreateCollectorForTasks($filter))
	
	$dummy = $collectionImpl.RewindCollector
	$collection = $collectionImpl.ReadNextTasks($tasknumber)
	while($collection -ne $null){
		$collection | where {$_.DescriptionId -eq "VirtualMachine.createSnapshot" -and $_.State -eq "success" -and $_.EntityName -eq $guestName} | %{
			$row = New-Object PsObject
			$row | Add-Member -MemberType NoteProperty -Name User -Value $_.Reason.UserName
			$vm = Get-View $_.Entity
			if($vm -ne $null){ 
				$snapshot = Get-SnapshotTree $vm.Snapshot.RootSnapshotList $_.Result
				if($snapshot -ne $null){
					$key = $_.EntityName + "&" + ($snapshot.CreateTime.ToString())
					$report[$key] = $row
				}
			}
		}
		$collection = $collectionImpl.ReadNextTasks($tasknumber)
	}
	$collectionImpl.DestroyCollector()
	
	# Get the guest's snapshots and add the user
	$snapshotsExtra = $snap | % {
		$key = $_.vm.Name + "&" + ($_.Created.ToString())
		if($report.ContainsKey($key)){
			$_ | Add-Member -MemberType NoteProperty -Name Creator -Value $report[$key].User
		}
		$_
	}
	$snapshotsExtra
}

Function Set-Cred ($File) {
	$Credential = Get-Credential
	$credential.Password | ConvertFrom-SecureString | Set-Content $File
}

Function Get-Cred ($User,$File) {
	$password = Get-Content $File | ConvertTo-SecureString
	$credential = New-Object System.Management.Automation.PsCredential($user,$password)
	$credential
}

function Get-UnShareableDatastore {
	$Report = @()
	Foreach ($datastore in (Get-Datastore)){
		If (($datastore | get-view).summary.multiplehostaccess -eq $false){
			ForEach ($VM in (get-vm -datastore $Datastore )){
				$SAHost = "" | Select VM, Datastore
				$SAHost.VM = $VM.Name 
				$SAHost.Datastore = $Datastore.Name
				$Report += $SAHost
			}
		}
	}
	$Report
}

If ($SetUsername -ne ""){
	if ((Test-Path -Path $CredFile) -eq $false) {
		Set-Cred $CredFile
	}
	$creds = Get-Cred $SetUsername $CredFile
}

Write-CustomOut "Connecting to VI Server"
$VIServer = Connect-VIServer $VISRV
If ($VIServer.IsConnected -ne $true){
	# Fix for scheduled tasks not running.
	$USER = $env:username
	$APPPATH = "C:\Documents and Settings\" + $USER + "\Application Data"

	#SET THE APPDATA ENVIRONMENT WHEN NEEDED
	if ($env:appdata -eq $null -or $env:appdata -eq 0)
	{
		$env:appdata = $APPPATH
	}
	$VIServer = Connect-VIServer $VISRV
	If ($VIServer.IsConnected -ne $true){
		send-SMTPmail -to $EmailTo -from $EmailFrom -subject "ERROR: $VISRV Daily Report" -smtpserver $SMTPSRV -body "The Connect-VISERVER Cmdlet did not work, please check you VI Server."
		exit
	}
	
}

# Find out which version of the VI we are connecting to
If ((Get-View ServiceInstance).Content.About.Version -ge "4.0.0"){
	$VIVersion = 4
}
Else{
	$VIVersion = 3
}

Write-CustomOut "Collecting VM Objects"
$VM = Get-VM | Sort Name
Write-CustomOut "Collecting VM Host Objects"
$VMH = Get-VMHost | Sort Name
Write-CustomOut "Collecting Cluster Objects"
$Clusters = Get-Cluster | Sort Name
Write-CustomOut "Collecting Datastore Objects"
$Datastores = Get-Datastore | Sort Name
Write-CustomOut "Collecting Detailed VM Objects"
$FullVM = Get-View -ViewType VirtualMachine | Where {-not $_.Config.Template}
Write-CustomOut "Collecting Template Objects"
$VMTmpl = Get-Template
Write-CustomOut "Collecting Detailed VI Objects"
$serviceInstance = get-view ServiceInstance
Write-CustomOut "Collecting Detailed Alarm Objects"
$alarmMgr = get-view $serviceInstance.Content.alarmManager
Write-CustomOut "Collecting Detailed VMHost Objects"
$HostsViews = Get-View -ViewType hostsystem

# Check for vSphere
If ($serviceInstance.Client.ServiceContent.About.Version -ge 4){
	$vSphere = $true
}

$MyReport = Get-CustomHTML "$VIServer vCheck"
	$MyReport += Get-CustomHeader0 ($VIServer.Name)
		
		# ---- General Summary Info ----
		If ($ShowGenSum){
			Write-CustomOut "..Adding General Summary Info to the report"
			$MyReport += Get-CustomHeader "1" "General Details"
				$MyReport += Get-HTMLDetail "Number of Hosts:" (@($VMH).Count)
				$MyReport += Get-HTMLDetail "Number of VMs:" (@($VM).Count)
				$MyReport += Get-HTMLDetail "Number of Templates:" (@($VMTmpl).Count)
				$MyReport += Get-HTMLDetail "Number of Clusters:" (@($Clusters).Count)
				$MyReport += Get-HTMLDetail "Number of Datastores:" (@($Datastores).Count)
				$MyReport += Get-HTMLDetail "Active VMs:" (@($FullVM | Where { $_.Runtime.PowerState -eq "poweredOn" }).Count) 
				$MyReport += Get-HTMLDetail "In-active VMs:" (@($FullVM | Where { $_.Runtime.PowerState -eq "poweredOff" }).Count) 
				$MyReport += Get-HTMLDetail "DRS Migrations for last $($DRSMigrateAge) Days:" @(Get-VIEvent -maxsamples 10000 -Start (Get-Date).AddDays(-$DRSMigrateAge ) | where {$_.Gettype().Name -eq "DrsVmMigratedEvent"}).Count
			$MyReport += Get-CustomHeaderClose
		}
		
		# ---- Snapshot Information ----
		If ($ShowSnap){
			Write-CustomOut "..Checking Snapshots"
			$Snapshots = @($VM | Get-Snapshot | Where {$_.Created -lt ((Get-Date).AddDays(-$SnapshotAge))} | Get-SnapshotSummary)
			If (($Snapshots | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "Snapshots (Over $SnapshotAge Days Old) : $($snapshots.count)"
					$MyReport += Get-HTMLTable $Snapshots
				$MyReport += Get-CustomHeaderClose
			}
		}
				
		# ---- Datastore Information ----
		If ($Showdata){
			Write-CustomOut "..Checking Datastores"
			$OutputDatastores = @($Datastores | Get-DatastoreSummary | Sort PercFreeSpace)
			If (($OutputDatastores | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "Datastores (Less than $DatastoreSpace% Free) : $($OutputDatastores.count)"
					$MyReport += Get-HTMLTable $OutputDatastores
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Hosts in Maintenance Mode ----
		If ($ShowMaint){
			Write-CustomOut "..Checking Hosts in Maintenance Mode"
			$MaintHosts = @($VMH | where {$_.State -match "Maintenance"} | Select name)
			If (($MaintHosts | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "Hosts in Maintenance Mode : $($MaintHosts.count)"
					$MyReport += Get-HTMLTable $MaintHosts
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Hosts Not responding or Disconnected ----
		If ($ShowResDis){
			Write-CustomOut "..Checking Hosts Not responding or Disconnected"
			$RespondHosts = @($VMH | where {$_.State -match "NotResponding" -or $_.State -match "Disconnected"} | get-view | Select name, @{N="Connection State";E={$_.Runtime.ConnectionState}}, @{N="Power State";E={$_.Runtime.PowerState}})
			If (($RespondHosts | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "Hosts not responding or disconnected : $($RespondHosts.count)"
				$MyReport += Get-HTMLTable $RespondHosts
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Dead LunPath ----
		If ($ShowLunPath){
			Write-CustomOut "..Checking Hosts Dead Lun Path"
			$deadluns = @()
			foreach ($esxhost in ($VMH | where {$_.State -ne "Disconnected"}))
			{
				$esxluns = Get-ScsiLun -vmhost $esxhost |Get-ScsiLunPath
				foreach ($esxlun in $esxluns){
					if ($esxlun.state -eq "Dead") {
						$myObj = "" |
						Select VMHost, Lunpath, State
						$myObj.VMHost = $esxhost
						$myObj.Lunpath = $esxlun.Lunpath
						$myObj.State = $esxlun.state
						$deadluns += $myObj
					}    
				}
			}
			If (($deadluns | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "Dead LunPath : $($deadluns.count)"
				$MyReport += Get-HTMLTable $deadluns
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- VMs created or Cloned ----
		If ($ShowCreated){
			Write-CustomOut "..Checking for created or cloned VMs"
			$VIEvent = Get-VIEvent -maxsamples 10000 -Start (Get-Date).AddDays(-$VMsNewRemovedAge)
			$OutputCreatedVMs = @($VIEvent | where {$_.Gettype().Name -eq "VmCreatedEvent" -or $_.Gettype().Name -eq "VmBeingClonedEvent" -or $_.Gettype().Name -eq "VmBeingDeployedEvent"} | Select createdTime, @{N="User";E={(Find-Username (($_.userName.split("\"))[1])).Properties.displayname}}, fullFormattedMessage)
			If (($OutputCreatedVMs | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "VMs Created or Cloned (Last $VMsNewRemovedAge Day(s)) : $($OutputCreatedVMs.count)"
					$MyReport += Get-HTMLTable $OutputCreatedVMs
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- VMs Removed ----
		If ($ShowRemoved){
			Write-CustomOut "..Checking for removed VMs"
			$OutputRemovedVMs = @($VIEvent | where {$_.Gettype().Name -eq "VmRemovedEvent"}| Select createdTime, @{N="User";E={(Find-Username (($_.userName.split("\"))[1])).Properties.displayname}}, fullFormattedMessage)
			If (($OutputRemovedVMs | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "VMs Removed (Last $VMsNewRemovedAge Day(s)) : $($OutputRemovedVMs.count)"
					$MyReport += Get-HTMLTable $OutputRemovedVMs
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- VMs vCPU ----
		If ($Showvcpu){
			Write-CustomOut "..Checking for VMs with over $vCPU vCPUs"
			$OverCPU = @($VM | Where {$_.NumCPU -gt $vCPU} | Select Name, PowerState, NumCPU)
			If (($OverCPU | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "VMs with over $vCPU vCPUs : $($OverCPU.count)"
					$MyReport += Get-HTMLTable $OverCPU
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- VMSwapfileDatastore not set----
		If ($Showswapfile){
			Write-CustomOut "..Checking Host Swapfile datastores"
			$cluswap = @()
			foreach ($clusview in $clusviews) {
				if ($clusview.ConfigurationEx.VmSwapPlacement -eq "hostLocal") {
					$CluNodesViews = Get-VMHost -Location $clusview.name |Get-View
					foreach ($CluNodesView in $CluNodesViews) {
						if ($CluNodesView.Config.LocalSwapDatastore.Value -eq $null) {
							$Details = "" | Select-Object Cluster, Host, Message
							$Details.cluster = $clusview.name
							$Details.host = $CluNodesView.name
							$Details.Message = "Swapfile location NOT SET"
							$cluswap += $Details
						}
					}
				}
			}
		
			If (($cluswap | Measure-Object).count -gt 0) {
				$cluswap = $cluswap | sort name
				$MyReport += Get-CustomHeader "1" "VMSwapfileDatastore(s) not set : $($cluswap.count)"
					$MyReport += Get-HTMLTable $cluswap
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- DRS Migrations ----
		If ($ShowDRSMig){
			Write-CustomOut "..Checking DRS Migrations"
			$DRSMigrations = @(Get-VIEvent -maxsamples 10000 -Start (Get-Date).AddDays(-$DRSMigrateAge ) | where {$_.Gettype().Name -eq "DrsVmMigratedEvent"} | select createdTime, fullFormattedMessage)
			If (($DRSMigrations | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "DRS Migrations (Last $DRSMigrateAge Day(s)) : $($DRSMigrations.count)"
					$MyReport += Get-HTMLTable $DRSMigrations
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# --- Cluster Slot Sizes ---
		If ($Showslot){
			If ($vSphere -eq $true){
				Write-CustomOut "..Checking Cluster Slot Sizes"
				$SlotInfo = @()
				Foreach ($Cluster in ($Clusters| Get-View)){
					If ($Cluster.Configuration.DasConfig.Enabled -eq $true){
						$SlotDetails = $Cluster.RetrieveDasAdvancedRuntimeInfo()
						$Details = "" | Select Cluster, TotalSlots, UsedSlots, AvailableSlots
						$Details.Cluster = $Cluster.Name
						$Details.TotalSlots =  $SlotDetails.TotalSlots
						$Details.UsedSlots = $SlotDetails.UsedSlots
						$Details.AvailableSlots = $SlotDetails.TotalSlots - $SlotDetails.UsedSlots
						$SlotInfo += $Details
					}
				}
				$SlotCHK = @($SlotInfo | Where { $_.AvailableSlots -lt $numslots})
				If (($SlotCHK | Measure-Object).count -gt 0) {
					$MyReport += Get-CustomHeader "1" "Clusters with less than $numslots Slot Sizes : $($SlotCHK.count)"
						$MyReport += Get-HTMLTable $SlotCHK
					$MyReport += Get-CustomHeaderClose	
				}
			}
		}
		
		# ---- VM Hardware Version ----
		If ($ShowHWVer){
			If ($vSphere -eq $true){
				Write-CustomOut "..Checking VM Hardware Version"
				$HV = @($FullVM | Select Name, @{N="HardwareVersion";E={"Version $($_.Config.Version[5])"}} | Where {$_.HardwareVersion -ne "Version 7"})
				If (($HV | Measure-Object).count -gt 0) {
					$MyReport += Get-CustomHeader "1" "VMs with old hardware : $($HV.count)"
						$MyReport += Get-HTMLTable $HV
					$MyReport += Get-CustomHeaderClose	
				}
			}
		}
		
		# ---- VC Errors ----
		If ($ShowVIEvents){
			Write-CustomOut "..Checking VI Events"
			$OutputErrors = @(Get-VIEvent -maxsamples 10000 -Start (Get-Date).AddDays(-$VCEventAge ) -Type Error | Select @{N="Host";E={$_.host.name}}, createdTime, @{N="User";E={(Find-Username (($_.userName.split("\"))[1])).Properties.displayname}}, fullFormattedMessage)
			If (($OutputErrors | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "Error Events (Last $VCEventAge Day(s)) : $($OutputErrors.count)"
					$MyReport += Get-HTMLTable $OutputErrors
				$MyReport += Get-CustomHeaderClose	
			}
		}
		
		# ---- VMs in inconsistent folders ----
		If ($Showfolders){
			Write-CustomOut "..Checking VMs in Inconsistent folders"
			$VMFolder = @()
			Foreach ($CHKVM in $FullVM){
				$Details = "" |Select-Object VM,Path
				$Folder = ((($CHKVM.Summary.Config.VmPathName).Split(']')[1]).Split('/'))[0].TrimStart(' ')
				$Path = ($CHKVM.Summary.Config.VmPathName).Split('/')[0]
				If ($CHKVM.Name-ne $Folder){
					$Details.VM= $CHKVM.Name
					$Details.Path= $Path
					$VMFolder += $Details}
			}
			If (($VMFolder | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "VMs in Inconsistent folders : $($VMFolder.count)"
					$MyReport += Get-HTMLTable $VMFolder
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- No VM Tools ----
		If ($Showtools){
			Write-CustomOut "..Checking VM Tools"
			$NoTools = @($FullVM | Where {$_.Runtime.Powerstate -eq "poweredOn" -And ($_.Guest.toolsStatus -eq "toolsNotInstalled" -Or $_.Guest.ToolsStatus -eq "toolsNotRunning")} | Select Name, @{N="Status";E={$_.Guest.ToolsStatus}})
			If (($NoTools | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "No VMTools : $($NoTools.count)"
					$MyReport += Get-HTMLTable $NoTools
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- CD-Roms Connected ----
		If ($ShowCDROM){
			Write-CustomOut "..Checking for connected CDRoms"
			$CDConn = @($VM | Where { $_ | Get-CDDrive | Where { $_.ConnectionState.Connected -eq $true } } | Select Name, Host)
			If (($CDConn | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "VM: CD-ROM Connected - VMotion Violation : $($CDConn.count)"
					$MyReport += Get-HTMLTable $CDConn
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Floppys Connected ----
		If ($ShowFloppy){
			Write-CustomOut "..Checking for connected floppy drives"
			$Floppy = @($VM | Where { $_ | Get-FloppyDrive | Where { $_.ConnectionState.Connected -eq $true } } | Select Name, Host)
			If (($Floppy | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "VM:Floppy Drive Connected - VMotion Violation : $($Floppy.count)"
					$MyReport += Get-HTMLTable $Floppy
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Single Storage VMs ----
		If ($ShowSingle){
			Write-CustomOut "..Checking Datastores assigned to single hosts for VMs"
			$LocalVMs = @($LocalOnly | Get-UnShareableDatastore | Where { $_.VM -notmatch $LVMDoNotInclude })
			If (($LocalVMs | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "VMs stored on non shared datastores : $($LocalVMs.count)"
					$MyReport += Get-HTMLTable $LocalVMs
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- NTP Check ----
		If ($ShowNTP){
			Write-CustomOut "..Checking NTP Name and Service"
			$NTPCheck = @($VMH | Where {$_.state -ne "Disconnected"} | Select Name, @{N="NTPServer";E={$_ | Get-VMHostNtpServer}}, @{N="ServiceRunning";E={(Get-VmHostService -VMHost $_ | Where-Object {$_.key -eq "ntpd"}).Running}} | Where {$_.ServiceRunning -eq $false -or $_.NTPServer -ne $ntpserver})
			If (($NTPCheck | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "NTP Issues : $($NTPCheck.count)"
					$MyReport += Get-HTMLTable $NTPCheck
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- CPU %Ready Check ----
		If ($ShowCPURDY){
			Write-CustomOut "..Checking VM CPU %RDY"
			$myCol = @()
			ForEach ($v in ($VM | Where {$_.PowerState -eq "PoweredOn"})){
				For ($cpunum = 0; $cpunum -lt $v.NumCpu; $cpunum++){
					$myObj = "" | Select VM, VMHost, CPU, PercReady
					$myObj.VM = $v.Name
					$myObj.VMHost = $v.Host
					$myObj.CPU = $cpunum
					$myObj.PercReady = [Math]::Round((($v | Get-Stat -Stat Cpu.Ready.Summation -RealTime | Where {$_.Instance -eq $cpunum} | Measure-Object -Property Value -Average).Average)/200,1)
					$myCol += $myObj
				}
			}
			
			$rdycheck = @($myCol | Where {$_.PercReady -gt $PercCPUReady} | Sort PercReady -Descending)
			If (($rdycheck | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "VM CPU % RDY over $PercCPUReady : $($rdycheck.count)"
					$MyReport += Get-HTMLTable $rdycheck
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Host Alarm ----
		If ($ShowHostAlarm){
			Write-CustomOut "..Checking Host Alarms"
			$alarms = $alarmMgr.GetAlarm($null)
			$valarms = $alarms | select value, @{N="name";E={(Get-View -Id $_).Info.Name}}
			$hostsalarms = @()
			foreach ($HostsView in $HostsViews){
				if ($HostsView.TriggeredAlarmState){
					$hostsTriggeredAlarms = $HostsView.TriggeredAlarmState
					Foreach ($hostsTriggeredAlarm in $hostsTriggeredAlarms){
						$Details = "" | Select-Object Object, Alarm, Status, Time
						$Details.Object = $HostsView.name
						$Details.Alarm = ($valarms |?{$_.value -eq ($hostsTriggeredAlarm.alarm.value)}).name
						$Details.Status = $hostsTriggeredAlarm.OverallStatus
						$Details.Time = $hostsTriggeredAlarm.time
						$hostsalarms += $Details
					}
				}
			}
	
			If (($hostsalarms | Measure-Object).count -gt 0) {
				$hostsalarms = @($hostsalarms |sort Object)
				$MyReport += Get-CustomHeader "1" "Host(s) Alarm(s) : $($hostalarms.count)"
					$MyReport += Get-HTMLTable $hostsalarms
				$MyReport += Get-CustomHeaderClose
			}                 
		}
		
		# ---- VM Alarm ----
		If ($ShowVMAlarm){
			Write-CustomOut "..Checking VM Alarms"
			$vmsalarms = @()
			foreach ($VMView in $VMViews){
				if ($VMView.TriggeredAlarmState){
					$VMsTriggeredAlarms = $VMView.TriggeredAlarmState
					Foreach ($VMsTriggeredAlarm in $VMsTriggeredAlarms){
						$Details = "" | Select-Object Object, Alarm, Status, Time
						$Details.Object = $VMView.name
						$Details.Alarm = ($valarms |?{$_.value -eq ($VMsTriggeredAlarm.alarm.value)}).name
						$Details.Status = $VMsTriggeredAlarm.OverallStatus
						$Details.Time = $VMsTriggeredAlarm.time
						$vmsalarms += $Details
					}
				}
			}
	
			If (($vmsalarms | Measure-Object).count -gt 0) {
				$vmsalarms = $vmsalarms | sort Object
				$MyReport += Get-CustomHeader "1" "VM(s) Alarm(s) : $($vmsalarms.count)"
					$MyReport += Get-HTMLTable $vmsalarms
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Cluster ConfigIssue ----
		If ($ShowCLUAlarm){
			Write-CustomOut "..Checking Cluster Configuration Issues"
			$clualarms = @()
			$clusviews = Get-View -ViewType ClusterComputeResource
			foreach ($clusview in $clusviews) {
				if ($clusview.ConfigIssue) {           
					$CluConfigIssues = $clusview.ConfigIssue
					Foreach ($CluConfigIssue in $CluConfigIssues) {
						$Details = "" | Select-Object Name, Message
						$Details.name = $clusview.name
						$Details.Message = $CluConfigIssue.FullFormattedMessage
						$clualarms += $Details
					}
				}
			}
	
			If (($clualarms | Measure-Object).count -gt 0) {
				$clualarms = $clualarms | sort name
				$MyReport += Get-CustomHeader "1" "Cluster(s) Config Issue(s) : $($Clualarms.count)"
					$MyReport += Get-HTMLTable $clualarms
				$MyReport += Get-CustomHeaderClose
			}
		}

		# ---- Virtual Center Details ----
		If ($ShowVCDetails){
			Write-CustomOut "..Checking VC Services"
			$Services = @(Get-VIServices | Where {$_.Name -ne $null -and $_.Health -ne "OK"})
			If (($Services | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "$VIServer Service Details : $($Services.count)"
					$MyReport += Get-HTMLTable ($Services)
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Virtual Center Event Logs - Error ----
		If ($Showvcerror){
			Write-CustomOut "..Checking VC Error Event Logs"
			$ConvDate = [System.Management.ManagementDateTimeConverter]::ToDmtfDateTime([DateTime]::Now.AddDays(-$VCEvntlgAge))
			If ($SetUsername -ne ""){
				$ErrLogs = @(Get-WmiObject -Credential $creds -computer $VIServer -query ("Select * from Win32_NTLogEvent Where Type='Error' and TimeWritten >='" + $ConvDate + "'") | Where {$_.Message -like "*VMware*"} | Select @{N="TimeGenerated";E={$_.ConvertToDateTime($_.TimeGenerated)}}, Message)
			} Else {
				$ErrLogs = @(Get-WmiObject -computer $VIServer -query ("Select * from Win32_NTLogEvent Where Type='Error' and TimeWritten >='" + $ConvDate + "'") | Where {$_.Message -like "*VMware*"} | Select @{N="TimeGenerated";E={$_.ConvertToDateTime($_.TimeGenerated)}}, Message)
			}
			
			If (($ErrLogs | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "$VIServer Event Logs ($VCEvntlgAge day(s)): Error : $($ErrLogs.count)"
					$MyReport += Get-HTMLTable ($ErrLogs)
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Virtual Center Event Logs - Warning ----
		If ($Showvcwarn){
			Write-CustomOut "..Checking VC Warning Event Logs"
			$ConvDate = [System.Management.ManagementDateTimeConverter]::ToDmtfDateTime([DateTime]::Now.AddDays(-$VCEvntlgAge))
			If ($SetUsername -ne ""){
				$WarnLogs = @(Get-WmiObject -Credential $creds -computer $VIServer -query ("Select * from Win32_NTLogEvent Where Type='Warning' and TimeWritten >='" + $ConvDate + "'") | Where {$_.Message -like "*VMware*"} | Select @{N="TimeGenerated";E={$_.ConvertToDateTime($_.TimeGenerated)}}, Message)
			} Else {
				$WarnLogs = @(Get-WmiObject -computer $VIServer -query ("Select * from Win32_NTLogEvent Where Type='Warning' and TimeWritten >='" + $ConvDate + "'") | Where {$_.Message -like "*VMware*"} | Select @{N="TimeGenerated";E={$_.ConvertToDateTime($_.TimeGenerated)}}, Message )
			}
			If (($WarnLogs | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "$VIServer Event Logs ($VCEvntlgAge day(s)): Warning : $($WarnLogs.count)"
					$MyReport += Get-HTMLTable ($WarnLogs)
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- vmkernel log file check ----
		If ($Showvmkernel){
			Write-CustomOut "..Checking vmkernel logs for warnings"
			$days = ([string](-$vmkernelchk..0 | Foreach-Object {Get-Date -date (Get-Date).AddDays($_) -uFormat "%b %e|"})).TrimEnd("|").Replace("| ","|")
			$VMKernelWarning = @()
			$rexp = [regex]("(?:" + $days + ")" + ".*" + "WARNING")
			foreach ($VMHost in ($VMH)){
				$Warnings = (Get-Log –VMHost ($VMHost) -Key vmkernel -ErrorAction SilentlyContinue).Entries | where {$_ -match $rexp}
				if ($Warnings -ne $null) {
					$Warnings | % {
						$Details = "" | Select-Object VMHost, Message
						$Details.VMHost = $VMHost.Name
						$Details.Message = $_
						$VMKernelWarning += $Details
					}
				}
			}
			
			If (($VMKernelWarning | Measure-Object).count -gt 0) {
				$MyReport += Get-CustomHeader "1" "Warning messages: vmkernel : $($VMKernelWarning.count)"
					$MyReport += Get-HTMLTable $VMKernelWarning
				$MyReport += Get-CustomHeaderClose
			}
		}
	$MyReport += Get-CustomHeader0Close
$MyReport += Get-CustomHTMLClose

#Uncomment the following lines to save the htm file in a central location
#$Date = Get-Date
#$Filename = "C:\Temp\" + $VIServer + "DailyReport" + "_" + $Date.Day + "-" + $Date.Month + "-" + $Date.Year + ".htm"
#$MyReport | out-file -encoding ASCII -filepath $Filename
#Invoke-Item $Filename

Write-CustomOut "..Sending Email"
send-SMTPmail $EmailTo $EmailFrom "$VISRV Daily Report" $SMTPSRV $MyReport

$VIServer | Disconnect-VIServer -Confirm:$false
