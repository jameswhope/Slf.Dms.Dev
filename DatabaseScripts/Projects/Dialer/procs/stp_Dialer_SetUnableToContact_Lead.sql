IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_SetUnableToContact_Leads.sql')
	BEGIN
		DROP  Procedure  stp_Dialer_SetUnableToContact_Leads.sql
	END

GO

CREATE Procedure stp_Dialer_SetUnableToContact_Leads
AS
BEGIN

Declare @TotalMaxAttempt int
Declare @LeadApplicantId int
Declare @ParentRoadMapId int
Declare @LastAttempt datetime

Select @TotalMaxAttempt = MaxAttempts 
From tblDialerWorkGroupQueue
Where QueueName = 'CID Dialer WorkGroup'

Declare cursor_leads Cursor for
select l.leadapplicantid,
lastattempt = (Select top 1 d1.created from tblleaddialercall d1 where d1.outboundcallkey is not null
				and  d1.LeadApplicantId = l.leadapplicantId order by d1.created desc)
from tblleadapplicant l
where l.statusid in (13, 15, 16, 17)
and  (Select Count(d.callmadeid) from tblleaddialercall d 
	  where d.outboundcallkey is not null
	  and d.LeadApplicantId = l.leadapplicantId
	  and d.created >= isnull(l.DialerLastRecycled, '1900-01-01')
	  ) >= @TotalMaxAttempt
	  
Open cursor_leads

Fetch next from cursor_leads into @LeadApplicantId, @LastAttempt

While @@fetch_status = 0
Begin
	 If datediff(hh,isnull(@LastAttempt, getdate()), getdate()) < 24
	   Begin 
			Update tblLeadApplicant Set StatusId = 1
 			Where LeadApplicantId = @LeadApplicantId
	  
			Select @ParentRoadmapID =  NULL 
			SELECT TOP 1 @ParentRoadmapID = RoadmapID  FROM tblLeadStatusRoadMap AS rm  WHERE (LeadApplicantID = @LeadApplicantId) ORDER BY LastModified DESC 
		
			Insert Into tblLeadRoadMap(LeadApplicantId, ParentLeadRoadMapId, LeadStatusId, Reason, Created, CreatedBy, LastModified, LastModifiedBy)
			Values (@LeadApplicantId, @ParentRoadMapId, 1, 'Dialer was unable to contact lead',  Getdate(), 31, GetDate(), 31)
		End

     Fetch next from cursor_leads into @LeadApplicantId, @LastAttempt

End

Close cursor_leads
Deallocate cursor_leads 

END

GO


