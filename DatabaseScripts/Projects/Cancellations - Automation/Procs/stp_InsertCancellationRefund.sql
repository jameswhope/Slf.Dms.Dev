IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertCancellationRefund')
	BEGIN
		DROP  Procedure  stp_InsertCancellationRefund
	END

GO

CREATE Procedure stp_InsertCancellationRefund
(
	@MatterId int,	
	@AccountsRefunded xml,
	@CreatedBy int
)
AS
BEGIN
	SET ARITHABORT ON;
	SET ANSI_PADDING ON;
	DECLARE @Return INT;

	SELECT @Return = 0


	IF @Return = 0 BEGIN
		BEGIN TRY
			DELETE FROM tblCancellation_RefundInfo WHERE MatterId = @MatterId;

			INSERT INTO tblCancellation_RefundInfo(MatterId, RegisterId, EntryTypeId, Created,
							CreatedBy, LastModified, LastModifiedBy)
			SELECT @MatterId, ParamValues.ParamId.value('@regid','int'), ParamValues.ParamId.value('@eid','int'), getdate(), @CreatedBy, getdate(), @CreatedBy
				FROM @AccountsRefunded.nodes('/Accounts/Account') AS ParamValues(ParamId)

		END TRY
		BEGIN CATCH
			SET @Return = -1;
		END CATCH
	END
	SET ARITHABORT OFF;
	SET ANSI_PADDING OFF;
	RETURN @Return;
END
GO



