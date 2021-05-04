IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ImportEnrollmentInsert')
	BEGIN
		DROP  Procedure  stp_ImportEnrollmentInsert
	END

GO

CREATE Procedure stp_ImportEnrollmentInsert
@Name varchar(50) = null,
@Phone varchar(50) = null,
@ZipCode varchar(50) = null,
@Behind bit = null,
@BehindId int = null,
@ConcernId int = null,
@TotalUnsecuredDebt money = null,
@DepositCommitment money = null,
@Qualified bit = 1,
@Committed bit = 1,
@DeliveryMethod varchar(50) = null,
@AgencyId int = null,
@CompanyId int = null,
@UserId int
AS
BEGIN

Insert Into tblEnrollment(
[Name], Phone, ZipCode, Behind, BehindID,
ConcernID, TotalUnsecuredDebt, DepositCommitment, Qualified,
[Committed], DeliveryMethod, AgencyID, CompanyID,
Created, CreatedBy)
Values (
@Name, @Phone, @ZipCode, @Behind, @BehindId,
@ConcernId, @TotalUnsecuredDebt, @DepositCommitment, @Qualified,
@Committed, @DeliveryMethod, @AgencyId, @CompanyId,
GetDate(), @UserId)

Select SCOPE_IDENTITY()

END

GO



