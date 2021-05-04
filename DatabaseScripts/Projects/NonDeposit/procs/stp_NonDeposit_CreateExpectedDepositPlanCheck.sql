IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_CreateExpectedDepositPlanCheck')
	BEGIN
		DROP  Procedure  stp_NonDeposit_CreateExpectedDepositPlanCheck
	END

GO

CREATE Procedure stp_NonDeposit_CreateExpectedDepositPlanCheck
@date datetime,
@userid int
AS
Begin

	if exists(select top 1 planid from tblPlannedDeposit where convert(varchar(10),ScheduledDate,101) = convert(varchar(10),@date,101) and DepositType in ('Check'))
	Begin
		Print 'The Check planned records for date ' + convert(varchar(10),@date,101) + ' have already been generated.'
		RETURN
	END
	
	Declare @lastdayofmonth bit
	
	if @date = dateadd(dd, -(day(dateadd(mm, 1, @date))), dateadd(mm, 1, @date))
		set @lastdayofmonth = 1
	else
		set @lastdayofmonth = 0

	BEGIN TRY

	
		/*	Scheduled FirstTime
			1 - Get all expected first draft checks for the date
		*/
		--(1)
		Insert into tblPlannedDeposit(ClientId, ScheduledDate, DepositType, MonthlyDepositAmount, PartialDepositAmount, ExpectedDepositAmount, MultiDepositClient, RuleACHId, RuleCheckId, AdHocAchId, ClientDepositId, FirstDeposit, ZeroAmountRule, CreatedDate, CreatedBy, ProcessedDate, ProcessedBy)
		SELECT  
			c.clientid, @date, 'Check', 0, c.initialdraftamount, c.initialdraftamount, c.MultiDeposit, null, null, null, null, 1, 0, getdate(), @userid, null, null
		from tblclient c
		where 
			c.currentclientstatusid not in (15,17,18,22)
			and c.clientId not in (Select v.clientid from vw_ExcludeAchNo3PV v)
			and c.ClientId not in (Select h.clientid from tblnondepositprobono h)
			and c.clientId not in (Select a.clientid from tbladhocach a where a.clientid = c.clientid and isnull(a.InitialDraftYN,0) = 1)
			and c.initialdraftdate is not null
			and convert(varchar(10),c.initialdraftdate,101) = convert(varchar(10),@date,101)
			and isnull(c.initialdraftamount,0) > 0
			--avoid duplicates	
			and convert(varchar,c.clientid)+convert(varchar(10),@date,101)+'Check'+'1'  not in (Select convert(varchar,pd.clientid)+convert(varchar(10),@date,101)+ pd.DepositType+convert(varchar,pd.FirstDeposit) from tblPlannedDeposit pd) 
			and c.ClientId not in (select cmp.clientid from vw_NonDeposit_ActiveCompletedClients cmp)

		/*	Scheduled Check
			For multi-deposit clients
			3 - Get all planned Checks with no rules for the date 
			4 - Get all planned Checks with rules for the date. Include zero dollar rule
			For single deposit clients
			5 - Get all planned Checks with no rules for the date 
			6 - Get all planned Checks with rules for the date. Include zero dollar rule
		*/
		--(3)
		Insert into tblPlannedDeposit(ClientId, ScheduledDate, DepositType, MonthlyDepositAmount, PartialDepositAmount, ExpectedDepositAmount, MultiDepositClient, RuleACHId, RuleCheckId, AdHocAchId, ClientDepositId, FirstDeposit, ZeroAmountRule, CreatedDate, CreatedBy, ProcessedDate, ProcessedBy)
		SELECT
			c.ClientID, @date, 'Check', 
			MonthlyDep = (Select Sum(d1.depositamount) from tblClientDepositDay d1 where d1.deletedDate is null and d1.clientid = c.clientid),
			d.DepositAmount, d.DepositAmount, c.Multideposit, null, null, null, d.ClientDepositID, 0, 0, getdate(), @userid, null, null
		FROM
			tblClient as c
			inner join tblClientDepositDay d on d.ClientID = c.ClientID
		WHERE
			d.ClientDepositID not in (SELECT ClientDepositID FROM tblDepositRuleCheck WHERE StartDate <= cast(convert(varchar(10), @date, 101) as datetime) and (EndDate is null or EndDate >= cast(convert(varchar(10), @date, 101) as datetime))) 
			and	(d.DepositDay = day(@date) or (@lastdayofmonth = 1 and d.DepositDay >= day(@date)))
			and c.DepositStartDate <= cast(convert(varchar(10), @date, 101) as datetime)
			and c.DepositStartDate is not null
			and c.CurrentClientStatusID in (14, 16) -- Active, Non-responsive
			and c.MultiDeposit = 1
			and lower(d.Frequency) = 'month'
			and d.DeletedDate is null
			and lower(d.DepositMethod) = 'check'
			and c.ClientId not in (Select v.clientid from vw_ExcludeAchNo3PV v)
			and c.ClientId not in (Select h.clientid from tblnondepositprobono h)
			--Avoid Duplicates
			and d.clientdepositid not in (select pd.clientdepositid from tblPlannedDeposit pd where month(pd.ScheduledDate) = month(@date) and year(pd.ScheduledDate) = year(@date) and pd.clientdepositid is not null)
			and c.ClientId not in (select cmp.clientid from vw_NonDeposit_ActiveCompletedClients cmp)

		--(4)
		Insert into tblPlannedDeposit(ClientId, ScheduledDate, DepositType, MonthlyDepositAmount, PartialDepositAmount, ExpectedDepositAmount, MultiDepositClient, RuleACHId, RuleCheckId, AdHocAchId, ClientDepositId, FirstDeposit, ZeroAmountRule, CreatedDate, CreatedBy, ProcessedDate, ProcessedBy)
		SELECT
			c.ClientID, @date, 'Check',
			MonthlyDep = (Select Sum(d1.depositamount) from tblClientDepositDay d1 where d1.deletedDate is null and d1.clientid = c.clientid),
			d.DepositAmount, r.DepositAmount, c.Multideposit, null, r.rulecheckid, null, r.ClientDepositID, 0, ZeroAmountRule = case when r.DepositAmount = 0 then 1 else 0 end, getdate(), @userid, null,  null
		FROM
			tblDepositRuleCheck as r
			inner join tblClientDepositDay d on d.ClientDepositID = r.ClientDepositID
			inner join tblClient as c on c.ClientID = d.ClientID
		WHERE 
			r.StartDate <= cast(convert(varchar(10), @date, 101) as datetime) 
			and	(r.EndDate is null or r.EndDate >= cast(convert(varchar(10), @date, 101) as datetime)) 
			and	(r.DepositDay = day(@date) or (@lastdayofmonth = 1 and r.DepositDay >= day(@date)))
			and c.DepositStartDate <= cast(convert(varchar(10), @date, 101) as datetime)
			and c.DepositStartDate is not null
			and c.CurrentClientStatusID in (14, 16) -- Active, Non-responsive
			and c.MultiDeposit = 1
			and lower(d.Frequency) = 'month'
			and d.DeletedDate is null
			and lower(d.DepositMethod) = 'Check'
			and c.ClientId not in (Select v.clientid from vw_ExcludeAchNo3PV v)
			and c.ClientId not in (Select h.clientid from tblnondepositprobono h)
			--avoid duplicates
			and d.clientdepositid not in (select pd.clientdepositid from tblPlannedDeposit pd where month(pd.ScheduledDate) = month(@date) and year(pd.ScheduledDate) = year(@date) and pd.clientdepositid is not null)
			and c.ClientId not in (select cmp.clientid from vw_NonDeposit_ActiveCompletedClients cmp)

		--(5)
		Insert into tblPlannedDeposit(ClientId, ScheduledDate, DepositType, MonthlyDepositAmount, PartialDepositAmount, ExpectedDepositAmount, MultiDepositClient, RuleACHId, RuleCheckId, AdHocAchId, ClientDepositId, FirstDeposit, ZeroAmountRule, CreatedDate, CreatedBy, ProcessedDate, ProcessedBy)
		SELECT
			c.ClientID, @date, 'Check', c.DepositAmount, c.DepositAmount, c.DepositAmount, c.Multideposit, null, null, null, null, 0, 0, getdate(), @userid, null, null
		FROM
			tblClient as c
		WHERE
			c.ClientID not in (SELECT ClientID FROM tblRuleCheck WHERE StartDate <= cast(convert(varchar(10), @date, 101) as datetime) and (EndDate is null or EndDate >= cast(convert(varchar(10), @date, 101) as datetime))) 
			and	(c.DepositDay = day(@date) or (@lastdayofmonth = 1 and c.DepositDay >= day(@date)))
			and c.DepositStartDate <= cast(convert(varchar(10), @date, 101) as datetime)
			and c.DepositStartDate is not null
			and c.CurrentClientStatusID in (14, 16) -- Active, Non-responsive
			and c.MultiDeposit = 0
			and lower(c.DepositMethod) = 'check'
			and c.ClientId not in (Select v.clientid from vw_ExcludeAchNo3PV v)
			and c.ClientId not in (Select h.clientid from tblnondepositprobono h)
			--avoid duplicates
			and c.clientid not in (select pd.clientid from tblPlannedDeposit pd where month(pd.ScheduledDate) = month(@date) and year(pd.ScheduledDate) = year(@date))
			and c.ClientId not in (select cmp.clientid from vw_NonDeposit_ActiveCompletedClients cmp)

		
		--(6)
		Insert into tblPlannedDeposit(ClientId, ScheduledDate, DepositType, MonthlyDepositAmount, PartialDepositAmount, ExpectedDepositAmount, MultiDepositClient, RuleACHId, RuleCheckId, AdHocAchId, ClientDepositId, FirstDeposit, ZeroAmountRule, CreatedDate, CreatedBy, ProcessedDate, ProcessedBy)
		SELECT
			c.ClientID, @date, 'Check', c.DepositAmount, c.DepositAmount, r.DepositAmount, c.Multideposit, null, r.rulecheckid, null, null, 0, ZeroAmountRule = Case When r.DepositAmount = 0 then 1 else 0 end , getdate(), @userid, null, null
		FROM
			tblRuleCheck as r
			inner join tblClient as c on c.ClientID = r.ClientID
		WHERE
			c.ClientID  in 
			(SELECT Min(RuleCheckId) FROM tblRuleCheck
			 WHERE StartDate <= cast(convert(varchar(10), @date, 101) as datetime) and 
			 (EndDate is null or EndDate >= cast(convert(varchar(10), @date, 101) as datetime))
			 and (r.DepositDay = day(@date) or (@lastdayofmonth = 1 and r.DepositDay >= day(@date)))
			 Group By ClientId) 
			and c.DepositStartDate <= cast(convert(varchar(10), @date, 101) as datetime)
			and c.DepositStartDate is not null
			and c.CurrentClientStatusID in (14, 16) -- Active, Non-responsive
			and c.MultiDeposit = 0
			and lower(c.DepositMethod) = 'check'
			and c.ClientId not in (Select v.clientid from vw_ExcludeAchNo3PV v)
			and c.ClientId not in (Select h.clientid from tblnondepositprobono h)
			--avoid duplicates
			and c.clientid not in (select pd.clientid from tblPlannedDeposit pd where month(pd.ScheduledDate) = month(@date) and year(pd.ScheduledDate) = year(@date))
			and c.ClientId not in (select cmp.clientid from vw_NonDeposit_ActiveCompletedClients cmp)

			
		END TRY
		BEGIN CATCH
			PRINT ERROR_MESSAGE();
		END CATCH
End

GO

