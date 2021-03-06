/****** Object:  StoredProcedure [dbo].[stp_Report_AccountsOverPercentage_Fulfillment_PlannedGrid]    Script Date: 11/19/2007 15:27:38 ******/
DROP PROCEDURE [dbo].[stp_Report_AccountsOverPercentage_Fulfillment_PlannedGrid]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Report_AccountsOverPercentage_Fulfillment_PlannedGrid]
(
	@SelectedClientIDs varchar(8000)=null
)

as

create table #SelectedClientIDs(ClientID int)
if not @selectedclientids is null
	exec('insert into #selectedclientids select clientid from tblclient where clientid in (' + @SelectedClientIDs + ')')

select 
	u.userid, 
	firstname + ' '+ lastname as fullname,  
	(select count(clientid) from tblclient where assignedmediator=u.userid) as has,
	(select count(clientid) from tblclient where assignedmediator=u.userid and clientid in (select clientid from #SelectedClientIDs)) as hasselected
from 
	tbluser u inner join 
	tbluserposition up on u.userid=up.userid 
where 
	up.positionid=4

drop table #SelectedClientIDs
GO
