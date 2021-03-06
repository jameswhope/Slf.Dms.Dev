/****** Object:  StoredProcedure [dbo].[stp_CollectACHCommission_S]    Script Date: 11/19/2007 15:26:57 ******/
DROP PROCEDURE [dbo].[stp_CollectACHCommission_S]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_CollectACHCommission_S]


as


---------------------------------------------------------------------------------------
-- LOGIC FOR COLLECTING COMMISSION BATCH TRANSFERS
-- (1) Get batch transfers that need to be ACH'd.  This would exclude:
--     (a) Any that had open (not declined) nacha records already
--     (b) Any that had check information on the transfer already
--     (c) Any where the associated recipient is locked
--     (d) Any where the associated recipient's delivery method is not ACH
-- (2) Loop through the open transfers to send
-- (3) On each commbatchtransfer that is sent, follow the following procedures
--     exactly and in order:
--     (a) If the parent recipient is null, use the trust recipient as the master
--     (b) Write a debit against the parent recipient for the transfer amount
--     (c) Write a credit to the recipient for the transfer amount
---------------------------------------------------------------------------------------


-- discretionary variables
declare @commbatchtransferid int
declare @transferamount money
declare @nacharegisterid int

declare @commrecid int
declare @recdisplay varchar (50)
declare @reciscommercial bit
declare @recroutingnumber varchar (50)
declare @recaccountnumber varchar (50)
declare @recaccounttype varchar (1)

declare @parentcommrecid int
declare @pardisplay varchar (50)
declare @pariscommercial bit
declare @parroutingnumber varchar (50)
declare @paraccountnumber varchar (50)
declare @paraccounttype varchar (1)

declare @trustcommrecid int
declare @trustdisplay varchar (50)
declare @trustiscommercial bit
declare @trustroutingnumber varchar (50)
declare @trustaccountnumber varchar (50)
declare @trustaccounttype varchar (1)


-- get trust account info (for step 3.a)
select
	@trustcommrecid = commrecid,
	@trustdisplay = display,
	@trustiscommercial = iscommercial,
	@trustroutingnumber = routingnumber,
	@trustaccountnumber = accountnumber,
	@trustaccounttype = [type]
from
	tblcommrec
where
	istrust = 1 and commrecid = 15


-- (1) get open batch transfers and dump into temp table
select
	c.commbatchtransferid,
	r.commrecid,
	r.display as recdisplay,
	r.iscommercial as reciscommercial,
	r.routingnumber as recroutingnumber,
	r.accountnumber as recaccountnumber,
	r.[type] as recaccounttype,
	p.commrecid as parentcommrecid,
	p.display as pardisplay,
	p.iscommercial as pariscommercial,
	p.routingnumber as parroutingnumber,
	p.accountnumber as paraccountnumber,
	p.[type] as paraccounttype,
	c.transferamount
into
	#temp
from
	tblcommbatchtransfer c inner join
	tblcommrec r on c.commrecid = r.commrecid and r.islocked = 0 and (r.method = 'ACH' or r.method = 'ach') left join
	tblcommrec p on c.parentcommrecid = p.commrecid
where
	c.checkdate is null and
	c.checknumber is null and
	c.commbatchtransferid not in
	(
		select
			nc.typeid
		from
			tblnachacabinet nc inner join
			tblnacharegister nr on nc.nacharegisterid = nr.nacharegisterid
		where
			nr.isdeclined = 0 and
			nc.type = 'commbatchtransferid'
	)
	and (c.parentcommrecid in (3, 11, 15) or (c.parentcommrecid = 4 and c.commrecid in (3, 11, 15)) or (c.parentcommrecid is null and c.commrecid in (3, 11, 15)))


-- for cursoring, use grouped amounts
declare cursor_CollectACHCommission cursor local for
	select
		commrecid,
		recdisplay,
		reciscommercial,
		recroutingnumber,
		recaccountnumber,
		recaccounttype,
		parentcommrecid,
		pardisplay,
		pariscommercial,
		parroutingnumber,
		paraccountnumber,
		paraccounttype,
		sum(transferamount)
	from
		#temp
	group by
		commrecid,
		recdisplay,
		reciscommercial,
		recroutingnumber,
		recaccountnumber,
		recaccounttype,
		parentcommrecid,
		pardisplay,
		pariscommercial,
		parroutingnumber,
		paraccountnumber,
		paraccounttype


open cursor_CollectACHCommission


-- (2) loop through
fetch next from cursor_CollectACHCommission into @commrecid, @recdisplay, @reciscommercial, 
	@recroutingnumber, @recaccountnumber, @recaccounttype, @parentcommrecid, @pardisplay, 
	@pariscommercial, @parroutingnumber, @paraccountnumber, @paraccounttype, @transferamount

while @@fetch_status = 0
	begin

		-- (3.a) if parent recipient is null, use trust recipient values
		if @parentcommrecid = 15
			begin

				set @parentcommrecid = @trustcommrecid
				set @pardisplay = @trustdisplay
				set @pariscommercial = @trustiscommercial
				set @parroutingnumber = @trustroutingnumber
				set @paraccountnumber = @trustaccountnumber
				set @paraccounttype = @trustaccounttype

			end

		if not @parentcommrecid is null
			begin

				-- (3.b) write out a debit against the parent recipient
				insert into
					tblnacharegister
					(
						[name],
						accountnumber,
						routingnumber,
						[type],
						amount,
						ispersonal,
						commrecid,
						companyid
					)
				values
					(
						@pardisplay,
						@paraccountnumber,
						@parroutingnumber,
						isnull(@paraccounttype, 'C'),
						round(-@transferamount, 2),
						~@pariscommercial,
						@parentcommrecid,
						1
					)


				-- get created nacha register id
				set @nacharegisterid = scope_identity()


				-- insert nacha cabinet records against all commbatchtransfers associated with this payment
				insert into
					tblnachacabinet
					(
						nacharegisterid,
						[type],
						typeid
					)
				select
					@nacharegisterid,
					'CommBatchTransferID',
					commbatchtransferid
				from
					#temp
				where
					(
						commrecid = @commrecid and
						parentcommrecid = @parentcommrecid
					)
					or
					(
						commrecid = @commrecid and
						parentcommrecid is null and
						@parentcommrecid = @trustcommrecid
					)


				-- (3.c) write out a credit to the recipient
				insert into
					tblnacharegister
					(
						[name],
						accountnumber,
						routingnumber,
						[type],
						amount,
						ispersonal,
						commrecid,
						companyid
					)
				values
					(
						@recdisplay,
						@recaccountnumber,
						@recroutingnumber,
						isnull(@recaccounttype, 'C'),
						round(@transferamount, 2),
						~@reciscommercial,
						@parentcommrecid,
						1
					)


				-- get created nacha register id
				set @nacharegisterid = scope_identity()


				-- insert nacha cabinet records against all commbatchtransfers associated with this payment
				insert into
					tblnachacabinet
					(
						nacharegisterid,
						[type],
						typeid
					)
				select
					@nacharegisterid,
					'CommBatchTransferID',
					commbatchtransferid
				from
					#temp
				where
					(
						commrecid = @commrecid and
						parentcommrecid = @parentcommrecid
					)
					or
					(
						commrecid = @commrecid and
						parentcommrecid is null and
						@parentcommrecid = @trustcommrecid
					)


			end

		fetch next from cursor_CollectACHCommission into @commrecid, @recdisplay, @reciscommercial, 
			@recroutingnumber, @recaccountnumber, @recaccounttype, @parentcommrecid, @pardisplay, 
			@pariscommercial, @parroutingnumber, @paraccountnumber, @paraccounttype, @transferamount

	end
close cursor_CollectACHCommission
deallocate cursor_CollectACHCommission


-- cleanup
drop table #temp
GO
