

$usergranted = read-host "Please enter mailbox user (with FQDN)"


Set-Clutter -Identity $usergranted -Enable $false