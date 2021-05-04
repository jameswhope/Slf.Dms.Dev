IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_UpdateStopLeadRequest')
	BEGIN
		DROP  Procedure  stp_Vici_UpdateStopLeadRequest
	END

GO

CREATE Procedure stp_Vici_UpdateStopLeadRequest
@LogId int,
@Processed  datetime  = NULL,
@Stopped bit = NULL,
@Note varchar(255) = NULL
AS
Begin
	Update tblViciStopLeadRequestLog Set
	LastModified = GetDate(),
	Processed = isnull(@Processed, Processed),
	Stopped = isnull(@Stopped, Stopped),
	Note = isnull(@Note, Note)
	Where LogId = @LogId
End
GO

