IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadCoApplicant')
	BEGIN
		CREATE TABLE [dbo].[tblLeadCoApplicant](
			[LeadCoApplicantID] [int] IDENTITY(1,1) NOT NULL,
			[LeadApplicantID] [int] NULL,
			[FirstName] [nvarchar](100) NULL,
			[MIddleName] [nvarchar](100) NULL,
			[LastName] [nvarchar](100) NULL,
			[Full Name] [nvarchar](302) NULL,
			[Address] [nvarchar](150) NULL,
			[City] [nvarchar](50) NULL,
			[StateID] [int] NULL,
			[ZipCode] [nvarchar](50) NULL,
			[HomePhone] [nvarchar](20) NULL,
			[BusPhone] [nvarchar](50) NULL,
			[CellPhone] [nvarchar](20) NULL,
			[FaxNumber] [nvarchar](20) NULL,
			[Email] [nvarchar](50) NULL,
			[SSN] [nvarchar](12) NULL,
			[DOB] [datetime] NULL,
			[RelationShipID] [int] NULL,
			[AuthorizationPower] [bit] NULL,
			[Created] [datetime] NULL,
			[CreatedByID] [int] NULL,
			[LastModified] [datetime] NULL,
			[LastModifiedByID] [int] NULL,
		 CONSTRAINT [PK_tblLeadCoApplicant] PRIMARY KEY CLUSTERED 
		(
			[tblLeadCoApplicantID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END


