 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDialerWorkgroupQueue')
 BEGIN
	IF col_length('tblDialerWorkgroupQueue', 'PivotUser') is null
		Alter table tblDialerWorkgroupQueue Add PivotUser varchar(255) null  
		
	IF col_length('tblDialerWorkgroupQueue', 'PivotExt') is null
		Alter table tblDialerWorkgroupQueue Add PivotExt varchar(10) null 
		
	IF col_length('tblDialerWorkgroupQueue', 'QueueNameSP') is null
		Alter table tblDialerWorkgroupQueue Add QueueNameSP varchar(255) null 
	
	IF col_length('tblDialerWorkgroupQueue', 'ExtensionSP') is null
		Alter table tblDialerWorkgroupQueue Add ExtensionSP varchar(10) null 
		
END
GO