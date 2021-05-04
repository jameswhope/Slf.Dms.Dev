IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblTreeTrackIDType')
	BEGIN
		DROP  Table tblTreeTrackIDType
	END
GO

CREATE TABLE [dbo].[tblTreeTrackIDType](
	[TreeTrackTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL
) ON [PRIMARY]

INSERT INTO [dbo].[tblTreeTrackIDType] ([Name]) VALUES ('Settlement')