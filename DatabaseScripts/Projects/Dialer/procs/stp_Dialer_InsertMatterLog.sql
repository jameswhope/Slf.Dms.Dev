IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_InsertMatterLog')
	BEGIN
		DROP  Procedure  stp_Dialer_InsertMatterLog
	END

GO

CREATE Procedure stp_Dialer_InsertMatterLog
@PrimaryCallMadeId int,
@MatterId int,
@ReasonId int
AS
Begin
	Insert Into tblMatterDialerLog(PrimaryCallMadeId, MatterId, ReasonId, Created)
	Values(@PrimaryCallMadeId, @MatterId, @ReasonId, GetDate())
	Select scope_identity()
End

GO



