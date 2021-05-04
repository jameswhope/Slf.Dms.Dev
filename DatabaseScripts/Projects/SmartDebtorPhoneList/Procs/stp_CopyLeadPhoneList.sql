IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CopyLeadPhoneList')
	BEGIN
		DROP  Procedure  stp_CopyLeadPhoneList
	END
GO

create procedure stp_CopyLeadPhoneList
(
	@CopyForDate datetime,
	@ForDate datetime,
	@UserID int
)
as
begin

if not exists (select 1 from tblLeadPhoneList where ForDate = @ForDate) begin
	insert tblLeadPhoneList (ForDate,LeadSourceID,Phone,Budget,Actual,CreatedBy,LastModifiedBy)
	select @ForDate,LeadSourceID,Phone,Budget,Actual,@UserID,@UserID
	from tblLeadPhoneList 
	where ForDate = @CopyForDate
end

end
go