$Host.UI.RawUI.WindowTitle = "AD Account Lockout Check"

do
{
$Now = Get-Date
$LockedOut = Get-QADObject -SearchRoot "dc=conseco,dc=ad" -ldapfilter '(&(&(&(objectCategory=Person)(objectClass=User)(lockoutTime>=1))))' -IncludedProperties sAMAccountName -SizeLimit 0
if($LockedOut.Count -gt 30)
{
Write-Output "**********************************************************************"
Write-Output $Now
Write-Output "> MORE THAN THIRTY Accounts Lockedout <"
Write-Output $LockedOut | Select Name, LogonName

$mailbody = "<H2>Warning: Multiple Accounts Locked Out!</H2>Contact NTADMIN OnCall and advise to investigate.<BR><BR> Accounts Currently Locked Out:" + ($LockedOut | Select Name,LogonName | ConvertTo-HTML)

$smtpServer = "smtp.conseco.com"
$mailfrom = "NTADMIN Alert <ntadmin@conseco.com>"
$mailto = "ntadmin@conseco.com,it_operations@conseco.com"
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient($smtpServer) 
$msg.From = $mailfrom
$msg.To.Add($mailto) 
$msg.Subject = "NTADMIN Alert - Account Lockouts"
$msg.Body = $mailbody
$msg.IsBodyHTML = $true 
$smtp.Send($msg)
Sleep 1800
}
else
{
Write-Output "**********************************************************************"
Write-Output $Now
Write-Output "> Less Than Thirty Accounts Lockedout <"
Write-Output $LockedOut | Select Name, LogonName
Sleep 300
}
}while($true)