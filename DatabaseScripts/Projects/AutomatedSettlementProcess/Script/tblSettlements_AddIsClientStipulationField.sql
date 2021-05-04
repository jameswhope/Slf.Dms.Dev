 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlements')
	Begin
		IF col_length('tblSettlements', 'IsClientStipulation') is null
				Alter table tblSettlements Add IsClientStipulation bit Null 
	IF col_length('tblSettlements', 'IsPaymentArrangement') is null
				Alter table tblSettlements Add IsPaymentArrangement bit Null 				
	End  
   