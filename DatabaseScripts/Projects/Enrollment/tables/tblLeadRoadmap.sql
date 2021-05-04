
CREATE TABLE [dbo].[tblLeadRoadmap](
	[LeadRoadmapID] [int] IDENTITY(1,1) NOT NULL,
	[ParentLeadRoadmapID] [int] NULL,
	[LeadApplicantID] [int] NOT NULL,
	[LeadStatusID] [int] NOT NULL,
	[Reason] [varchar](255) NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblLeadRoadmap] PRIMARY KEY CLUSTERED 
(
	[LeadRoadmapID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] 