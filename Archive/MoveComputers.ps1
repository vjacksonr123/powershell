$srvs = Get-Content c:\Jake\BLCpcs.txt
ForEach($srv in $srvs)
{
	move-qadobject ("CONSECO\" + $srv +"$") -NewParentContainer 'CONSECO.AD/BLC Corp/Computers'	
}