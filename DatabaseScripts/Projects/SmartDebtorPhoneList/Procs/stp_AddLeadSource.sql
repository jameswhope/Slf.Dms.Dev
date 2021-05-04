
create procedure stp_AddLeadSource
(
	@LeadMarketID int,
	@Source varchar(200),
	@UserID int
)
as
begin

if exists (select 1 from tblLeadSource where LeadMarketID = @LeadMarketID and Source = @Source) begin
	select LeadSourceID from tblLeadSource where LeadMarketID = @LeadMarketID and Source = @Source
end
else begin
	insert tblLeadSource (LeadMarketID,Source,CreatedBy) values (@LeadMarketID,@Source,@UserID) 
	select scope_identity()
end

end
go