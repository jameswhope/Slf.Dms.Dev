 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNonDepositLetter')
	IF col_length('tblNonDepositLetter', 'NoEmail') is null
		alter table tblNonDepositLetter add NoEmail bit not null default 0
Go