IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblAstCallLog')
 BEGIN
	IF col_length('tblAstCallLog', 'CallReasonId') is null
		Alter table tblAstCallLog Add CallReasonId int default 0
				 
 END