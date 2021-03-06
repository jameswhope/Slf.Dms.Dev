/****** Object:  Table [dbo].[tblContact]    Script Date: 11/19/2007 11:03:52 ******/
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblContact')
	BEGIN
	
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblContact' AND column_name='NegotiationSessionGUID')
		BEGIN
			ALTER TABLE tblContact ALTER COLUMN NegotiationSessionGUID varchar(50) NULL
		END	
	
	
	/*
			EXEC ('
Alter TABLE [dbo].[tblContact](
	[ContactID] [int] IDENTITY(1,1) NOT NULL,
	[CreditorID] [int] NOT NULL,
	[FirstName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EmailAddress] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[NegotiationSessionGUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_tblContact] PRIMARY KEY CLUSTERED 
(
	[ContactID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
')
	*/
	
	print 'x'
	
	END	
ELSE
BEGIN
	EXEC ('
	CREATE TABLE [dbo].[tblContact](
		[ContactID] [int] IDENTITY(1,1) NOT NULL,
		[CreditorID] [int] NOT NULL,
		[FirstName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[LastName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[EmailAddress] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Created] [datetime] NOT NULL,
		[CreatedBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[LastModified] [datetime] NOT NULL,
		[LastModifiedBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[NegotiationSessionGUID] [uniqueidentifier] NULL,
	 CONSTRAINT [PK_tblContact] PRIMARY KEY CLUSTERED 
	(
		[ContactID] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	')
END
