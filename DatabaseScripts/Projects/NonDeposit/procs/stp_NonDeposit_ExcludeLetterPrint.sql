IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_ExcludeLetterPrint')
	BEGIN
		DROP  Procedure  stp_NonDeposit_ExcludeLetterPrint
	END

GO

CREATE Procedure stp_NonDeposit_ExcludeLetterPrint
AS
update tblnondepositletter set
Donotprint = 1
where nondepositid in (
select n.nondepositid from tblnondeposit n
inner join tblclient c on c.clientid = n.clientid
where ((c.companyid = 1 
and (select count(r.registerid) from tblregister r where r.clientid = c.clientid and r.entrytypeid=3 and bounce is null and void is null and r.created between dateadd(d, -90, getdate()) and getdate()) = 0 and datediff(d,c.depositstartdate,getdate()) > 90  
))--exclude seideman clients with no deposits in more tan 90 days 
or c.clientid in (select clientid from tblnondepositprobono)
) and Donotprint = 0



GO


