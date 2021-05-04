IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlements_rejectOver')
	BEGIN
		DROP  Procedure  stp_settlements_rejectOver
	END

GO

CREATE Procedure stp_settlements_rejectOver

	(
		@userid int,
		@overid numeric
	)

AS
BEGIN
	declare @settid numeric
	
	UPDATE tblSettlements_Overs SET Rejected = GETDATE(), RejectedBy = @userid WHERE (OverID = @overid)
	select @settid = settlementid from tblSettlements_Overs  where (OverID = @overid)
	update tblsettlements set [status] ='R' where settlementid = @settid
END

GO


GRANT EXEC ON stp_settlements_rejectOver TO PUBLIC

GO


