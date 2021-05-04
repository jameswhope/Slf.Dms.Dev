IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertSettlementRecordedCall')
	BEGIN
		DROP  Procedure stp_InsertSettlementRecordedCall 
	END
GO

CREATE Procedure stp_InsertSettlementRecordedCall 
@SettlementId int,
@UserId int,
@CallIdKey varchar(50),
@LanguageId int 
AS
BEGIN
	INSERT INTO tblSettlementRecordedCall(SettlementId, StartDate, ExecutedBy, CallIdkey, LanguageId)
	Values(@SettlementId, GetDate(),@UserId, @CallIdKey, @LanguageId)

	Select scope_identity()
END

GO

