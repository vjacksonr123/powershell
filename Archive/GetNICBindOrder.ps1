

#region Script Settings
#<ScriptSettings xmlns="http://tempuri.org/ScriptSettings.xsd">
#  <ScriptPackager>
#    <process>powershell.exe</process>
#    <arguments />
#    <extractdir>%TEMP%</extractdir>
#    <files />
#    <usedefaulticon>true</usedefaulticon>
#    <showinsystray>false</showinsystray>
#    <altcreds>false</altcreds>
#    <efs>true</efs>
#    <ntfs>true</ntfs>
#    <local>false</local>
#    <abortonfail>true</abortonfail>
#    <product />
#    <version>1.0.0.1</version>
#    <versionstring />
#    <comments />
#    <includeinterpreter>false</includeinterpreter>
#    <forcecomregistration>false</forcecomregistration>
#    <consolemode>false</consolemode>
#    <EnableChangelog>false</EnableChangelog>
#    <AutoBackup>false</AutoBackup>
#    <snapinforce>false</snapinforce>
#    <snapinshowprogress>false</snapinshowprogress>
#    <snapinautoadd>0</snapinautoadd>
#    <snapinpermanentpath />
#  </ScriptPackager>
#</ScriptSettings>
#endregion

$server = "NTDB2UAT01"
Write-Host “ Processing server ” $server
$registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $server)        # Open remote HKLM key
if ($registry)
{
	$baseKey1 = $registry.OpenSubKey(”SYSTEM\CurrentControlSet\Services\Tcpip\linkage”,$true)
	$bindorder = $baseKey1.GetValue(”Bind”)
	$baseKey2 = $registry.OpenSubKey(”SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces”)
	$myCol = @( )
	$NICS = $baseKey2.GetSubKeyNames()        # Set of interfaces

	foreach ($NIC in $NICS)
	{
		$myObj = “ ” | Select-Object Key, IP        # Create object for relation between identifier and IP address
		$key = $baseKey2.OpenSubKey(”$NIC”)
		$myObj.Key = $NIC        # Get identifier of interface
		$myObj.IP = $key.GetValue(”IPAddress”)[0]        # Get IP address of interface
		$myCol += $myObj        # Create collection of interface objects
	}
	
	$FrontOffice = $myCol | Where {$_.IP -ilike "192.168.20?.*"}
	$BackOffice = $myCol | Where {$_.IP -ilike "*.14[0,1].*"}
	
	$FrontOfficeDevice = "\Device\" + $FrontOffice.Key
	
	$Bindings = @( )
		
	foreach ($bindentry in $bindorder)
	{
		$myObj = “ ” | Select-Object BindOrder, Device
		$myObj.Device = $bindentry
		If($bindentry -eq $FrontOfficeDevice)
		{
			$myObj.BindOrder = 0
		} elseif($bindentry -eq "\Device\NdisWanIp")
		{
			$myObj.BindOrder = 9
		} else
		{
			$myObj.BindOrder = 1
		}
		
		$Bindings += $myObj
	}
	
	$BindOrder = New-Object System.Collections.ArrayList
	
	foreach ($bind in $Bindings | Sort BindOrder)
	{
		$BindOrder.Add($bind.device)
	}
	
	$baseKey1.SetValue("Bind", [string[]]$BindOrder)
	
	$BackOfficeInterfaceKeyName = "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\" + $BackOffice.Key
	$registry.OpenSubKey($BackOfficeInterfaceKeyName,$true)
	$BackOfficeKey.GetValue("RegistrationEnabled")	
	$BackOfficeKey.SetValue("RegistrationEnabled",[int]0)
	
	$BackOfficeConnectionKeyName = "SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}\" + $BackOffice.Key +"\Connection"
	$FrontOfficeConnectionKeyName = "SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}\" + $FrontOffice.Key +"\Connection"
	$registry.OpenSubKey($BackOfficeConnectionKeyName,$true).SetValue("Name","Back Office")
	$registry.OpenSubKey($FrontOfficeConnectionKeyName,$true).SetValue("Name","Front Office")
}

		
