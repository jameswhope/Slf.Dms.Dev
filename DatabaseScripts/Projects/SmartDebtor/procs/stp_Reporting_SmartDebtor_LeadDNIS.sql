IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Reporting_SmartDebtor_LeadDNIS')
	BEGIN
		DROP  Procedure  stp_Reporting_SmartDebtor_LeadDNIS
	END

GO

CREATE procedure [dbo].[stp_Reporting_SmartDebtor_LeadDNIS]
(
@dnis varchar(max) ,
@startDate datetime ,
@endDate datetime 
)
as
BEGIN

/* 
usage: --stp_Reporting_SmartDebtor_LeadDNIS 'ALL', '6/22/2009','6/23/2009'

dev
declare @startDate datetime
declare @dnis varchar(max) 
set @dnis = '9650, 9677, 9678, 9679'
set @startDate = dateadd(d,-day(getdate())+1,getdate())

*/

	if @dnis = 'ALL'
	BEGIN
		declare @addDNIS varchar(20)
		set @dnis = ''
		declare cursor_DNIS cursor forward_only read_only for SELECT right(dnis,4)[dnis] from tblleaddnis where dnis <> '' order by right(dnis,4)
		open cursor_DNIS
		fetch next from cursor_DNIS into @addDNIS
		while @@fetch_status = 0
			begin
				set @dnis = @dnis + case when @addDNIS is null then '' else @addDNIS + ',' end 
				
				fetch next from cursor_DNIS into @addDNIS
			end
		close cursor_DNIS
		deallocate cursor_DNIS

		set @dnis = left(@dnis, len(@dnis)-1)
		--select @dnis
	END

	declare @ssql varchar(max)
	declare @val varchar(4)

	set @ssql = ''

	set @ssql = 'select '
	set @ssql = @ssql + '[DNIS] = substring(cd.dnis,5,4)'
	set @ssql = @ssql + ',[I3CallIDKey] = cd.callid'
	set @ssql = @ssql + ',[LocalCallIDKey] = isnull(lc.callidkey,'''')'
	set @ssql = @ssql + ',[StationID] = case when cd.stationid = ''System'' then ''System'' else '''' end'
	set @ssql = @ssql + ',[Screen Pop]= cd.localname'
	set @ssql = @ssql + ',[initiated]= cd.ConnectedDate'
	set @ssql = @ssql + ',[initDay] = datename(day,cd.ConnectedDate)'
	set @ssql = @ssql + ',[Created] = isnull(lc.created,'''')'
	set @ssql = @ssql + ',[Status] = isnull(ls.description,'''')'
	set @ssql = @ssql + ',[Full Name] = isnull(la.fullname,'''')'
	set @ssql = @ssql + ',[City] = isnull(la.city,'''')'
	set @ssql = @ssql + ',[State] = isnull(st.name,'''')'
	set @ssql = @ssql + ',Concerns = isnull(con.description,'''')'
	set @ssql = @ssql + ',LawFirm = isnull(comp.ShortCoName,'''')'
	set @ssql = @ssql + ',Associate = isnull(u2.firstname +'' '' + u2.lastname,'''')'
	set @ssql = @ssql + ',Rep = isnull(u.firstname + '' '' + u.lastname,'''')'
	set @ssql = @ssql + ',[Total Debt] = isnull(calc.totaldebt,0)'
	set @ssql = @ssql + ',[RemoteNumber] = cd.remoteNumber '
	set @ssql = @ssql + ',[HoldDuration] = cd.HoldDurationSeconds '
	set @ssql = @ssql + 'from [DMF-SQL-0001].i3_cic.dbo.calldetail cd '
	set @ssql = @ssql + 'left join tblleadcall lc on lc.callidkey = cd.callid '
	set @ssql = @ssql + 'left join tblleadapplicant la on la.leadapplicantid = lc.leadapplicantid '
	set @ssql = @ssql + 'left join tblleadstatus ls on la.statusid = ls.statusid '
	set @ssql = @ssql + 'left join tblstate st on la.stateid = st.stateid '
	set @ssql = @ssql + 'left join tblcompany comp on la.companyid = comp.companyid '
	set @ssql = @ssql + 'left join tblleadconcerns con on la.concernsid = con.concernsid '
	set @ssql = @ssql + 'left join tbluser u on repid = u.userid '
	set @ssql = @ssql + 'left join tbluser u2 on createdbyid = u2.userid '
	set @ssql = @ssql + 'left join tblleadcalculator calc on lc.leadapplicantid = calc.leadapplicantid '
	set @ssql = @ssql + 'where '

	
	set @ssql = @ssql + '(' + char(13)
	DECLARE @pos int,@nextpos int,@valuelen int
	SELECT @pos = 0, @nextpos = 1

	WHILE @nextpos > 0
	BEGIN
	  SELECT @nextpos = charindex(',', @dnis, @pos + 1)
	  SELECT @valuelen = CASE WHEN @nextpos > 0 THEN @nextpos ELSE len(@dnis) + 1 END - @pos - 1
	  set @ssql = @ssql + 'cd.dnis like ''sip:' + convert(varchar, substring(@dnis, @pos + 1, @valuelen)) + '@%'' '
	  SELECT @pos = @nextpos
		if @pos > 0
			BEGIN
				set @ssql = @ssql + 'OR ' + char(13)
			END
	END 
	set @ssql = @ssql + ') and '

	set @ssql = @ssql + 'calldirection =''inbound'' and calltype = ''external'' '
	set @ssql = @ssql + 'and cd.ConnectedDate >= ' + char(39) + convert(varchar,@startDate) + char(39) + ' '
	set @ssql = @ssql + 'and cd.ConnectedDate <= ' + char(39) + convert(varchar,@endDate) + char(39) + ' '
	set @ssql = @ssql + 'order by cd.dnis, cd.ConnectedDate'

	exec(@ssql)

END


GRANT EXEC ON stp_Reporting_SmartDebtor_LeadDNIS TO PUBLIC



