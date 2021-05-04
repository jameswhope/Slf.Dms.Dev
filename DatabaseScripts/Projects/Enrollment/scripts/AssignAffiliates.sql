
declare @leadapplicantid int, @productid int, @rcid varchar(100), @code varchar(20), @affiliateid int
declare cur cursor for select leadapplicantid, productid, rcid from tblleadapplicant where productid > 0 and len(rcid) > 0 and affiliateid is null

open cur
fetch next from cur into @leadapplicantid, @productid, @rcid
while @@fetch_status = 0 begin 
	select top 1 @code=[value] from dbo.splitstr(@rcid,'-')

	if not exists (select 1 from tblleadaffiliates where affiliatecode = @code and productid = @productid) begin
		insert tblleadaffiliates (affiliatecode,affiliatedesc,productid,createdby)
		values (@code,@code,@productid,1265)
		select @affiliateid = scope_identity()
	end
	else begin
		select @affiliateid=affiliateid from tblleadaffiliates where affiliatecode = @code and productid = @productid
	end

	update tblleadapplicant set affiliateid = @affiliateid where leadapplicantid = @leadapplicantid

	fetch next from cur into @leadapplicantid, @productid, @rcid
end
close cur
deallocate cur 