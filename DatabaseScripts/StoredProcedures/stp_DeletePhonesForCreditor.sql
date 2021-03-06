/****** Object:  StoredProcedure [dbo].[stp_DeletePhonesForCreditor]    Script Date: 11/19/2007 15:26:59 ******/
DROP PROCEDURE [dbo].[stp_DeletePhonesForCreditor]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stp_DeletePhonesForCreditor]
	(
		@creditorid int,
		@criteria varchar (8000) = ''
	)

as


-- discretionary variables
declare @creditorphoneid int
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
		creditorphoneid int,
		phoneid int
	)


-- fill temp table with results
exec
(
	'insert into
		#tblphone
	select
		tblcreditorphone.creditorphoneid,
		tblphone.phoneid
	from
		tblcreditorphone inner join
		tblphone on tblcreditorphone.phoneid = tblphone.phoneid
	where
		tblcreditorphone.creditorid = ' + @creditorid + @criteria
)


-- drop all creditorphone records that were returned in temp table
delete from
	tblcreditorphone
where
	creditorphoneid in
	(
		select
			creditorphoneid
		from
			#tblphone
	)


-- TODO: drop all phone records if there are no other table entities using them


-- clean up temp table
select * from #tblphone
drop table #tblphone
GO
