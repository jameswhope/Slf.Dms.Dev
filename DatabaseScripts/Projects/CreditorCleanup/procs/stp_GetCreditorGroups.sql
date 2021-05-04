IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetCreditorGroups')
	BEGIN
		DROP  Procedure   stp_GetCreditorGroups
	END
GO

CREATE procedure [dbo].[stp_GetCreditorGroups]
(
	@creditor varchar(50),
	@street varchar(50) = null,
	@street2 varchar(50) = null,
	@city varchar(50) = null,
	@stateid int = null,
	@returnnewaddress bit = 1
)
as
begin

	declare @diff int, @count int
	set @diff = 3
	set @count = 0
	
	if @returnnewaddress = 0 begin
		set @diff = 99 -- don't return new address records
		set @count = 1 -- only return groups with matching addresses
	end
	
	select 
		g.creditorgroupid, 
		c.creditorid, 
		replace(isnull(c.street,'-'),',',' ') [street], 
		replace(isnull(c.street2,''),',',' ') [street2], 
		replace(isnull(c.city,''),',',' ') [city], 
		replace(isnull(c.zipcode,''),',',' ') [zipcode], 
		isnull(s.abbreviation,'') [state], 
		c.validated,
		1 [rating],
		replace(g.name,',',' ') [creditorgroup],
		isnull(c.stateid,-1) [stateid],
		c.created, 
		u.firstname + ' ' + u.lastname [createdby], 
		ug.name [dept]
	into #creditors
	from tblcreditorgroup g
	join tblcreditor c on c.creditorgroupid = g.creditorgroupid
	left join tblstate s on s.stateid = c.stateid 
	left join tbluser u on u.userid = c.createdby 
	left join tblusergroup ug on ug.usergroupid = u.usergroupid
	where (difference(ltrim(rtrim(g.name)), @creditor) > 3 or difference(@creditor, ltrim(rtrim(g.name))) > 3)
		and (@street is null or difference(ltrim(rtrim(c.street)), @street) > 3)
		and (@street2 is null or difference(ltrim(rtrim(c.street2)), @street2) > 3)
		and (@city is null or difference(ltrim(rtrim(c.city)), @city) > 3)
		and (@stateid is null or c.stateid = @stateid)


	insert #creditors (creditorgroupid,creditorid,street,street2,city,zipcode,[state],validated,rating,creditorgroup,stateid,created,createdby,dept)
	select creditorgroupid,creditorid,street,street2,city,zipcode,[state],validated,rating,creditorgroup,stateid,created,createdby,dept
	from (
		select 
			g.creditorgroupid, 
			c.creditorid, 
			replace(isnull(c.street,'-'),',',' ') [street], 
			replace(isnull(c.street2,''),',',' ') [street2], 
			replace(isnull(c.city,''),',',' ') [city], 
			replace(isnull(c.zipcode,''),',',' ') [zipcode], 
			isnull(s.abbreviation,'') [state], 
			c.validated,
			2 [rating],
			replace(g.name,',',' ') [creditorgroup],
			isnull(c.stateid,-1) [stateid],
			c.created, 
			u.firstname + ' ' + u.lastname [createdby], 
			ug.name [dept]
		from tblcreditorgroup g
		join tblcreditor c on c.creditorgroupid = g.creditorgroupid
		left join tblstate s on s.stateid = c.stateid 
		left join tbluser u on u.userid = c.createdby 
		left join tblusergroup ug on ug.usergroupid = u.usergroupid
		where (g.name like '%'+replace(@creditor,' ','%')+'%')
			and (@street is null or c.street like '%'+replace(@street,' ','%')+'%')
			and (@street2 is null or c.street2 like '%'+replace(@street2,' ','%')+'%')
			and (@city is null or c.city like '%'+replace(@city,' ','%')+'%')
			and (@stateid is null or c.stateid = @stateid)
	) d
	where not exists (select 1 from #creditors c where c.creditorid = d.creditorid)
		
	
	-- creditor groups
	select g.creditorgroupid, replace(g.name,',',' ') [creditorgroup], count(distinct c.creditorid) [NoCreditors],
		case when g.name = @creditor then 2 else 1 end [rating]
	into #groups
	from tblcreditorgroup g
	left join #creditors c on c.creditorgroupid = g.creditorgroupid
	where g.name like '%'+replace(@creditor,' ','%')+'%'
	group by g.creditorgroupid, g.name
	having count(distinct c.creditorid) >= @count

	insert #groups (creditorgroupid,creditorgroup,nocreditors,rating)
	select creditorgroupid,creditorgroup,nocreditors,rating
	from (
		select g.creditorgroupid, replace(g.name,',',' ') [creditorgroup], count(distinct c.creditorid) [NoCreditors],
		case when g.name = @creditor then 2 else 0 end [rating]
		from tblcreditorgroup g
		left join #creditors c on c.creditorgroupid = g.creditorgroupid
		where (difference(ltrim(rtrim(g.name)), @creditor) > 3 or difference(@creditor, ltrim(rtrim(g.name))) > 3)
		group by g.creditorgroupid, g.name
		having count(distinct c.creditorid) >= @count
	) d
	where not exists (select 1 from #groups g where g.creditorgroupid = d.creditorgroupid)

	select * from #groups
	order by [rating] desc, [NoCreditors] desc, [creditorgroup]		
	
	
	-- creditors
	select * from #creditors
		
	union all
	
	select distinct
		g.creditorgroupid, 
		-1 [creditorid], 
		'+ New Addess' [street], 
		'' [street2], 
		'' [city], 
		'' [zipcode], 
		'' [state], 
		null [validated],
		0 [rating],
		g.name [creditorgroup],
		-1 [stateid],
		'1/1/1900' [created],
		'' [createdby],
		'' [dept]
	from tblcreditorgroup g
	where (difference(ltrim(rtrim(g.name)), @creditor) > @diff or difference(@creditor, ltrim(rtrim(g.name))) > @diff
		or g.name like '%'+replace(@creditor,' ','%')+'%')
		and @diff <> 99
		
	order by creditorgroupid, validated desc, rating desc, city, street


	drop table #creditors
	drop table #groups
	
end
GO