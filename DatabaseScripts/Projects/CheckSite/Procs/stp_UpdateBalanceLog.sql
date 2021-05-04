IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UpdateBalanceLog')
	BEGIN
		DROP  Procedure  stp_UpdateBalanceLog
	END

GO

CREATE Procedure stp_UpdateBalanceLog
@Clientid int,
@BalanceDate datetime,
@Balanced bit
AS
Update tblBalanceLog Set
LastCheck = @BalanceDate,
Balanced = @Balanced
Where ClientId = @ClientId

GO


