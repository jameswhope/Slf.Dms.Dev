IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_InsertStopLeadRequest')
	BEGIN
		DROP  Procedure  stp_Vici_InsertStopLeadRequest
	END

GO

CREATE Procedure stp_Vici_InsertStopLeadRequest
@LeadId int,
@SourceId Varchar(50),
@RequestingProcess varchar(100)
AS
Begin
	declare @logid int
	
	Select @logid = LogId from tblViciStopLeadRequestLog  Where LeadId = @leadid and sourceid = @sourceid and processed is not null
	
	if @logid is not null 
	begin
		--change date to increase priority
		Update tblViciStopLeadRequestLog Set LastModified = GetDate() Where LogId = @logid
		select @logid
	end
	else
	begin
		Insert into tblViciStopLeadRequestLog(LeadId, SourceId, RequestingProcess) 
		Values (@LeadId, @SourceId, @RequestingProcess) 
		select scope_identity()
	end
End
GO

 