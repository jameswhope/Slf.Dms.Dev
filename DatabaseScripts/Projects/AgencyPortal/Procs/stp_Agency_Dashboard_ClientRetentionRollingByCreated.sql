IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Agency_Dashboard_ClientRetentionRollingByCreated')
	BEGIN
		DROP  Procedure  stp_Agency_Dashboard_ClientRetentionRollingByCreated
	END

GO


CREATE Procedure [dbo].[stp_Agency_Dashboard_ClientRetentionRollingByCreated]
(
	@userid int,
	@MonthCreated int,
	@YearCreated int,
	@companyid int = -1
)
as
BEGIN

	/*
	--development use
	declare @userid int
	declare @YearCreated int
	declare @MonthCreated int
	set @userid = 492
	set @MonthCreated = 5
	set @YearCreated = 2008

	stp_Agency_Dashboard_ClientRetentionRollingByCreated 375, 1,2007

	*/
	--script vars
	declare @sSQL varchar(max)
	declare @pstart datetime
	declare @pend datetime

	select @pstart = cast(cast(@YearCreated as varchar) + '-' + cast(@MonthCreated as varchar) + '-01' as datetime)
	select @pend = cast(cast(@YearCreated as varchar) + '-' + cast(@MonthCreated as varchar) + '-' + cast(day(dateadd(d,-1,dateadd(m,1,@pstart))) as varchar) as datetime)

	select 
		  a.ImportAbbr
		  ,convert(varchar,c.accountnumber) [Acct#]       
		  ,convert(varchar,c.created,110) [Created]
		  ,s.name [Status]
		  --,TermDate = isnull(convert(varchar,(select top(1) rm.created from tblroadmap rm where clientstatusid in (17,18) and rm.clientid = c.clientid order by roadmapid desc),110),'')
		  ,Retention = isnull(datediff(day,c.created,(select top(1) rm.created from tblroadmap rm where clientstatusid in (17) and rm.clientid = c.clientid order by roadmapid desc)),'')
	into #cr
	from tblclient c
		inner join tblClientStatus s on c.currentclientstatusid = s.clientstatusid
		inner join tblagency a on c.agencyid = a.agencyid
		Inner join tbluseragencyaccess uaa on uaa.agencyid = c.agencyid and uaa.userid = @userid
		inner join tblusercompanyaccess uca on uca.userid = uaa.userid and uca.companyid = c.companyid and (@companyid = -1 or uca.companyid = @companyid)
		inner join tbluserclientaccess ucc on ucc.userid = uaa.userid and c.created between ucc.clientcreatedfrom and ucc.clientcreatedto
	where c.created >= @pstart 
		and c.created < @pend
		and c.accountnumber is not null
	order by c.created

	--update #cr set retention = datediff(day, created, getdate()) where retention =0
	--select * from #cr

	declare @Months int
	declare @LastNumber int
	declare @totalclients int

	select @totalclients = count(*) from #cr

	set @Months = 1
	set @LastNumber = 0

	set @sSQL = 'select ''Cancelled''[Status],[TotalClients] = ' + cast(@totalclients as varchar) + char(13)
	while @Months <= datediff(m,@pstart,getdate())
		BEGIN
			set @sSQL = @sSQL + ',[Month ' + cast(@Months as varchar) + ']'
			set @sSQL = @sSQL + ' = (select count(*) from #cr where retention > ' + cast(@LastNumber as varchar) 
			set @sSQL = @sSQL + ' and retention <=' + cast(@months*30 as varchar) + ')' + char(13)
			set @LastNumber = @months*30
			set @months = @Months + 1
		END

	set @sSQl = @sSQL + ' Union all '	+ char(13)

	set @months = 1
	set @sSQl = @sSQL +'select ''Remaining''[Status]'
	set @sSQl = @sSQL + ', ' + cast(@totalclients as varchar)+ ' [TotalClients]'
	set @LastNumber = 0
	
	while @Months <= datediff(m,@pstart,getdate())
		BEGIN
			declare @remaining int

			select @remaining  = @totalclients -(select count(*) from #cr where retention > @LastNumber  and retention <=@months*30 )
				
			set @sSQl = @sSQL + ', ' + cast(@remaining as varchar) +' [Month ' + cast(@Months as varchar) + ']' + char(13)
			
			set @totalclients = @remaining 
			set @LastNumber = @months*30
			set @months = @Months + 1
		END

	exec(@sSQl)
	drop table #cr

END



GRANT EXEC ON stp_Agency_Dashboard_ClientRetentionRollingByCreated TO PUBLIC


