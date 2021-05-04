  IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNonDepositLetter')
	IF col_length('tblNonDepositLetter', 'Filename') is null
		alter table tblNonDepositLetter add Filename varchar(1000) null 
Go