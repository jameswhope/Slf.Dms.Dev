/****** Object:  Table [dbo].[tblRoadmapNote]    Script Date: 11/19/2007 11:04:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblRoadmapNote](
	[RoadmapNoteID] [int] IDENTITY(1,1) NOT NULL,
	[RoadmapID] [int] NOT NULL,
	[NoteID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblRoadmapNote] PRIMARY KEY CLUSTERED 
(
	[RoadmapNoteID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
