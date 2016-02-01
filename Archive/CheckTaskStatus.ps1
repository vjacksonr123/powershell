While($true)
{
$SmtpClient = new-object system.net.mail.smtpClient
$SmtpClient.host = "smtp.conseco.com"
$From = "VMware VI <vmwarevi@conseco.com>"
$To = "Jakub Pawlak <jakub_pawlak@conseco.com>, <3173547691@txt.att.net>"

Connect-VIServer -Server "vcenter.conseco.ad"
$TaskStatus = Get-Task -Status "running" |  Where {$_.id -eq "Task-task-5241"}

$Title = "Task Status - " + $TaskStatus.PercentComplete + "%"
$Body = "<B>Task Status Update</B> <BR>"+ `
		"Task: " + $TaskStatus.Description + "<BR>" + `
		"Task State: " + $TaskStatus.State + "<BR>" + `
		$TaskStatus.PercentComplete + "% Complete"
$SmtpMsg = New-Object system.net.Mail.MailMessage($from,$to,$title,$body)
$SmtpMsg.IsBodyHTML = $True
$SmtpClient.Send($SmtpMsg)  
Start-Sleep -Seconds 600
}