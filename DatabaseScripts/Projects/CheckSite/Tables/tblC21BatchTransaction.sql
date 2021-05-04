IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblC21BatchTransaction')
	BEGIN
		CREATE TABLE tblC21BatchTransaction
		(TransactionId varchar(50) not null PRIMARY KEY,
		 BatchId varchar(50) not null,
		 Created Datetime not null,
		 FrontImagePath varchar(max) null,
		 BackImagePath varchar(max) null,
		 ItemType int null,
		 CheckType int null,
		 CheckNumber varchar(50) null,
		 AccountNumber varchar(50) null,
		 Amount money null,
		 DepositId int null,
		 Status int null,
		 State int null,
		 ReceivedDate datetime null,
		 ProcessedDate datetime null,
		 ExceptionCode varchar(255) null,
		 Notes varchar(max) null,
		 Closed bit not null default 0
		) 
	END
ELSE
	BEGIN
		IF col_length('tblC21BatchTransaction', 'LastMapped') is null
			Alter table tblC21BatchTransaction Add LastMapped datetime null
		IF col_length('tblC21BatchTransaction', 'LastMappedBy') is null
			Alter table tblC21BatchTransaction Add LastMappedBy int null
		IF col_length('tblC21BatchTransaction', 'SettlementDate') is null
			Alter table tblC21BatchTransaction Add SettlementDate datetime null
		IF col_length('tblC21BatchTransaction', 'Hide') is null
			Alter table tblC21BatchTransaction Add Hide bit not null default 0
	END
GO