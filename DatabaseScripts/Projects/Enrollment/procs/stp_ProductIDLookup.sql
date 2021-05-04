IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ProductIDLookup')
	BEGIN
		DROP  Procedure  stp_ProductIDLookup
	END
GO

create procedure stp_ProductIDLookup
(
	@VendorCode varchar(20),
	@ProductCode varchar(20)
)
as
begin


select 
	case 
		when (datepart(hour,getdate()) > r.FromHr or datepart(hour,getdate()) < r.ToHr) and p.afterhoursproductid is not null then p.afterhoursproductid 
		else p.productid 
	end [productid],
	case 
		when (datepart(hour,getdate()) > r.FromHr or datepart(hour,getdate()) < r.ToHr) and p.afterhoursproductid is not null and a.revshare = 1 then 0 
		when p.revshare = 1 then 0
		else p.cost 
	end [cost]
from tblleadproducts p 
join tblleadvendors v on v.vendorid = p.vendorid 
join tblRevShareHours r on r.rDay = datename(weekday,getdate())
left join tblleadproducts a on a.productid = p.afterhoursproductid
where v.vendorcode = @VendorCode
and p.productcode = @ProductCode 


end
go