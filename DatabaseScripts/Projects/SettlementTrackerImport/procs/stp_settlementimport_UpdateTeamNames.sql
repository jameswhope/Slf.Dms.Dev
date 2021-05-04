 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_UpdateTeamNames')
	BEGIN
		DROP  Procedure  stp_settlementimport_UpdateTeamNames
	END

GO

create procedure stp_settlementimport_UpdateTeamNames
as
BEGIN
	declare @tblGroups table(NegotiationEntityID int,Name varchar(100))
	declare @tblTeams table(tid int,Name varchar(100))

	insert into @tblGroups 
	select NegotiationEntityID, name from tblnegotiationentity with(nolock) where type = 'group'

	--select * from @tblGroups 
	insert into @tblTeams
	select sti.trackerimportid, tg.name
	from tblsettlementtrackerimports sti with(nolock)
	inner join tblnegotiationentity  ne with(nolock) on ne.negotiationentityid = sti.team
	inner join @tblGroups tg on tg.NegotiationEntityID = ne.parentNegotiationEntityID
	where isnumeric(sti.team) = 1 and ne.parentnegotiationentityid is not null

	update tblsettlementtrackerimports 
	set team = tm.name
	from @tblTeams tm
	inner join tblsettlementtrackerimports sti with(nolock) on sti.trackerimportid = tm.tid

END


GRANT EXEC ON stp_settlementimport_UpdateTeamNames TO PUBLIC

GO


