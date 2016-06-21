#### Set Variable
Set-Variable -name DGOwners -value timmckenna@absbiomedical.com
 
#### Create Function Logon to Office365 - Exchange Online
function Logon {
    #### Pop-up a dialog for username and request your password
    $cred = Get-Credential
    #### Import the Local Microsoft Online PowerShell Module Cmdlets and Connect to O365 Online
    Import-Module MSOnline
    Connect-MsolService -Credential $cred
    #### Establish an Remote PowerShell Session to Exchange Online
    $msoExchangeURL = "https://ps.outlook.com/powershell/"
    $session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $msoExchangeURL -Credential $cred -Authentication Basic -AllowRedirection
    Import-PSSession $session
                }
 
#### Create Function Logoff Office365 & Exchange Online
function Logoff {
    #### Remove the Remote PowerShell Session to Exchange Online ----
    Get-PsSession | Remove-PsSession
    #Remove-PsSession $session
                }
 
############################################################################################################################
############################################################################################################################
 
#### Logon to Office 365 & Exchange Online
Logon
 
#### Ask the user for input CSV File
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
$ofd = New-Object System.Windows.Forms.OpenFileDialog
#$ofd.InitialDirectory = "d:\scripts"
$ofd.ShowHelp=$true
if($ofd.ShowDialog() -eq "OK") { $ofd.FileName }
$File = $ofd.Filename
 
#### Create Log File + Start Logging
if ($File -ne $Null) {
$Log = $File + ".log"
$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path $Log -append
   }
 
#### Import CSV
Import-csv -Delimiter ";" $File | ForEach {
 
#### Create DistributionGroup
New-DistributionGroup -Name $_."Name" -Alias $_."Name" -DisplayName $_."Display Name" -PrimarySmtpAddress $_."Email" -Type Distribution
 
#### Add Aliases
$Aliases = $_.Alias -split ','
if ($Aliases -ne $Null) {
Set-DistributionGroup -Identity $_."Name" -EmailAddresses @{add= $Aliases}
   }
 
#### Hide or show the DistributionGroup in the Global Address List
if ($_.Hidden) {
[boolean] $StoreBool = [System.Convert]::ToBoolean($_."Hidden")
Set-DistributionGroup -Identity $_."Name" -HiddenFromAddressListsEnabled $StoreBool
    }
 
#### Add Members
$Name = $_."Name"
$Member = $_.Members -split ","
$Member | Foreach-object {
Add-DistributionGroupMember -Identity $Name -Member $_
   }
 
#### Set Owners
Set-DistributionGroup $_."Name" -BypassSecurityGroupManagerCheck -ManagedBy $DGOwners
 
}
 
#### Stop Logging
Stop-Transcript
 
#### Logoff
Logoff