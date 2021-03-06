if exists (select * from sysobjects where name = 'stp_AgencyClientIntake')
	drop procedure stp_AgencyClientIntake
go

create procedure stp_AgencyClientIntake
(
	@startdate datetime = '2006-01-01',
	@enddate datetime = null,
	@dateperiod varchar(1) = 'm',
	@userid int,
	@companyid int = -1
)
as
BEGIN

	declare @total varchar(1000)

	select @total = coalesce(@total + ', ', '') + cast(count(*) as varchar(20)) + ' [' + dbo.udf_DatePartName(@DatePeriod, dbo.udf_DatePartStart(@dateperiod,c.created) )  + ']'
	from tblclient c 
	join tbluseragencyaccess ua on ua.agencyid = c.agencyid and ua.userid = @userid
	join tblusercompanyaccess uca on uca.companyid = c.companyid and uca.userid = ua.userid and (@CompanyID = -1 or uca.companyid = @CompanyID)
	where c.created >= @startDate and c.created < isnull(@enddate, getdate())
	group by dbo.udf_DatePartStart(@dateperiod,c.created) 
	order by dbo.udf_DatePartStart(@dateperiod,c.created) 

	exec('select ''Total Client Intake Count'' [Label], ' + @total)

END
