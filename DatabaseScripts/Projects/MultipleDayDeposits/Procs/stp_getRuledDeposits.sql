IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_getRuledDeposits')
	BEGIN
		DROP  Procedure  stp_getRuledDeposits
	END

GO

CREATE Procedure stp_getRuledDeposits
@RuleAchId int
AS
select u.ruleachid, r.ACHMonth, r.ACHYear, r.transactiondate as LastDateUsed from tblruleach u
inner join tblregister r on r.clientid = u.clientid
where  cast(convert(varchar,r.transactiondate,111) as datetime) between u.startdate and isnull(u.enddate,getdate())
and r.entrytypeid = 3
--and r.amount = u.depositamount
and r.ACHMonth is not null
and r.ACHYear is not null  
and u.ruleachid = @RuleAchId
order by  r.ACHYear desc, r.ACHMonth desc 

GO


