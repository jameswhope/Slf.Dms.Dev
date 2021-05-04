IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Reporting_SmartDebtor_KPI')
	BEGIN
		DROP  Procedure  stp_Reporting_SmartDebtor_KPI
	END

GO

CREATE procedure [dbo].[stp_Reporting_SmartDebtor_KPI]
(
	@startdate datetime,
	@enddate datetime
)
as
BEGIN
/*	developement

	[stp_Reporting_SmartDebtor_KPI] '7/1/2009 12:00:00 AM','7/14/2009 12:00:00 AM'

	declare @startDate datetime
	declare @endDate datetime

	set @startDate = '6/1/2009 12:00:00 AM'
	set @endDate = '7/1/2009 12:00:00 AM'

*/
/*    developement */

   
	declare @ssql varchar(max)
	declare @val varchar(4)
	declare @dnis varchar(max) 
	declare @addDNIS varchar(20)

	set @ssql = ''
	set @dnis = ''

	-- hard coded values (need to find where these come from)
	declare @TransferPercentGoal float
	declare @NumCasesGoal int
	declare @ConversionPercentGoal float
	declare @MarketingBudgetPerDay money
	declare @CostPerConversionGoal money

	-- set values
	set @TransferPercentGoal = 85.00
	set @NumCasesGoal  = 12
	set @ConversionPercentGoal = 12.00
	set @MarketingBudgetPerDay = 5531.00
	set @CostPerConversionGoal = 416.67

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

	
--get internet/phone lead data
set @ssql = @ssql + 'declare @tblRpt table (TypeDayID int, ConnectDate varchar(20), TotalInboundCalls int, TotalInternet int, TotalSystemCalls int, TotalAppointments int,TotalCallsAnswered int,TotalOtherInboundLeads int ,TotalCallsTransferred int, TransferPercent float, TransferPercentGoal float, NumCasesAgainstMarketingDollars int, NumCasesGoal int, ConversionPercent float, ConversionPercentGoal float,MarketingBudgetSpentPerDay Money, MarketingBudgetPerDay Money, CostPerConversionDay Money, CostPerConversionGoal Money, TotalNumCases int) ' + char(13)
set @ssql = @ssql + 'insert into @tblRpt '
set @ssql = @ssql + 'select '
set @ssql = @ssql + '[DayOfWeek] = case when datepart(dw, initiated-1) in (6,7) then ''0'' else ''1'' end '
set @ssql = @ssql + ', [ConnectDate] = convert(varchar(10),initiated,101) '
set @ssql = @ssql + ', [TotalInboundCalls] = SUM(CASE WHEN [TYPE] = ''PHONE'' THEN 1 ELSE 0 END) '
set @ssql = @ssql + ', [TotalInternet] = SUM(CASE WHEN [TYPE] = ''INTERNET'' THEN 1 ELSE 0 END) '
set @ssql = @ssql + ', [TotalSystemCalls] = sum(case when Stationid = ''System'' then 1 else 0 end) '
set @ssql = @ssql + ', [TotalAppointments] = sum(FirstAppointmentDate) '
set @ssql = @ssql + ', [TotalCallsAnswered] = 0 '
set @ssql = @ssql + ', [TotalCallsTransferred] = 0'
set @ssql = @ssql + ', [TotalOtherInboundLeads] = sum(case when Leadsourceid in (1,2) then 1 else 0 end)'
set @ssql = @ssql + ', [TransferPercent] = 0 '
set @ssql = @ssql + ', [TransferPercentGoal] = ' + convert(varchar,@TransferPercentGoal)
set @ssql = @ssql + ', [NumCasesAgainstMarketingDollars] = 0 '
set @ssql = @ssql + ', [NumCasesGoal] = ' + convert(varchar,@NumCasesGoal)
set @ssql = @ssql + ', [ConversionPercent] = 0 '
set @ssql = @ssql + ', [ConversionPercentGoal] = ' + convert(varchar,@ConversionPercentGoal)
set @ssql = @ssql + ', [MarketingBudgetSpentPerDay] = 0 '
set @ssql = @ssql + ', [MarketingBudgetPerDay] = 0' 
set @ssql = @ssql + ', [CostPerConversionDay] = ' + convert(varchar,@CostPerConversionGoal)
set @ssql = @ssql + ', [CostPerConversionGoal] = ' + convert(varchar,@CostPerConversionGoal)
set @ssql = @ssql + ', [TotalNumCases] = (select count(distinct(leadapplicantid))  from tblleadstatusroadmap where leadstatusid = 6 and convert(varchar(10),created ,101) = convert(varchar(10),initiated,101)) '
set @ssql = @ssql + 'from ( ' + char(13)
set @ssql = @ssql + 'select [Type] = ''INTERNET'''
set @ssql = @ssql + ',[DNIS] = ''00000'' '
set @ssql = @ssql + ',[I3CallIDKey] = ''00000'' '
set @ssql = @ssql + ',[LocalCallIDKey] = ''*****'''
set @ssql = @ssql + ',[StationID] = ''00000'' '
set @ssql = @ssql + ',[Screen Pop]= ''00000'' '
set @ssql = @ssql + ',[initiated]= la.created'
set @ssql = @ssql + ',[initDay] = day(la.created)'
set @ssql = @ssql + ',[Created] = la.created'
set @ssql = @ssql + ',[Status] = isnull(ls.description,'''')'
set @ssql = @ssql + ',[Full Name] = isnull(la.fullname,'''')'
set @ssql = @ssql + ',[City] = isnull(la.city,'''')'
set @ssql = @ssql + ',[State] = isnull(st.name,'''')'
set @ssql = @ssql + ',Concerns = isnull(con.description,'''')'
set @ssql = @ssql + ',LawFirm = isnull(comp.ShortCoName,'''')'
set @ssql = @ssql + ',Associate = isnull(u2.firstname +'' '' + u2.lastname,'''')'
set @ssql = @ssql + ',Rep = isnull(u.firstname + '' '' + u.lastname,'''')'
set @ssql = @ssql + ',[Total Debt] = isnull(calc.totaldebt,0)'
set @ssql = @ssql + ',[RemoteNumber] = ''00000'' '
set @ssql = @ssql + ',[HoldDuration] = ''00000'' '
set @ssql = @ssql + ',[LeadStatusId] = la.statusid '
set @ssql = @ssql + ',[FirstAppointmentDate] = case when not FirstAppointmentDate is null then 1 else 0 end '
set @ssql = @ssql + ',[LeadCreatedDate] = la.Created '
set @ssql = @ssql + ',[LeadSourceID]=la.LeadSourceID ' + char(13)
set @ssql = @ssql + 'from tblleadapplicant la '
set @ssql = @ssql + 'left join tblleadstatus ls on la.statusid = ls.statusid '
set @ssql = @ssql + 'left join tblstate st on la.stateid = st.stateid '
set @ssql = @ssql + 'left join tblcompany comp on la.companyid = comp.companyid '
set @ssql = @ssql + 'left join tblleadconcerns con on la.concernsid = con.concernsid '
set @ssql = @ssql + 'left join tbluser u on repid = u.userid '
set @ssql = @ssql + 'left join tbluser u2 on createdbyid = u2.userid '
set @ssql = @ssql + 'left join tblleadcalculator calc on la.leadapplicantid = calc.leadapplicantid ' + char(13)
set @ssql = @ssql + 'where (rgrid is not null or publisherid is not null) ' 
set @ssql = @ssql + 'and la.Created >= ' + char(39) + convert(varchar,@startDate,120) + char(39) + ' '
set @ssql = @ssql + 'and la.Created <  ' + char(39) + convert(varchar,@endDate,120)  + char(39)  + ' ' + char(13)
set @ssql = @ssql + 'union all ' + char(13)
set @ssql = @ssql + 'select [Type] = ''PHONE''' + char(13)
set @ssql = @ssql + ',[DNIS] = substring(cd.dnis,5,4)'
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
set @ssql = @ssql + ',[LeadStatusId] = la.statusid '
set @ssql = @ssql + ',[FirstAppointmentDate] = case when not FirstAppointmentDate is null then 1 else 0 end '
set @ssql = @ssql + ',[LeadCreatedDate] = la.Created '
set @ssql = @ssql + ',[LeadSourceID]=la.LeadSourceID '
set @ssql = @ssql + 'from [DMF-SQL-0001].i3_cic.dbo.calldetail cd ' + char(13)
set @ssql = @ssql + 'left join tblleadcall lc on lc.callidkey = cd.callid '
set @ssql = @ssql + 'left join tblleadapplicant la on la.leadapplicantid = lc.leadapplicantid '
set @ssql = @ssql + 'left join tblleadstatus ls on la.statusid = ls.statusid '
set @ssql = @ssql + 'left join tblstate st on la.stateid = st.stateid '
set @ssql = @ssql + 'left join tblcompany comp on la.companyid = comp.companyid '
set @ssql = @ssql + 'left join tblleadconcerns con on la.concernsid = con.concernsid '
set @ssql = @ssql + 'left join tbluser u on repid = u.userid '
set @ssql = @ssql + 'left join tbluser u2 on createdbyid = u2.userid '
set @ssql = @ssql + 'left join tblleadcalculator calc on lc.leadapplicantid = calc.leadapplicantid '
set @ssql = @ssql + 'where rgrid is null and publisherid is null and (' + char(13)
DECLARE @pos int,@nextpos int,@valuelen int
SELECT @pos = 0, @nextpos = 1
WHILE @nextpos > 0
	BEGIN
		SELECT @nextpos = charindex(',', @dnis, @pos + 1)
		SELECT @valuelen = CASE WHEN @nextpos > 0 THEN @nextpos ELSE len(@dnis) + 1 END - @pos - 1
		set @ssql = @ssql + 'cd.dnis like ''sip:' + convert(varchar, substring(@dnis, @pos + 1, @valuelen)) + '%'' '
		SELECT @pos = @nextpos
		if @pos > 0
			BEGIN
				set @ssql = @ssql + 'OR ' 
			END
	END 
	set @ssql = @ssql + ') and calldirection =''inbound'' and calltype =''external'' '
	set @ssql = @ssql + 'and cd.ConnectedDate >= convert(varchar,' + char(39) +  convert(varchar,@startDate) + char(39) + ') '
	set @ssql = @ssql + 'and cd.ConnectedDate <  convert(varchar,' + char(39) + convert(varchar,@endDate) + char(39)  + ') '
	set @ssql = @ssql + 'and cd.InteractionType = 0 ) as leaddata '
	set @ssql = @ssql + 'group by convert(varchar(10),initiated,101), DATENAME(dw, initiated), DATEPART(dw, initiated - 1) '
	set @ssql = @ssql + 'order by convert(varchar(10),initiated,101);' + char(13)

	set @ssql = @ssql + 'declare @numDate varchar(10) '
	set @ssql = @ssql + 'declare @nextDate varchar(10)'
	set @ssql = @ssql + 'declare NumCur cursor for select convert(varchar(10),connectdate, 101)from @tblRpt '
	set @ssql = @ssql + 'open NumCur '
	set @ssql = @ssql + 'fetch next from NumCur into @numDate '
	set @ssql = @ssql + 'while @@fetch_status = 0 begin '
	set @ssql = @ssql + '  declare @numCnt int '
	set @ssql = @ssql + '  set @nextDate = convert(varchar(10),dateadd(d,1,@numDate), 101) '
	set @ssql = @ssql + '  select @numCnt = count(*) '
	set @ssql = @ssql + '  from (select Signed = (select top(1) created from tblleadstatusroadmap lrm where lrm.leadapplicantid = la.leadapplicantid and lrm.leadstatusid in (6,7,10,11) order by lrm.roadmapid desc) '
	set @ssql = @ssql + '  from tblleadapplicant la '
	set @ssql = @ssql + '  where created between @numDate and @nextDate '
	set @ssql = @ssql + '  ) as caseData where signed is not null;'
	set @ssql = @ssql + '  update @tblRpt set NumCasesAgainstMarketingDollars = @numCnt where connectdate between @numDate and @nextDate'
	set @ssql = @ssql + '  print(@numDate)'
	set @ssql = @ssql + '  print(@numCnt)'
	set @ssql = @ssql + '  fetch next from NumCur into @numDate '
	set @ssql = @ssql + 'end '
	set @ssql = @ssql + 'close NumCur deallocate NumCur '

--get budget info	
	set @ssql = @ssql + 'declare @phonelist table (date datetime, budget money, actual money) '
	set @ssql = @ssql + 'declare @date datetime, @fordate datetime, @nextfordate datetime, @budget money, @actual money,@days int ;'

	set @ssql = @ssql + 'with mycte as ('
	set @ssql = @ssql + 'select cast(''1/1/'' + cast(year(' + char(39) +  convert(varchar,@startDate) + char(39) + ') as varchar) as datetime) DateValue'
	set @ssql = @ssql + ' union all '
	set @ssql = @ssql + 'select DateValue + 1 '
	set @ssql = @ssql + 'from    mycte    '
	set @ssql = @ssql + 'where   DateValue + 1 <= ' + char(39) + convert(varchar,@endDate) + char(39)  + ') '
	set @ssql = @ssql + 'insert @phonelist (date) '
	set @ssql = @ssql + 'select DateValue from mycte where datevalue between ' + char(39) + convert(varchar,@startDate) + char(39) + ' and '+ char(39) + convert(varchar,@endDate) + char(39) + ' '
	set @ssql = @ssql + 'OPTION (MAXRECURSION 0)'
	set @ssql = @ssql + 'declare cur cursor for select date from @phonelist '
	set @ssql = @ssql + 'open cur '
	set @ssql = @ssql + 'fetch next from cur into @date '
	set @ssql = @ssql + 'while @@fetch_status = 0 begin '
	set @ssql = @ssql + '  select @fordate = max(fordate) from tblleadphonelist where fordate <= @date '
	set @ssql = @ssql + '  select @nextfordate = isnull(min(fordate),getdate()) from tblleadphonelist where fordate > @fordate '
	set @ssql = @ssql + '  select @budget = sum(budget) from tblleadphonelist where fordate = @fordate '
	set @ssql = @ssql + '  select @actual = sum(actual) from tblleadphonelist where fordate = @fordate '
	set @ssql = @ssql + '  set @days = datediff(day,@fordate,@nextfordate) '
	set @ssql = @ssql + '  update @phonelist set budget = (@budget / @days) where date = @date '
	set @ssql = @ssql + '  update @phonelist set actual = (@actual / @days) where date = @date '
	set @ssql = @ssql + '  fetch next from cur into @date '
	set @ssql = @ssql + 'end '
	set @ssql = @ssql + 'close cur deallocate cur '
	set @ssql = @ssql + 'update @tblRpt set MarketingBudgetPerDay = budget,MarketingBudgetSpentPerDay = actual from @tblRpt r join @phonelist p on p.date = r.connectdate '
	set @ssql = @ssql +' update @tblRpt set [CostPerConversionDay] = case when NumCasesAgainstMarketingDollars = 0 then 0 else convert(float,MarketingBudgetPerDay)/convert(float,NumCasesAgainstMarketingDollars) end;'

--update total calls answered
	set @ssql = @ssql + 'update @tblRpt set TotalCallsAnswered = TotalInboundCalls - TotalSystemCalls; '  + char(13)

--update conversion %
	set @ssql = @ssql + 'update @tblRpt set '
	set @ssql = @ssql + 'ConversionPercent = NumCasesAgainstMarketingDollars/ISNULL(NULLIF(convert(float,TotalInboundCalls) + convert(float,TotalInternet),0),1) '  + char(13)
	set @ssql = @ssql + 'where NumCasesAgainstMarketingDollars <> 0'


	set @ssql = @ssql + 'select * from @tblRpt ORDER BY cast(CONNECTDATE as datetime)'  + char(13)

	exec( @ssql)

END




GRANT EXEC ON stp_Reporting_SmartDebtor_KPI TO PUBLIC



