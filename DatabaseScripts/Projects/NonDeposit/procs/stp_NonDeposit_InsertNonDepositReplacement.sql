IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_InsertNonDepositReplacement')
	BEGIN
		DROP  Procedure  stp_NonDeposit_InsertNonDepositReplacement
	END

GO

CREATE Procedure stp_NonDeposit_InsertNonDepositReplacement
@NonDepositId int,
@DepositDate datetime,
@DepositAmount money,
@AdHocAchId int = null,
@UserId int
AS
BEGIN
	--Remove pending add hocs for this replacement
	exec stp_NonDeposit_RemoveCurrentReplacement @NonDepositId, @UserId
	
	declare @Type varchar(10)
	
	Select @Type = Case When @AdHocAchId is not null Then 'ACH' else 'Check' end
	
	Insert into tblNonDepositReplacement(NonDepositId, DepositDate, DepositAmount, AdHocACHId, CreatedBy, LastModifiedBy, ReplacementType)
	Values (@NonDepositId, @DepositDate, @DepositAmount, @AdHocAchId, @UserId, @UserId, @Type)
	
	declare @replacementid int 
	Select  @replacementid = scope_identity()
	
	Update tblNonDeposit Set
	currentreplacementid = @replacementid
	where NonDepositId = @NonDepositId
	
	Select @replacementid
	
	RETURN @replacementid
	
END

GO

 
