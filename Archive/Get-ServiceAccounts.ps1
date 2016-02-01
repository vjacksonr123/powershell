﻿#start

#requires -pssnapin PSCX
#Author:     Glenn Sizemore glnsize@get-admin.com
#Purpose:    Scan a remote system for any services running under a non standard account.
#            Standard accounts would be considered, NT AUTHORITY\NetworkService, 
#            NT AUTHORITY\LocalService, LocalSystem, or .\ASPNET
#            
#Usage:      PS > Get-ServiceAccounts [-Target <string>] [-Path <string>] [-verbose] [-Credential <PSCredential Object> ]
#            
#            -Target(optional)  
#                  can be either a string or an array of strings.
#            -Path(optional)    
#                 Path to an item containing a list of Targets
#            -Verbose(optional) 
#                 turns on verbose logging to the console
#            -Credential(optional) 
#                  should only be used with V2, uses alternate credentials when 
#                querying target for services.
#
#Returns:    PSCustom Object
#
#Example:    Get-ServiceAccounts -Target "host1","host2","host3" -Path "C:\temp\otherhosts.txt" -verbose
#            
#            this command will combined the targets: host1, host2, and host3 with all targets located in 
#            the file otherhost.txt, and scan all of them for unique service accounts.
#

param($target,
[string]$Path,
[switch]$verbose,
[System.Management.Automation.PSCredential]$credential = ($null)
)
begin 
{
    # Create an empty object to hold all service accounts found.
    $SvcAccounts = @()

    #Save the current $ErrorActionPreference so we can restore it.
    $ErrActionSave = $ErrorActionPreference 
    $Verbosesave = $VerbosePreference
    $warningSave = $WarningPreference

    #If a PSCredential is supplied then wmi query will be ran under that account.
    if ($credential)
    {
        Write-Host "there is a known bug using -credential in V1..."
        $gwmiquery = {Get-WmiObject -Class Win32_Service -ComputerName $computer -Credential $credential `
            -property name, startname, caption, StartMode `
            -filter 'NOT Startname LIKE "%NT AUTHORITY%" AND NOT Startname LIKE "LocalSystem" AND NOT Startname LIKE "ASPNET"'}
    }
    else
    {
        $gwmiquery = {Get-WmiObject -Class Win32_Service -ComputerName $computer -property name, startname, caption, StartMode `
            -filter 'NOT Startname LIKE "%NT AUTHORITY%" AND NOT Startname LIKE "LocalSystem" AND NOT Startname LIKE "ASPNET"'}
    }

    if ($Verbose) {$VerbosePreference = "Continue"; $WarningPreference = "Continue"}

    #Workhorse...
    function ProcessTarget ($computer) 
    {
        $obj = @()

        #Set ErrorAction to silent... we'll handle the error's ourselves.
        $ErrorActionPreference = "SilentlyContinue" 

        Write-Verbose "querying $computer ..."

        #call the Query from above.
        $services = &$gwmiquery 

        #set erroraction back there sould be no error's from here on out.
        $ErrorActionPreference = $ErrActionSave 

        Write-Verbose " $($services.count) services located on $computer using "
        foreach ($service in $Services)
        {

            # If there was an error while attempting the gwmi call, there will be only one error.
            # We check that error to help annotate why we were unsuccessful.
            switch -regex ($Error[0].Exception) 
            {
                "The RPC server is unavailable"
                {
                    Write-warning "RPC Unavailable on $computer"
                    $obj += "" | Select @{e={$computer};n='Target'},@{e={"RPC_Unavalable"};n='SvcName'}
                    continue
                } 
                #vista
                "Access denied"
                {
                    Write-warning "Access Denied on $computer"
                    $obj += "" | Select @{e={$computer};n='Target'},@{e={"Access_Denied"};n='SvcName'}
                    continue
                }
                #XP/Server 2k3
                "Access is denied"
                {
                    Write-warning "Access Denied on $computer"
                    $obj += "" | Select @{e={$computer};n='Target'},@{e={"Access_Denied"};n='SvcName'}
                    continue
                }
                $null 
                {
                    $obj += "" | Select @{e={$computer};n='Target'},
                    @{e={$service.name };n='SvcName'},
                    @{e={$service.startname };n='SvcAcccount'},
                    @{e={$service.caption };n='SvcDes'},
                    @{e={$service.StartMode };n='StartMode'}
                } 
            }
            $Error.clear()
        }
        return $obj
    } 
}
process 
{
    $Targets = @()
    if ($Path){$Targets = Get-Content $Path}
    if ($Target){$Targets += $target}

    foreach ($computer in $Targets) 
    {
        ping-host -HostName $computer -Count 1 -Quiet -Timeout 1| Where-Object { $_.loss -ne 100} | `
        ForEach-Object {$SvcAccounts += ProcessTarget $_.host}
    }

}
End 
{
    $ErrorActionPreference = $ErrActionSave
    $VerbosePreference = $Verbosesave
    $WarningPreference = $warningSave
    Write-Output $SvcAccounts
}

#end
