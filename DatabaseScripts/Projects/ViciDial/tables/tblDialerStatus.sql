IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDialerStatus')
	BEGIN
		CREATE TABLE [dbo].[tblDialerStatus](
		[DialerStatusId] [int] NOT NULL PRIMARY KEY CLUSTERED,
		[StatusName] [varchar](50) NOT NULL,
		[UseDialer] [bit] NOT NULL DEFAULT 0)
 	END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDialerStatus')
	BEGIN
		Delete from tblDialerStatus
		
		Insert Into tblDialerStatus(DialerStatusId, StatusName, UseDialer) Values (1, 'NEW', 1)
		Insert Into tblDialerStatus(DialerStatusId, StatusName, UseDialer) Values (2, 'PENDING', 0)
		Insert Into tblDialerStatus(DialerStatusId, StatusName, UseDialer) Values (3, 'INCALL', 0)
		Insert Into tblDialerStatus(DialerStatusId, StatusName, UseDialer) Values (4, 'CALLED', 1)
		Insert Into tblDialerStatus(DialerStatusId, StatusName, UseDialer) Values (5, 'STOPPING', 0)
		Insert Into tblDialerStatus(DialerStatusId, StatusName, UseDialer) Values (6, 'STOPPED', 0)
		
	END
	
GO