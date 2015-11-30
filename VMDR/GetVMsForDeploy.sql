﻿SELECT 

(SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin) Server Name' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id] ) vmname,
CASE WHEN (SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin/ITDeploy) OS' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id]) = 'WXP' THEN 'DESK' ELSE 'SRV' END vmOS,
CASE WHEN (SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin/ITDeploy) OS' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id]) = 'W2K3' THEN 'W2K3R2_Standard_x86' WHEN (SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin/ITDeploy) OS' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id]) LIKE '%-%' THEN (SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin/ITDeploy) OS' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id]) ELSE 'Unknown' END vmOSver,
(SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin) Front Office IP Address' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id] ) vmIPAddress,
RTrim((SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(ITSTORAGE) Back Office IP Address' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id] )) vmBOIPAddress,
(SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin/ITDeploy) vCPUS (1, 2, 4)' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id] ) vmvCPUs,
(SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin/ITDeploy) RAM (in MB)' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id] ) vmram,
(SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin/ITDeploy) D: Drive Size (in GB)' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id] ) vmdisk,
'' HOST,
(SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin) VM Datastore' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id] ) vmdatastore,
(SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin) VM Folder' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id] ) vmfolder,
(SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin) VM Cluster' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id] ) vmcluster,
(SELECT [mdb].[dbo].[prp].[value] FROM [mdb].[dbo].[prp] WHERE [mdb].[dbo].[prp].[label] = '(NTAdmin) VM Resource Pool' AND [mdb].[dbo].[prp].[object_id] = [mdb].[dbo].[wf].[object_id] ) vmresourcepool,
(SELECT [mdb].[dbo].[chg].[chg_ref_num] FROM [mdb].[dbo].[chg] WHERE [mdb].[dbo].[chg].[id] = [mdb].[dbo].[wf].[object_id] ) changeorder

FROM [mdb].[dbo].[wf]
WHERE [mdb].[dbo].[wf].[object_type] = 'chg' 
AND [mdb].[dbo].[wf].[status] = 'PEND'
AND [mdb].[dbo].[wf].[description] LIKE '%Deploy VM%'
--AND [mdb].[dbo].[wf].[object_id] = (SELECT [mdb].[dbo].[chg].[id] FROM [mdb].[dbo].[chg] WHERE [mdb].[dbo].[chg].[chg_ref_num] = '26238')

