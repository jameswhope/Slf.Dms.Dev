IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblClientMedicalHistoryConditions')
	BEGIN
		DROP  Table tblClientMedicalHistoryConditions
	END
GO

CREATE TABLE [dbo].[tblClientMedicalHistoryConditions](
	[HistoryConditionID] [int] IDENTITY(1,1) NOT NULL,
	[MedicalHistoryID] [int] NOT NULL,
	[ConditionTypeID] [int] NOT NULL,
	[ConditionTypeValue] [varchar](500) NULL,
	[Deleted] [datetime] NULL,
	[DeletedBy] [int] NULL,
 CONSTRAINT [PK_tblClientMedicalHistoryConditions] PRIMARY KEY CLUSTERED 
(
	[HistoryConditionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


GRANT SELECT ON tblClientMedicalHistoryConditions TO PUBLIC

