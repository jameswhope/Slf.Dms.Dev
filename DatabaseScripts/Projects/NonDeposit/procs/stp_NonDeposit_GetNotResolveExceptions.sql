IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_GetNotResolvedExceptions')
	BEGIN
		DROP  Procedure  stp_NonDeposit_GetNotResolvedExceptions
	END

GO

CREATE Procedure stp_NonDeposit_GetNotResolvedExceptions
@date datetime
AS
select c.accountnumber, p.* from tblplanneddeposit p
inner join tblnondepositexception e on. e.planid = p.planid
inner join tblclient c on c.clientid = p.clientid
where e.fixed = 0 
and scheduleddate <= @Date
order by scheduleddate

GO


