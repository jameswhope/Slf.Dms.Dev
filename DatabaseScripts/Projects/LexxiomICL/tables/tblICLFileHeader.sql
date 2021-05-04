IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblICLFileHeader')
	BEGIN
		--drop table tblICLFileHeader
		CREATE TABLE [dbo].[tblICLFileHeader](
			[ICLFileId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
			[Date] [datetime] NOT NULL,
			[EffectiveDate] [datetime] NOT NULL,
			[DateSent] [datetime] NULL,
			[FileName] varchar(200) NULL,
			[StandardLevel] [varchar](2) NULL,
			[FileIndicator] [varchar](2) NULL,
			[ImmediateDestinationRoutingNumber] [varchar](9) NULL,
			[ImmediateOriginRoutingNumber] [varchar](9) NULL,
			[FileCreationDate] [varchar](8) NULL,
			[FileCreationTime] [varchar](4) NULL,
			[ResendIndicator] [varchar](1) NULL,
			[ImmediateDestinationName] [varchar](18) NULL,
			[ImmediateOriginName] [varchar](18) NULL,
			[FileIDModifier] [varchar](1) NULL,
			[CountryCode] [varchar](2) NULL,
			[UserField] [varchar](4) NULL,
			[Reserved] [varchar](1) NULL
		) ON [PRIMARY]
	END

GRANT SELECT ON tblICLFileHeader TO PUBLIC

GO

