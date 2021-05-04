 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlements')
	Begin
		IF col_length('tblSettlements', 'IsRestrictiveEndorsement') is null
				Alter table tblSettlements Add IsRestrictiveEndorsement bit Null 
	End  
   