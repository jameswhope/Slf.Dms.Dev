IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblTreeTrackType')
	BEGIN
		DROP  Table tblTreeTrackType
	END
GO

CREATE TABLE [dbo].[tblTreeTrackType](
	[TreeTrackTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[ParentTreeTrackTypeID] [int] NULL
) ON [PRIMARY]