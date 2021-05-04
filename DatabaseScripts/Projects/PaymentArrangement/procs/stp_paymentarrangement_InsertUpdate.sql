IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_paymentarrangement_InsertUpdate')
	BEGIN
		DROP  Procedure  stp_paymentarrangement_InsertUpdate
	END

GO

CREATE PROCEDURE [dbo].[stp_paymentarrangement_InsertUpdate]
(
@PmtScheduleID                       int,
@ClientID                            int,
@AccountID                           int,
@SettlementID                        int,
@PmtDate                             datetime,
@PmtAmount                           money,
@PmtRecdDate                         datetime = null,
@userid	                             int
)
AS
BEGIN
	declare @retTbl table (id int)

	IF EXISTS(select PmtScheduleID from tblPaymentSchedule where PmtScheduleID = @PmtScheduleID)
		BEGIN
		--Update existing row
			UPDATE tblPaymentSchedule
			SET
				PmtDate = @PmtDate,
				PmtAmount = @PmtAmount,
				PmtRecdDate = @PmtRecdDate,
				LastModified = getdate(),
				LastModifiedBy = @userid
			OUTPUT INSERTED.PmtScheduleID INTO @retTbl			
			WHERE
				PmtScheduleID = @PmtScheduleID
		END
	ELSE
		BEGIN
			--Insert new row
			INSERT INTO tblPaymentSchedule(ClientID,AccountID,SettlementID,PmtDate,PmtAmount,PmtRecdDate,Created,CreatedBy,LastModified,LastModifiedBy)
			OUTPUT Inserted.PmtScheduleID INTO @retTbl
			VALUES(@ClientID,@AccountID,@SettlementID,@PmtDate,@PmtAmount,@PmtRecdDate,getdate(),@userid,getdate(),@userid)
		END
		
	SELECT id from @retTbl		
END



GO


GRANT EXEC ON stp_paymentarrangement_InsertUpdate TO PUBLIC

GO


