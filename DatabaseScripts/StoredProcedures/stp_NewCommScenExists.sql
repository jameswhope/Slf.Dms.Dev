
alter procedure stp_NewCommScenExists
(
	@ClientID int,
	@NewCompanyID int
)
as
begin
-- Used when moving clients to a new company. Checks if the scenario the client uses has a commission
-- structure for their new company.

declare @clientenrolled datetime,
		@retention int,
		@agencyid int,
		@commscenid int

select
	@clientenrolled = created,
	@agencyid = agencyid
from
	tblclient
where
	clientid = @clientid	

	
select @retention = datediff(m,@clientenrolled,getdate())

if (day(@clientenrolled) > day(getdate())) begin
	set @retention = @retention - 1
end	


select
	@commscenid = commscenid
from
	tblcommscen
where
	agencyid = @agencyid and
	startdate <= @clientenrolled and
	(
		enddate is null or
		enddate >= cast(convert(char(10), @clientenrolled, 101) as datetime)
	) and
	@retention between retentionfrom and retentionto


-- exception: allow old DRF(840) clients to use default scenario
if (@agencyid = 840 and @clientenrolled < '6/1/06') begin
	return 1
end


if exists (select 1 from tblcommstruct where commscenid = @commscenid and companyid = @NewCompanyID)
	return 1
else
	return 0


end
go 