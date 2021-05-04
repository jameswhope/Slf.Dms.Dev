IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_InsertDepositDay')
	BEGIN
		DROP  Procedure  stp_enrollment_InsertDepositDay
	END

GO

CREATE Procedure stp_enrollment_InsertDepositDay
@DepositDay int,
@LeadApplicantId int,
@DepositAmount money,
@UserId int
AS
Begin
Insert Into tblLeadDeposits(LeadApplicantId, DepositDay, DepositAmount, Created, CreatedBy, LastModified, LastModifiedBy)
Values(@LeadApplicantId,@DepositDay, @DepositAmount, GetDate(), @UserId, GetDate(), @UserId)

Select Scope_identity()
End
GO
