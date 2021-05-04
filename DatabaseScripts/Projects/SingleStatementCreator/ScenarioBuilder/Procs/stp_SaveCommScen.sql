if exists (select * from sysobjects where name = 'stp_SaveCommScen')
	drop procedure stp_SaveCommScen
go

create procedure stp_SaveCommScen
(
	@AgencyID int,
	@CompanyID int,
	@StartDate datetime,
	@EndDate datetime = null,
	@RetFrom int,
	@RetTo int,
	@UserID int
)
as
begin
-- Returns CommScenID

declare @cnt int, @commscenid int


select
	@cnt = count(*), @commscenid = max(commscenid)
from
	tblcommscen
where
	agencyid = @AgencyID and
	startdate <= @StartDate and
	(
		enddate is null or
		enddate >= cast(convert(char(10), @StartDate, 101) as datetime)
	) and
	retentionfrom = @retFrom and
	retentionto = @retTo


if @cnt = 0
 begin
	-- The agency does not have any scenarios defined that meet the Start Date range, create new scenario
	insert tblCommScen (AgencyID, StartDate, EndDate, RetentionFrom, RetentionTo, Created, CreatedBy, LastModified, LastModifiedBy)
	values (@AgencyId, @StartDate, @EndDate, @RetFrom, @RetTo, getdate(), @UserID, getdate(), @UserID)

	select scope_identity()
 end
else
 begin
	if not exists (select 1 from tblCommStruct s where CommScenID = @commscenid and CompanyID = @CompanyID)
	 begin
		-- Add company to existing scenario
		select @commscenid
	 end
	else
	 begin
		-- Uncommented 5/20/09 - Need to manually adjust the start/end dates for this agency so that none overlap
		-- The scenario already has a structure defined for this settlement attorney, a new scenario is required
		insert tblCommScen (AgencyID, StartDate, EndDate, RetentionFrom, RetentionTo, Created, CreatedBy, LastModified, LastModifiedBy)
		values (@AgencyId, @StartDate, @EndDate, @RetFrom, @RetTo, getdate(), @UserID, getdate(), @UserID)

		select scope_identity()
	 end
 end


end
go