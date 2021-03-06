/****** Object:  Trigger [trg_UpdateUsers]    Script Date: 11/19/2007 11:04:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_UpdateUsers]

ON [dbo].[tblUser]

FOR UPDATE
AS

	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN
		DECLARE @UserID int
		DECLARE @UIDName varchar(255)
		DECLARE @modby int
		DECLARE @modbyName varchar(255)
		
		DECLARE @oldVal varchar(255)
		DECLARE @newVal varchar(255)
		
		SELECT @UserID = UserID FROM deleted
		SELECT @UIDName =(select username from tbluser where userid = @userid)
		
		SELECT @modby = LastModifiedBy FROM inserted
		SELECT @modbyName = (select username from tbluser where userid = @modby)

		IF COLUMNS_UPDATED() > 0
		BEGIN
			SET @oldVal = (select password from deleted)
			SET @newVal = (select password from inserted)
		END



		declare @body varchar(3000)
		SET @body = ' User ' + Convert(Varchar(50),@modbyName) + ' modified ' + Convert(Varchar(50), @UIDName)-- + ' From '+convert(varchar(255),@oldVal)+' to '+convert(varchar(255),@newVal)

		EXEC msdb.dbo.sp_send_dbmail @recipients = 'cnott@dmsi.local',
									 @body = @body,
									 @subject = 'tblUser Modified'						       
	END
GO
