/****** Object:  StoredProcedure [dbo].[stp_IssueCommBatchOut]    Script Date: 11/19/2007 15:27:23 ******/
DROP PROCEDURE [dbo].[stp_IssueCommBatchOut]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_IssueCommBatchOut]
	(
		@commbatchid int,
		@commscenid int,
		@temptablename varchar (50),
		@parentcommrecid int
	)

as

-----------------------------------------------------------------------------
-- LOGIC FOR SENDING BATCHED COMMISSION FROM TEMP TO REGULAR TABLE
-- (1) The temp table name passed into this proc contains batched amounts
--     for the respective comm scenarios listed.  A parent recipient is
--     also passed in.  This is so we can recursively drill down.
-- (2) Prepare a local cursor against all recipients that have this parent
--     recipient.  Recipients must be in order -> #temp.[order]
-- (3) Run through the cursor and do the following
--     (a) Insert the batch from temp to regular with the passed in
--         commbatchid value and no transferamount
--     (b) Execute this same stored proc using the commrecid as the 
--         parentcommrecid for the newly-invoked proc.
--     (c) Add the current amount to the current transferamount
--     (d) Retrieve the current transferamount and add it to the
--         parent transferamount
-- (4) Cleanup temp table info
-----------------------------------------------------------------------------


-- discretionary variables
declare @sql varchar (8000)

declare @commrecid int
declare @order int
declare @amount money
declare @commbatchtransferid int
declare @transferamount money


create table #temploop
(
	commrecid int not null,
	[order] int not null,
	amount money not null
)

-- (1) prepare statement for finding results
set @sql = 'select commrecid, [order], amount from ' + @temptablename + ' where commscenid = ' + convert(varchar (50), @commscenid)

if @parentcommrecid is null
	begin
		set @sql = @sql + ' and parentcommrecid is null'
	end
else
	begin
		set @sql = @sql + ' and parentcommrecid = ' + convert(varchar (50), @parentcommrecid)
	end

set @sql = @sql + ' order by [order]'


exec('insert into #temploop ' + @sql)

-- (2) prepare loop for recipients against current parent and scenario
--exec('declare cursor_IssueCommBatchOut cursor local for ' + @sql)

declare cursor_IssueCommBatchOut cursor local for select * from #temploop

open cursor_IssueCommBatchOut

-- (3) run through
fetch next from cursor_IssueCommBatchOut into @commrecid, @order, @amount
while @@fetch_status = 0

	begin

		-- (3.a) insert batch info from temp to regular table
		insert into
			tblcommbatchtransfer
			(
				commbatchid,
				commrecid,
				parentcommrecid,
				[order],
				amount
			)
		values
			(
				@commbatchid,
				@commrecid,
				@parentcommrecid,
				@order,
				@amount
			)

		-- retrieve fresh insert
		set @commbatchtransferid = scope_identity()


		-- (3.b) recursively run this same proc again with this recipient as parent
		exec stp_IssueCommBatchOut @commbatchid, @commscenid, @temptablename, @commrecid


		-- (3.c) add the current amount to the current transferamount
		update
			tblcommbatchtransfer
		set
			transferamount = isnull(transferamount, 0) + @amount
		where
			commbatchtransferid = @commbatchtransferid


		-- (3.d) retrieve the current transferamount and add it to the parent transferamount
		if not @parentcommrecid is null
			begin

				select
					@transferamount = isnull(transferamount, 0)
				from
					tblcommbatchtransfer
				where
					commbatchtransferid = @commbatchtransferid

				update
					tblcommbatchtransfer
				set
					transferamount = isnull(transferamount, 0) + @transferamount
				where
					commbatchid = @commbatchid and
					commrecid = @parentcommrecid

			end


		fetch next from cursor_IssueCommBatchOut into @commrecid, @order, @amount

	end

close cursor_IssueCommBatchOut
deallocate cursor_IssueCommBatchOut


-- (4) cleanup temp tables
drop table #temploop
GO
