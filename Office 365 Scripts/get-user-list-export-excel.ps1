

#Get-MsolUser | Where-Object { $_.isLicensed -eq “TRUE” }

#Get-MsolUser | Where-Object { $_.isLicensed -eq “TRUE” } | Select-Object UserPrincipalName, DisplayName, Country, Department | Export-Csv c:\LicensedUsers.csv

#Get-MsolUser | Where-Object { $_.isLicensed -eq “TRUE” } | Select-Object UserPrincipalName, DisplayName, Country, Department | Out-Gridview

