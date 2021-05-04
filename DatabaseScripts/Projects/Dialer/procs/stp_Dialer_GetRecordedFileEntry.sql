IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetRecordedFileEntry')
	BEGIN
		DROP  Procedure  stp_Dialer_GetRecordedFileEntry
	END

GO

CREATE Procedure stp_Dialer_GetRecordedFileEntry
@DocTypeId nvarchar(50) 
AS
Select RecId, Reference, ReferenceId, RecCallIdKey, CreatedBy from tblCallRecording
Where RecCallIdKey is not null and RecFile is null
and DocTypeId = @DocTypeId
order by RecId desc

GO

