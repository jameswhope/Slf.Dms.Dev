IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_AddFeeAdjustmentsToSettlement')
	BEGIN
		DROP  Procedure  stp_AddFeeAdjustmentsToSettlement
	END
GO

create procedure [dbo].[stp_AddFeeAdjustmentsToSettlement]
(
	@SettlementId int,
	@NewAmount money, 
	@AdjustedBy int, 
	@EntryTypeId int, 
	@AdjustedReason varchar(250),
	@IsApproved bit,
	@ApprovedBy int,
	@IsDeleted bit,
	@DeletedBy int
)
as
begin

	declare @amount money,
			@existingEntryType int,
			@DeletedDate datetime;

	select @amount = NewAmount, @existingEntryType = EntryTypeId from tblSettlement_AdjustedFeeDetail where
			settlementid = @SettlementId and entrytypeid = @EntryTypeId and isDeleted = 0;

	select @DeletedDate = (case when @IsDeleted = 0 then null else getdate() end);

	if @existingEntryType is null  or @isApproved = 0 or @EntryTypeId = -2 begin
		Insert Into tblSettlement_AdjustedFeeDetail (SettlementId, NewAmount, AdjustedBy, AdjustedDate, EntryTypeId, 
				AdjustedReason, Approved, ApprovedBy, ApprovedDate, isDeleted, Deleted, DeletedBy)
		Values (@SettlementId, @NewAmount, @AdjustedBy, getdate(), @EntryTypeId, @AdjustedReason, @IsApproved, 
				@ApprovedBy, getdate(), @IsDeleted, @DeletedDate, @DeletedBy)
	end
	else begin
		update tblSettlement_AdjustedFeeDetail
		set newamount = @NewAmount, adjustedby = @AdjustedBy, adjusteddate = getdate(), Approved = @IsApproved, 
			ApprovedBy = @ApprovedBy, ApprovedDate = getdate(), isDeleted = @IsDeleted, Deleted = @DeletedDate, DeletedBy = @DeletedBy
		where settlementid = @SettlementId and entrytypeid = @EntryTypeId and Approved = 1
	end
end
go