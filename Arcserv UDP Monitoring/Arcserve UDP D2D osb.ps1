Param(
    [string]$dom,
    [string]$user,
    [string]$pass,
    [string]$Hourstogoback
)

# IMPORTANT NOTE : THE SCRIPT IS IN DEBUG SO THE USERNAME/PASSWORD IS PRE-ENTERED
# IMPORTANT NOTE : THE SCRIPT IS IN DEBUG SO THE USERNAME/PASSWORD IS PRE-ENTERED
# IMPORTANT NOTE : THE SCRIPT IS IN DEBUG SO THE USERNAME/PASSWORD IS PRE-ENTERED
# IMPORTANT NOTE : THE SCRIPT IS IN DEBUG SO THE USERNAME/PASSWORD IS PRE-ENTERED
$user = "nesiagent"
$pass = "r00tr00t~"
$dom  = "osb"
$Hourstogoback=100

# This Don’t forget to change IP address/host name for domain variable above and in WSDL URI below 


[system.net.servicepointmanager]::servercertificatevalidationcallback = {$True}

$URI = "https://localhost:8014/WebServiceImpl/services/WebServiceImpl?WSDL"
$agent = New-WebServiceProxy -Uri $URI  -Namespace WebServiceProxy -Class D2Dagent


# We need cookie container to maintain session cookie 
$cookieContainer = New-Object system.Net.CookieContainer
$agent.CookieContainer = $cookieContainer

# This prints all available methods 
# $agent | get-member -type method


#lets authenticate against agent web service and print session ID 
$res = $agent.login($user,$pass, $dom)
echo "Created new session $res"


#lets get current agent configuratino and print current destination 
$cfg = $agent.getD2DConfiguration();
Write-host "Current backup destinatination: "   $cfg.backupConfiguration.destination  
$cfg.backupConfiguration.destination
$cfg.backupConfiguration.backupVolumes.fullMachine #true/false
$cfg.backupConfiguration.backupVolumes.volumes #blank if true
$cfg.backupConfiguration.enableEncryption #true/false



[datetime]$datefrom = get-date 
[datetime]$dateto=get-date
$datetostr = $dateto.ToString(("yyyy-MM-dd hh:mm:ss"))
$datefrom=$datefrom.AddHours(-$Hourstogoback)
$datefromstr=$datefrom.ToString(("yyyy-MM-dd hh:mm:ss"))

$flt = New-Object WebServiceProxy.flashJobHistoryFilter
$flt.jobType = -1;
$flt.jobStatus = -1;
$flt.startTime = $datefrom;
$flt.startTimeSpecified = 1


$jobs = $agent.getJobHistory(0,100,$flt) #| where-object {$_.jobLocalEndTime -gt $datefromstr}
#$jobs = $agent.getRecentBackupsByServerTime(1,1,$datefromstr,$dateto,"false")



#we can simply dump all log records to the console 
#Write-output "Retrieved "  $jobs.logs
$JobInProgressCount=0
$JobSuccessCount=0
$JobFailCount=0
$JobCancelledCount=0
$JobRebootCount=0
$JobOtherCount=0

$Hourstogobacklog=100

[datetime]$MostRecentJobStart = get-date

[datetime]$MostRecentJobFinish = get-date

$MostRecentJobStart=$MostRecentJobStart.AddHours(-$Hourstogobacklog)

$RecentJobStatus = "No backup Data for polling period"
$RecentJobID = 50

#or we can have more elaborated logics
ForEach ($record  in $jobs.jobHistory)
{
    #you may format and/or  feed data to external data cosumer or write into DB
  #  Write-host "jobID: " $record.jobId " jobName:" $record.jobName " jobStatus: "  $record.jobStatus
    #$record |fl
  
        if ( $record.jobStatus -eq  0)
        {
            $JobInProgressCount+=1
        }
        elseif ( $record.jobStatus -eq  1)
        {
            $JobSuccessCount+=1
        }
        elseif ( $record.jobStatus -eq  2)
        {
            $JobCancelledCount+=1
        }
        elseif ( $record.jobStatus -eq  3)
        {
            $JobFailCount+=1
        }
        elseif ( $record.jobStatus -eq  4)
        {
            $JobFailCount+=1
        }
        elseif ( $record.jobStatus -eq  5)
        {
            $JobInProgressCount+=1
        }
        elseif ( $record.jobStatus -eq  6)
        {
            $JobInProgressCount+=1
            
        }
        elseif ( $record.jobStatus -eq  7)
        {
            $JobFailCount+=1
            
        }
        elseif ( $record.jobStatus -eq  8)
        {
            $JobRebootCount+=1
            
        }
        else
        {
            $JobOtherCount+=1
            $record |fl
        }
        if($record.jobLocalStartTime -ne $null)
        {
            if([datetime]$record.jobLocalStartTime -gt $MostRecentJobStart)
            {
                $MostRecentJobStart =[datetime]$record.jobLocalStartTime
            }

        }
        if($record.jobLocalEndTime -ne $null)
        {
            if([datetime]$record.jobLocalEndTime -gt $MostRecentJobFinish)
            {
                $MostRecentJobFinish =[datetime]$record.jobLocalEndTime
                if ( $record.jobStatus -eq  0)
                {
                    $RecentJobStatus="Job In Progress"
                    $RecentJobID=0
                }
                elseif ( $record.jobStatus -eq  1)
                {
                     $RecentJobStatus="Job Finished Successfully"
                    $RecentJobID=0
                }
                elseif ( $record.jobStatus -eq  2)
                {
                     $RecentJobStatus="Job Cancelled"
                    $RecentJobID=2
                }
                elseif ( $record.jobStatus -eq  3)
                {
                     $RecentJobStatus="Job Failed"
                    $RecentJobID=2
                }
                elseif ( $record.jobStatus -eq  4)
                {
                     $RecentJobStatus="Job Incomplete"
                    $RecentJobID=0
                }
                elseif ( $record.jobStatus -eq  5)
                {
                     $RecentJobStatus="Job Idle (In Progress)"
                    $RecentJobID=0
                }
                elseif ( $record.jobStatus -eq  6)
                {
                     $RecentJobStatus="Job Waiting (In Progress)"
                    $RecentJobID=0
                }
                elseif ( $record.jobStatus -eq  7)
                {
                     $RecentJobStatus="Job Crashed (Failed)"
                    $RecentJobID=2
                }
                elseif ( $record.jobStatus -eq  8)
                {
                     $RecentJobStatus="Job Waiting for a Reboot"
                    $RecentJobID=1
                }
                else
                {
                     $RecentJobStatus="Invalid Job Status"
                    $RecentJobID=2
                }   
        }
        }
}

$JobInProgressCount
$JobSuccessCount
$JobFailCount
$JobCancelledCount
$JobRebootCount
$JobOtherCount
$cfg.backupConfiguration.destination  
$MostRecentJobStart
$MostRecentJobFinish
$RecentJobStatus
$RecentJobID








$ns=[wmiclass]'__namespace'
$sc=$ns.CreateInstance()
$sc.Name='ncentral'
$sc.Put()
$file="c:\temp\file1.txt"

if ((get-wmiobject -namespace "root/cimv2/ncentral" -list -EV namespaceError) | ? {$_.name -match "CAUDP"})
{
   
    $dbcount = New-Object system.Collections.ArrayList
    $testfolder=Get-WMIObject -namespace root/cimv2/ncentral -query "Select * From CAUDP"
    $rr=0;
    Get-WMIObject -namespace root/cimv2/ncentral -query "Select * From CAUDP" | foreach {$dbcount.Insert($rr, $_);$rr++ }

    $dbcnt=$dbcount.count
    if($dbcount.count -ge '1')
    {
        $testfolder | Remove-WMIObject
    }  

}
else
{
    

    if( ![string]::IsNullOrEmpty( $namespaceError[0] ) )
    {
    	add-content $file "ERROR accessing namespace: $namespaceError[0]"
    	RETURN
    }

    try 
    {

    $newClass = New-Object System.Management.ManagementClass `
        ("root\cimv2\ncentral", [String]::Empty, $null); 
        $newClass["__CLASS"] = "CAUDP"; 

    $newClass.Qualifiers.Add("Static", $true)
	$newClass.Properties.Add("BackupDestination", [System.Management.CimType]::String, $false)
    $newClass.Properties["BackupDestination"].Qualifiers.Add("Key", $true)
	
    $newClass.Qualifiers.Add("Static", $true)
	$newClass.Properties.Add("JobSuccessCount", [System.Management.CimType]::uint16, $false)
	
    $newClass.Qualifiers.Add("Static", $true)
	$newClass.Properties.Add("JobFailCount", [System.Management.CimType]::uint16, $false)
	
    $newClass.Qualifiers.Add("Static", $true)
	$newClass.Properties.Add("JobInProgressCount", [System.Management.CimType]::uint16, $false)
	
    $newClass.Qualifiers.Add("Static", $true)
	$newClass.Properties.Add("JobOtherCount", [System.Management.CimType]::uint16, $false)
	
    $newClass.Qualifiers.Add("Static", $true)
	$newClass.Properties.Add("JobCancelledCount", [System.Management.CimType]::uint16, $false)
	
    $newClass.Qualifiers.Add("Static", $true)
	$newClass.Properties.Add("JobRebootCount", [System.Management.CimType]::uint16, $false)
	
    $newClass.Qualifiers.Add("Static", $true)
	$newClass.Properties.Add("MostRecentJobStart", [System.Management.CimType]::String, $false)
	
    $newClass.Qualifiers.Add("Static", $true)
	$newClass.Properties.Add("MostRecentJobFinish", [System.Management.CimType]::String, $false)
	
    $newClass.Qualifiers.Add("Static", $true)
	$newClass.Properties.Add("RecentJobStatus", [System.Management.CimType]::String, $false)
	
    $newClass.Qualifiers.Add("Static", $true)
	$newClass.Properties.Add("RecentJobIDS", [System.Management.CimType]::uint16, $false)
	
    $newClass.Qualifiers.Add("Static", $true)
	$newClass.Properties.Add("LastScriptExecutionTime", [System.Management.CimType]::String, $false)
	
    $newClass.Qualifiers.Add("Static", $true)
	$newClass.Properties.Add("FromTimeFilter", [System.Management.CimType]::String, $false)
	
    $newClass.Qualifiers.Add("Static", $true)
	$newClass.Properties.Add("ToTimeFilter", [System.Management.CimType]::String, $false)



    $newClass.Put()
    }
    catch
    {
       add-content $file "ERROR creating WMI class: $_"
    }
    ######################################
}

$scriptexecutiontime  = get-date
        try 
        {
            $mb = ([wmiclass]"root/cimv2/ncentral:CAUDP").CreateInstance()

            $mb.JobSuccessCount = $JobSuccessCount
            $mb.JobFailCount = $JobFailCount
            $mb.JobInProgressCount = $JobInProgressCount
            $mb.JobOtherCount = $JobOtherCount
            $mb.JobCancelledCount = $JobCancelledCount
            $mb.JobRebootCount = $JobRebootCount
            if($cfg.backupConfiguration.destination   -ne $null)
            {
                $mb.BackupDestination = $cfg.backupConfiguration.destination  
            }
            else
            {
                $mb.BackupDestination = "Invalid"
            }
            if ($MostRecentJobStart -ne $Null)
            {
                $mb.MostRecentJobStart = $MostRecentJobStart
            }
            else
            {
                $mb.MostRecentJobStart = "N/A"
            }
            if($MostRecentJobFinish -ne $Null)
            {
                $mb.MostRecentJobFinish = $MostRecentJobFinish
            }
            else
            {
                $mb.MostRecentJobFinish = "N/A"
            }
            if($RecentJobStatus -ne $Null)
            {
                $mb.RecentJobStatus = $RecentJobStatus
            }
            else
            {
                $mb.RecentJobStatus = "N/A"
            }
            if($RecentJobID -ne $Null)
            {
                if($RecentJobID -gt 0)
                {
                    $mb.RecentJobIDS = $RecentJobID
                }
                else
                {
                    $mb.RecentJobIDS = 6
                }
            }
            else
            {
                $mb.RecentJobIDS = 6
            }
            $mb.LastScriptExecutionTime = $scriptexecutiontime 
               $mb.FromTimeFilter=$datefromstr
               $mb.ToTimeFilter=$datetostr        

            $mb.Put() 
        }
        catch
        {
            add-content $file "ERROR creating a new instance: $_"
        }


        [system.net.servicepointmanager]::servercertificatevalidationcallback =  $null
