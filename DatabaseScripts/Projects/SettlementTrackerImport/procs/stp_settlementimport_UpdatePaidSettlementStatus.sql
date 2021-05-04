IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_UpdatePaidSettlementStatus')
	BEGIN
		DROP  Procedure  stp_settlementimport_UpdatePaidSettlementStatus
	END

GO

CREATE Procedure stp_settlementimport_UpdatePaidSettlementStatus
AS
BEGIN
	declare @tblsett table(settlementid numeric,accountstatusid int,settled datetime)

	insert into @tblsett
	select s.settlementid,a.accountstatusid, isnull(a.settled,a.lastmodified)
	from tblsettlements s
	inner join tblaccount a on s.creditoraccountid = a.accountid
	where settlementid in (
	select settlementid from tblsettlementtrackerimports where paid is null or year(paid) = 1900 ) and accountstatusid = 54
	option (fast 100)
	--select * from @tblsett 

	update tblsettlementtrackerimports
	set [status] = acct.code, paid = s.settled
	from @tblsett s
	inner join tblsettlementtrackerimports sti on sti.settlementid = s.settlementid
	inner join tblaccountstatus acct on acct.accountstatusid = s.accountstatusid
	where expired is null
END

GO


GRANT EXEC ON stp_settlementimport_UpdatePaidSettlementStatus TO PUBLIC

GO


