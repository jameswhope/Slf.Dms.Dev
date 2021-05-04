/****** Object:  StoredProcedure [dbo].[stp_IssueCommBatch_P]    Script Date: 11/19/2007 15:27:23 ******/
DROP PROCEDURE [dbo].[stp_IssueCommBatch_P]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_IssueCommBatch_P]


as

---------------------------------------------------------------------------------------------------------
-- LOGIC FOR ISSUING A NEW COMMISSION BATCH
-- (1) Create a temp table for holding recipient data to analyze; include:
--     (a) commscenid, commrecid, parentcommrecid, order so we can group by those together and keep
--         as many comm payments together as possible
--     (b) TransferAmount so we can do a second pass over the table and find the child amounts
--         we need to transfer
-- (2) Get all commpays without a commbatchid and group by commstructid, linking to commrec so we
--     can pull the commrecid
-- (3) Fill tables with pulled information
-- (5) Prepare and loop through comm scenarios distinctly from the pulled list currently inside the
--     temp table.  This will make sure the procedure does not access any new commission records that
--     come in live to the database while the batching is going on.  While looping:
--     (a) Make sure all parent recipients are present as actual recipients in the table (loop against flag)
--     (b) Any time a new parent is added as a recipient, recheck the table to make sure the parent
--         of that parent has also been added
--     (c) Prepare a new comm batch and grab the new id to use
--     (d) Recursively, send batches from temp table to regular table in the proper order
--     (e) Mark the original commpay records with the new commbatchid
-- (6) Cleanup temp tables
---------------------------------------------------------------------------------------------------------


-- discretionary variables
declare @commscenid int
declare @commrecid int
declare @parentcommrecid int
declare @numrecs int
declare @checkparentsagain bit
declare @commbatchid int
declare @numparentcommrecs int
declare @StoneWallSwitchDate DATETIME
declare @AvertSwitchDate DATETIME

set @StoneWallSwitchDate = CAST('5/16/2007 11:59PM' AS DATETIME)
set @AvertSwitchDate = CAST('7/31/2008 11:59PM' AS DATETIME)

-- (1) create table for comms
declare @vtblcomm table
(
      commpayid int null,
      commchargebackid int null,
      commscenid int not null,
      commrecid int not null,
        ClientCreated datetime NULL,
      amount money not NULL
)


-- create table for grouped commission
create table #tempGroup
(
      id int identity(1,1) not null,
      commscenid int not null,
      commrecid int not null,
      parentcommrecid int null,
      [order] int not null,
      amount money not null
)


-- (2) fill unbatched commpays (with commscen's) into temp table
insert into
      @vtblcomm
      (
            commpayid,
            commscenid,
            commrecid,
                  clientcreated,
            amount
      )
select
      tblcommpay.commpayid,
      tblcommstruct.commscenid,
      commrecid = 
            CASE 
			WHEN (tblClient.created > @StoneWallSwitchDate AND [tblcommstruct].commrecid = 5) THEN 24
			WHEN (tblClient.created > @AvertSwitchDate AND [tblcommstruct].commrecid = 17) THEN 29
            ELSE [tblcommstruct].commrecid
            END                           
      ,
        tblClient.[Created],
      tblcommpay.amount
from
      tblcommpay 
      inner JOIN tblcommstruct on tblcommpay.commstructid = tblcommstruct.commstructid
      INNER JOIN tblRegisterPayment ON [tblRegisterPayment].RegisterPaymentID = [tblcommpay].RegisterPaymentID
      INNER JOIN tblRegister ON tblRegister.[RegisterId] = [tblRegisterPayment].[FeeRegisterId]
      INNER JOIN tblClient ON [tblClient].ClientID = tblRegister.ClientID

where
      commbatchid is null
      and tblcommstruct.commstructid > 55


-- (2) fill unbatched commchargebacks (with commscen''s) into temp table
insert into
      @vtblcomm
      (
            commchargebackid,
            commscenid,
            commrecid,
                  clientcreated,
            amount
      )
select
      tblcommchargeback.commchargebackid,
      tblcommstruct.commscenid,
      commrecid =
            CASE 
				  WHEN (tblClient.created > @StoneWallSwitchDate AND [tblcommstruct].commrecid = 5) THEN 24
				  WHEN (tblClient.created > @AvertSwitchDate AND [tblcommstruct].commrecid = 17) THEN 29
                  ELSE [tblcommstruct].commrecid
            END   
        ,
            tblClient.[Created],
            -tblcommchargeback.amount
from
      tblcommchargeback 
        inner join tblcommstruct on tblcommchargeback.commstructid = tblcommstruct.commstructid
        INNER JOIN tblRegisterPayment ON [tblRegisterPayment].RegisterPaymentID = [tblcommchargeback].RegisterPaymentID
      INNER JOIN tblRegister ON tblRegister.[RegisterId] = [tblRegisterPayment].[FeeRegisterId]
      INNER JOIN tblClient ON [tblClient].ClientID = tblRegister.ClientID
where
      tblcommchargeback.commbatchid is null
      and tblcommstruct.commstructid > 55


-- (3) get all commpays and commchargebacks that match those selected
insert into
      #tempGroup
      (
            commscenid,
            commrecid,
            parentcommrecid,
            [order],
            amount
      )
select
      commscenid,
      commrecid,
      parentcommrecid,
      [order],
      sum(amount)
from
      (
            select
                  tblcommstruct.commscenid,
                  --tblcommstruct.commrecid,
                          commrecid =
                                    CASE 
											WHEN (c.[ClientCreated] > @StoneWallSwitchDate AND [tblcommstruct].commrecid = 5) THEN 24
											WHEN (c.[ClientCreated] > @AvertSwitchDate AND [tblcommstruct].commrecid = 17) THEN 29
                                            ELSE [tblcommstruct].commrecid
                                    END   
                          ,
                  tblcommstruct.parentcommrecid,
                  tblcommstruct.[order],
                  sum(tblcommpay.amount) as amount
            from
                  tblcommpay inner join
                  @vtblcomm c on tblcommpay.commpayid = c.commpayid inner join
                  tblcommstruct on tblcommpay.commstructid = tblcommstruct.commstructid and tblcommstruct.commstructid > 55
            group by
                  tblcommstruct.commscenid,
                  tblcommstruct.commrecid,
                  tblcommstruct.parentcommrecid,
                  tblcommstruct.[order],
                          c.[ClientCreated]
            union all
            select
                  tblcommstruct.commscenid,
                  --tblcommstruct.commrecid,
                          commrecid =
                                    CASE 
											WHEN (c.[ClientCreated] > @StoneWallSwitchDate AND [tblcommstruct].commrecid = 5) THEN 24
											WHEN (c.[ClientCreated] > @AvertSwitchDate AND [tblcommstruct].commrecid = 17) THEN 29
                                            ELSE [tblcommstruct].commrecid
                                    END   
                          ,
                  tblcommstruct.parentcommrecid,
                  tblcommstruct.[order],
                  (sum(tblcommchargeback.amount) * -1) as amount
            from
                  tblcommchargeback inner join
                  @vtblcomm c on tblcommchargeback.commchargebackid = c.commchargebackid inner join
                  tblcommstruct on tblcommchargeback.commstructid = tblcommstruct.commstructid and tblcommstruct.commstructid > 55
            group by
                  tblcommstruct.commscenid,
                  tblcommstruct.commrecid,
                  tblcommstruct.parentcommrecid,
                  tblcommstruct.[order],
                          c.[ClientCreated]
      )
      derivedtbl
group by
      commscenid,
      commrecid,
      parentcommrecid,
      [order]
--select * from #tempgroup

-- find commrecs that have a total negative amount and remove from both temp tables
declare cursorComScensA cursor local for select commscenid, commrecid from #tempgroup where amount <= 0

open cursorComScensA

fetch next from cursorComScensA into @commscenid, @commrecid
while @@fetch_status = 0
      begin

            -- remove the commissions and chargebacks from the line item table
            delete from @vtblcomm where commscenid = @commscenid and commrecid = @commrecid

            -- remove the batch group from the table
            delete from #tempgroup where commscenid = @commscenid and commrecid = @commrecid

            fetch next from cursorComScensA into @commscenid, @commrecid
      end
close cursorComScensA
deallocate cursorComScensA


-- (5) loop through comm scenarios
declare cursorComScens cursor local for select distinct commscenid from @vtblcomm order by commscenid

open cursorComScens

fetch next from cursorComScens into @commscenid
while @@fetch_status = 0
      begin

            -- (5.a) make sure all parent recs are present as actual recs (loop against flag)
            -- make sure it runs the first time
            set @numparentcommrecs = null
            set @checkparentsagain = 1

            -- loop as long as it returns another
            while @checkparentsagain = 1
                  begin

                        -- first check to make sure there are any parentcommrecs, so we don't get an infinite loop
                        select
                              @numparentcommrecs = count(distinct parentcommrecid)
                        from
                              #tempGroup
                        where
                              commscenid = @commscenid and
                              not parentcommrecid = 22

                        -- if parents exists, open loop and being checking
                        if not @numparentcommrecs is null and @numparentcommrecs > 0
                              begin

                                    declare cursorComScensParentRecs cursor local for
                                          select distinct parentcommrecid from #tempGroup where commscenid = @commscenid and not parentcommrecid = 22
            
                                    open cursorComScensParentRecs
            
                                    fetch next from cursorComScensParentRecs into @parentcommrecid
                                    while @@fetch_status = 0
                                          begin
            
                                                -- (5.b) check to see if parent is a recipient
                                                select
                                                      @numrecs = count(id)
                                                from
                                                      #tempGroup
                                                where
                                                      commrecid = @parentcommrecid and
                                                      commscenid = @commscenid
            
                                                -- if parent is not a recipient
                                                if @numrecs = 0
                                                      begin
            
                                                            -- insert parent (with info from struct) as recipient
                                                            insert into
                                                                  #tempGroup
                                                                  (
                                                                        commscenid,
                                                                        commrecid,
                                                                        parentcommrecid,
                                                                        [order],
                                                                        amount
                                                                  )
                                                            select
                                                                  commscenid,
                                                                  commrecid,
                                                                  parentcommrecid,
                                                                  [order],
                                                                  0
                                                            from
                                                                  tblcommstruct
                                                            where
                                                                  commscenid = @commscenid and
                                                                  commrecid = @parentcommrecid and
                                                                  commstructid > 55
            
                                                            -- since new parent may have just been added, set flag to check again
                                                            set @checkparentsagain = 1
            
                                                      end -- if @numrecs = 0
                                                else
                                                      begin
                                                            set @checkparentsagain = 0
                                                      end
            
                                                fetch next from cursorComScensParentRecs into @parentcommrecid
                                          end
                                    close cursorComScensParentRecs
                                    deallocate cursorComScensParentRecs

                              end
                        else -- no parents at all
                              begin
                                    set @checkparentsagain = 0
                              end
                  end -- while @checkparentsagain


            -- (5.c) prepare new batch
            insert into tblcommbatch (commscenid, batchdate) values (@commscenid, getdate())

            -- scoop up new id for newly created batch
            set @commbatchid = scope_identity()


            -- (5.d) recursively, send batches from temp table to regular table
            exec stp_IssueCommBatchOut @commbatchid, @commscenid, '#tempGroup', 22


            -- (5.e) mark all commpays and commchargebacks with this commbatchid
            update
                  tblcommpay
            set
                  commbatchid = @commbatchid
            where
                  commpayid in
                  (
                        select
                              commpayid
                        from
                              @vtblcomm
                        where
                              commscenid = @commscenid
                  )

            update
                  tblcommchargeback
            set
                  commbatchid = @commbatchid
            where
                  commchargebackid in
                  (
                        select
                              commchargebackid
                        from
                              @vtblcomm
                        where
                              commscenid = @commscenid
                  )


            fetch next from cursorComScens into @commscenid
      end
close cursorComScens
deallocate cursorComScens


-- (6) cleanup
drop table #tempGroup
GO
 