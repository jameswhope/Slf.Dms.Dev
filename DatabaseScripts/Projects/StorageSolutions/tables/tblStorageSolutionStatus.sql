IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblStorageSolutionStatus')
	BEGIN
		DROP  Table tblStorageSolutionStatus
	END

CREATE TABLE tblStorageSolutionStatus(
	[StorageSolutionStatusID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[StorageSolutionStatus] [varchar](50) NOT NULL
) ON [PRIMARY]


SET IDENTITY_INSERT dbo.tblStorageSolutionStatus ON
insert into tblStorageSolutionStatus ([StorageSolutionStatusID],[StorageSolutionStatus]) Values(1,'ERROR')
insert into tblStorageSolutionStatus ([StorageSolutionStatusID],[StorageSolutionStatus]) Values(2,'PROCESSING')
insert into tblStorageSolutionStatus ([StorageSolutionStatusID],[StorageSolutionStatus]) Values(3,'COMPLETE')
SET IDENTITY_INSERT dbo.tblStorageSolutionStatus OFF

GRANT SELECT ON tblStorageSolutionStatus TO PUBLIC


