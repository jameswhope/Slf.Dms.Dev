drop table tblAstCallReason
--GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblAstCallReason')
	BEGIN
		CREATE  Table tblAstCallReason(
			CallReasonId int not null primary key clustered,
			Reason varchar(20) not null,
			Description varchar(100) not null 
		)
	END
GO

Insert Into  tblAstCallReason(CallReasonId, Reason, Description) values (0, 'General', 'General purpose')
Insert Into  tblAstCallReason(CallReasonId, Reason, Description) values (1, 'Welcome', 'Welcome client call')
Insert Into  tblAstCallReason(CallReasonId, Reason, Description) values (2, 'Settlement', 'Settlement')
Insert Into  tblAstCallReason(CallReasonId, Reason, Description) values (3, 'Nondeposit', 'Non deposit')

GO




