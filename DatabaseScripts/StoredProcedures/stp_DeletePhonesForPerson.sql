/****** Object:  StoredProcedure [dbo].[stp_DeletePhonesForPerson]    Script Date: 11/19/2007 15:26:59 ******/
DROP PROCEDURE [dbo].[stp_DeletePhonesForPerson]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_DeletePhonesForPerson]
	(
		@personid int,
		@criteria varchar (8000) = ''
	)

as


-- discretionary variables
declare @personphoneid int
declare @phoneid int


-- setup criteria if anything was passed in
if not @criteria is null and len(@criteria) > 0
	begin
		set @criteria = ' AND ' + @criteria
	end


-- create a temp table for results
create table
	#tblphone
	(
		personphoneid int,
		phoneid int
	)


-- fill temp table with results
exec
(
	'insert into
		#tblphone
	select
		tblpersonphone.personphoneid,
		tblphone.phoneid
	from
		tblpersonphone inner join
		tblphone on tblpersonphone.phoneid = tblphone.phoneid
	where
		tblpersonphone.personid = ' + @personid + @criteria
)


-- drop all personphone records that were returned in temp table
delete from
	tblpersonphone
where
	personphoneid in
	(
		select
			personphoneid
		from
			#tblphone
	)


-- TODO: drop all phone records if there are no other table entities using them


-- clean up temp table
select * from #tblphone
drop table #tblphone
GO
