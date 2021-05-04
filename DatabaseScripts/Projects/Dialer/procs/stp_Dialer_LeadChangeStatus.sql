IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_LeadChangeStatus')
	BEGIN
		DROP  Procedure  stp_Dialer_LeadChangeStatus
	END

GO

CREATE Procedure stp_Dialer_LeadChangeStatus
@LeadApplicantId int,
@StatusId int,
@ReasonId int = NULL,
@Reason varchar(255) = NULL,
@UserId int
AS
Begin
	Update tblLeadApplicant Set StatusId = @StatusId, ReasonId = isnull(ReasonId, @ReasonId) Where LeadApplicantId = @LeadApplicantId
	  
	Declare @ParentRoadmapID int
	Select @ParentRoadmapID =  NULL 
	SELECT TOP 1 @ParentRoadmapID = RoadmapID  FROM tblLeadStatusRoadMap AS rm  WHERE (LeadApplicantID = @LeadApplicantId) ORDER BY LastModified DESC 
		
	Insert Into tblLeadRoadMap(LeadApplicantId, ParentLeadRoadMapId, LeadStatusId, Reason, Created, CreatedBy, LastModified, LastModifiedBy)
	Values (@LeadApplicantId, @ParentRoadMapId, @StatusId, @Reason,  Getdate(), @UserId, GetDate(), @UserId)
	
	Insert Into tblLeadStatusRoadMap(LeadApplicantId, ParentRoadMapId, LeadStatusId, Reason, Created, CreatedBy, LastModified, LastModifiedBy)
	Values (@LeadApplicantId, @ParentRoadMapId, @StatusId, @Reason,  Getdate(), @UserId, GetDate(), @UserId)
End

GO
 

