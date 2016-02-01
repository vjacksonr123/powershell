# Process to generate the script to re-create the file share resources from a Windows 2003 cluster.
# It needs the cluster name as a parameter and it generates the script with the configuration from each resource.
# The new cluster name will be NEWCLUSTER so you need to change it before run it.

param([string]$ServerOp) # Cluster Server Name.
$mydate = get-date -uformat "%Y%m%d"
$FolderScripts = "d:\DRCluster\scripts\$mydate\" # It will create this folder, so we have a folder by date.
$FileLog="d:\DRCluster\logs\DrCluster_$mydate.log" # Log File Name

clear-host
if (!$ServerOp){ throw "You must specify the cluster name" }

$f = [System.IO.Path]::Combine($FolderScripts, $ServerOp + "_shares.txt")
[string]$hora=get-date -uformat "[%r]"
out-file -filepath $FileLog -inputobject "#############################################################################################################################################" -append
out-file -filepath $FileLog -inputobject " " -append
out-file -filepath $FileLog -inputobject " PROCESS TO GENERATE THE SCRIPT TO RECREATE THE CLUSTER: $hora " -append
out-file -filepath $FileLog -inputobject " " -append
out-file -filepath $FileLog -inputobject "#############################################################################################################################################" -append
out-file -filepath $FileLog -inputobject " " -append

[string]$hora=get-date -uformat "[%r]"
if (!(Test-Path $FolderScripts)) {
out-file -filepath $FileLog -inputobject "$hora The folder $FolderScripts is created" -append
md $FolderScripts | Out-Null
if($? -ne $True) {
out-file -filepath $FileLog -inputobject "$hora ERROR: Couldn't create the folder: $FolderScripts" -append
throw "The folder $FolderScripts could not be created"
}
}

$f = [System.IO.Path]::Combine($FolderScripts, $ServerOp + "_shares.txt")
out-file -filePath $f -inputobject "REM ######################################################################################################## " -Encoding ASCII
out-file -filePath $f -inputobject "REM SCRIPT TO RECREATE THE SHARES IN ANOTHER CLUSTER" -Append -Encoding ASCII
out-file -filePath $f -inputobject "REM VERIFY DRIVES AND CLUSTER NAME BEFORE RUN IT! " -Append -Encoding ASCII
out-file -filePath $f -inputobject "REM ######################################################################################################## " -Append -Encoding ASCII
out-file -filePath $f -inputobject " " -Append -Encoding ASCII
out-file -filePath $f -inputobject " " -Append -Encoding ASCII

[string]$hora=get-date -uformat "[%r]"
out-file -filepath $FileLog -inputobject "$hora Getting the shares..." -append
$shares = Get-WMIObject Win32_Share -Computer $ServerOp
if($? -ne $True) {
out-file -filepath $FileLog -inputobject "$hora ERROR: There was an error getting the shares" -append
break
}else{ 
[string]$hora=get-date -uformat "[%r]"
out-file -filepath $FileLog -inputobject "$hora Done.." -append 
}
out-file -filepath $FileLog -inputobject " " -append
[string]$hora=get-date -uformat "[%r]"
out-file -filepath $FileLog -inputobject "$hora Begin processing every share to get the configuration" -append
foreach ($sharefolder in $shares){
if (0 -eq $sharefolder.Type){

$Groups = Get-WmiObject -class MSCluster_ResourceGroupToResource -namespace "root\mscluster" -computername $ServerOp
$name=$sharefolder.Name

$Group = $Groups | Where-Object { $_.PartComponent -eq "MSCluster_Resource.Name="""+$name+"""" } 
if ($Group -ne $null){
[string]$mygrp = $Group.GroupComponent
$Groupshare = $mygrp.Substring($mygrp.IndexOf(""""),$mygrp.Length-$mygrp.IndexOf(""""))
[string]$mystring="cluster /cluster:NEWCLUSTER resource "+"""$name"""+ " /create /group:"+$Groupshare+ " /type:""File Share"""
out-file -filepath $f -inputobject $mystring -append -Encoding ASCII
[string]$mystring="clusetr /cluster:NEWCLUSTER resource "+"""$name"""+ " /priv path="""+$sharefolder.Path+""""
out-file -filepath $f -inputobject $mystring -append -Encoding ASCII
[string]$mystring="cluster /cluster:NEWCLUSTER resource "+"""$name"""+ " /priv Sharename="+$sharefolder.name
out-file -filepath $f -inputobject $mystring -append -Encoding ASCII
[string]$mystring="cluster /cluster:NEWCLUSTER resource "+"""$name"""+ " /priv Remark="""+$sharefolder.Description+""""
out-file -filepath $f -inputobject $mystring -append -Encoding ASCII
[string]$mystring="cluster /cluster:NEWCLUSTER resource "+"""$name"""+ " /prop Description="""+$sharefolder.Description+""""
out-file -filepath $f -inputobject $mystring -append -Encoding ASCII

$Access = @();
$SD = (Get-WMIObject -Class Win32_LogicalShareSecuritySetting -Computer $ServerOp -Filter "Name='$($name)'").GetSecurityDescriptor().Descriptor
$SD.DACL | %{ $Trustee = $_.Trustee.Name
If ($_.Trustee.Domain -ne $Null) { # The account has a domain. 
$Trustee = "$($_.Trustee.Domain)\$Trustee" 
$Access+= New-Object System.Security.AccessControl.FileSystemAccessRule($Trustee, $_.AccessMask, $_.AceType)
} elseif ( $_.Trustee.Name -ne $Null ) { # The account doesn't have a domain, but still valid, e.g. Everyone
$Access+= New-Object System.Security.AccessControl.FileSystemAccessRule($Trustee, $_.AccessMask, $_.AceType)
}else{ # The account doesn't have a domain nor valid.
Write-Host "Warning: Found an account in the share that could not be resolved, its possible that doesnt exists in AD"
$sharetemp1 = $sharefolder.Name
out-file -filepath $FileLog -inputobject "Found an account in the share that could not be resolved, its possible that doesnt exists in AD" -append
}
}
foreach($permission in $Access){
if ( $permission.FileSystemRights -eq "ReadAndExecute,Synchronize"){ $perm = "R" } 
elseif ( $permission.FileSystemRights -eq "Modify,Synchronize"){ $perm ="RC" }
elseif ( $permission.FileSystemRights -eq "FullControl") { $perm = "F" }
if ($permission.AccessControlType -eq "Allow") {
[string]$mystring="cluster /cluster:NEWCLUSTER resource "+"""$name"""+ " /priv Security="""+$permission.IdentityReference+""""+",grant,"+$perm+":security"
out-file -filepath $f -inputobject $mystring -append -Encoding ASCII
}
}
$cmd = cluster.exe $ServerOp res $name /listdep | select-string "Online"
if($? -ne $True) {
out-file -filepath $FileLog -inputobject "$hora ERROR: THERE WAS AN ERROR GETTING THE DEPENDENCIES" -append
}
$gtp = " " + $Groupshare.substring(1,$Groupshare.length-2) + " "
foreach ($myline in $cmd){ 
[string]$valor=$myline; 
$dep=($valor.substring(0,$valor.indexOf($gtp,$gtp.length-1))).trimend()
[string]$mystring="cluster /cluster:NEWCLUSTER resource "+"""$name"""+ " /AddDep:"""+$dep+""""
out-file -filepath $f -inputobject $mystring -append -Encoding ASCII 
}

[string]$mystring="cluster /cluster:NEWCLUSTER resource "+"""$name"""+ " /On"
out-file -filepath $f -inputobject $mystring -append -Encoding ASCII
out-file -filepath $f -inputobject " " -append -Encoding ASCII
} 
}
}
[string]$hora=get-date -uformat "[%r]"
out-file -filepath $FileLog -inputobject "$hora Done getting the shares properties" -append
out-file -filePath $FileLog -inputobject " " -Append

out-file -filepath $FileLog -inputobject "#############################################################################################################################################" -append
out-file -filepath $FileLog -inputobject " " -append
out-file -filepath $FileLog -inputobject " END OF THE PROCESS: $hora " -append
out-file -filepath $FileLog -inputobject " " -append
out-file -filepath $FileLog -inputobject "#############################################################################################################################################" -append
