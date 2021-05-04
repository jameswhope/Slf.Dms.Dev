IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNegotiationSettlementStatus')
	BEGIN
		CREATE TABLE [dbo].[tblNegotiationSettlementStatus](
			[SettlementStatusID] [int] IDENTITY(1,1) NOT NULL,
			[ParentSettlementStatusID] [int] NULL,
			[Name] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
			[Code] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
			[Order] [int] NOT NULL CONSTRAINT [DF_tblNegotiationSettlementStatus_Order]  DEFAULT (0),
			[Created] [datetime] NOT NULL,
			[CreatedBy] [int] NOT NULL,
			[LastModified] [datetime] NOT NULL,
			[LastModifiedBy] [int] NOT NULL,
		 CONSTRAINT [PK_tblNegotiationSettlementStatus] PRIMARY KEY CLUSTERED 
		(
			[SettlementStatusID] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]

		GRANT SELECT ON tblNegotiationSettlementStatus TO PUBLIC
		SET IDENTITY_INSERT tblNegotiationSettlementStatus ON
		
		INSERT INTO [tblNegotiationSettlementStatus] ([SettlementStatusID],[ParentSettlementStatusID],[Name],[Code],[Order],[Created],[CreatedBy],[LastModified],[LastModifiedBy])  SELECT 1, NULL, 'Negotiations Dept', 'ND', '0', '2008-05-02 07:31:58.810', 750, '2008-05-02 07:31:58.810', 750 
		INSERT INTO [tblNegotiationSettlementStatus] ([SettlementStatusID],[ParentSettlementStatusID],[Name],[Code],[Order],[Created],[CreatedBy],[LastModified],[LastModifiedBy])  SELECT 2, 1, 'Offer Rejected', 'OR', '1', '2008-05-02 07:32:52.423', 750, '2008-05-02 07:32:52.423', 750 
		INSERT INTO [tblNegotiationSettlementStatus] ([SettlementStatusID],[ParentSettlementStatusID],[Name],[Code],[Order],[Created],[CreatedBy],[LastModified],[LastModifiedBy])  SELECT 3, 1, 'Offer Accepted', 'OA', '2', '2008-05-02 07:34:06.487', 750, '2008-05-02 07:34:06.487', 750 
		INSERT INTO [tblNegotiationSettlementStatus] ([SettlementStatusID],[ParentSettlementStatusID],[Name],[Code],[Order],[Created],[CreatedBy],[LastModified],[LastModifiedBy])  SELECT 5, 3, 'Waiting on SIF', 'WS', '3', '2008-05-02 07:44:13.630', 750, '2008-05-02 07:44:13.630', 750 
		
		INSERT INTO [tblNegotiationSettlementStatus] ([SettlementStatusID],[ParentSettlementStatusID],[Name],[Code],[Order],[Created],[CreatedBy],[LastModified],[LastModifiedBy])  SELECT 7, NULL, 'Processing Dept', 'PD', '4', '2008-05-02 07:46:49.060', 750, '2008-05-02 07:46:49.060', 750 
		INSERT INTO [tblNegotiationSettlementStatus] ([SettlementStatusID],[ParentSettlementStatusID],[Name],[Code],[Order],[Created],[CreatedBy],[LastModified],[LastModifiedBy])  SELECT 6, 7, 'Pending Verification', 'PV', '5', '2008-05-02 07:45:25.227', 750, '2008-05-02 07:45:25.227', 750  
		INSERT INTO [tblNegotiationSettlementStatus] ([SettlementStatusID],[ParentSettlementStatusID],[Name],[Code],[Order],[Created],[CreatedBy],[LastModified],[LastModifiedBy])  SELECT 14, 7, 'Waiting on Manager Approval', 'WMA', '6', '2008-05-02 07:51:54.637', 750, '2008-05-02 07:51:54.637', 750 
		INSERT INTO [tblNegotiationSettlementStatus] ([SettlementStatusID],[ParentSettlementStatusID],[Name],[Code],[Order],[Created],[CreatedBy],[LastModified],[LastModifiedBy])  SELECT 8, 7, 'Pending Client Approval', 'PCA', '7', '2008-05-02 07:48:45.190', 750, '2008-05-02 07:48:45.190', 750
		INSERT INTO [tblNegotiationSettlementStatus] ([SettlementStatusID],[ParentSettlementStatusID],[Name],[Code],[Order],[Created],[CreatedBy],[LastModified],[LastModifiedBy])  SELECT 9, 7, 'Unable to Process', 'UP', '8', '2008-05-02 07:51:02.277', 750, '2008-05-02 07:51:02.277', 750 
		INSERT INTO [tblNegotiationSettlementStatus] ([SettlementStatusID],[ParentSettlementStatusID],[Name],[Code],[Order],[Created],[CreatedBy],[LastModified],[LastModifiedBy])  SELECT 10, 7, 'Client Approved Settlement', 'CAS', '9', '2008-05-02 07:51:23.870', 750, '2008-05-02 07:51:23.870', 750 
		INSERT INTO [tblNegotiationSettlementStatus] ([SettlementStatusID],[ParentSettlementStatusID],[Name],[Code],[Order],[Created],[CreatedBy],[LastModified],[LastModifiedBy])  SELECT 11, 7, 'Client Declined Settlement', 'CDS', '10', '2008-05-02 07:51:54.637', 750, '2008-05-02 07:51:54.637', 750 
		
		SET IDENTITY_INSERT tblNegotiationSettlementStatus Off
	END

