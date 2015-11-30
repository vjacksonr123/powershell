Connect-VIServer vcenter.conseco.ad
# get-cluster -name "Sigma" | get-vmhost | get-scsilun | set-scsilun -MultiPathPolicy RoundRobin
get-cluster -name "Sigma" | get-vmhost | get-scsilun | Export-Csv C:\MPP.csv
Disconnect-VIServer -Confirm:$false
