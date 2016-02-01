add-pssnapin VMware.VimAutomation.Core
Set-PowerCLIConfiguration -DefaultVIServerMode multiple -Confirm:$false

Connect-VIServer @('vcenter.conseco.ad','view4vc.conseco.ad') 
$vmxp = (Get-VM | where {$_.Guest.OSFullName -like '*XP*'}).Count
$vmw7 = (Get-VM | where {$_.Guest.OSFullName -like '*7*'}).Count
Disconnect-VIServer -Confirm:$false '*'

		$mailbody = "
VMware Windows Desktop Licensing Report <BR>
<BR>
<FONT FACE =""Courier New"">
--- Windows XP: $vmxp<BR>
--- Windows  7: $vmw7<BR>
<BR>
<BR>
<BR>
<BR>
Note:This report runs from the virtual center server as a scheduled task.<BR>
	 Script Location '\\ntadminp01\ntadmin\PowerShell\VM.DesktopLicenseCounts.ps1'<BR>
</FONT>"

		$smtpServer = "smtp.conseco.com"
		$mailfrom = "VMware Desktop Licensing <VMLIC@CNOinc.com>"
		$mailto = "csassets@cnoinc.com,ntadmin@conseco.com"
		$msg = new-object Net.Mail.MailMessage
		$smtp = new-object Net.Mail.SmtpClient($smtpServer) 
		$msg.From = $mailfrom
		$msg.To.Add($mailto) 
		$msg.Subject = "VMware Windows Desktop Licensing Report"
		$msg.Body = $mailbody
		$msg.IsBodyHTML = $true 
		$smtp.Send($msg)