IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblAgencyAgent')
	BEGIN
		-- Edit
		PRINT 'DO NOTHING'
	END
ELSE EXEC('
		-- Add
		CREATE TABLE [dbo].[tblAgencyAgent](
		[AgencyAgentId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
		[AgencyId] [int] NOT NULL,
		[AgentId] [int] NOT NULL,
		[Created] [datetime] NULL,
		[CreatedBy] [int] NULL,
		[LastModified] [datetime] NULL,
		[LastModifiedBy] [int] NULL,
		 CONSTRAINT [UX_tblAgencyAgent] UNIQUE NONCLUSTERED 
		(
			[AgencyId] ASC,
			[AgentId] ASC
		))
		
		-- Add Foreign Keys
		ALTER TABLE [dbo].[tblAgencyAgent]  ADD  CONSTRAINT [FK_tblAgencyAgent_tblAgency] FOREIGN KEY([AgencyId])
		REFERENCES [dbo].[tblAgency] ([AgencyID])
		ON DELETE CASCADE
		
		ALTER TABLE [dbo].[tblAgencyAgent]  ADD  CONSTRAINT [FK_tblAgencyAgent_tblAgent] FOREIGN KEY([AgentId])
		REFERENCES [dbo].[tblAgent] ([AgentID])
		ON DELETE CASCADE
		
		-- Migrate existing Relationships
		INSERT INTO tblAgencyAgent(AgencyId, AgentId, Created, CreatedBy, LastModified, LastModifiedBy)
		SELECT t.AgencyId, t.AgentId, GETDATE(), 24, GETDATE(), 24
		FROM tblAgent t
		INNER JOIN tblAgency a on (t.AgencyId = a.AgencyId)
	')
	
GO

--GRANT SELECT ON Table_Name TO PUBLIC

