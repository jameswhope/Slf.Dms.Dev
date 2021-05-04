IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ClientFile_getAllCommunications')
	BEGIN
		DROP  Procedure  stp_ClientFile_getAllCommunications
	END

GO

CREATE Procedure stp_ClientFile_getAllCommunications
(
@clientid int
)
as 
BEGIN

	/*
	declare @clientid int
	set @clientid = 1658
	*/	
	--create our results table
	declare @tblComms table (CommType varchar(20),[Date] datetime,[By] varchar(255),[Message] varchar(max),direction bit,userid int)
	declare @accountnumber int

	select @accountnumber=accountnumber from tblclient where clientid = @clientid

	insert into @tblComms 
	select 
		'note' as CommType,
		tblnote.lastmodified as [Date],
		tbllastmodifiedby.firstname + ' ' + tbllastmodifiedby.lastname + char(13) + ug.name as [by],
		tblnote.[value] as [message],
		null as direction,
		tblnote.createdby
	from
		tblnote left outer join
		tbluser as tbllastmodifiedby on tblnote.lastmodifiedby = tbllastmodifiedby.userid
		inner join tblusergroup as ug on ug.usergroupid = tblnote.usergroupid
	where
		(tblnote.clientid = @clientid )

	insert into @tblComms 
		select 
			'phonecall' as CommType,
			tblphonecall.lastmodified as [date],
			tbllastmodifiedby.firstname + ' ' + tbllastmodifiedby.lastname + char(13) + ug.name as [by],
			tblphonecall.[subject] + '.' + tblphonecall.[body] as message,
			tblphonecall.direction,
			tblphonecall.createdby
		from
			tblphonecall left outer join
			tbluser as tbllastmodifiedby on tblphonecall.lastmodifiedby = tbllastmodifiedby.userid
			inner join tblusergroup as ug on ug.usergroupid = tblphonecall.usergroupid
		where
			tblphonecall.clientid=@clientid

/*
	insert into @tblComms 
	SELECT 
		 CommType
		, [Date]
		, Staff + ' (Litigation Personnel)'[By]
		, [Message] = [Description] + '.' + convert(varchar(max),[Content])
		, Null[Direction]
		, Null[UserID]
		
	FROM 
		(
			SELECT 
				mat_no as AccountNumber
				, 'note' as CommType
				, [desc] as [Description]
				, memo as [Content]
				, staff
				, dateadd(s, (time - 1)/100, dateadd(d, [date], '12-28-1800')) as [date]
				, [date] as CommDate
				, time as CommTime
				, 'tm8user.notes' as CommTable 
			FROM 
				timematters.timematters.tm8user.notes 

			UNION ALL 

			SELECT 
				mat_no as AccountNumber
				, 'phonecall' as CommType
				, subject as [Description]
				, memo as [Content]
				, staff
				, dateadd(s, (time - 1)/100, dateadd(d, [date], '12-28-1800')) as [date]
				, [date] as CommDate, time as CommTime, 'tm8user.phone' as CommTable 
			FROM 
				timematters.timematters.tm8user.phone 

			UNION ALL 

			SELECT 
				mat_no as AccountNumber
				, 'mail' as CommType
				, [desc] as [Description]
				, memo as [Content]
				, staff
				, dateadd(s, (time - 1)/100, dateadd(d, [date], '12-28-1800')) as [date]
				, [date] as CommDate
				, time as CommTime
				, 'tm8user.mail' as CommTable 
			FROM 
				timematters.timematters.tm8user.mail
	) as LitCommunications 
	WHERE AccountNumber = cast(@accountnumber as varchar) 
*/
	select CommType[Type],[Date],[By],[Message]  from @tblComms order by date desc
END

GRANT EXEC ON stp_ClientFile_getAllCommunications TO PUBLIC



