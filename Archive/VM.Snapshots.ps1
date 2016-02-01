add-pssnapin VMware.VimAutomation.Core
Set-PowerCLIConfiguration -DefaultVIServerMode multiple -Confirm:$false

Connect-VIServer @('vcenter.conseco.ad','view4vc.conseco.ad')
$snapshots = Get-VM | Get-Snapshot | Select VM , Name , Created | ConvertTo-Html
Disconnect-VIServer -Confirm:$false '*'

		$mailbody = "
VMware Snapshot Report<BR>
<BR>
<FONT FACE =""Courier New"">
--- VM snapshots: $snapshots<BR>
<BR>
<BR>
<BR>
<BR>
Note:This report runs from the virtual center server as a scheduled task.<BR>
	 Script Location '\\ntadminp01\ntadmin\PowerShell\VM.Snapshots.ps1'<BR>
</FONT>"

		$smtpServer = "smtp.conseco.com"
		$mailfrom = "VMware Snapshot Report <VMSnap@CNOinc.com>"
		$mailto = "ntadmin@conseco.com"
		$msg = new-object Net.Mail.MailMessage
		$smtp = new-object Net.Mail.SmtpClient($smtpServer) 
		$msg.From = $mailfrom
		$msg.To.Add($mailto) 
		$msg.Subject = "VMware Snapshot Report"
		$msg.Body = $mailbody
		$msg.IsBodyHTML = $true 
		$smtp.Send($msg)
