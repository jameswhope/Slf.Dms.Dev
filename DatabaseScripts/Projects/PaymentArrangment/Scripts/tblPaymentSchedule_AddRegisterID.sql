 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblPaymentSchedule')
	Begin
		IF col_length('tblPaymentSchedule', 'RegisterID') is null
				Alter table tblPaymentSchedule Add RegisterID int Null 
	End   