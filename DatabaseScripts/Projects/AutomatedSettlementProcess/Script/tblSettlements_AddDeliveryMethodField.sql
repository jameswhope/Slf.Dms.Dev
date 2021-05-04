  IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlements')
	Begin
		IF col_length('tblSettlements', 'DeliveryMethod') is null
				Alter table tblSettlements Add DeliveryMethod varchar(50) Null 
	End  
	Begin
		IF col_length('tblSettlements', 'DeliveryAmount') is null
				Alter table tblSettlements Add DeliveryAmount money Null 
	End