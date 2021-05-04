IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_MatchPlanACH')
	BEGIN
		DROP  Procedure  stp_NonDeposit_MatchPlanACH
	END

GO

Create PROCEDURE [dbo].[stp_NonDeposit_MatchPlanACH]
@userId int
AS
Begin
	--Get All Planned ACH that dont have a mapped register
	--Rule ACH - Multideposit
	insert into tblPlannedDepositRegisterXref(PlanId, RegisterId, Amount, Created, CreatedBy)
	Select d.planid, r.registerid, r.amount, GetDate(), @userId 
	from tblPlannedDeposit d 
	inner join tblregister r on r.ClientDepositId = d.ClientDepositId
	left join tblPlannedDepositRegisterXref r1 on r.registerid = r1.registerid
	Where d.DepositType = 'ACH' 
	and d.MultiDepositClient = 1 
	and d.RuleACHId is not null
	and d.ClientDepositId is not null
	and d.ZeroAmountRule = 0
	and r.achmonth = month(scheduleddate) and r.achyear = year(scheduleddate)
	--avoid duplicates
	and r1.registerid is null
	
	--No Rule ACH - Multideposit
	insert into tblPlannedDepositRegisterXref(PlanId, RegisterId, Amount, Created, CreatedBy)
	Select d.planid, r.registerid, r.amount, GetDate(), @userid
	from tblPlannedDeposit d 
	inner join tblregister r on r.ClientDepositId = d.ClientDepositId
	left join tblPlannedDepositRegisterXref r1 on r.registerid = r1.registerid
	Where d.DepositType = 'ACH' 
	and d.MultiDepositClient = 1 
	and d.ClientDepositId is not null
	and d.RuleACHId is null
	and r.achmonth = month(scheduleddate) and r.achyear = year(scheduleddate)
	--avoid duplicates
	and r1.registerid is null

	--Rule ACH - Single Deposit
	insert into tblPlannedDepositRegisterXref(PlanId, RegisterId, Amount, Created, CreatedBy)
	Select d.planid, r.registerid, r.amount,  GetDate(), @userid
	from tblPlannedDeposit d 
	inner join tblregister r on r.ClientId = d.ClientId
	left join tblPlannedDepositRegisterXref r1 on r.registerid = r1.registerid
	Where d.DepositType = 'ACH' 
	and d.MultiDepositClient = 0 
	and d.RuleACHId is not null
	and r.ClientDepositId is null
	and r.achmonth = month(scheduleddate) and r.achyear = year(scheduleddate)
	--avoid duplicates
	and r1.registerid is null
	
	--No Rule ACH - Single Deposit
	insert into tblPlannedDepositRegisterXref(PlanId, RegisterId, Amount, Created, CreatedBy)
	Select d.planid, r.registerid, r.amount,  GetDate(), @userid
	from tblPlannedDeposit d 
	inner join tblregister r on r.ClientId = d.ClientId
	left join tblPlannedDepositRegisterXref r1 on r.registerid = r1.registerid
	Where d.DepositType = 'ACH' 
	and d.MultiDepositClient = 0 
	and d.RuleACHId is null
	and r.ClientDepositId is null
	and r.achmonth = month(scheduleddate) and r.achyear = year(scheduleddate)
	--avoid duplicates
	and r1.registerid is null
	
	--Adhoc first deposit
	insert into tblPlannedDepositRegisterXref(PlanId, RegisterId, Amount, Created, CreatedBy)
	Select d.planid, r.registerid, r.amount, GetDate(), @userid
	from tblPlannedDeposit d 
	inner join tblregister r on r.ClientId = d.ClientId
	left join tblPlannedDepositRegisterXref r1 on r.registerid = r1.registerid
	Where d.DepositType = 'AdHocACH' 
	and d.FirstDeposit = 1
	and r.ClientDepositId is null
	and r.registerid in (Select a.registerId from tblAdHocAch a where a.registerId is not null)
	--avoid duplicates
	and r1.registerid is null
	
End

