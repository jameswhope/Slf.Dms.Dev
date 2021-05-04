IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetNegotiationTeams')
	BEGIN
		DROP  Procedure  stp_GetNegotiationTeams
	END

GO

CREATE Procedure stp_GetNegotiationTeams
AS
declare @vPersons table
(
UserName nvarchar(150),
UserID int,
ParentNegotiationEntityID int,
IsSupervisor bit
)

declare @vGroups table
(
GroupName nvarchar(150),
UserID int,
NegotiationEntityID int
)

insert into @vPersons
select  
n1.[Name], 
n1.UserID, 
n1.parentnegotiationentityid,
isnull(n1.IsSupervisor, 0) 
from tblNegotiationEntity n1
where n1.type = 'Person'
insert into @vGroups
select
n2.[Name],
n2.userid,
n2.negotiationentityid
from tblNegotiationEntity n2
where n2.type = 'Group'

select * from @vPersons p
join @vGroups g on g.negotiationentityid = p.parentnegotiationentityid
order by g.negotiationentityid

