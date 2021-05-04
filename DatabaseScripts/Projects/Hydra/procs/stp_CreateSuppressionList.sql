IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CreateSuppressionList')
	BEGIN
		DROP  Procedure  stp_CreateSuppressionList
	END
GO

create procedure stp_CreateSuppressionList
(
	@VendorID int = 201 -- Hydra
)
as
begin

	declare @id int
	set @id = -1

	if exists ( select 1 
				from tblleademails e 
				join tblleadapplicant l on l.leadapplicantid = e.leadapplicantid 
				join tblleadproducts p on p.productid = l.productid and p.vendorid = @VendorID 
				where e.dateunsubscribed is not null 
				and e.suppressionlistid is null
				
				union
				
				select 1 from tblhydrasuppressions where suppressionlistid is null and vendorid = @VendorID) begin

		insert tblsuppressionlist (datesent) values (getdate())
		select @id = scope_identity()

		update tblleademails 
		set suppressionlistid = @id
		from tblleademails e 
		join tblleadapplicant l on l.leadapplicantid = e.leadapplicantid 
		join tblleadproducts p on p.productid = l.productid and p.vendorid = @VendorID 
		where e.dateunsubscribed is not null 
		and e.suppressionlistid is null
		
		update tblhydrasuppressions
		set suppressionlistid = @id
		where suppressionlistid is null
		and vendorid = @VendorID
		
	end

	select distinct email 
	from tblleademails 
	where suppressionlistid = @id
	
	union 
	
	select distinct email
	from tblhydrasuppressions
	where suppressionlistid = @id

end
go 