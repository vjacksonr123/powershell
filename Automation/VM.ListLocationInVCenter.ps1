
function get-children($entity,$path){
  if($entity.Name -ne "vm"){
    $path += ("\" + $entity.Name)
  }
  foreach($child in $entity.ChildEntity){
    $childfld = Get-View -Id $child
	switch($childfld.gettype().name){
	  "Folder" {
	    Write-Host ($path + "\" + $childfld.Name)
		get-children $childfld $path
	  }
      "VirtualMachine"{
	    $vm = $path + "\" + $childfld.Name
        Write-Host $vm
	  }
	  "Datacenter"{
	    Write-Host ($path + "\" + $childfld.Name)
        get-children $childfld $path
	  }
	  "ClusterComputeResource" {
	    Write-Host ($path + "\" + $childfld.Name)
        foreach($esxMoRef in $childfld.Host){
          $esx = Get-View -Id $esxMorEF
	      $h = $path + "\" + $childfld.Name + "\" + $esx.Name
		  Write-Host $h
		}
	  }
     }
  }
}

# Virtual machines & Templates
Connect-VIServer vcenter.conseco.ad

Write-Host "Virtual Machines & Templates`n"
Get-Datacenter | %{
  $dc = Get-View -Id ($_).id
  $folder = Get-View -Id $dc.VmFolder
  get-children $folder $dc.Name
}
