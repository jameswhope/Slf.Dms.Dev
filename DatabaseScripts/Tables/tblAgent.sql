IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblAgent')
	EXEC('
	-- Edit
	PRINT ''Modify AgencyId Field which is deprecated''
	ALTER TABLE tblAgent ALTER COLUMN AgencyId int NULL
	')
ELSE 
	EXEC('
	CREATE TABLE [dbo].[tblAgent](
		[AgentID] [int] IDENTITY(1,1) NOT NULL,
		[AgencyID] [int] NOT NULL,
		[FirstName] [varchar](50) NULL,
		[LastName] [varchar](50) NULL,
		[Street] [varchar](50) NULL,
		[Street2] [varchar](50) NULL,
		[City] [varchar](50) NULL,
		[StateID] [int] NULL,
		[ZipCode] [varchar](50) NULL,
		[EmailAddress] [varchar](50) NULL,
		[Created] [datetime] NOT NULL,
		[CreatedBy] [varchar](50) NOT NULL,
		[LastModified] [datetime] NOT NULL,
		[LastModifiedBy] [varchar](50) NOT NULL,
	 CONSTRAINT [PK_tblAgent] PRIMARY KEY CLUSTERED 
	(
		[AgentID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
	) ON [PRIMARY]
	')
