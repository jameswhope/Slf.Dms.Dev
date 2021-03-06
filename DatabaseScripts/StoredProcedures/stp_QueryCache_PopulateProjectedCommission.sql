/****** Object:  StoredProcedure [dbo].[stp_QueryCache_PopulateProjectedCommission]    Script Date: 11/19/2007 15:27:33 ******/
DROP PROCEDURE [dbo].[stp_QueryCache_PopulateProjectedCommission]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_QueryCache_PopulateProjectedCommission]
as

set nocount on

declare @verbose bit
set @verbose = 0;

declare @classname varchar(100)
set @classname='default_aspx' 
declare @queryname varchar(100)
set @queryname='Projected Commissions'

declare @monthdatenow datetime  --first of this month
declare @monthdate datetime --Current month to be calculated against.  Day is always the first.
declare @monthstart datetime --Beginning point of @monthdate (first second of month)
declare @monthend datetime  --End point of @monthdate (second before the next month)

set @monthdatenow=
	convert(datetime, 
		convert(varchar, datepart(year,getdate())) + '.' 
		+ convert(varchar, datepart(month,getdate())) + '.01'
	)

set @monthdate=dateadd(month,-6,getdate())
set @monthdate=
	convert(datetime, 
		convert(varchar, datepart(year,@monthdate)) + '.' 
		+ convert(varchar, datepart(month,@monthdate)) + '.01'
	)

declare @i int
set @i = 1
while @i <= 13 begin

	set @monthstart=
		convert(datetime, 
			convert(varchar, datepart(year,@monthdate)) + '.' 
			+ convert(varchar, datepart(month,@monthdate)) + '.01'
		)
	set @monthend=dateadd(ss, -1, dateadd(month,1,@monthstart))

	create table #tmpRules
	(
		ClientID int,
		DepositDay int,
		DepositAmount money
	)

	insert into #tmpRules
	(
		clientid,
		depositday,
		depositamount
	)	
	select 
		r.clientid,
		r.depositday,
		r.depositamount
	from 
		tblruleach r
	where 
		r.ruleachid in
		(
			select 
				max(nr.ruleachid) as ruleachid
			from
				tblruleach nr 
				inner join tblclient nc on nr.clientid=nc.clientid
			where
				dbo.fitdate(
					datepart(year,@monthdate),
					datepart(month,@monthdate),
					nc.depositday
				) >= nr.startdate
				and dbo.fitdate(
					datepart(year,@monthdate),
					datepart(month,@monthdate),
					nc.depositday
				) < isnull(dateadd(day,1,nr.enddate), @monthend)
			group by
				nc.clientid
		)

	--Create Potentials table
	create table #tmpPotential
	(
		clientid int primary key,
		firstname varchar(50),
		lastname varchar(50),
		mca money,
		da money,
		ea money,
		depositmethod varchar(50),
		ach bit,
		exceptionreason varchar(1000)
	) 

	create index idx_tmppotential_mca on #tmppotential(mca)
	create index idx_tmppotential_da on #tmppotential(da)
	create index idx_tmppotential_ea on #tmppotential(ea)
	create index idx_tmppotential_ach on #tmppotential(ach)

	--Create predicted commission table
	create table #tmpPDC
	(
		clientid int,
		commrecid int,
		feepaymentamount money,
		[percent] float,
		commissionearned money,
		entrytypeid int,
		ismca bit
	)

	create index idx_tmppdc_clientid on #tmppdc(clientid)
	create index idx_tmppdc_commrecid on #tmppdc(commrecid)
	create index idx_tmppdc_entrytypeid on #tmppdc(entrytypeid)
	create index idx_tmppdc_ismca on #tmppdc(ismca)

	declare @clientcount float
	declare @clientcur float


	--Variables for cursor 'c'
	declare @clientid int
	declare @agencyid int
	declare @depositstartdate datetime
	declare @mca money
	declare @depositday int
	declare @depositmethod varchar(50)
	declare @created datetime
	declare @firstname varchar(50)
	declare @lastname varchar(50)
	declare @routingnumber varchar(50)
	declare @accountnumber varchar(50)

	--Variables for cursor 'c2'
	declare @feeamount money
	declare @entrytypeid int
	declare @registerid int

	--Manipulation variables
	declare @ea money
	declare @ruleamount money
	declare @ruleday int
	declare @da money
	declare @hypdepamt money --hypothetical deposit amount
	declare @continue bit
	declare @lefttopay money
	declare @paymentamount money
	declare @commscenid int
	declare @ismca bit
	declare @commrecid int
	declare @exceptionreason varchar(1000)	
	declare @customid varchar(50)
	declare @col int	

	--only run this process if the projected commission will be used for this month
	if (
		@monthdate >= @monthdatenow 
		or not exists(
			select querycacheid from tblquerycache where 
				classname=@classname 
				and queryname=@queryname
				and convert(varchar,customid) like '%' + convert(varchar,@monthdate,6)
				and row=1 and col=4
		)
		or not exists(
			select querycacheid from tblquerycache where 
				classname=@classname 
				and queryname=@queryname
				and convert(varchar,customid) like '%' + convert(varchar,@monthdate,6)
				and row=1 and col=1
		)
	) begin

		print  '(' + convert(varchar,getdate(),9) + ') ' +
			'Predicting Commission for month ' + convert(varchar,@monthdate,6) 
			

		set @clientcount=
		(
			select 
				count(clientid)
			from  
				tblclient
			where
				isnull(depositamount,0) > 0 
				and not depositstartdate is null
				and not currentclientstatusid in (15,17,18)
		)

		

		set @clientcur=0
		--Loop through all potentials
		declare c cursor for 
			select 
				c.clientid, 
				p.firstname,
				p.lastname,
				c.agencyid,
				c.depositstartdate, 
				c.depositamount,
				c.depositday,
				isnull(c.depositmethod, 'Check'),
				c.created,
				c.bankroutingnumber,
				c.bankaccountnumber
			from  
				tblclient c inner join
				tblperson p on c.primarypersonid=p.personid
			where
				isnull(c.depositamount,0) > 0 
				and not c.depositstartdate is null
				and not currentclientstatusid in (15,17,18)

		open c
		fetch next from c into @clientid,@firstname,@lastname,@agencyid,@depositstartdate,@mca,@depositday,@depositmethod,@created,@routingnumber,@accountnumber
		while @@fetch_status=0 begin
			set @exceptionreason=null

			-- 0 deposit day is equivalent to null
			if @depositday<=0 
				set @depositday=null

			--status update
			set @clientcur=@clientcur+1

			if @verbose = 1 and (convert(int,@clientcur) % convert(int,@clientcount/100)) = 0 begin
				
				print '(' + convert(varchar,getdate(),9) + ') ' + 
					convert(varchar,convert(int,@clientcur/@clientcount*100,3)) + '% of ' + convert(varchar,@clientcount) + ' Clients' 
			
			end

			--find the commscenid for this client
			set @commscenid=
				(select 
					commscenid 
				from 
					tblcommscen 
				where 
					agencyid=@agencyid 
					and @created between startdate and isnull(enddate,@created))

			if @commscenid is null begin
				set @commscenid=(select commscenid from tblcommscen where [default]=1)
			end

			
			set @ruleamount = 
			(
				select
					r.depositamount
				from
					#tmprules r
				where
					clientid=@clientid
			)
			
			if not @ruleamount is null begin 
				set @da=@ruleamount				
				set @ea=@mca-@ruleamount
				if @ruleamount > 0 begin
					set @exceptionreason = 'Client has an active positive-amount rule.'
				end else begin
					set @exceptionreason='Client has an active zero-amount rule.'
				end
			end else if @depositday is null begin
				set @da=0
				set @ea=@mca
				set @exceptionreason='Client has no deposit day.'
			end else if @depositmethod='ach' and (@routingnumber is null or @routingnumber='' or @accountnumber is null or @accountnumber='') begin
				set @da=0
				set @ea=@mca
				set @exceptionreason='Client has missing banking information.'
			--If listed DepositStartDate is on or before current month's deposit day
			--don't need to check for null day on fitdate here because we know it is not null
			end else if isnull(@depositstartdate,@monthstart) <= dbo.fitdate(datepart(year,@monthdate),datepart(month,@monthdate),@depositday) begin
				set @da=@mca
				set @ea=0
			end else begin --DepositStartDate after current month's deposit day
				set @exceptionreason='DepositStartDate is after current month''s deposit day.'
				set @da=0
				set @ea=@mca
			end
			
			--Save record in Potentials table
			insert into #tmppotential
			(
				clientid,
				firstname,
				lastname,
				mca,
				da,
				ea,
				depositmethod,
				ach,
				exceptionreason
			)
			values
			(
				@clientid,
				@firstname,
				@lastname,
				@mca,
				@da,
				@ea,
				@depositmethod,
				(case when @depositmethod='ach' then 1 else 0 end),
				@exceptionreason
			)

			--Calculate commission against MCA amount
			set @hypdepamt = @mca
			set @continue=1
			set @ismca = (case when @da=@mca then null else 1 end)
			while @continue=1 begin
				--Loop through all un-fully-paid fees for this client
				--	Order by the entrytype order
				declare c2 cursor for 
					select 
						r.registerid,
						r.amount,
						et.entrytypeid
					from 
						tblregister r inner join
						tblentrytype et on r.entrytypeid=et.entrytypeid
					where 
						et.fee=1
						and r.clientid=@clientid
						and not r.isfullypaid=1
						--and (select abs(isnull(sum(amount),0)) from tblregisterpayment where feeregisterid=@registerid and bounced=0 and voided=0)>0
					order by 
						et.[order]
				open c2
				fetch next from c2 into @registerid,@feeamount,@entrytypeid
				while @@fetch_status=0 and @hypdepamt > 0 begin
					--Find the unpaid amount of this fee
					set @lefttopay = abs(@feeamount)-
						(select abs(isnull(sum(amount),0)) from tblregisterpayment where feeregisterid=@registerid and bounced=0 and voided=0)

					/*
					Payment amount is the amount of the fee, if
					what's left of the deposit covers it.  Otherwise,
					it's what's left of the deposit.
					*/
					if @hypdepamt >= @lefttopay begin
						set @paymentamount = @lefttopay
					end else begin
						set @paymentamount = @hypdepamt
					end --if

					--Decrement the deposit amount by the payment amount
					set @hypdepamt = @hypdepamt - @paymentamount
					
					--Record commission amounts for this payment
					insert into #tmppdc
					(
						clientid,
						commrecid,
						feepaymentamount,
						[percent],
						commissionearned,
						entrytypeid,
						ismca
					)
					select
						@clientid,
						cr.commrecid,
						@paymentamount,
						cf.[percent],
						(cf.[percent]*@paymentamount),
						@entrytypeid,
						@ismca
					from
						tblcommrec cr inner join 
						tblcommstruct cs on cr.commrecid=cs.commrecid inner join
						tblcommfee cf on cs.commstructid=cf.commstructid
					where
						cf.entrytypeid=@entrytypeid
						and cs.commscenid=@commscenid

					--Loop to the next un-fully-paid fee
					fetch next from c2 into @registerid,@feeamount,@entrytypeid
				end --while
				close c2
				deallocate c2

				if isnull(@ismca, 0)=0 begin --Finished.  Either done with DA, or don't need to do DA
					set @continue=0
				end else begin --finished calculating MCA.  Need to calculate DA
					set @continue=1
					set @hypdepamt = @da
					set @ismca=0
				end --if
			end --while


			--Loop to next potential client
			fetch next from c into @clientid,@firstname,@lastname,@agencyid,@depositstartdate,@mca,@depositday,@depositmethod,@created,@routingnumber,@accountnumber
		end --while
		close c
		deallocate c
	end --if

	if (
		@monthdate > @monthdatenow 
		or not exists(
			select querycacheid from tblquerycache where 
				classname=@classname 
				and queryname=@queryname
				and convert(varchar,customid) like '%' + convert(varchar,@monthdate,6)
				and row=1 and col=1
		)
	) begin
		print  '(' + convert(varchar,getdate(),9) + ') ' + 
			'Saving Potential, Exception and Planned for month ' + convert(varchar,@monthdate,6) 

		declare c3 cursor for select commrecid from tblcommrec
		open c3
		set @commrecid = null
		while @@fetch_status=0 or @commrecid is null begin
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Potential/Planned for CommRecID ' + convert(varchar,isnull(@commrecid, ''))
			end

			set @customid=''
			if not @commrecid is null
				set @customid=convert(varchar,@commrecid) + '|'
			set @customid = @customid + convert(varchar,@monthdate,6)

			--Delete the old values from the cache table
			delete from tblquerycache where classname=@classname and queryname=@queryname and customid=@customid and col in (1,2,3)
			
			
			/*(1)  Potential*/
			--ach sum
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Potential - ACH Sum'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,1,1,@customid, isnull(sum(commissionearned),0)
				from #tmppotential p left outer join #tmppdc pdc on pdc.clientid=p.clientid 
				where (@commrecid is null or @commrecid=commrecid) and p.ach=1 and (pdc.ismca=1 or pdc.ismca is null)

			--ach count
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Potential - ACH Count'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,2,1,@customid, count(distinct p.clientid)
				from #tmppotential p left outer join #tmppdc pdc on pdc.clientid=p.clientid 
				where (@commrecid is null or @commrecid=commrecid) and p.ach=1 and (pdc.ismca=1 or pdc.ismca is null)

			--non-ach sum
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Potential - Non-ACH Sum'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,3,1,@customid,isnull(sum(commissionearned),0)
				from #tmppotential p left outer join #tmppdc pdc on pdc.clientid=p.clientid 
				where (@commrecid is null or @commrecid=commrecid) and p.ach=0 and (pdc.ismca=1 or pdc.ismca is null)

			--non-ach count
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Potential - Non-ACH Count'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,4,1,@customid, count(distinct p.clientid)
				from #tmppotential p left outer join #tmppdc pdc on pdc.clientid=p.clientid 
				where (@commrecid is null or @commrecid=commrecid) and p.ach=0 and (pdc.ismca=1 or pdc.ismca is null)


			/*(2)  Exceptions*/	
			--ach sum
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Exceptions - ACH Sum'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,1,2,@customid, isnull(sum(commissionearned),0)
				from #tmppotential p left outer join #tmppdc pdc on pdc.clientid=p.clientid 
				where (@commrecid is null or @commrecid=commrecid) and p.ach=1 and not p.exceptionreason is null

			--ach count
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Exceptions - ACH Count'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,2,2,@customid, count(distinct p.clientid)
				from #tmppotential p left outer join #tmppdc pdc on pdc.clientid=p.clientid 
				where (@commrecid is null or @commrecid=commrecid) and p.ach=1 and not p.exceptionreason is null

			--non-ach sum
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Exceptions - Non-ACH Sum'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,3,2,@customid,isnull(sum(commissionearned),0)
				from #tmppotential p left outer join #tmppdc pdc on pdc.clientid=p.clientid 
				where (@commrecid is null or @commrecid=commrecid) and p.ach=0 and not p.exceptionreason is null

			--non-ach count
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Exceptions - Non-ACH Count'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,4,2,@customid, count(distinct p.clientid)
				from #tmppotential p left outer join #tmppdc pdc on pdc.clientid=p.clientid 
				where (@commrecid is null or @commrecid=commrecid) and p.ach=0 and not p.exceptionreason is null


			/*(3)  Planned*/
			--ach sum
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Planned - ACH Sum'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,1,3,@customid, isnull(sum(commissionearned),0)
				from #tmppotential p left outer join #tmppdc pdc on pdc.clientid=p.clientid 
				where (@commrecid is null or @commrecid=commrecid) and p.ach=1 and (pdc.ismca=0 or pdc.ismca is null)

			--ach count
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Planned - ACH Count'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,2,3,@customid, count(distinct p.clientid)
				from #tmppotential p left outer join #tmppdc pdc on pdc.clientid=p.clientid 
				where (@commrecid is null or @commrecid=commrecid) and p.ach=1 and (pdc.ismca=0 or pdc.ismca is null)

			--non-ach sum
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Planned - Non-ACH Sum'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,3,3,@customid, isnull(sum(commissionearned),0)
				from #tmppotential p left outer join #tmppdc pdc on pdc.clientid=p.clientid 
				where (@commrecid is null or @commrecid=commrecid) and p.ach=0 and (pdc.ismca=0 or pdc.ismca is null)

			--non-ach count
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Planned - Non-ACH Count'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,4,3,@customid, count(distinct p.clientid)
				from #tmppotential p left outer join #tmppdc pdc on pdc.clientid=p.clientid 
				where (@commrecid is null or @commrecid=commrecid) and p.ach=0 and (pdc.ismca=0 or pdc.ismca is null)

			fetch next from c3 into @commrecid	
		end --while

		close c3
		deallocate c3


		--Save actual values for drilldown
		delete from tblprojectedclient where [month]=month(@monthdate) and [year]=year(@monthdate)
		delete from tblprojectedcommission where [month]=month(@monthdate) and [year]=year(@monthdate)

		if @verbose=1 begin
			print  '(' + convert(varchar,getdate(),9) + ') ' + 
				'Projected Client Insert'
		end
		insert into tblprojectedclient(clientid,firstname,lastname,mca,da,ea,depositmethod,ach,[month],[year],exceptionreason)
		select clientid,firstname,lastname,mca,da,ea,depositmethod,ach,month(@monthdate),year(@monthdate),exceptionreason from #tmppotential

		if @verbose=1 begin
			print  '(' + convert(varchar,getdate(),9) + ') ' + 
				'Projected Commission Insert'
		end
		insert into tblprojectedcommission(clientid,commrecid,feepaymentamount,[percent],commissionearned,entrytypeid,ismca,[month],[year])
		select clientid,commrecid,feepaymentamount,[percent],commissionearned,entrytypeid,ismca,month(@monthdate),year(@monthdate) from #tmppdc

	end --if

	--Calculate Actuals for this month
	
	if (
		--locks in on the first of the next month
		getdate() < dateadd(day,1,@monthend) 
		--@monthdate >= @monthdatenow 
		or not exists(
			select querycacheid from tblquerycache where 
				classname=@classname 
				and queryname=@queryname
				and convert(varchar,customid) like '%' + convert(varchar,@monthdate,6)
				and row=1 and col=4
		)
	) begin

		print  '(' + convert(varchar,getdate(),9) + ') ' + 
			'Saving Actual-Exceptions, Actual-Missed and Actual-Pending for month ' + convert(varchar,@monthdate,6)
		
		declare c5 cursor for select commrecid from tblcommrec
		open c5
		set @commrecid = null
		while @@fetch_status=0 or @commrecid is null begin
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Exceptions/Missed/Pending for CommRecID ' + convert(varchar,isnull(@commrecid, ''))
			end

			set @customid=''
			if not @commrecid is null
				set @customid=convert(varchar,@commrecid) + '|'
			set @customid = @customid + convert(varchar,@monthdate,6)

			--Delete the old values from the cache table
			delete from tblquerycache where classname=@classname and queryname=@queryname and customid=@customid and col in (4,5,8)

			/*(4)  Actual-Exceptions*/
			--ach sum
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Exceptions - ACH Sum'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,1,4,@customid, isnull(sum(commissionearned),0)
				from #tmppotential p left outer join #tmppdc pdc on pdc.clientid=p.clientid 
				where (@commrecid is null or @commrecid=commrecid) and p.ach=1 
				and not pdc.ismca is null and not p.exceptionreason is null

			--ach count
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Exceptions - ACH Count'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,2,4,@customid, count(distinct p.clientid)
				from #tmppotential p left outer join #tmppdc pdc on pdc.clientid=p.clientid 
				where (@commrecid is null or @commrecid=commrecid) and p.ach=1 
				and not p.exceptionreason is null
			--non-ach sum
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Exceptions - Non-ACH Sum'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,3,4,@customid, isnull(sum(commissionearned),0)
				from #tmppotential p left outer join #tmppdc pdc on pdc.clientid=p.clientid 
				where (@commrecid is null or @commrecid=commrecid) and p.ach=0 
				and not pdc.ismca is null and not p.exceptionreason is null

			--non-ach count
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Exceptions - Non-ACH Count'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,4,4,@customid, count(distinct p.clientid)
				from #tmppotential p left outer join #tmppdc pdc on pdc.clientid=p.clientid 
				where (@commrecid is null or @commrecid=commrecid) and p.ach=0 
				and not p.exceptionreason is null


			--(5)  Actual-Missed
			--ach sum
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Missed - ACH Sum'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,1,5,@customid, isnull(sum(commissionearned),0)
				from 
					#tmppotential p left outer join 
					#tmppdc pdc on pdc.clientid=p.clientid inner join
					(
						select 
							c.clientid,
							isnull(r.depositday,c.depositday) as depositday,
							isnull(r.depositamount,c.depositamount) as depositamount
						from
							tblclient c 
							left outer join #tmprules r on c.clientid=r.clientid
					) c on p.clientid=c.clientid
				where 
					(@commrecid is null or @commrecid=commrecid)
					and p.ach=1
					and p.da > 0
					and not c.depositday is null and c.depositday > 0
					and getdate() > dbo.fitdate(year(@monthstart),month(@monthstart),isnull(c.depositday,1))
					and (pdc.ismca=0 or pdc.ismca is null)
					and not exists(
						select registerid from tblregister r 
						where r.clientid=c.clientid 
						and r.entrytypeid=3 
						and transactiondate >= @monthstart 
						and transactiondate <= @monthend 
					)

			--ach count
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Missed - ACH Count'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,2,5,@customid, count(distinct p.clientid)
				from 
					#tmppotential p left outer join 
					#tmppdc pdc on pdc.clientid=p.clientid inner join
					(
						select 
							c.clientid,
							isnull(r.depositday,c.depositday) as depositday,
							isnull(r.depositamount,c.depositamount) as depositamount
						from
							tblclient c 
							left outer join #tmprules r on c.clientid=r.clientid
					) c on p.clientid=c.clientid
				where 
					(@commrecid is null or @commrecid=commrecid)
					and p.ach=1
					and p.da > 0
					and not c.depositday is null and c.depositday > 0
					and getdate() > dbo.fitdate(year(@monthstart),month(@monthstart),isnull(c.depositday,1))
					and (pdc.ismca=0 or pdc.ismca is null)
					and not exists(
						select registerid from tblregister r 
						where r.clientid=c.clientid 
						and r.entrytypeid=3 
						and transactiondate >= @monthstart 
						and transactiondate <= @monthend  
					)

			--non-ach sum
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Missed - Non-ACH Sum'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,3,5,@customid, isnull(sum(commissionearned),0)
				from 
					#tmppotential p left outer join 
					#tmppdc pdc on pdc.clientid=p.clientid inner join
					(
						select 
							c.clientid,
							isnull(r.depositday,c.depositday) as depositday,
							isnull(r.depositamount,c.depositamount) as depositamount
						from
							tblclient c 
							left outer join #tmprules r on c.clientid=r.clientid
					) c on p.clientid=c.clientid
				where 
					(@commrecid is null or @commrecid=commrecid)
					and p.ach=0
					and p.da > 0
					and not c.depositday is null and c.depositday > 0
					and getdate() > dbo.fitdate(year(@monthstart),month(@monthstart),isnull(c.depositday,1))
					and (pdc.ismca=0 or pdc.ismca is null)
					and not exists(
						select registerid from tblregister r 
						where r.clientid=c.clientid 
						and r.entrytypeid=3 
						and transactiondate >= @monthstart 
						and transactiondate <= @monthend  
					)

			--non-ach count
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Missed - Non-ACH Count'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,4,5,@customid, count(distinct p.clientid)
				from 
					#tmppotential p left outer join 
					#tmppdc pdc on pdc.clientid=p.clientid inner join
					(
						select 
							c.clientid,
							isnull(r.depositday,c.depositday) as depositday,
							isnull(r.depositamount,c.depositamount) as depositamount
						from
							tblclient c 
							left outer join #tmprules r on c.clientid=r.clientid
					) c on p.clientid=c.clientid
				where 
					(@commrecid is null or @commrecid=commrecid)
					and p.ach=0
					and p.da > 0
					and not c.depositday is null and c.depositday > 0
					and getdate() > dbo.fitdate(year(@monthstart),month(@monthstart),isnull(c.depositday,1))
					and (pdc.ismca=0 or pdc.ismca is null)
					and not exists(
						select registerid from tblregister r 
						where r.clientid=c.clientid 
						and r.entrytypeid=3 
						and transactiondate >= @monthstart 
						and transactiondate <= @monthend  
					)

			--(8)  Actual-Pending
			--ach sum
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Pending - ACH Sum'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,1,8,@customid, isnull(sum(commissionearned),0)
				from 
					#tmppotential p left outer join 
					#tmppdc pdc on pdc.clientid=p.clientid inner join
					(
						select 
							c.clientid,
							isnull(r.depositday,c.depositday) as depositday,
							isnull(r.depositamount,c.depositamount) as depositamount
						from
							tblclient c 
							left outer join #tmprules r on c.clientid=r.clientid
					) c on p.clientid=c.clientid
				where 
					(@commrecid is null or @commrecid=commrecid)
					and p.ach=1
					and p.da > 0
					and not c.depositday is null and c.depositday > 0
					and getdate() < dbo.fitdate(year(@monthstart),month(@monthstart),isnull(c.depositday,1))
					and (pdc.ismca=0 or pdc.ismca is null)
					and not exists(
						select registerid from tblregister r 
						where r.clientid=c.clientid 
						and r.entrytypeid=3 
						and transactiondate >= @monthstart 
						and transactiondate <= @monthend  
					)

			--ach count
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Pending - ACH Count'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,2,8,@customid, count(distinct p.clientid)
				from 
					#tmppotential p left outer join 
					#tmppdc pdc on pdc.clientid=p.clientid inner join
					(
						select 
							c.clientid,
							isnull(r.depositday,c.depositday) as depositday,
							isnull(r.depositamount,c.depositamount) as depositamount
						from
							tblclient c 
							left outer join #tmprules r on c.clientid=r.clientid
					) c on p.clientid=c.clientid
				where 
					(@commrecid is null or @commrecid=commrecid)
					and p.ach=1
					and p.da > 0
					and not c.depositday is null and c.depositday > 0
					and getdate() < dbo.fitdate(year(@monthstart),month(@monthstart),isnull(c.depositday,1))
					and (pdc.ismca=0 or pdc.ismca is null)
					and not exists(
						select registerid from tblregister r 
						where r.clientid=c.clientid 
						and r.entrytypeid=3 
						and transactiondate >= @monthstart 
						and transactiondate <= @monthend  
					)

			--non-ach sum
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Pending - Non-ACH Sum'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,3,8,@customid, isnull(sum(commissionearned),0)
				from 
					#tmppotential p left outer join 
					#tmppdc pdc on pdc.clientid=p.clientid inner join
					(
						select 
							c.clientid,
							isnull(r.depositday,c.depositday) as depositday,
							isnull(r.depositamount,c.depositamount) as depositamount
						from
							tblclient c 
							left outer join #tmprules r on c.clientid=r.clientid
					) c on p.clientid=c.clientid
				where 
					(@commrecid is null or @commrecid=commrecid)
					and p.ach=0
					and p.da > 0
					and not c.depositday is null and c.depositday > 0
					and getdate() < dbo.fitdate(year(@monthstart),month(@monthstart),isnull(c.depositday,1))
					and (pdc.ismca=0 or pdc.ismca is null)
					and not exists(
						select registerid from tblregister r 
						where r.clientid=c.clientid 
						and r.entrytypeid=3 
						and transactiondate >= @monthstart 
						and transactiondate <= @monthend  
					)

			--non-ach count
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Pending - Non-ACH Count'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select @classname,@queryname,4,8,@customid, count(distinct p.clientid)
				from 
					#tmppotential p left outer join 
					#tmppdc pdc on pdc.clientid=p.clientid inner join
					(
						select 
							c.clientid,
							isnull(r.depositday,c.depositday) as depositday,
							isnull(r.depositamount,c.depositamount) as depositamount
						from
							tblclient c 
							left outer join #tmprules r on c.clientid=r.clientid
					) c on p.clientid=c.clientid
				where 
					(@commrecid is null or @commrecid=commrecid)
					and p.ach=0
					and p.da > 0
					and not c.depositday is null and c.depositday > 0
					and getdate() < dbo.fitdate(year(@monthstart),month(@monthstart),isnull(c.depositday,1))
					and (pdc.ismca=0 or pdc.ismca is null)
					and not exists(
						select registerid from tblregister r 
						where r.clientid=c.clientid 
						and r.entrytypeid=3 
						and transactiondate >= @monthstart 
						and transactiondate <= @monthend  
					)

			--Delete old values from the tblHomepageClientCache table
			delete from tblhomepageclientcache 
			where [month]=month(@monthstart)
			and [year]=year(@monthstart)
			and isnull(commrecid,-1)=isnull(@commrecid,-1)
			
			--Exceptions
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Execeptions - HomepageClientCache insert'
			end
			insert into tblhomepageclientcache([month],[year],commrecid,col,ach,typeid,customvalue,customvalue2,customvalue3)
			select 
				month(@monthstart),year(@monthstart),@commrecid,4,p.ach,p.clientid,p.exceptionreason,sum(pdc.commissionearned),p.da
			from
				#tmppotential p left outer join #tmppdc pdc on pdc.clientid=p.clientid 
			where 
				(@commrecid is null or @commrecid=commrecid)
				and not p.exceptionreason is null
			group by
				p.clientid,
				p.ach,
				p.exceptionreason,
				p.da
			
			--Missed
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Missed - HomepageClientCache insert'
			end
			insert into tblhomepageclientcache([month],[year],commrecid,col,ach,typeid,customvalue,customvalue2,customvalue3)
			select 
				month(@monthstart),year(@monthstart),@commrecid,5,p.ach,p.clientid,'Deposit Missed', sum(pdc.commissionearned),p.da
			from 
				#tmppotential p left outer join 
				#tmppdc pdc on pdc.clientid=p.clientid inner join
				(
					select 
						c.clientid,
						isnull(r.depositday,c.depositday) as depositday,
						isnull(r.depositamount,c.depositamount) as depositamount
					from
						tblclient c 
						left outer join #tmprules r on c.clientid=r.clientid
				) c on p.clientid=c.clientid
			where 
				(@commrecid is null or @commrecid=commrecid)
				and p.da > 0
				and not c.depositday is null and c.depositday > 0
				and getdate() > dbo.fitdate(year(@monthstart),month(@monthstart),isnull(c.depositday,1))
				and (pdc.ismca=0 or pdc.ismca is null)
				and not exists(
					select registerid from tblregister r 
						where r.clientid=c.clientid 
						and r.entrytypeid=3 
						and transactiondate >= @monthstart 
						and transactiondate <= @monthend  
				)
			group by
				p.clientid,
				p.ach,
				p.exceptionreason,
				p.da


			--Pending
			if @verbose=1 begin
				print  '(' + convert(varchar,getdate(),9) + ') ' + 
					'Pending - HomepageClientCache insert'
			end
			insert into tblhomepageclientcache([month],[year],commrecid,col,ach,typeid,customvalue,customvalue2,customvalue3)
			select 
				month(@monthstart),year(@monthstart),@commrecid,8,p.ach,p.clientid,'Deposit Pending', sum(pdc.commissionearned),p.da
			from 
				#tmppotential p left outer join 
				#tmppdc pdc on pdc.clientid=p.clientid inner join
				(
					select 
						c.clientid,
						isnull(r.depositday,c.depositday) as depositday,
						isnull(r.depositamount,c.depositamount) as depositamount
					from
						tblclient c 
						left outer join #tmprules r on c.clientid=r.clientid
				) c on p.clientid=c.clientid
			where 
				(@commrecid is null or @commrecid=commrecid)
				and p.da > 0
				and not c.depositday is null and c.depositday > 0
				and getdate() < dbo.fitdate(year(@monthstart),month(@monthstart),isnull(c.depositday,1))
				and (pdc.ismca=0 or pdc.ismca is null)
				and not exists(
					select registerid from tblregister r 
					where r.clientid=c.clientid 
					and r.entrytypeid=3 
					and transactiondate between @monthstart and @monthend
				)
			group by
				p.clientid,
				p.ach,
				p.exceptionreason,
				p.da

			fetch next from c5 into @commrecid	
		end --while

		close c5
		deallocate c5
	end --if

	--Drop these tables - process is finished
	drop table #tmpPDC
	drop table #tmpPotential

	print '(' + convert(varchar,getdate(),9) + ') ' 
		+ 'Void/Bounce and Actual for month ' + convert(varchar,@monthdate,6)
	
	--wipe out everything for this month
	delete from tblprojectedcommissionactual where
		[month]=month(@monthstart)
		and [year]=year(@monthstart)

	if @verbose = 1 begin
		print '(' + convert(varchar,getdate(),9) + ') ' 
			+ 'Actual - ProjectedCommissionActual insert'
	end

	insert into tblprojectedcommissionactual
	(
		clientid,
		commrecid,
		feepaymentamount,
		[percent],
		commissionearned,
		entrytypeid,
		col,
		[month],
		[year]
	)
	select 
		c.clientid,
		cst.commrecid,
		rp.amount,
		cf.[percent],
		(rp.amount * cf.[percent]),
		rfee.entrytypeid,
		7,
		month(@monthstart),
		year(@monthstart)
	from
		tblregisterpayment rp inner join
		tblregisterpaymentdeposit dp on rp.registerpaymentid=dp.registerpaymentid inner join
		tblregister rdep on dp.depositregisterid=rdep.registerid inner join
		tblregister rfee on rp.feeregisterid=rfee.registerid inner join
		tblclient c on rfee.clientid=c.clientid inner join
		tblagency a on c.agencyid=a.agencyid inner join
		tblentrytype et on rfee.entrytypeid=et.entrytypeid inner join
		tblcommscen cs on 
			a.agencyid=cs.agencyid 
			and cs.startdate <= @monthstart 
			and isnull(cs.enddate,@monthend) >= @monthend inner join
		tblcommstruct cst on cst.commscenid=cs.commscenid inner join
		tblcommfee cf on 
			cst.commstructid=cf.commstructid 
			and et.entrytypeid=cf.entrytypeid inner join
		tblperson p on c.primarypersonid=p.personid
	where
		(rp.voided=0 and rp.bounced=0)
		and rdep.transactiondate between @monthstart and @monthend

	if @verbose = 1 begin
		print '(' + convert(varchar,getdate(),9) + ') ' 
			+ 'Void/Bounce - ProjectedCommissionActual insert'
	end
	insert into tblprojectedcommissionactual
	(
		clientid,
		commrecid,
		feepaymentamount,
		[percent],
		commissionearned,
		entrytypeid,
		col,
		[month],
		[year]
	)
	select 
		c.clientid,
		cst.commrecid,
		rp.amount,
		cf.[percent],
		(rp.amount * cf.[percent]),
		rfee.entrytypeid,
		6,
		month(@monthstart),
		year(@monthstart)
	from
		tblregisterpayment rp inner join
		tblregisterpaymentdeposit dp on rp.registerpaymentid=dp.registerpaymentid inner join
		tblregister rdep on dp.depositregisterid=rdep.registerid inner join
		tblregister rfee on rp.feeregisterid=rfee.registerid inner join
		tblclient c on rfee.clientid=c.clientid inner join
		tblagency a on c.agencyid=a.agencyid inner join
		tblentrytype et on rfee.entrytypeid=et.entrytypeid inner join
		tblcommscen cs on 
			a.agencyid=cs.agencyid 
			and cs.startdate <= @monthstart 
			and isnull(cs.enddate,@monthend) >= @monthend inner join
		tblcommstruct cst on cst.commscenid=cs.commscenid inner join
		tblcommfee cf on 
			cst.commstructid=cf.commstructid 
			and et.entrytypeid=cf.entrytypeid inner join
		tblperson p on c.primarypersonid=p.personid
	where	
		(rp.voided=1 or rp.bounced=1)
		and rdep.transactiondate between @monthstart and @monthend

	declare c4 cursor for select commrecid from tblcommrec
	open c4
	set @commrecid = null
	while @@fetch_status=0 or @commrecid is null begin
		if @verbose = 1 begin
			print '(' + convert(varchar,getdate(),9) + ') ' 
				+ 'QueryCache loop: V/B, Actual for CommRecID ' + convert(varchar,isnull(@commrecid, ''))
		end
		set @customid=''
		if not @commrecid is null
			set @customid=convert(varchar,@commrecid) + '|'
		set @customid = @customid + convert(varchar,@monthdate,6)

		--Delete the old values from the cache table
		delete from tblquerycache where classname=@classname and queryname=@queryname and customid=@customid and col in (6,7)

		set @col=6
		while @col<=7 begin
			if @verbose = 1 begin
				print '(' + convert(varchar,getdate(),9) + ') ' 
					+ 'Column: ' + convert(varchar,isnull(@col, ''))
			end
			--ach sum
			if @verbose = 1 begin
				print '(' + convert(varchar,getdate(),9) + ') ' 
					+ 'ACH Sum'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select 
					@classname,@queryname,1,@col,@customid, isnull(sum(commissionearned),0)
				from
					tblprojectedcommissionactual ca inner join
					tblclient c on ca.clientid=c.clientid
				where (@commrecid is null or @commrecid=commrecid) and isnull(c.depositmethod,'check')='ach'
					and ca.col=@col and [month]=month(@monthstart) and [year]=year(@monthstart)

			--ach count
			if @verbose = 1 begin
				print '(' + convert(varchar,getdate(),9) + ') ' 
					+ 'ACH Count'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select 
					@classname,@queryname,2,@col,@customid, count(distinct ca.clientid)
				from
					tblprojectedcommissionactual ca inner join
					tblclient c on ca.clientid=c.clientid
				where (@commrecid is null or @commrecid=commrecid) and isnull(c.depositmethod,'check')='ach'
					and ca.col=@col and [month]=month(@monthstart) and [year]=year(@monthstart)

			--non-ach sum
			if @verbose = 1 begin
				print '(' + convert(varchar,getdate(),9) + ') ' 
					+ 'Non-ACH Sum'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select 
					@classname,@queryname,3,@col,@customid, isnull(sum(commissionearned),0)
				from
					tblprojectedcommissionactual ca inner join
					tblclient c on ca.clientid=c.clientid
				where (@commrecid is null or @commrecid=commrecid) and not isnull(c.depositmethod,'check')='ach'
					and ca.col=@col and [month]=month(@monthstart) and [year]=year(@monthstart)

			--non-ach count
			if @verbose = 1 begin
				print '(' + convert(varchar,getdate(),9) + ') ' 
					+ 'Non-ACH Count'
			end
			insert into tblquerycache(classname,queryname,row,col,customid,[value])	
				select 
					@classname,@queryname,4,@col,@customid, count(distinct ca.clientid)
				from
					tblprojectedcommissionactual ca inner join
					tblclient c on ca.clientid=c.clientid
				where (@commrecid is null or @commrecid=commrecid) and not isnull(c.depositmethod,'check')='ach'
					and ca.col=@col and [month]=month(@monthstart) and [year]=year(@monthstart)


			set @col = @col+1
		end

		fetch next from c4 into @commrecid	
	end

	close c4
	deallocate c4

	drop table #tmpRules

	print '(' + convert(varchar,getdate(),9) + ') ' 
		+ 'Process finished for month ' + convert(varchar,@monthdate,6)

	--Advance to the next month
	set @monthdate=dateadd(month,1,@monthdate)
	set @i=@i+1
end --while
set nocount off
GO
