#
#

$LocalGroups = "Administrators", "Power Users", "Remote Desktop Users"
$Results = @()
$Results2 = @()
$Results3 = @()
$FinalResults = @()
$MemberNames = @()
# uncomment this line to grab list of computers from a file
#$Servers = Get-Content \\ntadminp01\NTADMIN\listofservers.txt
$Servers = 'NTTRECSA','NTTRECSC','NTTRECSS'#, 'NTBPAP02'#, 'NTBPAP99','CPLPS01','BLCEXP01','BLCEXCH4','NTIACTXPROD','NTRADIUS' # for testing on local computer

foreach ( $Server in $Servers ) {
	
	trap { ' ---- Error: {3}' -f $_.CategoryInfo.Category, $_.Exception.GetType().FullName, $_.FullyQualifiedErrorID, $_.Exception.Message; continue } 
	
	If($Server -notlike "#*")
	{
		Write-Host "Processing Server: $Server"
		foreach ($LocalGroup in $LocalGroups) {
		Write-Host " -- Group: $LocalGroup"
		$Group= [ADSI]"WinNT://$Server/$LocalGroup,group"
		$Members = @($Group.psbase.Invoke("Members"))
		$Members | ForEach-Object {
			$Result = "" | Select-Object Server, Group, Object, ObjectType, ObjectPath, ObjectRights
			$Result.Server = $Server
			$Result.Group = $LocalGroup
			$Result.Object = $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
			$Result.ObjectType = $_.GetType().InvokeMember("Class", 'GetProperty', $null, $_, $null)
			$Result.ObjectPath = ($_.GetType().InvokeMember("AdsPath", 'GetProperty', $null, $_, $null)).Replace("WinNT://","").Replace("/","\")
			$Result.ObjectRights = "Local Permissions"
			$Results += $Result
		} 
		}
	}
}

foreach ( $Result in $Results)
{
	if($Result.ObjectType -eq 'Group' -and $Result.Object -notlike '*Authenticated Users*' -and $Result.Object -notlike '*Domain Users*')
	{
		if($Result.ObjectPath -like "*CONSECO*")
		{
			$GroupMembers = get-QADGroupMember $Result.ObjectPath -Indirect -SizeLimit 0 -Service ldapcml.conseco.ad
		}
		elseif($Result.ObjectPath -like "*BANKERSLIFE*" )
		{
			$GroupMembers = get-QADGroupMember $Result.ObjectPath -Indirect -SizeLimit 0 -Service ldapcml.bankerslife.internal
		}
		elseif($Result.ObjectPath -like "*COLPENN*")
		{
			$GroupMembers = get-QADGroupMember $Result.ObjectPath -Indirect -SizeLimit 0 -Service ldapcml.colpenn.internal
		}
		else
		{
			$GroupMembers = @()
		}
		
		foreach ($GroupMember in $GroupMembers)
			{
				If($GroupMember.NTAccountName.Length -ge 0)
				{
					$Result2 = "" | Select-Object Server, Group, Object, ObjectType, ObjectPath, ObjectRights
					$Result2.Server = $Result.Server
					$Result2.Group =  $Result.Group
					$Result2.Object =  $GroupMember.Name
					$Result2.ObjectType = $GroupMember.Type
					$Result2.ObjectPath = $GroupMember.NTAccountName
					$Result2.ObjectRights = "Via " + $Result.Object
					If($Result2.ObjectRights -ne ("Via " + $Result2.Object))
					{
						$Results2 += $Result2	 
					}
				}
			}
	}
}

$ResultsFinal += $Results
$ResultsFinal += $Results2

$ResultsFinal | Format-Table
$ResultsFinal | Sort-Object -Property Server,Group,ObjectType,Object | Export-Csv "LocalUserAudit.CSV"