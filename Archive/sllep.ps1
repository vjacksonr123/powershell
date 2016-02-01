$exitafter=10000
$dir=get-wmiobject win32_Directory
$start=get-date
do{
$dir|%{
	$_.Name
	if((new-timespan $start).TotalMilliSeconds -ge $exitafter)
	{'***10 SECONDS ELAPSED***';break}
}
'***SCRIPT END***'
break
}while($true)




