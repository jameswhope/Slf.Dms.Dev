IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_UpdateNegotiatorNames')
	BEGIN
		DROP  Procedure  stp_settlementimport_UpdateNegotiatorNames
	END

GO

CREATE Procedure stp_settlementimport_UpdateNegotiatorNames
/*
	(
		@parameter1 int = 5,
		@parameter2 datatype OUTPUT
	)

*/
AS
BEGIN
/*
	update tblSettlementTrackerImports 
	set negotiator = u.firstname + ' ' + u.lastname
	from tblSettlementTrackerImports sti
	inner join tblsettlements s with(nolock) on s.settlementid = sti.settlementid
	inner join tbluser u with(nolock) on u.userid = s.createdby
	where  year(sti.importdate) = year(getdate())
	and month(sti.importdate) = month(getdate())
*/	
	update tblsettlementtrackerimports 
set negotiator = u.firstname + ' ' + u.lastname
from tblsettlementtrackerimports sti
inner join tbluser u on u.username = sti.negotiator
	
END

GO


GRANT EXEC ON stp_settlementimport_UpdateNegotiatorNames TO PUBLIC

GO


