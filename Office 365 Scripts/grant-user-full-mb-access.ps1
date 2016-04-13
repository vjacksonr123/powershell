$UserCredential = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection


Import-PSSession $Session

$userarchive = read-host "Please enter mailbox identiy to archive"

$usergranted = read-host "Please enter mailbox identiy to grant full access to"

Add-MailboxPermission $userarchive -User $usergranted -AccessRights FullAccess -InheritanceType All

Remove-PSSession $Session