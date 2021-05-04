IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_UpdateExpiredSettlements')
	BEGIN
		DROP  Procedure  stp_settlementimport_UpdateExpiredSettlements
	END

GO

CREATE Procedure stp_settlementimport_UpdateExpiredSettlements
/*
	(
		@parameter1 int = 5,
		@parameter2 datatype OUTPUT
	)

*/
AS
BEGIN
	declare @tblsett table(settlementid numeric)

	insert into @tblsett
	select s.settlementid
	from tblsettlements s
	inner join tblaccount a on s.creditoraccountid = a.accountid
	where datediff(d,settlementduedate,getdate()) > 1 and active = 1 and status = 'a' and accountstatusid <> 54
	and year(settlementduedate) = year(getdate()) 
	and month(settlementduedate) = month(getdate())
	and day(settlementduedate) = day(getdate())
	order by settlementduedate desc
	option (fast 10)

	update tblsettlementtrackerimports set expired = getdate()
	where settlementid in (select settlementid from @tblsett) and paid is null and canceldate is null
END

GO


GRANT EXEC ON stp_settlementimport_UpdateExpiredSettlements TO PUBLIC

GO


