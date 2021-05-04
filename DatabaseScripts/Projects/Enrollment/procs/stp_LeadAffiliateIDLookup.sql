IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_LeadAffiliateIDLookup')
	BEGIN
		DROP  Procedure  stp_LeadAffiliateIDLookup
	END
GO

create procedure stp_LeadAffiliateIDLookup
(
	@AffiliateCode varchar(20),
	@ProductID int
)
as
begin


if not exists (select 1 from tblleadaffiliates where affiliatecode = @AffiliateCode and productid = @ProductID) begin
	insert tblleadaffiliates (affiliatecode,affiliatedesc,productid,createdby)
	values (@AffiliateCode,@AffiliateCode,@ProductID,1265)
	select scope_identity()
end
else begin
	select affiliateid from tblleadaffiliates where affiliatecode = @AffiliateCode and productid = @ProductID
end


end
go 