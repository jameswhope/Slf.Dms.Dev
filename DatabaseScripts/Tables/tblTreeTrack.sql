IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblTreeTrack')
	BEGIN
		DROP  Table tblTreeTrack
	END
GO

CREATE TABLE [dbo].[tblTreeTrack](
	[TreeTrackID] [int] IDENTITY(1,1) NOT NULL,
	[ID] [int] NOT NULL,
	[TreeTrackIDTypeID] [int] NOT NULL,
	[ParentTreeTrackID] [int] NULL,
	[TreeTrackTypeID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL
) ON [PRIMARY]