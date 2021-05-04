 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblAdHocAch')
	IF col_length('tblAdHocAch', 'BankAccountId') is null
		alter table tblAdHocAch add BankAccountId int null 
Go