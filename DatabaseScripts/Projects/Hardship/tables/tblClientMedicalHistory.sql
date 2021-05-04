IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblClientMedicalHistory')
	BEGIN
		DROP  Table tblClientMedicalHistory
	END
GO

CREATE TABLE [dbo].[tblClientMedicalHistory](
	[MedicalHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[ClientHardShipID] [int] NOT NULL,
	[ClientRelationTypeID] [int] NOT NULL,
	[PillsTakenDaily] [int] NULL CONSTRAINT [DF_tblClientMedicalHistory_PillsTakenDaily]  DEFAULT ((0)),
	[MedicalHistoryDescription] [varchar](500) NULL,
	[Created] [datetime] NOT NULL CONSTRAINT [DF_tblClientMedicalHistory_Created]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL CONSTRAINT [DF_tblClientMedicalHistory_LastModified]  DEFAULT (getdate()),
	[LastModifiedBy] [int] NOT NULL,
	[Deleted] [datetime] NULL,
	[DeletedBy] [int] NULL,
 CONSTRAINT [PK_tblClientMedicalHistory] PRIMARY KEY CLUSTERED 
(
	[MedicalHistoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GRANT SELECT ON tblClientMedicalHistory TO PUBLIC


