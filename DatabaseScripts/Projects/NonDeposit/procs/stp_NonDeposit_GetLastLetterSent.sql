IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_GetLastLetterSent')
	BEGIN
		DROP  Procedure  stp_NonDeposit_GetLastLetterSent
	END

GO

CREATE Procedure stp_NonDeposit_GetLastLetterSent
@ClientId int
AS
Begin
/*select top 1  relateddate, 
[month]=month(relateddate),
[year]=year(relateddate),
days=datediff(d,relateddate, getdate()), 
lastletter = 
case  doctypeid 
when 'd5030' then 1
when 'd5031' then 2
when 'd5013' then 3
when 'd8022' then 4
else null	 
end,
doctypeid
from tblDocRelation
where clientid = @ClientId
and doctypeid  in ('d5030', 'd5031', 'd5013', 'd8022')
order by relateddate desc*/

select top 1 DateCreated = l.Created, l.lettertype, m.mattersubstatusid 
from tblnondepositletter l
inner join tblnondeposit n on n.nondepositid = l.nondepositid
inner join tblmatter m on n.matterid = m.matterid
where n.clientid = @clientid
and l.lettertype in ('d5030', 'd5031', 'd5013', 'd8022', '4letter')
and n.deleted is null
and m.mattersubstatusid not in (90)
order by l.created desc

End

GO

 

