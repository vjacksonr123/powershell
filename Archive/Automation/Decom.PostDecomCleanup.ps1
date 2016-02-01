$ServerNames = @('NTFVWSP02','NTFVAPP02','NTFVPAMP02','NTFVRSUP02','NTFVWSUAT02','NTFVAPUAT02','NTFVPAMUAT02','NTFVRSUUAT02','BLCIIS1','BLCFS03','BLCDFS01','BLCLANIR')

ForEach ($ServerName in $ServerNames)
{
#$ServerName = "XPINFOSYS4"
$DomainSrvName = "CONSECO\" + $ServerName + "$"

# Delete DNS Record
dnscmd ntdccmlp01.conseco.ad /RecordDelete CONSECO.AD $ServerName A /f

# Delete AD Computer Object
remove-QADObject $DomainSrvName -Force

# Delete AD Server Access Groups
remove-QADObject ("CONSECO\NTSrv - " + $ServerName + " - Administrators") -Force
remove-QADObject ("CONSECO\NTSrv - " + $ServerName + " - Power Users") -Force
remove-QADObject ("CONSECO\NTSrv - " + $ServerName + " - RDP Users") -Force

#Remove from IP database
#http://conseconetwork.conseco.ad/IP_DB2.asp?Assignment=$ServerName

#Remove from TrendMicro
}