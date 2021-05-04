 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNonDepositReplacement')
	IF col_length('tblNonDepositReplacement', 'ReplacementType') is null
		alter table tblNonDepositReplacement add ReplacementType varchar(10) not null default 'Check'