IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_getCallClient')
	BEGIN
		DROP  Procedure  stp_getCallClient
	END

GO

CREATE Procedure stp_getCallClient
@CallIdKey varchar(20)
AS
Select * From 
tblClientCall p 
where  callidkey = @CallIdKey
 

GO



