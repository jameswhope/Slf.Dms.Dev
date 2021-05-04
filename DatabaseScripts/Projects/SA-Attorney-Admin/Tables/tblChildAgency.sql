IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblChildAgency')
	BEGIN
		-- Edit
		PRINT 'DO NOTHING'
	END
ELSE EXEC('
		-- Add
		CREATE TABLE [dbo].[tblChildAgency](
		[AgencyId] [int] NOT NULL,
		[ParentAgencyId] [int] NOT NULL,
		[Created] [datetime] NULL,
		[CreatedBy] [int] NULL,
		[LastModified] [datetime] NULL,
		[LastModifiedBy] [int] NULL,
		 CONSTRAINT [PK_tblChildAgency] PRIMARY KEY CLUSTERED 
		(
			[AgencyId] ASC,
			[ParentAgencyId] ASC
		))
		
		-- Add Foreign Key
		ALTER TABLE [dbo].[tblChildAgency]  ADD  CONSTRAINT [FK_tblChildAgency_tblAgency] FOREIGN KEY([ParentAgencyId])
		REFERENCES [dbo].[tblAgency] ([AgencyID])
		ON DELETE CASCADE
	')
	
GO
