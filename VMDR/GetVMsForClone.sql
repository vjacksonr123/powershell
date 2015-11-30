SELECT 

(SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin) New Server Name' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id] ) vmname,
'SRV' vmOS, 
'W2K3R2-SP2-ENT-X86' vmOSver, 
(SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin) Front Office IP Address' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id] ) vmIPAddress,
RTrim((SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(ITSTORAGE) Back Office IP Address' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id] )) vmBOIPAddress,
'' vmvcpus,
'' vmram,
'' vmdisk,
'' vmhost,
(SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin) VM Datastore' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id] ) vmdatastore,
(SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin) VM Folder' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id] ) vmfolder,
(SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin) VM Cluster' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id] ) vmcluster,
(SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin) VM Resource Pool' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id] ) vmresourcepool,
(SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin/ITDeploy) Source Server Name' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id] ) vmsource,
(SELECT [mdb].[dbo].[chg].[chg_ref_num] FROM [mdb].[dbo].[chg] WHERE [mdb].[dbo].[chg].[id] = [mdb].[dbo].[wf].[object_id] ) changeorder
FROM [mdb].[dbo].[wf]
WHERE [mdb].[dbo].[wf].[object_type] = 'chg' 
AND [mdb].[dbo].[wf].[status] = 'PEND'
AND [mdb].[dbo].[wf].[description] LIKE 'Clone VM%'
