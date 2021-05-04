IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblStorageSolutionType')
	BEGIN
		DROP  Table tblStorageSolutionType
	END

CREATE TABLE [tblStorageSolutionType](
	[StorageSolutionTypeID]  [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[StorageSolutionType] [varchar](50) NOT NULL
) ON [PRIMARY]

SET IDENTITY_INSERT dbo.tblStorageSolutionType ON
insert into tblStorageSolutionType ([StorageSolutionTypeID],[StorageSolutionType]) Values(1,'ARCH')
insert into tblStorageSolutionType ([StorageSolutionTypeID],[StorageSolutionType]) Values(2,'ARCH_REST')
insert into tblStorageSolutionType ([StorageSolutionTypeID],[StorageSolutionType]) Values(3,'BACK')
insert into tblStorageSolutionType ([StorageSolutionTypeID],[StorageSolutionType]) Values(4,'BACK_REST')
SET IDENTITY_INSERT dbo.tblStorageSolutionType OFF


GRANT SELECT ON tblStorageSolutionType TO PUBLIC

