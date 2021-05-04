IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_CreateExpectedDepositPlanACH')
	BEGIN
		DROP  Procedure  stp_NonDeposit_CreateExpectedDepositPlanACH
	END

GO

CREATE Procedure stp_NonDeposit_CreateExpectedDepositPlanACH
@date datetime,
@userid int
AS
Begin

	if exists(select top 1 planid from tblPlannedDeposit where convert(varchar(10),ScheduledDate,101) = convert(varchar(10),@date,101) and DepositType in ('ACH','AdhocACH'))
	Begin
		Print 'The ach planned records for date ' + convert(varchar(10),@date,101) + ' have already been generated.'
		RETURN 0
	END

	declare @lastdayofmonth bit
	
	if @date = dateadd(dd, -(day(dateadd(mm, 1, @date))), dateadd(mm, 1, @date))
		set @lastdayofmonth = 1
	else
		set @lastdayofmonth = 0
	
	BEGIN TRY

	
		/*	Scheduled FirstTime
			1 - Get all adhoc ach that are First Draft for the date
		*/
		
		--(1)
		Insert into tblPlannedDeposit(ClientId, ScheduledDate, DepositType, MonthlyDepositAmount, PartialDepositAmount, ExpectedDepositAmount, MultiDepositClient, RuleACHId, AdHocAchId, ClientDepositId, FirstDeposit, ZeroAmountRule, CreatedDate, CreatedBy, ProcessedDate, ProcessedBy)
		SELECT
			a.ClientID, @date, 'AdhocACH', 0, abs(a.DepositAmount), abs(a.DepositAmount), c.MultiDeposit, Null, a.AdHocACHID, null, a.InitialDraftYN, 0, Getdate(), @userid, null, null
		FROM
			tblAdHocACH as a
			inner join tblClient as c on c.ClientID = a.ClientID
		WHERE
			c.CurrentClientStatusID in (14, 16) -- Active, Non-responsive
			and cast(convert(varchar(10), a.DepositDate, 101) as datetime) = cast(convert(varchar(10), @date, 101) as datetime)
			and a.InitialDraftYN = 1
			and a.ClientId not in (Select v.clientid from vw_ExcludeAchNo3PV v) 
			and a.ClientId not in (Select h.clientid from tblnondepositprobono h)
			--avoid duplicates
			and a.AdHocACHID not in (Select pd.AdHocAchId from tblPlannedDeposit pd where adhocachid is not null)
		--(2) SKIP Step 2	
		
		/*	Scheduled ACH
			For multi-deposit clients
			3 - Get all planned ACH with no rules for the date 
			4 - Get all planned ACH with rules for the date. Include zero dollar rule
			For single deposit clients
			5 - Get all planned ACH with no rules for the date 
			6 - Get all planned ACH with rules for the date. Include zero dollar rule
		*/
		--(3)
		Insert into tblPlannedDeposit(ClientId, ScheduledDate, DepositType, MonthlyDepositAmount, PartialDepositAmount, ExpectedDepositAmount, MultiDepositClient, RuleACHId, AdHocAchId, ClientDepositId, FirstDeposit, ZeroAmountRule, CreatedDate, CreatedBy, ProcessedDate, ProcessedBy)
		SELECT
			c.ClientID, @date, 'ACH', 
			MonthlyDep = (Select Sum(d1.depositamount) from tblClientDepositDay d1 where d1.deletedDate is null and d1.clientid = c.clientid),
			d.DepositAmount, d.DepositAmount, c.Multideposit, null, null, d.ClientDepositID, 0, 0, getdate(), @userid, null, null
		FROM
			tblClient as c
			inner join tblClientDepositDay d on d.ClientID = c.ClientID
		WHERE
			d.ClientDepositID not in (SELECT ClientDepositID FROM tblDepositRuleACH	WHERE StartDate <= cast(convert(varchar(10), @date, 101) as datetime) and (EndDate is null or EndDate >= cast(convert(varchar(10), @date, 101) as datetime))) 
			and	(d.DepositDay = day(@date) or (@lastdayofmonth = 1 and d.DepositDay >= day(@date)))
			and c.DepositStartDate <= cast(convert(varchar(10), @date, 101) as datetime)
			and c.DepositStartDate is not null
			and c.CurrentClientStatusID in (14, 16) -- Active, Non-responsive
			and c.MultiDeposit = 1
			and lower(d.Frequency) = 'month'
			and d.DeletedDate is null
			and lower(d.DepositMethod) = 'ach'
			and c.ClientId not in (Select v.clientid from vw_ExcludeAchNo3PV v)
			and c.ClientId not in (Select h.clientid from tblnondepositprobono h)
			--ignore if register for the month exists
			--and d.clientdepositid not in (Select rg.clientdepositid from tblregister rg where rg.clientid = c.clientid and rg.achmonth=month(@date) and rg.achyear = year(@date))
			--avoid duplicates
			and d.clientdepositid not in (select pd.clientdepositid from tblPlannedDeposit pd where month(pd.ScheduledDate) = month(@date) and year(pd.ScheduledDate) = year(@date) and pd.clientdepositid is not null)
			and c.ClientId not in (select cmp.clientid from vw_NonDeposit_ActiveCompletedClients cmp)

		--(4)
		Insert into tblPlannedDeposit(ClientId, ScheduledDate, DepositType, MonthlyDepositAmount, PartialDepositAmount, ExpectedDepositAmount, MultiDepositClient, RuleACHId, AdHocAchId, ClientDepositId, FirstDeposit, ZeroAmountRule, CreatedDate, CreatedBy, ProcessedDate, ProcessedBy)
		SELECT
			c.ClientID, @date, 'ACH',
			MonthlyDep = (Select Sum(d1.depositamount) from tblClientDepositDay d1 where d1.deletedDate is null and d1.clientid = c.clientid),
			d.DepositAmount, r.DepositAmount, c.Multideposit, r.ruleachid, null, d.ClientDepositId, 0, ZeroAmountRule = case when r.DepositAmount = 0 then 1 else 0 end, getdate(), @userid, null,  null
		FROM
			tblDepositRuleACH as r
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
			and lower(d.DepositMethod) = 'ach'
			and c.ClientId not in (Select v.clientid from vw_ExcludeAchNo3PV v)
			and c.ClientId not in (Select h.clientid from tblnondepositprobono h)
			--ignore if register for the month exists
			--and d.clientdepositid not in (Select rg.clientdepositid from tblregister rg where rg.clientid = c.clientid and rg.achmonth=month(@date) and rg.achyear = year(@date))
			--avoid duplicates
			and d.clientdepositid not in (select pd.clientdepositid from tblPlannedDeposit pd where month(pd.ScheduledDate) = month(@date) and year(pd.ScheduledDate) = year(@date) and pd.clientdepositid is not null)
			--and r.ruleachid not in (select pd.ruleachid from tblPlannedDeposit pd where month(pd.ScheduledDate) = month(@date) and year(pd.ScheduledDate) = year(@date) and  pd.ruleachid is not null and pd.MultiDepositClient=1)
			and c.ClientId not in (select cmp.clientid from vw_NonDeposit_ActiveCompletedClients cmp)

		--(5)
		Insert into tblPlannedDeposit(ClientId, ScheduledDate, DepositType, MonthlyDepositAmount, PartialDepositAmount, ExpectedDepositAmount, MultiDepositClient, RuleACHId, AdHocAchId, ClientDepositId, FirstDeposit, ZeroAmountRule, CreatedDate, CreatedBy, ProcessedDate, ProcessedBy)
		SELECT
			c.ClientID, @date, 'ACH', c.DepositAmount, c.DepositAmount, c.DepositAmount, c.Multideposit, null, null, null, 0, 0, getdate(), @userid, null, null
		FROM
			tblClient as c
		WHERE
			c.ClientID not in (SELECT ClientID FROM tblRuleACH	WHERE StartDate <= cast(convert(varchar(10), @date, 101) as datetime) and (EndDate is null or EndDate >= cast(convert(varchar(10), @date, 101) as datetime))) 
			and	(c.DepositDay = day(@date) or (@lastdayofmonth = 1 and c.DepositDay >= day(@date)))
			and c.DepositStartDate <= cast(convert(varchar(10), @date, 101) as datetime)
			and c.DepositStartDate is not null
			and c.CurrentClientStatusID in (14, 16) -- Active, Non-responsive
			and c.MultiDeposit = 0
			and lower(c.DepositMethod) = 'ach'
			and c.ClientId not in (Select v.clientid from vw_ExcludeAchNo3PV v)
			and c.ClientId not in (Select h.clientid from tblnondepositprobono h)
			--ignore if register for the month exists
			--and c.clientid not in (Select rg.clientid from tblregister rg where rg.clientid = c.clientid and rg.achmonth=month(@date) and rg.achyear = year(@date))
			--avoid duplicates
			and c.clientid not in (select pd.clientid from tblPlannedDeposit pd where month(pd.ScheduledDate) = month(@date) and year(pd.ScheduledDate) = year(@date))
			and c.ClientId not in (select cmp.clientid from vw_NonDeposit_ActiveCompletedClients cmp)

		
		--(6)
		Insert into tblPlannedDeposit(ClientId, ScheduledDate, DepositType, MonthlyDepositAmount, PartialDepositAmount, ExpectedDepositAmount, MultiDepositClient, RuleACHId, AdHocAchId, ClientDepositId, FirstDeposit, ZeroAmountRule, CreatedDate, CreatedBy, ProcessedDate, ProcessedBy)
		SELECT
			c.ClientID, @date, 'ACH', c.DepositAmount, c.DepositAmount, r.DepositAmount, c.Multideposit, r.ruleachid, null, null, 0, ZeroAmountRule = Case When r.DepositAmount = 0 then 1 else 0 end , getdate(), @userid, null, null
		FROM
			tblRuleACH as r
			inner join tblClient as c on c.ClientID = r.ClientID
		WHERE
			c.ClientID  in 
			(SELECT Min(RuleACHId) FROM tblRuleACH 
			 WHERE StartDate <= cast(convert(varchar(10), @date, 101) as datetime) and 
			 (EndDate is null or EndDate >= cast(convert(varchar(10), @date, 101) as datetime))
			 and (r.DepositDay = day(@date) or (@lastdayofmonth = 1 and r.DepositDay >= day(@date)))
			 Group By ClientId) 
			and c.DepositStartDate <= cast(convert(varchar(10), @date, 101) as datetime)
			and c.DepositStartDate is not null
			and c.CurrentClientStatusID in (14, 16) -- Active, Non-responsive
			and c.MultiDeposit = 0
			and lower(c.DepositMethod) = 'ach'
			and c.ClientId not in (Select v.clientid from vw_ExcludeAchNo3PV v)
			and c.ClientId not in (Select h.clientid from tblnondepositprobono h)
			--ignore if register for the month exists
			--and c.clientid not in (Select rg.clientid from tblregister rg where rg.clientid = c.clientid and rg.achmonth=month(@date) and rg.achyear = year(@date))
			--avoid duplicates
			and c.clientid not in (select pd.clientid from tblPlannedDeposit pd where month(pd.ScheduledDate) = month(@date) and year(pd.ScheduledDate) = year(@date))
			--and r.ruleachid not in (select pd.ruleachid from tblPlannedDeposit pd where month(pd.ScheduledDate) = month(@date) and year(pd.ScheduledDate) = year(@date) and pd.deposittype= 'ACH' and pd.MultiDepositClient=0)
			and c.ClientId not in (select cmp.clientid from vw_NonDeposit_ActiveCompletedClients cmp)

		
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();
	END CATCH
End

GO

