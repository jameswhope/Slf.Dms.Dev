IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_LeadProductIDLookup')
	BEGIN
		DROP  Procedure  stp_LeadProductIDLookup
	END
GO

create procedure stp_LeadProductIDLookup
(
	@ProductCode varchar(20),
	@VendorID int,
	@ProductDesc varchar(50) = '',
	@Cost money = 0,
	@Rev bit = 0
)
as
begin

	declare @ProductID int

	select @ProductID=productid, @Cost=cost 
	from tblleadproducts 
	where productcode = @ProductCode 
		and vendorid = @VendorID 
		and active = 1

	if @ProductID is null begin
		if @ProductDesc = '' begin
			set @ProductDesc = @ProductCode
		end
		
		if @Cost = 0 begin
			select @Cost = DefaultCost from tblleadvendors where vendorid = @VendorID
		end
	
		insert tblleadproducts (productcode,productdesc,vendorid,cost,created,createdby,revshare)
		values (@ProductCode,@ProductDesc,@VendorID,@Cost,getdate(),1265,@Rev)

		select @ProductID = scope_identity()
	end

	select @ProductID, @Cost

end
go
 