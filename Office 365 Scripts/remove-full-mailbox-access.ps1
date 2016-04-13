$UserCredential = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection


Import-PSSession $Session

$userarchive = read-host "Please enter mailbox identiy to change premission on"

$usergranted = read-host "Please enter mailbox identiy to remove full access from"

Remove-MailboxPermission  $userarchive -User $usergranted -AccessRights FullAccess -Confirm:$False

Remove-PSSession $Session