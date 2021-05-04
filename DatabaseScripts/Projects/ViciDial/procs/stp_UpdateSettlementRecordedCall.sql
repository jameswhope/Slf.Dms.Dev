IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UpdateSettlementRecordedCall')
	BEGIN
		DROP  Procedure  stp_UpdateSettlementRecordedCall
	END

GO

CREATE Procedure  stp_UpdateSettlementRecordedCall 
@SettlementRecId int,
@EndDate datetime = null,
@Completed bit = null,
@RecId int = null,
@LastStep varchar(50) = null,
@ViciFileName varchar(255) = null
AS
Update tblSettlementRecordedCall Set
EndDate = isnull(@EndDate, EndDate),
Completed = isNull(@Completed, Completed),
RecId = isnull(@RecId, RecId),
LastStep = isnull(@LastStep, LastStep),
ViciFileName = isnull(@ViciFileName, ViciFileName)
Where SettlementRecId = @SettlementRecId

