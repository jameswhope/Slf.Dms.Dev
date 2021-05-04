IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ClientFile_getCreditorSettlementCommunications')
	BEGIN
		DROP  Procedure  stp_ClientFile_getCreditorSettlementCommunications
	END

GO

CREATE Procedure stp_ClientFile_getCreditorSettlementCommunications
	(
		@clientid int,
		@acctID int
	)

AS
BEGIN

/* dev
	declare @acctID int
	declare @clientid int
	set @clientid = 1658
	set @acctID = 34865
*/
	--create our results table
	declare @tblComms table (relID int,CommType varchar(20),[Date] datetime,[By] varchar(255),[Message] varchar(max),direction bit,userid int)
	declare @accountnumber int

	select @accountnumber=accountnumber from tblclient where clientid = @clientid

	insert into @tblComms 
	select 
		nr.RelationID,
		'note' as CommType,
		n.lastmodified as [Date],
		tbllastmodifiedby.firstname + ' ' + tbllastmodifiedby.lastname + ' ' + ug.name as [by],
		n.[value] as [message],
		null as direction,
		n.createdby
	from
		tblnote n with(NOLOCK) left outer join
		tbluser as tbllastmodifiedby with(NOLOCK) on n.lastmodifiedby = tbllastmodifiedby.userid
		inner join tblusergroup as ug with(NOLOCK) on ug.usergroupid = n.usergroupid
		inner join tblNoteRelation nr WITH(nolock) on n.noteid=nr.noteid
	where
		(n.clientid = @clientid )
		and nr.RelationTypeID in (2,20)
		and nr.RelationID=@acctID
		
	insert into @tblComms 
	select 
		pcr.RelationID,
		'phonecall' as CommType,
		tblphonecall.lastmodified as [date],
		tbllastmodifiedby.firstname + ' ' + tbllastmodifiedby.lastname + ' ' + ug.name as [by],
		tblphonecall.[subject] + '.' + tblphonecall.[body] as message,
		tblphonecall.direction,
		tblphonecall.createdby
	from
		tblphonecall with(NOLOCK) left outer join
		tbluser as tbllastmodifiedby with(NOLOCK) on tblphonecall.lastmodifiedby = tbllastmodifiedby.userid
		inner join tblusergroup as ug with(NOLOCK) on ug.usergroupid = tblphonecall.usergroupid
		inner JOIN tblPhoneCallRelation pcr WITH(nolock) ON tblPhoneCall.PhoneCallID=pcr.PhoneCallID
	where
		tblphonecall.clientid=@clientid
		and pcr.RelationTypeID in (2,20)
		and pcr.RelationID=@acctID


	select CommType[Type],[Date],[By],[Message]  from @tblComms 
	order by date desc

END

GO


GRANT EXEC ON stp_ClientFile_getCreditorSettlementCommunications TO PUBLIC

GO


