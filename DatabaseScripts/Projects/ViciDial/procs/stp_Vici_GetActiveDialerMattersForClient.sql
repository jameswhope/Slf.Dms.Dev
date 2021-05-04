IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_GetActiveDialerMattersForClient')
	BEGIN
		DROP  Procedure  stp_Vici_GetActiveDialerMattersForClient
	END

GO

CREATE Procedure stp_Vici_GetActiveDialerMattersForClient
@ClientId int
AS
select MatterId from tblmatter
Where MatterStatusId In (1,3)
and mattertypeid = 5
and clientid = @ClientId

GO
 
