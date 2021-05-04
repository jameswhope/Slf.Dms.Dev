IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadAging')
	BEGIN
		DROP  Table tblLeadAging
	END
GO

CREATE TABLE tblLeadAging

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblLeadAging](
	[LeadAgingID] [int] IDENTITY(1,1) NOT NULL,
	[LeadAge] [int] NOT NULL,
	[From] [nvarchar](50) NULL,
	[To] [nvarchar](50) NULL,
	[Created] [datetime] NOT NULL,
	[Createdby] [int] NOT NULL,
	[Modified] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblLeadAging] PRIMARY KEY CLUSTERED 
(
	[LeadAgingID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]   

GO

/*
GRANT SELECT ON tblLeadAging TO PUBLIC

GO
*/
