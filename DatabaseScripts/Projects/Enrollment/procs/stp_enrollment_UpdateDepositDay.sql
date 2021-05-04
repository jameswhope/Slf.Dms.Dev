IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_UpdateDepositDay')
	BEGIN
		DROP  Procedure  stp_enrollment_UpdateDepositDay
	END

GO

CREATE Procedure stp_enrollment_UpdateDepositDay
@LeadDepositId int,
@DepositDay int = null,
@DepositAmount money = null,
@UserId int
AS
Update tblLeadDeposits Set
DepositDay = isnull(@DepositDay, DepositDay),
DepositAmount = isnull(@DepositAmount, DepositAmount),
LastModified = GetDate(),
LastModifiedBy = @UserId
Where  LeadDepositId = @LeadDepositId

GO

