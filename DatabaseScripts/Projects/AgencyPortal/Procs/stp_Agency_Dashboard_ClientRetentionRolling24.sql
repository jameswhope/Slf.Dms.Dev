IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Agency_Dashboard_ClientRetentionRolling24')
	BEGIN
		DROP  Procedure  stp_Agency_Dashboard_ClientRetentionRolling24
	END

GO

create procedure [dbo].[stp_Agency_Dashboard_ClientRetentionRolling24]
(
	@userid int,
	@companyid int = -1
)
as
BEGIN
	/* development usage
	declare @userid int
	set @userid = 375
	*/
	declare @sSQL varchar(max)

	select 
		  a.ImportAbbr
		  ,convert(varchar,c.accountnumber) [Acct#]       
		  ,convert(varchar,c.created,110) [Created]
		  ,s.name [Status]
		  ,TermDate = isnull(convert(varchar,(select top(1) rm.created from tblroadmap rm where clientstatusid in (17,18) and rm.clientid = c.clientid order by roadmapid desc),110),'')
		  ,Retention = isnull(datediff(day,c.created,(select top(1) rm.created from tblroadmap rm where clientstatusid in (17) and rm.clientid = c.clientid order by roadmapid desc)),'')
	into #cr
	from tblclient c
	inner join tblClientStatus s on c.currentclientstatusid = s.clientstatusid
	inner join tblagency a on c.agencyid = a.agencyid
	Inner join tbluseragencyaccess uaa on uaa.agencyid = c.agencyid and uaa.userid = @userid
	inner join tblusercompanyaccess uca on uca.userid = uaa.userid and uca.companyid = c.companyid and (@companyid = -1 or uca.companyid = @companyid)
	inner join tbluserclientaccess uc on uc.userid = uca.userid and c.created between uc.clientcreatedfrom and uc.clientcreatedto
	where c.created >= dateadd(yy,-2,getdate())
	and c.accountnumber is not null
	order by c.created

	declare @Months int
	declare @LastNumber int
	declare @totalclients int

	select @totalclients = count(*) from #cr

	set @Months = 1
	set @LastNumber = 0

	--build case statement for 24 blocks of 30 days
	set @sSQL = 'select ''Cancelled/Completed''[Status],[TotalClients] = ' + cast(@totalclients as varchar) + char(13)
	WHILE @Months <= 24
		BEGIN
			set @sSQL = @sSQL + ',[Month ' + cast(@Months as varchar) + ']'
			set @sSQL = @sSQL + ' = (select count(*) from #cr where retention > ' + cast(@LastNumber as varchar) 
			set @sSQL = @sSQL + ' and retention <=' + cast(@months*30 as varchar) + ')' + char(13)
			set @LastNumber = @months*30
			set @months = @Months + 1
		END

	set @sSQl = @sSQL + ' Union all '	+ char(13)

	--build case statement for 24 blocks of 30 days
	set @months = 1
	set @sSQl = @sSQL +'select ''Remaining''[Status]'
	set @sSQl = @sSQL + ', ' + cast(@totalclients as varchar)+ ' [TotalClients]'
	set @LastNumber = 0
	
	WHILE @Months <= 24
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


GRANT EXEC ON stp_Agency_Dashboard_ClientRetentionRolling24 TO PUBLIC


