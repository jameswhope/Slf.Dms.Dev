IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Harassment_UpdateStatus')
	BEGIN
		DROP  Procedure  stp_Harassment_UpdateStatus
	END

GO

CREATE Procedure stp_Harassment_UpdateStatus

	(
		@clientsubmissionid int,
		@statusid int,
		@declinereasonid int = -1
	)
AS
BEGIN
	update tblharassmentclient
	set HarassmentStatusID =@statusid,HarassmentStatusDate=getdate(),HarassmentDeclineReasonID=@declinereasonid
	where clientsubmissionid = @clientsubmissionid
end




GRANT EXEC ON stp_Harassment_UpdateStatus TO PUBLIC

GO


