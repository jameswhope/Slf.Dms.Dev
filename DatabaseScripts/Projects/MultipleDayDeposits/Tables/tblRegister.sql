IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblregister')
	IF col_length('tblRegister', 'ClientDepositID') is null
		alter table tblRegister add ClientDepositID int null 
Go