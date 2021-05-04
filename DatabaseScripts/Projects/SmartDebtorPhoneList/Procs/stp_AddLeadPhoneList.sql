IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_AddLeadPhoneList')
	BEGIN
		DROP  Procedure  stp_AddLeadPhoneList
	END
GO
 
create procedure stp_AddLeadPhoneList
(
	@ForDate datetime,
	@LeadSourceID int,
	@Phone varchar(10),
	@Budget money,
	@Actual money,
	@UserID int
)
as
begin

/*if exists (select 1 from tblLeadPhoneList where ForDate = @ForDate and LeadSourceID = @LeadSourceID) begin
	update tblLeadPhoneList 
	set Phone = @Phone, Budget = @Budget, Actual = @Actual, LastModified = getdate(), LastModifiedBy = @UserID
	where ForDate = @ForDate and LeadSourceID = @LeadSourceID
end
else begin*/
	insert tblLeadPhoneList (ForDate,LeadSourceID,Phone,Budget,Actual,CreatedBy,LastModifiedBy)
	values (@ForDate,@LeadSourceID,@Phone,@Budget,@Actual,@UserID,@UserID)
--end

end
go