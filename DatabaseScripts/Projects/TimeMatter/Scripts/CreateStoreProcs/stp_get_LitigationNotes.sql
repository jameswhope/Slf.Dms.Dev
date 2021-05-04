IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_get_LitigationNotes')
	BEGIN
		DROP  Procedure  stp_get_LitigationNotes
	END

GO

CREATE Procedure stp_get_LitigationNotes

	(
		@clientid int
	)


AS
BEGIN
select 
	c.AccountNumber as AccountNumber
	, 'note' as CommType
	, [subject] as [Description]
	, [value] as [Content]
	, [Staff] = u.firstname + ' ' + u.lastname
	, n.created  as [date]
	, n.created as CommDate
	, CONVERT(CHAR(8),n.created,8) as CommTime
	, oldtable as CommTable 
from tblnote n inner join tblclient c on c.clientid = n.clientid inner join tbluser u on u.userid = n.createdby
where oldtable = 'tm8user.notes' and c.clientid = @clientid
order by n.created desc
END

GO


GRANT EXEC ON stp_get_LitigationNotes TO PUBLIC

GO


