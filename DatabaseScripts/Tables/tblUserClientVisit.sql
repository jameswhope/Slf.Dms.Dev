IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblUserClientVisit')
	BEGIN
		DROP  Table tblUserClientVisit
	END
GO

CREATE TABLE [dbo].[tblUserClientVisit](
	[UserClientVisitID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ClientID] [int] NOT NULL,
	[VisitedOn] [datetime] NOT NULL
) ON [PRIMARY]