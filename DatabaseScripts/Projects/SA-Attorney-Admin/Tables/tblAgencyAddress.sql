IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblAgencyAddress')
	BEGIN
		PRINT 'DO NOTHING'
	END
ELSE
	BEGIN
	CREATE TABLE [dbo].[tblAgencyAddress](
	[AgencyAddressID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
	[AddressTypeID] [int] NULL,
	[Address1] [nvarchar](150) NULL,
	[Address2] [nvarchar](150) NULL,
	[City] [nvarchar](150) NULL,
	[State] [nvarchar](50) NULL,
	[ZipCode] [nvarchar](25) NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[LastModified] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
	[AgencyID] [int] NULL foreign key (AgencyID) references tblAgency(AgencyID) on delete cascade)
	END 
GO

--GRANT SELECT ON Table_Name TO PUBLIC

GO
