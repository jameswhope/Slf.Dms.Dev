/****** Object:  Trigger [trg_tblClient_AccountNumberLog]    Script Date: 11/19/2007 11:04:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_tblClient_AccountNumberLog] ON [dbo].[tblClient]
FOR UPDATE
AS

DECLARE @clientId int
DECLARE @new varchar(50)
DECLARE @old varchar(50)
DECLARE @changedby int

SELECT @clientId=ClientId,@new=accountnumber,@changedby=lastmodifiedby FROM inserted
SELECT @old=accountnumber FROM deleted

if (not @old=@new or (@old is null and not @new is null) or (@new is null and not @old is null))
begin
	INSERT INTO tblClientANChangeLog (clientid,oldaccountnumber,newaccountnumber,dateChanged,changedby) values 
		(@clientid,@old,@new,getdate(),@changedby)
end
GO
