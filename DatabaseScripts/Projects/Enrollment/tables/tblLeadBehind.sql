IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadBehind')
	BEGIN
		CREATE TABLE [dbo].[tblLeadBehind](
			[BehindID] [int] IDENTITY(1,1) NOT NULL,
			[Description] [nvarchar](50) NULL,
			[Created] [datetime] NULL,
			[CreatedBy] [int] NULL,
			[Modified] [datetime] NULL,
			[ModifiedBy] [int] NULL,
		 CONSTRAINT [PK_tblLeadBehind] PRIMARY KEY CLUSTERED 
		(
			[BehindID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END


