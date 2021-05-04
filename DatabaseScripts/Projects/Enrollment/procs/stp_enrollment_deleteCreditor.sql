IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_deleteCreditor')
	BEGIN
		DROP  Procedure  stp_enrollment_deleteCreditor
	END

GO

create procedure stp_enrollment_deleteCreditor
(
	@creditorInstanceID int
)
as
BEGIN
	DELETE FROM [tblLeadCreditorInstance]
	WHERE LeadCreditorInstance = @creditorInstanceID
END
