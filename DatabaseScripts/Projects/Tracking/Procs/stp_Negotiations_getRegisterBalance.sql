IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Negotiations_getRegisterBalance')
	BEGIN
		DROP  Procedure  stp_Negotiations_getRegisterBalance
	END

GO
create procedure stp_negotiations_getRegisterBalance
(
@clientid int
)
as
BEGIN

	--declare @clientid int
	--set @clientid = 1671

	declare @tblreg table(amount money, eid int,bounce datetime,void datetime,hold datetime,[clear] datetime)

	insert into @tblreg 
	select amount,entrytypeid,bounce,void,hold,[clear]
	from tblregister with(nolock)
	where clientid = @clientid order by transactiondate desc

	delete from @tblreg where eid = 3 and hold > getdate() and [clear] is null
	delete from @tblreg where bounce is not null
	delete from @tblreg where void is not null
	delete from @tblreg where eid = -2


	select 
	isnull(sum(case when eid IN(3,-2) then amount else 0 end),0)[TotDeps] 
	,isnull(sum(case when not eid IN(3,-2) then amount else 0 end),0)[TotWith] 
	,isnull(case when sum(case when eid IN(3,-2) then amount else 0 end)+sum(case when not eid IN(3,-2) then amount else 0 end) < 0 then 0 else sum(case when eid IN(3,-2) then amount else 0 end)+sum(case when not eid IN(3,-2) then amount else 0 end)end,0)[SDABal] 
	,isnull(case when sum(case when eid IN(3,-2) then amount else 0 end)+sum(case when not eid IN(3,-2) then amount else 0 end) > 0 then 0 else sum(case when eid IN(3,-2) then amount else 0 end)+sum(case when not eid IN(3,-2) then amount else 0 end)end,0)[PFOBal] 
	from @tblreg
END