IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNegotiationRoadmapNote')
	BEGIN
		CREATE TABLE [dbo].[tblNegotiationRoadmapNote](
			[RoadmapNoteID] [int] IDENTITY(1,1) NOT NULL,
			[RoadmapID] [int] NOT NULL,
			[NoteID] [int] NOT NULL,
			[Created] [datetime] NOT NULL,
			[CreatedBy] [int] NOT NULL,
			[LastModified] [datetime] NOT NULL,
			[LastModifiedBy] [int] NOT NULL,
		 CONSTRAINT [PK_tblNegotiationRoadmapNoteNote] PRIMARY KEY CLUSTERED 
		(
			[RoadmapNoteID] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]
	END


GRANT SELECT ON tblNegotiationRoadmapNote TO PUBLIC


