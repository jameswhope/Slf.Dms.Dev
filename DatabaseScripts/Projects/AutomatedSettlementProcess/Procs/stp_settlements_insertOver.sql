IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlements_insertOver')
	BEGIN
		DROP  Procedure  stp_settlements_insertOver
	END

GO

CREATE Procedure stp_settlements_insertOver
(@SettlementID int
,@CreatedBy int
,@OverAmount money)
as
BEGIN
	INSERT INTO [tblSettlements_Overs]([SettlementID],[Created],[CreatedBy],[Approved],[ApprovedBy],[OverAmount])
	VALUES (@SettlementID,getdate(),@CreatedBy,Null,Null,@OverAmount)
END



GRANT EXEC ON stp_settlements_insertOver TO PUBLIC

GO


