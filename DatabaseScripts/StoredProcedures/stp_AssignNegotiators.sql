/****** Object:  StoredProcedure [dbo].[stp_AssignNegotiators]    Script Date: 11/19/2007 15:26:54 ******/
DROP PROCEDURE [dbo].[stp_AssignNegotiators]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_AssignNegotiators]

as

create table #tblClients
(
	clientid int,
	assignedmediator int,
	lastname varchar(50),
	sdabalance money,
	accounts int
)

declare	@hiredate1 datetime
declare	@hiredate2 datetime
declare	@percent1 float
declare	@percent2 float 
declare	@sdabal1 float 
declare	@sdabal2 float 
declare	@accountbal1 float 
declare	@accountbal2 float 
declare	@clientstatusids varchar(999)
declare	@clientstatusidschoice bit
declare	@agencyids varchar(999)
declare	@agencyidschoice bit 
declare	@accountstatusids varchar(999) 
declare	@accountstatusidschoice bit

set @hiredate1=(select convert(datetime,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='HireDate1')
set @hiredate2=(select convert(datetime,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='HireDate2')
set @percent1=(select convert(float,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='ThresholdPercent1')/100
set @percent2=(select convert(float,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='ThresholdPercent2')/100
set @sdabal1=null
set @sdabal2=null
set @accountbal1=(select convert(float,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='AccountBalance1')
set @accountbal2=(select convert(float,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='AccountBalance2')
set @clientstatusids=(select convert(varchar,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='ClientStatusIDs')
set @clientstatusidschoice=(select convert(bit,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='ClientStatusChoice')
set @agencyids=(select convert(varchar,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='AgencyIDs')
set @agencyidschoice=(select convert(bit,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='AgencyChoice')
set @accountstatusids=(select convert(varchar,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='AccountStatusIDs')
set @accountstatusidschoice=(select convert(bit,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='AccountStatusChoice')


declare	@clientstatusidsop varchar(10)
set @clientstatusidsop = case when @clientstatusidschoice=1 then '' else 'not' end
declare	@agencyidsop varchar(10)
set @agencyidsop = case when @agencyidschoice=1 then '' else 'not' end
declare	@accountstatusidsop varchar(10)
set @accountstatusidsop = case when @accountstatusidschoice=1 then '' else 'not' end

declare @userid int
declare @rangestart varchar(2)
declare @rangeend varchar(2)

declare c cursor for 
select
	rn.userid,
	rn.rangestart,
	rn.rangeend
from
	tblrulenegotiation rn inner join
	tbluser u on rn.userid=u.userid

--remove all assignments for auto-assignable clients
update
	tblclient
set
	assignedmediator=null
where
	AutoAssignMediator=1

insert into 
	#tblclients 
	(
		clientid,
		assignedmediator,
		lastname,
		sdabalance,
		accounts
	)
exec stp_Report_AccountsOverPercentage_Fulfillment
	@hiredate1,
	@hiredate2,
	@percent1,
	@percent2,
	@sdabal1,
	@sdabal2,
	@accountbal1,
	@accountbal2,
	@clientstatusids,
	@clientstatusidsop,
	@agencyids,
	@agencyidsop,
	@accountstatusids,
	@accountstatusidsop

open c
fetch next from c into @userid,@rangestart,@rangeend
while @@fetch_status=0 begin

	update 
		tblclient 
	set 
		assignedmediator=@userid
	where
		clientid in 
		(
			select 
				clientid
			from 
				#tblclients 
			where 
				substring(lastname,1,2) >= @rangestart
				and substring(lastname,1,2) <= @rangeend
		)
		and autoassignmediator=1

	print 'assigned clients between ' + @rangestart + ' and ' + @rangeend + ' to user ' + convert(varchar,@userid)

	fetch next from c into @userid,@rangestart,@rangeend
end

close c
deallocate c

drop table #tblclients
GO
