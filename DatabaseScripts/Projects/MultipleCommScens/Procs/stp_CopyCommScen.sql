
if exists (select * from sysobjects where name = 'stp_CopyCommScen')
	drop procedure stp_CopyCommScen
go

create procedure stp_CopyCommScen
(
	@commscenid int, -- source scenario
	@commrecid int, -- commrec to replace
	@newcommrecid int, 
	@oldenddate datetime, -- source scenario end date
	@startdate datetime, -- new scenario start date
	@enddate datetime, -- new scenario end date
	@userid int 
)
as
begin

declare @newcommscenid int, @commstructid int, @newcommstructid int

-- set end date of old scenario
if @oldenddate is not null begin
	update tblcommscen set enddate = @oldenddate, LastModified = getdate(), LastModifiedBy = @UserID
	where commscenid = @commscenid
end

-- add new scenario
insert tblcommscen (agencyid,startdate,enddate,[default],created,createdby,lastmodified,lastmodifiedby)
select agencyid, @startdate, @enddate, 0, getdate(), @userid, getdate(), @userid
from tblcommscen
where commscenid = @commscenid

select @newcommscenid = scope_identity()

declare cur cursor for select commstructid from tblcommstruct where commscenid = @commscenid

open cur
fetch next from cur into @commstructid

while @@fetch_status = 0 begin

	-- add new commstruct
	insert tblcommstruct (commscenid,commrecid,parentcommrecid,[order],created,createdby,lastmodified,lastmodifiedby,companyid)
	select @newcommscenid, case when commrecid = @commrecid then @newcommrecid else commrecid end, parentcommrecid, [order], getdate(), @userid, getdate(), @userid, companyid
	from tblcommstruct
	where commstructid = @commstructid

	select @newcommstructid = scope_identity()

	-- add new fee structure
	insert tblcommfee (commstructid,entrytypeid,[percent],created,createdby,lastmodified,lastmodifiedby)
	select @newcommstructid, entrytypeid, [percent], created, @userid, lastmodified, @userid
	from tblcommfee
	where commstructid = @commstructid

	fetch next from cur into @commstructid
end

close cur
deallocate cur


end